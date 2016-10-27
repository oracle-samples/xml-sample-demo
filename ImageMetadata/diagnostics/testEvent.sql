
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
 * ================================================
 */

set echo on
--
def USERNAME = &1
--
def PASSWORD = &2
--
connect &USERNAME/&PASSWORD
--
set serveroutput on
-- 
 call image_processor.handle_event(xmltype(
'<ResourceEvent xmlns="http://xmlns.oracle.com/xdb/resourceEvent">
   <CurrentUser>&USERNAME</CurrentUser>
   <EventType>3</EventType>
   <resourcePath>/home/&USERNAME/ImageLibrary/Concorde.jpg</resourcePath>
   <new>
     <ACL></ACL>
     <Author/>
     <CharacterSet>UTF-8</CharacterSet>
     <Comment/>
     <ContentType>image/jpeg</ContentType>
     <CreationDate>22-SEP-07 04.35.22.984000 AM</CreationDate>
     <Creator>&USERNAME</Creator>
     <DisplayName>Florence.jpg</DisplayName>
     <Language>en-us</Language>
     <ModificationDate>22-SEP-07 04.35.22.984000 AM</ModificationDate>
     <LastModifier>&USERNAME</LastModifier>
     <Owner>&USERNAME</Owner>
     <RefCount>1</RefCount>
   </new>
 </ResourceEvent>'))
/
set define on
