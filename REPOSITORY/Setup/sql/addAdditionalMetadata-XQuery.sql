
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

set long 100000
set echo on
set define off
--
select object_value
  from IMAGE_METADATA_TABLE m, RESOURCE_VIEW r
 where m.RESID = r.RESID
   and equals_path(res,'/home/%USER%/ImageLibrary/Norwich (3).jpg') = 1
/
update IMAGE_METADATA_TABLE m
   set object_value = XMLQUERY(
                        'declare namespace img = "http://xmlns.oracle.com/xdb/metadata/ImageMetadata"; (: :)
                         declare default element namespace "http://www.w3.org/1999/xhtml"; (: :)
                         copy $NEWXML := $XML modify (
                                               	 let $TARGET := $NEWXML/img:imageMetadata
                                                 return (
                                                   insert node element img:Title {$TITLE} into $TARGET,
                                                   insert node element img:Description{$DESCRIPTION} into $TARGET
                                                 )
                                         )
                         return $NEWXML'
                         passing OBJECT_VALUE as "XML",
                                 'Norwich Catherdral from Ethelbert Gate' as "TITLE",
                                 XMLTYPE(
'<div xmlns="http://www.w3.org/1999/xhtml">
<p>In the heart of Norwich stands the Cathedral, separated from the busy streets 
by flint walls and entrance gates, but still a living part of the city. At least 
three services are held in the Cathedral every day, often sung by the choir. The 
choristers are pupils of King Edward VI School, which has its daily assembly in 
the Cathedral. Concerts, lectures and exhibitions also frequently take place here.
<br/>
<br/>
The Cathedral was begun in 1096, the vision of Herbert de Losinga, first bishop 
of Norwich. Building work on the Cathedral, a bishop&apos;s palace and the 
associated Benedictine monastery continued throughout his life, but the Cathedral 
was not finally consecrated until 1278. The building is mainly of Caen stone, 
a pale, honey-coloured limestone brought over from Normandy, but Norfolk flints 
form the core of the Cathedral, and stone from Northamptonshire was used for 
medieval additions.
<br/>
<br/>
This great church has a Norman ground plan and walls, and a Perpendicular roof 
and spire, added after a fire caused by lightning destroyed the wooden roof and 
spire in 1463. The Cathedral spire is 315 ft (96m) high - second only in height 
to that of Salisbury.</p>
</div>'
															   ) as DESCRIPTION
                         returning content
                      )
 where m.RESID = (
         select RESID 
           from RESOURCE_VIEW
          where equals_path(res,'/home/%USER%/ImageLibrary/Norwich (3).jpg') = 1
       )
/
select object_value
  from IMAGE_METADATA_TABLE m, RESOURCE_VIEW r
 where m.RESID = r.RESID
   and equals_path(res,'/home/%USER%/ImageLibrary/Norwich (3).jpg') = 1
/
--
