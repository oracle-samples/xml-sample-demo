#/* ================================================  
# *    
# * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# *
# * ================================================
# */
DBA=$1
DBAPWD=$2
XFILES=$3
XFILESPWD=$4
XDBEXT=$5
XDBEXTPWD=$6
DEMOUSER=$7
DEMOPWD=$8
SERVERURL=$9
cd XFILES/install 
sh XFILES.sh $DBA $DBAPWD $XFILES $XFILESPWD $SERVERURL
cd ../../ImageMetadata/install
sh ImageMetadata.sh $DBA $DBAPWD $XDBEXT $XDBEXTPWD $SERVERURL
cd ../../XMLSchemaWizard/install
sh XMLSchemaWizard.sh $DBA $DBAPWD $XFILES $XFILESPWD $SERVERURL
cd ../../EVOLUTION/install
sh EVOLUTION.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../FULLTEXT-LITE/install
sh FULLTEXT-LITE.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../GENERATION/install
sh GENERATION.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../INTRODUCTION/install
sh INTRODUCTION.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../NVPAIR/install
sh NVPAIR.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../PARTITIONING/install
sh PARTITIONING.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../REPOSITORY/install
sh REPOSITORY.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../XMLDB-HOL/install
sh XMLDB-HOL.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../XQUERY/install
sh XQUERY.sh $DBA $DBAPWD $DEMOUSER $DEMOPWD $SERVERURL
cd ../../..
