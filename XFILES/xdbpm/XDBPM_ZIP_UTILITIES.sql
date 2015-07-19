
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
alter session set current_schema = XDBPM
/
create or replace type ZIP_CONTENTS_LIST
    as TABLE of VARCHAR2(4000)
/
grant execute on ZIP_CONTENTS_LIST to public
/
create or replace type ZIP_ENTRY as OBJECT
(
  FILENAME VARCHAR2(4000),
  CONTENT  BLOB
)
/
grant execute on ZIP_ENTRY to public
/
create or replace type ZIP_ENTRY_TABLE as table of ZIP_ENTRY
/
grant execute on ZIP_ENTRY_TABLE to public
/
CREATE OR REPLACE package as_zip
is
/*
** Written by Anton Scheffer
** 3 April 2011
*/
--
  function get_file_list(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return zip_contents_list;
--
  function get_file_list(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null /* Use CP850 for zip files created with a German Winzip to see umlauts, etc */
  )
    return zip_contents_list;
--
  function get_file(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  function get_file(
    p_zipped_blob in blob
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  function unzip(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null
  )
    return zip_entry_table pipelined;
--
  function unzip(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return zip_entry_table pipelined;
--
  procedure add1file(
    p_zipped_blob in out blob
  , p_name in varchar2
  , p_content in blob
  );
--
  procedure finish_zip(
    p_zipped_blob in out blob
  );
--
  procedure save_zip(
    p_zipped_blob in blob
  , p_dir in varchar2 := 'MY_DIR'
  , p_filename in varchar2 := 'my.zip'
  );
--
/*
declare
  g_zipped_blob blob;
begin
  as_zip.add1file( g_zipped_blob, 'test1.txt', utl_raw.cast_to_raw( 'Dit is de laatste test! Waarom wordt dit dan niet gecomprimeerd?' ) );
  as_zip.add1file( g_zipped_blob, 'test1234.txt', utl_raw.cast_to_raw( 'En hier staat wat anders' ) );
  as_zip.finish_zip( g_zipped_blob );
  as_zip.save_zip( g_zipped_blob, 'MY_DIR', 'my.zip' );
end;
--
declare
  t_dir varchar2(100) := 'MY_DIR';
  t_zip varchar2(100) := 'my.zip';
  zip_files zip_contents_list;
begin
  zip_files  := as_zip.get_file_list( t_dir, t_zip );
  for i in zip_files.first() .. zip_files.last
  loop
    dbms_output.put_line( zip_files( i ) );
    dbms_output.put_line( utl_raw.cast_to_varchar2( as_zip.get_file( t_dir, t_zip, zip_files( i ) ) ) );
  end loop;
end;
*/
end;
/
show errors
--
grant execute on AS_ZIP to public
/
CREATE OR REPLACE package body as_zip
is
--
  function raw2num(
    p_value in raw
  )
    return number
  is
  begin                                               -- note: FFFFFFFF => -1
    return utl_raw.cast_to_binary_integer( p_value
                                         , utl_raw.little_endian
                                         );
  end;
--
  function file2blob(
    p_dir in varchar2
  , p_file_name in varchar2
  )
    return blob
  is
    file_lob bfile;
    file_blob blob;
  begin
    file_lob := bfilename( p_dir
                         , p_file_name
                         );
    dbms_lob.open( file_lob
                 , dbms_lob.file_readonly
                 );
    dbms_lob.createtemporary( file_blob
                            , true
                            );
    dbms_lob.loadfromfile( file_blob
                         , file_lob
                         , dbms_lob.lobmaxsize
                         );
    dbms_lob.close( file_lob );
    return file_blob;
  exception
    when others
    then
      if dbms_lob.isopen( file_lob ) = 1
      then
        dbms_lob.close( file_lob );
      end if;
      if dbms_lob.istemporary( file_blob ) = 1
      then
        dbms_lob.freetemporary( file_blob );
      end if;
      raise;
  end;
--
  function raw2varchar2(
    p_raw in raw
  , p_encoding in varchar2
  )
    return varchar2
  is
  begin
    return nvl
            ( utl_i18n.raw_to_char( p_raw
                                  , p_encoding
                                  )
            , utl_i18n.raw_to_char
                            ( p_raw
                            , utl_i18n.map_charset( p_encoding
                                                  , utl_i18n.generic_context
                                                  , utl_i18n.iana_to_oracle
                                                  )
                            )
            );
  end;
--
  function get_file_list(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return zip_contents_list
  is
  begin
    return get_file_list( file2blob( p_dir
                                   , p_zip_file
                                   )
                        , p_encoding
                        );
  end;
--
  function get_file_list(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null
  )
    return zip_contents_list
  is
    t_ind integer;
    t_hd_ind integer;
    t_rv zip_contents_list;
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when dbms_lob.substr( p_zipped_blob
                               , 4
                               , t_ind
                               ) = hextoraw( '504B0506' )
            or t_ind < 1;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return null;
    end if;
--
    t_hd_ind := raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_ind + 16
                                        ) ) + 1;
    t_rv := zip_contents_list();
    t_rv.extend( raw2num( dbms_lob.substr( p_zipped_blob
                                         , 2
                                         , t_ind + 10
                                         ) ) );
    for i in 1 .. raw2num( dbms_lob.substr( p_zipped_blob
                                          , 2
                                          , t_ind + 8
                                          ) )
    loop
      t_rv( i ) :=
        raw2varchar2
             ( dbms_lob.substr( p_zipped_blob
                              , raw2num( dbms_lob.substr( p_zipped_blob
                                                        , 2
                                                        , t_hd_ind + 28
                                                        ) )
                              , t_hd_ind + 46
                              )
             , p_encoding
             );
      t_hd_ind :=
          t_hd_ind
        + 46
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 28
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 30
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 32
                                  ) );
    end loop;
--
    return t_rv;
  end;
--
  function get_file(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob
  is
  begin
    return get_file( file2blob( p_dir
                              , p_zip_file
                              )
                   , p_file_name
                   , p_encoding
                   );
  end;
--
  function get_file(
    p_zipped_blob in blob
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob
  is
    t_tmp blob;
    t_ind integer;
    t_hd_ind integer;
    t_fl_ind integer;
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when dbms_lob.substr( p_zipped_blob
                               , 4
                               , t_ind
                               ) = hextoraw( '504B0506' )
            or t_ind < 1;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return null;
    end if;
--
    t_hd_ind := raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_ind + 16
                                        ) ) + 1;
    for i in 1 .. raw2num( dbms_lob.substr( p_zipped_blob
                                          , 2
                                          , t_ind + 8
                                          ) )
    loop
      if p_file_name =
           raw2varchar2
             ( dbms_lob.substr( p_zipped_blob
                              , raw2num( dbms_lob.substr( p_zipped_blob
                                                        , 2
                                                        , t_hd_ind + 28
                                                        ) )
                              , t_hd_ind + 46
                              )
             , p_encoding
             )
      then
        if dbms_lob.substr( p_zipped_blob
                          , 2
                          , t_hd_ind + 10
                          ) = hextoraw( '0800' )                -- deflate
        then
          t_fl_ind :=
                raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_hd_ind + 42
                                        ) );
          t_tmp := hextoraw( '1F8B0800000000000003' );          -- gzip header
          dbms_lob.copy( t_tmp
                       , p_zipped_blob
                       , raw2num( dbms_lob.substr( p_zipped_blob
                                                 , 4
                                                 , t_fl_ind + 19
                                                 ) )
                       , 11
                       ,   t_fl_ind
                         + 31
                         + raw2num( dbms_lob.substr( p_zipped_blob
                                                   , 2
                                                   , t_fl_ind + 27
                                                   ) )
                         + raw2num( dbms_lob.substr( p_zipped_blob
                                                   , 2
                                                   , t_fl_ind + 29
                                                   ) )
                       );
          dbms_lob.append( t_tmp
                         , dbms_lob.substr( p_zipped_blob
                                          , 4
                                          , t_fl_ind + 15
                                          )
                         );
          dbms_lob.append( t_tmp
                         , dbms_lob.substr( p_zipped_blob, 4, t_fl_ind + 23 )
                         );
          return utl_compress.lz_uncompress( t_tmp );
        end if;
--
        if dbms_lob.substr( p_zipped_blob
                          , 2
                          , t_hd_ind + 10
                          ) =
                      hextoraw( '0000' )
                                        -- The file is stored (no compression)
        then
          t_fl_ind :=
                raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_hd_ind + 42
                                        ) );
          return dbms_lob.substr( p_zipped_blob
                                , raw2num( dbms_lob.substr( p_zipped_blob
                                                          , 4
                                                          , t_fl_ind + 19
                                                          ) )
                                ,   t_fl_ind
                                  + 31
                                  + raw2num( dbms_lob.substr( p_zipped_blob
                                                            , 2
                                                            , t_fl_ind + 27
                                                            ) )
                                  + raw2num( dbms_lob.substr( p_zipped_blob
                                                            , 2
                                                            , t_fl_ind + 29
                                                            ) )
                                );
        end if;
      end if;
      t_hd_ind :=
          t_hd_ind
        + 46
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 28
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 30
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 32
                                  ) );
    end loop;
--
    return null;
  end;
--
  function unzip(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return zip_entry_table pipelined
  is
    t_zipped_blob blob;
    cursor getcontent 
    is
    select value(a) ZIP_ENTRY 
      from table(as_zip.unzip(t_zipped_blob,p_encoding)) a;
  begin
    t_zipped_blob := file2blob( p_dir
                              , p_zip_file
                              );
    for t in getContent loop
      pipe row (t.ZIP_ENTRY);
    end loop;
  end;
--
  function unzip(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null
  )
    return zip_entry_table pipelined
  is
    t_tmp blob;
    t_ind integer;
    t_hd_ind integer;
    t_fl_ind integer;
    t_file_name varchar2(4000);
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when dbms_lob.substr( p_zipped_blob
                               , 4
                               , t_ind
                               ) = hextoraw( '504B0506' )
            or t_ind < 1;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return;
    end if;
--
    t_hd_ind := raw2num( dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_ind + 16
                                        ) ) + 1;
    for i in 1 .. raw2num( dbms_lob.substr( p_zipped_blob
                                          , 2
                                          , t_ind + 8
                                          ) )
    loop
      t_file_name :=
           raw2varchar2
             ( dbms_lob.substr( p_zipped_blob
                              , raw2num( dbms_lob.substr( p_zipped_blob
                                                        , 2
                                                        , t_hd_ind + 28
                                                        ) )
                              , t_hd_ind + 46
                              )
             , p_encoding
             );
      if dbms_lob.substr( p_zipped_blob
                        , 2
                        , t_hd_ind + 10
                        ) = hextoraw( '0800' )                -- deflate
      then
        t_fl_ind :=
              raw2num( dbms_lob.substr( p_zipped_blob
                                      , 4
                                      , t_hd_ind + 42
                                      ) );
        t_tmp := hextoraw( '1F8B0800000000000003' );          -- gzip header
        dbms_lob.copy( t_tmp
                     , p_zipped_blob
                     , raw2num( dbms_lob.substr( p_zipped_blob
                                               , 4
                                               , t_fl_ind + 19
                                               ) )
                     , 11
                     ,   t_fl_ind
                       + 31
                       + raw2num( dbms_lob.substr( p_zipped_blob
                                                 , 2
                                                 , t_fl_ind + 27
                                                 ) )
                       + raw2num( dbms_lob.substr( p_zipped_blob
                                                 , 2
                                                 , t_fl_ind + 29
                                                 ) )
                     );
        dbms_lob.append( t_tmp
                       , dbms_lob.substr( p_zipped_blob
                                        , 4
                                        , t_fl_ind + 15
                                        )
                       );
        dbms_lob.append( t_tmp
                       , dbms_lob.substr( p_zipped_blob, 4, t_fl_ind + 23 )
                       );
        pipe row( zip_entry( t_file_name, utl_compress.lz_uncompress( t_tmp ) ) );
      end if;
--
      if dbms_lob.substr( p_zipped_blob
                        , 2
                        , t_hd_ind + 10
                        ) =
                    hextoraw( '0000' )
                                      -- The file is stored (no compression)
      then
        t_fl_ind :=
              raw2num( dbms_lob.substr( p_zipped_blob
                                      , 4
                                      , t_hd_ind + 42
                                      ) );
        pipe row( zip_entry( t_file_name
                           , dbms_lob.substr( p_zipped_blob
                                            , raw2num( dbms_lob.substr( p_zipped_blob
                                                                      , 4
                                                                      , t_fl_ind + 19
                                                     ) )
                                            ,   t_fl_ind
                                              + 31
                                              + raw2num( dbms_lob.substr( p_zipped_blob
                                                                        , 2
                                                                        , t_fl_ind + 27
                                                       ) )
                                              + raw2num( dbms_lob.substr( p_zipped_blob
                                                                        , 2
                                                                        , t_fl_ind + 29
                                                       ) )
                                            )
                           )
                );
      end if;
--
      t_hd_ind :=
          t_hd_ind
        + 46
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 28
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 30
                                  ) )
        + raw2num( dbms_lob.substr( p_zipped_blob
                                  , 2
                                  , t_hd_ind + 32
                                  ) );
    end loop;
--
    return;
  end;
--
  function little_endian(
    p_big in number
  , p_bytes in pls_integer := 4
  )
    return raw
  is
  begin
    return utl_raw.substr
                  ( utl_raw.cast_from_binary_integer( p_big
                                                    , utl_raw.little_endian
                                                    )
                  , 1
                  , p_bytes
                  );
  end;
--
  procedure add1file(
    p_zipped_blob in out blob
  , p_name in varchar2
  , p_content in blob
  )
  is
    t_now date;
    t_blob blob;
    t_clen integer;
  begin
    t_now := sysdate;
    t_blob := utl_compress.lz_compress( p_content );
    t_clen := dbms_lob.getlength( t_blob );
    if p_zipped_blob is null
    then
      dbms_lob.createtemporary( p_zipped_blob
                              , true
                              );
    end if;
    dbms_lob.append
      ( p_zipped_blob
      , utl_raw.concat
          ( hextoraw( '504B0304' )              -- Local file header signature
          , hextoraw( '1400' )                  -- version 2.0
          , hextoraw( '0000' )                  -- no General purpose bits
          , hextoraw( '0800' )                  -- deflate
          , little_endian
              (   to_number( to_char( t_now
                                    , 'ss'
                                    ) ) / 2
                + to_number( to_char( t_now
                                    , 'mi'
                                    ) ) * 32
                + to_number( to_char( t_now
                                    , 'hh24'
                                    ) ) * 2048
              , 2
              )                                 -- File last modification time
          , little_endian
              (   to_number( to_char( t_now
                                    , 'dd'
                                    ) )
                + to_number( to_char( t_now
                                    , 'mm'
                                    ) ) * 32
                + ( to_number( to_char( t_now
                                      , 'yyyy'
                                      ) ) - 1980 ) * 512
              , 2
              )                                 -- File last modification date
          , dbms_lob.substr( t_blob
                           , 4
                           , t_clen - 7
                           )                                         -- CRC-32
          , little_endian( t_clen - 18 )                    -- compressed size
          , little_endian( dbms_lob.getlength( p_content ) )
                                                          -- uncompressed size
          , little_endian( length( p_name )
                         , 2
                         )                                 -- File name length
          , hextoraw( '0000' )                           -- Extra field length
          , utl_raw.cast_to_raw( p_name )                         -- File name
          )
      );
    dbms_lob.copy( p_zipped_blob
                 , t_blob
                 , t_clen - 18
                 , dbms_lob.getlength( p_zipped_blob ) + 1
                 , 11
                 );                                      -- compressed content
    dbms_lob.freetemporary( t_blob );
  end;
--
  procedure finish_zip(
    p_zipped_blob in out blob
  )
  is
    t_cnt pls_integer := 0;
    t_offs integer;
    t_offs_dir_header integer;
    t_offs_end_header integer;
    t_comment raw( 32767 )
                 := utl_raw.cast_to_raw( 'Implementation by Anton Scheffer' );
  begin
    t_offs_dir_header := dbms_lob.getlength( p_zipped_blob );
    t_offs := dbms_lob.instr( p_zipped_blob
                            , hextoraw( '504B0304' )
                            , 1
                            );
    while t_offs > 0
    loop
      t_cnt := t_cnt + 1;
      dbms_lob.append
        ( p_zipped_blob
        , utl_raw.concat
            ( hextoraw( '504B0102' )
                                    -- Central directory file header signature
            , hextoraw( '1400' )                                -- version 2.0
            , dbms_lob.substr( p_zipped_blob
                             , 26
                             , t_offs + 4
                             )
            , hextoraw( '0000' )                        -- File comment length
            , hextoraw( '0000' )              -- Disk number where file starts
            , hextoraw( '0100' )                   -- Internal file attributes
            , hextoraw( '2000B681' )               -- External file attributes
            , little_endian( t_offs - 1 )
                                       -- Relative offset of local file header
            , dbms_lob.substr
                ( p_zipped_blob
                , utl_raw.cast_to_binary_integer
                                           ( dbms_lob.substr( p_zipped_blob
                                                            , 2
                                                            , t_offs + 26
                                                            )
                                           , utl_raw.little_endian
                                           )
                , t_offs + 30
                )                                                 -- File name
            )
        );
      t_offs :=
          dbms_lob.instr( p_zipped_blob
                        , hextoraw( '504B0304' )
                        , t_offs + 32
                        );
    end loop;
    t_offs_end_header := dbms_lob.getlength( p_zipped_blob );
    dbms_lob.append
      ( p_zipped_blob
      , utl_raw.concat
          ( hextoraw( '504B0506' )       -- End of central directory signature
          , hextoraw( '0000' )                          -- Number of this disk
          , hextoraw( '0000' )          -- Disk where central directory starts
          , little_endian
                   ( t_cnt
                   , 2
                   )       -- Number of central directory records on this disk
          , little_endian( t_cnt
                         , 2
                         )        -- Total number of central directory records
          , little_endian( t_offs_end_header - t_offs_dir_header )
                                                  -- Size of central directory
          , little_endian
                    ( t_offs_dir_header )
                                       -- Relative offset of local file header
          , little_endian
                ( nvl( utl_raw.length( t_comment )
                     , 0
                     )
                , 2
                )                                   -- ZIP file comment length
          , t_comment
          )
      );
  end;
--
  procedure save_zip(
    p_zipped_blob in blob
  , p_dir in varchar2 := 'MY_DIR'
  , p_filename in varchar2 := 'my.zip'
  )
  is
    t_fh utl_file.file_type;
    t_len pls_integer := 32767;
  begin
    t_fh := utl_file.fopen( p_dir
                          , p_filename
                          , 'wb'
                          );
    for i in 0 .. trunc(  ( dbms_lob.getlength( p_zipped_blob ) - 1 ) / t_len )
    loop
      utl_file.put_raw( t_fh
                      , dbms_lob.substr( p_zipped_blob
                                       , t_len
                                       , i * t_len + 1
                                       )
                      );
    end loop;
    utl_file.fclose( t_fh );
  end;
--
end;
/
show errors
/
create or replace package XDBPM_ZIP_UTILITY
AUTHID CURRENT_USER
as
  procedure UNZIP(P_ZIP_FILE_PATH VARCHAR2, P_LOG_FILE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_DUPLICATE_ACTION VARCHAR2);
end;
/
--
show errors
--
create or replace synonym XDB_ZIP_UTILITY for XDBPM_ZIP_UTILITY
/
grant execute on XDBPM_ZIP_UTILITY to public
/
create or replace package body XDBPM_ZIP_UTILITY
as 
--
procedure UNZIP(P_ZIP_FILE_PATH VARCHAR2, P_LOG_FILE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_DUPLICATE_ACTION VARCHAR2)
as
  V_ZIP_FILE  BLOB := xdburitype(P_ZIP_FILE_PATH).getBLOB();

  V_LOG_FILE_BUFFER CLOB;
  V_BUFFER VARCHAR2(4000);

  cursor getContents 
  is
  select FILENAME, CONTENT 
    from TABLE(XDBPM.AS_ZIP.unZip(V_ZIP_FILE,NULL))
   order by FILENAME;
    
  V_FOLDER_PATH   VARCHAR2(4000);
  V_RESOURCE_PATH VARCHAR2(4000);
  V_RESULT BOOLEAN;
  
begin
  DBMS_LOB.CREATETEMPORARY(V_LOG_FILE_BUFFER,TRUE);

  V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Unzip log file for  "' || P_ZIP_FILE_PATH || '".' || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
  
  begin
  	
	  for f in getContents loop
	
	    V_RESOURCE_PATH := P_TARGET_FOLDER || '/' || f.FILENAME;

	   	V_FOLDER_PATH   := substr(V_RESOURCE_PATH,1,INSTR(V_RESOURCE_PATH,'/',-1)-1);
      if (not DBMS_XDB.existsResource(V_FOLDER_PATH)) then
        V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Creating Folder "' || V_FOLDER_PATH || '".' || CHR(13) || CHR(10);
        DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
	      XDB_UTILITIES.mkdir(V_FOLDER_PATH,TRUE);
	    end if;

			if (instr(V_RESOURCE_PATH,'/',-1) != length(V_RESOURCE_PATH)) then
        V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Creating Resource "' || V_RESOURCE_PATH || '".' || CHR(13) || CHR(10);
        DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
  	    XDB_IMPORT_UTILITIES.createResource(V_RESOURCE_PATH, f.CONTENT, P_DUPLICATE_ACTION);	      
      end if;	     
        
    end loop;
	
    V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Unzip completed successfully.' || CHR(13) || CHR(10);
    DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
     
  exception
    when OTHERS then
      V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Unzip failed while processing resource "' || V_RESOURCE_PATH || '".' || CHR(13) || CHR(10);
      DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
      V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Error Message "' || SQLERRM || '".' || CHR(13) || CHR(10);
      DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
      V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'Error Message "' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() || '".' || CHR(13) || CHR(10);
      DBMS_LOB.WRITEAPPEND(V_LOG_FILE_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
      rollback;
  end;
   
  if DBMS_XDB.existsResource(P_LOG_FILE_PATH) then
    DBMS_XDB.deleteResource(P_LOG_FILE_PATH);
  end if;
  V_RESULT := DBMS_XDB.createResource(P_LOG_FILE_PATH,V_LOG_FILE_BUFFER);
  DBMS_LOB.freeTemporary(V_LOG_FILE_BUFFER);
  commit;

end;
--
end;
/
show errors
--
ALTER SESSION SET CURRENT_SCHEMA = SYS
/