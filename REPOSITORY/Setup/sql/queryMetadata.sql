
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================ */

set linesize  132
set long    10240
--
column "Filename" format A32
column "Camera" format A20
column "Height"   format 99999
column "Width"    format 99999
column "Exposure"   format A20
--
set echo on
--
select object_value
  from IMAGE_METADATA_TABLE m, RESOURCE_VIEW r
 where m.RESID = r.RESID
   and equals_path(res,'/home/%USER%/ImageLibrary/Golden Gate by Night.jpg') = 1
/
pause
--
select FILENAME, MANUFACTURER, MODEL, HEIGHT, WIDTH, TIMING || ' @ F' || APETURE EXPOSURE
  from IMAGE_METADATA_TABLE m, RESOURCE_VIEW r,
       xmlTable
       (
          xmlNamespaces
          (
             'http://xmlns.oracle.com/xdb/XDBResource.xsd' as "res"
          ),
          '$r/res:Resource'
          passing RES as "r"
          COLUMNS
          FILENAME VARCHAR2(64) path 'res:DisplayName'
       ) res,
       xmlTable
       (
          xmlNamespaces
          (
             'http://xmlns.oracle.com/xdb/metadata/ImageMetadata' as "img",
             'http://xmlns.oracle.com/ord/meta/exif' as "exif"
          ),
          '$m/img:imageMetadata/exif:exifMetadata'
          passing OBJECT_VALUE as "m"
          COLUMNS
          MANUFACTURER   varchar2(32) path 'exif:TiffIfd/exif:Make/text()',
          MODEL          varchar2(32) path 'exif:TiffIfd/exif:Model/text()',
          HEIGHT            number(6) path 'exif:ExifIfd/exif:PixelXDimension/text()',
          WIDTH             number(6) path 'exif:ExifIfd/exif:PixelYDimension/text()',
          TIMING          NUMBER(8,6) path 'exif:ExifIfd/exif:ExposureTime/text()',
          APETURE        varchar2(16) path 'exif:ExifIfd/exif:FNumber/text()'
       ) img       
 where m.RESID = r.RESID
   and under_path(res,'/home/%USER%/ImageLibrary') = 1
 order by HEIGHT * WIDTH
/
--
