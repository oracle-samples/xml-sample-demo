
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
declare 
  V_SOURCE_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_HOME || '/icons/famfamfam/icons'; 
  V_TARGET_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/lib/icons';
  V_KML_FOLDER    VARCHAR2(700) := V_TARGET_FOLDER || '/KML';
  V_RESULT        BOOLEAN;
begin                                                                                     
  dbms_xdb.link(XFILES_CONSTANTS.FOLDER_HOME || '/icons/famfamfam/readme.txt',  V_TARGET_FOLDER,   'famfamfam.txt',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/user_add.png',                  V_TARGET_FOLDER,   'addUser.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/user_edit.png',                 V_TARGET_FOLDER,   'setPassword.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/door_in.png',                   V_TARGET_FOLDER,   'login.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/door_out.png',                  V_TARGET_FOLDER,   'logout.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/help.png',                      V_TARGET_FOLDER,   'help.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_link.png',               V_TARGET_FOLDER,   'repositoryRoot.png',DBMS_XDB.LINK_TYPE_WEAK);
	dbms_xdb.link(V_SOURCE_FOLDER || '/house_go.png',                  V_TARGET_FOLDER,   'homeFolder.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/find.png',                      V_TARGET_FOLDER,   'search.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/magnifier.png',                 V_TARGET_FOLDER,   'guidedSearch.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_down.png',         V_TARGET_FOLDER,   'dsort.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_up.png',           V_TARGET_FOLDER,   'asort.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/cog.png',                       V_TARGET_FOLDER,   'doAction.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_add.png',                V_TARGET_FOLDER,   'newFolder.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_add.png',                  V_TARGET_FOLDER,   'uploadFile.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/book_add.png',                  V_TARGET_FOLDER,   'newWikiPage.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/xhtml_add.png',                 V_TARGET_FOLDER,   'addIndexPage.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/lock.png',                      V_TARGET_FOLDER,   'lockedDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_wrench.png',         V_TARGET_FOLDER,   'pageProperties.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_stack.png',          V_TARGET_FOLDER,   'versionedDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_go.png',             V_TARGET_FOLDER,   'checkedOutDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/cancel.png',                    V_TARGET_FOLDER,   'cancel.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/accept.png',                    V_TARGET_FOLDER,   'accept.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/disk.png',                      V_TARGET_FOLDER,   'save.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/disk_grey.png',                 V_TARGET_FOLDER,   'saveDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/saveAndClose.png',              V_TARGET_FOLDER,   'saveAndClose.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_save.png',             V_TARGET_FOLDER,   'saveChanges.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_go.png',               V_TARGET_FOLDER,   'saveChangesAndClose.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/tick.png',                      V_TARGET_FOLDER,   'saveChange.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/cross.png',                     V_TARGET_FOLDER,   'cancelChange.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_add.png',                V_TARGET_FOLDER,   'editSimpleText.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_delete.png',             V_TARGET_FOLDER,   'undoSimpleText.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/note_edit.png',                 V_TARGET_FOLDER,   'editMultiLineText.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/note_delete.png',               V_TARGET_FOLDER,   'undoMultiLineText.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_right.png',        V_TARGET_FOLDER,   'repositoryFolder.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_bottom.png',       V_TARGET_FOLDER,   'repositoryFile.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_save.png',                 V_TARGET_FOLDER,   'download.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/magnifier.png',                 V_TARGET_FOLDER,   'preview.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/note_edit.png',                 V_TARGET_FOLDER,   'editValue.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/note_add.png',                  V_TARGET_FOLDER,   'addValue.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/note_delete.png',               V_TARGET_FOLDER,   'removeValue.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/note_error.png',                V_TARGET_FOLDER,   'resetValue.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/feed.png',                      V_TARGET_FOLDER,   'feed.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/feed_add.png',                  V_TARGET_FOLDER,   'enableFeed.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/feed_delete.png',               V_TARGET_FOLDER,   'disableFeed.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_open_yellow.png',        V_TARGET_FOLDER,   'readOnlyFolderOpen.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_closed_yellow.png',      V_TARGET_FOLDER,   'readOnlyFolderClosed.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_open_green.png',         V_TARGET_FOLDER,   'writeFolderOpen.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_closed_green.png',       V_TARGET_FOLDER,   'writeFolderClosed.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_state_open.png',         V_TARGET_FOLDER,   'hideChildren.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_state_closed.png',       V_TARGET_FOLDER,   'showChildren.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_pause_blue.png',        V_TARGET_FOLDER,   'pageNotReady.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_play_blue.png',         V_TARGET_FOLDER,   'pageReady.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/attribute.png',                 V_TARGET_FOLDER,   'attribute.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/attribute_show.png',            V_TARGET_FOLDER,   'elementShowAttrs.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/attribute_hide.png',            V_TARGET_FOLDER,   'elementHideAttrs.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/tag.png',                       V_TARGET_FOLDER,   'element.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/element_expand.png',            V_TARGET_FOLDER,   'elementExpand.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/element_hide.png',              V_TARGET_FOLDER,   'elementHideChildren.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/element_show.png',              V_TARGET_FOLDER,   'elementShowChildren.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_grey.png',               V_TARGET_FOLDER,   'pathSearch.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder.png',                    V_TARGET_FOLDER,   'notPathSearch.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/key_grey.png',                  V_TARGET_FOLDER,   'uniqueKey.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/key.png',                       V_TARGET_FOLDER,   'notUniqueKey.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_add.png',                V_TARGET_FOLDER,   'showNodeValue.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_delete.png',             V_TARGET_FOLDER,   'hideNodeValue.png',DBMS_XDB.LINK_TYPE_WEAK);
	dbms_xdb.link(V_SOURCE_FOLDER || '/table_add.png',                 V_TARGET_FOLDER,   'addTable.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_refresh.png',          V_TARGET_FOLDER,   'reloadTree.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_stop_blue.png',         V_TARGET_FOLDER,   'showSubGroup.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/hide_sub_group.png',            V_TARGET_FOLDER,   'hideSubGroup.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                          
                                                                                           
  dbms_xdb.link(V_SOURCE_FOLDER || '/cup.png',                       V_TARGET_FOLDER,   'javaSource.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/script.png',                    V_TARGET_FOLDER,   'jscriptSource.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database.png',                  V_TARGET_FOLDER,   'sql.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                            
  dbms_xdb.link(V_SOURCE_FOLDER || '/page.png',                      V_TARGET_FOLDER,   'document.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/application.png',               V_TARGET_FOLDER,   'application.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_word.png',                 V_TARGET_FOLDER,   'wordDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_excel.png',                V_TARGET_FOLDER,   'excelDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_powerpoint.png',     V_TARGET_FOLDER,   'pptDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page.png',                      V_TARGET_FOLDER,   'textDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/tag.png',                       V_TARGET_FOLDER,   'xmlDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/book_edit.png',                 V_TARGET_FOLDER,   'wikiDocument.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/compress.png',                  V_TARGET_FOLDER,   'zip.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_acrobat.png',        V_TARGET_FOLDER,   'pdf.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                            
  dbms_xdb.link(V_SOURCE_FOLDER || '/image.png',                     V_TARGET_FOLDER,   'imageJPEG.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/image.png',                     V_TARGET_FOLDER,   'imageGIF.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/image.png',                     V_TARGET_FOLDER,   'imageTIF.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/image.png',                     V_TARGET_FOLDER,   'imageBMP.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/image.png',                     V_TARGET_FOLDER,   'imagePNG.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                            
  dbms_xdb.link(V_SOURCE_FOLDER || '/film.png',                      V_TARGET_FOLDER,   'mov.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/film.png',                      V_TARGET_FOLDER,   'mp4.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/film.png',                      V_TARGET_FOLDER,   'avi.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                            
  dbms_xdb.link(V_SOURCE_FOLDER || '/printer.png',                   V_TARGET_FOLDER,   'printPurchaseOrder.png',DBMS_XDB.LINK_TYPE_WEAK);
                                                                                            
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_world.png',                V_TARGET_FOLDER,   'htmlPage.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_world.png',                V_TARGET_FOLDER,   'xhtmlPage.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/world.png',                     V_TARGET_FOLDER,   'browser.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/folder_explore.png',            V_TARGET_FOLDER,   'EXPLORER.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/application_xp_terminal.png',   V_TARGET_FOLDER,   'CommandWindow.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_excel.png',          V_TARGET_FOLDER,   'MicrosoftExcel.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_word.png',           V_TARGET_FOLDER,   'MicrosoftWord.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_gear.png',             V_TARGET_FOLDER,   'SQLPLUS.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/world.png',                     V_TARGET_FOLDER,   'HTTP.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/transmit_blue.png',             V_TARGET_FOLDER,   'FTP.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/database_lightning.png',        V_TARGET_FOLDER,   'executeQuery.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_add.png',              V_TARGET_FOLDER,   'expandCodeView.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_delete.png',           V_TARGET_FOLDER,   'restoreCodeView.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_refresh.png',          V_TARGET_FOLDER,   'reloadScript.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_add.png',                  V_TARGET_FOLDER,   'expandOutput.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_delete.png',               V_TARGET_FOLDER,   'restoreOutput.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/page_white_wrench.png',         V_TARGET_FOLDER,   'showPlan.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_table.png',            V_TARGET_FOLDER,   'showResults.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_stop.png',              V_TARGET_FOLDER,   'stopDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_stop_blue.png',         V_TARGET_FOLDER,   'stopEnabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_fastforward.png',       V_TARGET_FOLDER,   'nextDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_fastforward_blue.png',  V_TARGET_FOLDER,   'nextEnabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_rewind.png',            V_TARGET_FOLDER,   'prevDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_rewind_blue.png',       V_TARGET_FOLDER,   'prevEnabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_play.png',              V_TARGET_FOLDER,   'startDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_play_blue.png',         V_TARGET_FOLDER,   'startEnabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_pause.png',             V_TARGET_FOLDER,   'pauseDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/control_pause_blue.png',        V_TARGET_FOLDER,   'pauseEnabled.png',DBMS_XDB.LINK_TYPE_WEAK);
 
  dbms_xdb.link(V_SOURCE_FOLDER || '/server.png',                    V_TARGET_FOLDER,   'simulationComplete.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_go.png',                 V_TARGET_FOLDER,   'simulationStart.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_lightning.png',          V_TARGET_FOLDER,   'simulationRunning.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/world_go.png',                  V_TARGET_FOLDER,   'mapSearch.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/world_delete.png',              V_TARGET_FOLDER,   'mapClear.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_gear.png',             V_TARGET_FOLDER,   'showQuery.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_lightning.png',        V_TARGET_FOLDER,   'executeSQL.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_go.png',                 V_TARGET_FOLDER,   'showSOAPRequest.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_response.png',           V_TARGET_FOLDER,   'showSOAPResponse.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/script_lightning.png',          V_TARGET_FOLDER,   'showNodeList.png',DBMS_XDB.LINK_TYPE_WEAK);

  dbms_xdb.link(V_SOURCE_FOLDER || '/resultset_next.png',            V_TARGET_FOLDER,   'wizardNext.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/resultset_previous.png',        V_TARGET_FOLDER,   'wizardPrev.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/resultset_next.png',            V_TARGET_FOLDER,   'shiftRight.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/resultset_previous.png',        V_TARGET_FOLDER,   'shiftLeft.png',DBMS_XDB.LINK_TYPE_WEAK);
  
  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_down.png',         V_TARGET_FOLDER,   'xml_visible_children.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/bullet_arrow_right.png',        V_TARGET_FOLDER,   'xml_hidden_children.png',DBMS_XDB.LINK_TYPE_WEAK);

  -- Mappings for JSON Demo

  dbms_xdb.link(V_SOURCE_FOLDER || '/database_add.png',              V_TARGET_FOLDER,   'json_create_collection.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_delete.png',           V_TARGET_FOLDER,   'json_delete_collection.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/table_key.png',                 V_TARGET_FOLDER,   'json_get_keys.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/table_lightning.png',           V_TARGET_FOLDER,   'json_get_documents.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/table_add.png',                 V_TARGET_FOLDER,   'json_create_document.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/table_go.png',                  V_TARGET_FOLDER,   'json_update_document.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/table_delete.png',              V_TARGET_FOLDER,   'json_delete_document.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/find.png',                      V_TARGET_FOLDER,   'json_query_collection.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_add.png',                V_TARGET_FOLDER,   'json_add_field.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/pencil_delete.png',             V_TARGET_FOLDER,   'json_remove_field.png',DBMS_XDB.LINK_TYPE_WEAK);

  if (not DBMS_XDB.existsResource(V_KML_FOLDER)) then
    V_RESULT := DBMS_XDB.createFolder(V_KML_FOLDER);
  end if;

  dbms_xdb.link(V_SOURCE_FOLDER || '/world_go.png',                  V_KML_FOLDER,   'mapSearch.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/world_add.png',                 V_KML_FOLDER,   'mapAddPoint.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/world_delete.png',              V_KML_FOLDER,   'mapClear.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/database_gear.png',             V_KML_FOLDER,   'showQuery.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_response.png',           V_KML_FOLDER,   'showSOAPResponse.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/server_go.png',                 V_KML_FOLDER,   'showSOAPRequest.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/world_link.png',                V_KML_FOLDER,   'showKML.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/cancel.png',                    V_KML_FOLDER,   'cancel.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/accept.png',                    V_KML_FOLDER,   'accept.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/disk.png',                      V_KML_FOLDER,   'save.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/disk_grey.png',                 V_KML_FOLDER,   'saveDisabled.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER || '/image_add.png',                 V_KML_FOLDER,   'imageAdd.png',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
