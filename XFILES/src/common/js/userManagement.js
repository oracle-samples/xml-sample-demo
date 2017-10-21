
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

"use strict";          
          
var authStatusURL = '/XFILES/authenticationStatus.xml';

function isBrokenEdgeBrowser() {

  /*
  **
  ** https://developer.microsoft.com/en-us/microsoft-edge/platform/issues/13029031/
  **
  */

  return (navigator.userAgent.indexOf('Edge/15.15063') > 0);
  
}

function isRealSafariBrowser() {
	
  return (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1);
  
}

function getHttpUsername() {

  /* 
  **
  ** Find the user name for the current session...
  **
  ** whoami.xml is a protected resource that can only be accessed by USERS who have been granted XFILES_USER or XFILES_SESSION.
  ** Attempts to access it as ANONYMOUS will fail. 
  **
  ** authenticationStatus.xml is a resource that can be accessed by ANONYMOUS or users who have not been granted XFILES_USER or 
  ** XFILES_SESSION. If attemtpts to access authenticationStatus.xml fail then the ANONYMOUS account has been locked. 
  ** 
  */

  var l_httpUsername = "ANONYMOUS";
  var whoAmIURL = '/XFILES/whoami.xml';
  
  if (useMSXML) {

	  /*
	  **
	  ** The IE Implementation of "load" will fail with "Access is Denied" when accessing a protected resource as the ANONYMOUS user. 
	  ** It will never prompt for authentication.
	  **
	  ** IE appears to always make an inital unauthenticated attempt when requesting a resource. It only provides authentication headers 
	  ** once the browser has rejected the unauthenticated request. This means we cannot use authenticationStatus.xml to determine the 
	  ** state of authentication with IE.
	  **
	  */
 
    try {  	
      var usernameXML = new xmlDocument().load(whoAmIURL);
      l_httpUsername = usernameXML.getDocumentElement().firstChild.nodeValue;
      currentHttpState = httpStateAuthenticated;
 		  var authenticationStatusXML = new xmlDocument().load(authStatusURL);
		  // alert(authenticationStatusXML.serialize());
    }  
    catch (e) {
    	if (e.number == -2147024891) {
    		/*
    		**
    		** Check if ANONYMOUS access is enabled.
    		**
    		*/
    		try {
    		  var authenticationStatusXML = new xmlDocument().load(authStatusURL);
    		  // alert(authenticationStatusXML.serialize());
          currentHttpState = httpStateUnauthenticated;
    		}
        catch (e) {
        	if (e.number == -2147024891) {
            currentHttpState = httpStateUnauthorized;
          }
          else {
            var error = new xfilesException('userManagement.getHttpUsername',14,authStatusURL,e);
            error.setDescription("[MSFT]:Load");
            throw error;
          }
        }
      }
      else {
        var error = new xfilesException('userManagement.getHttpUsername',14,whoAmIURL,e);
        error.setDescription("[MSFT]:Load");
      }
    }
  } 
  else {
 	
  	/*
    **
  	** Start by determining whether or not we are currently connected.
  	**
 	  ** By default the FF Implementation of XHR will automatically prompt for credentials when accessing a protected resource 
  	** Use mozBackgroundRequest to prevent prompting for username and password.
  	**
  	*/
  	
  	try {

      var XHR = soapManager.createGetRequest(authStatusURL,false);

      try {
        XHR.mozBackgroundRequest = true;
   	  }
   	  catch (e) {
        var error = new xfilesException('userManagement.getHttpUsername',14,authStatusURL,e);
        error.setDescription("[GECKO]:Unsupported Firefox / Chrome / Safari Version : Error setting XHR.mozBackgroundRequest=true");
        throw error;
      }
      
      XHR.send(null);
      if (XHR.status == 401) {
      	currentHttpState = httpStateUnauthorized;
      }
      else {
      	if (XHR.status == 200) {
          var isAuthenticatedXML = new xmlDocument().parse(XHR.responseText);
          currentHttpState = isAuthenticatedXML.getDocumentElement().firstChild.nodeValue;
          if (isAuthenticatedUser()) {
          	try {
              var usernameXML = new xmlDocument().load(whoAmIURL);
              l_httpUsername = usernameXML.getDocumentElement().firstChild.nodeValue;
            }
            catch (e) {
              var error = new xfilesException('userManagement.getHttpUsername',14,whoAmIURL,e);
              error.setDescription("[GECKO]:" + XHR.statusText);
              error.setNumber(XHR.status);
              throw error;
            }
          }
        }
        else {
          var error = new xfilesException('userManagement.getHttpUsername',14,authStatusURL,null);
          error.setDescription("[GECKO]:" + XHR.statusText);
          error.setNumber(XHR.status);
          throw error;
        }
      } 
    }  
    catch (e) {
      var error = new xfilesException('userManagement.getHttpUsername',14,null,e);
      throw error;
    }
  }    
  return l_httpUsername;
}  

function setHttpUsername() {
	
	httpUsername = getHttpUsername();

}

function isAuthorizedUser() {
	return (currentHttpState != httpStateUnauthorized);
}

function isAuthenticatedUser() {

	return (currentHttpState == httpStateAuthenticated);

}

function doManualAuthentication(usernameID, passwordID) {
 
  var username = document.getElementById(usernameID).value; 
  var passwd = document.getElementById(passwordID).value;

  var targetURL = '/XFILES/whoami.xml';
  var XHR = soapManager.createGetRequest(targetURL,false,username,passwd);
  try {
  	XHR.mozBackgroundRequest = false;
	}
	catch (e) {
  }
  XHR.send();
  if (XHR.status == 200) {
	closeModalDialog('dialog_ManualLogin');
  	getHttpUsername();
	reloadForm();
  }
  else {
	alert('Invalid Credentials. Please try again or use a different browser.');
  }  
}

function openAuthenticationDialog() {

  openModalDialog('dialog_ManualLogin');

}

function doHttpAuthentication() {
	
	/*
	**
	** Use an XMLHTTPRequest to access the who am i document. This will cause the browser to request HTTP authentication for 
	** an unauthenticated user.
	**
	** Safari and Edge/15 do not appear to respond to a 401 with a request for credentials. This breaks the XFILES
	** login process.
	**
	*/
	
  var targetURL = '/XFILES/whoami.xml';
  var XHR = soapManager.createGetRequest(targetURL,false);
  try {
  	XHR.mozBackgroundRequest = false;
	}
	catch (e) {
  }
  XHR.send();
  if (XHR.status == 200) {
  	getHttpUsername();
  }
  else{
  	if (XHR.status == 401) {
	  if (isBrokenEdgeBrowser() || isRealSafariBrowser()  ) {
		openAuthenticationDialog()
      }		
	  else {
        var error = new xfilesException('userManagement.doHttpAuthentication',1,targetURL,null);
        throw error;
	  }
    }
    else {
      var error = new xfilesException('userManagement.doHttpAuthentication',14,targetURL,null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status);
      throw error;
    } 
  }

}

function doLogon(evt) {
	
	/*
	**
	** Force Login / Verify Authenticated Used by accessing a protected resource. 
	** This will force the browser to prompt for username and password if the session is not authenticated
	** If the Authentication succeeds set httpUsername to value specified in the whoami.xml document
	** If login succeeds reload the current page. Pages that cannot use reload() must override the reloadPage method
	** If login fails redirect to /XFILES home page...
  **
  */

  try {
  
    evt = (evt) ? evt : ((window.event) ? window.event : "")
    doHttpAuthentication();
    // processAuthentication(XHR);
  }
  catch (e) {
    var error = new xfilesException('userManagement.doLogon',12, null, e);
    throw error;
  }
  
}

function ffxClearAuthenticationCache() {
 
  /*
  **
  ** Cannot do graceful HTTP Session logoff with Firebox Browser.
  **
  ** The solution below is proposed on many Web Sites. It appears to only apply to XMLHTTPRequest objects, and 
  ** not to the Browsers HTTP Session, so use with care.
  **
  ** Access a protected resource so at to force an Authentication Challange which will display the Browser's HTTP login dialog.
  ** Clicking cancel on the HTTP Login Dialog will flush the current Authentication information for this website.
  ** Must use Synchronous mode.
  **
  ** At that point the HTTP session will be effectively be logged out.  
  **
  ** Previous implementations have tried setting target as follows :
  **
  ** var target = window.location.protocol + "//" + "ANONYMOUS:ANONYMOUS@" + window.location.hostname + target;
  ** var target = '/XFILES/index.html?reAuthenticate=true';
  **  
  **
  */

	var target = '/XFILES/unauthenticated.xml';

  try {
    var XHR = soapManager.createGetRequest(target, false, 'INVALID', 'CREDENTIAL');
    try {
    	XHR.mozBackgroundRequest = true;
   	}
   	catch (e) {
      var error = new xfilesException('userManagement.ffxClearAuthenticationCache',14,authStatusURL,e);
      error.setDescription("[GECKO]:Unsupported Firefox Version : Error setting XHR.mozBackgroundRequest=true");
      throw error;
    };    
    XHR.send("");
    if (XHR.status != 401) {
      var error = new xfilesException('userManagement.ffxClearAuthenticationCache',14,authStatusURL,null);
      error.setDescription("[GECKO] Unable to clear authentication cache. Please close Browser to complete Logoff. (HTTP Status = '" + XHR.status + "')");
      throw error;
    }    	
  }
  catch(e) {
  	throw new xfilesException('userManagement.ffxClearAuthenticationCache',14,target,e);
  }
 
}

function chromeClearAuthenticationCache() {
 
  /*
  **
  ** Cannot do graceful HTTP Session logoff with Firebox Browser.
  **
  ** The solution below is proposed on many Web Sites. It appears to only apply to XMLHTTPRequest objects, and 
  ** not to the Browsers HTTP Session, so use with care.
  **
  ** Access a protected resource so at to force an Authentication Challange which will display the Browser's HTTP login dialog.
  ** Clicking cancel on the HTTP Login Dialog will flush the current Authentication information for this website.
  ** Must use Synchronous mode.
  **
  ** At that point the HTTP session will be effectively be logged out.  
  **
  ** Previous implementations have tried setting target as follows :
  **
  ** var target = window.location.protocol + "//" + "ANONYMOUS:ANONYMOUS@" + window.location.hostname + target;
  ** var target = '/XFILES/index.html?reAuthenticate=true';
  **  
  **
  */

	var target = '/XFILES/unauthenticated.xml';

  try {
  	showInfoMessage("Logoff not available for Chrome/Safari. Please cancel credential request inorder to end session.");
    var XHR = soapManager.createGetRequest(target, false, 'INVALID', 'CREDENTIAL');
    try {
    	XHR.mozBackgroundRequest = true;
   	}
   	catch (e) {
      var error = new xfilesException('userManagement.chromeClearAuthenticationCache',14,authStatusURL,e);
      error.setDescription("[CHROME]:Unsupported Chrome / Safari Version : Error setting XHR.mozBackgroundRequest=true");
      throw error;
    };    
    XHR.send("");
    if (XHR.status != 401) {
      var error = new xfilesException('userManagement.chromeClearAuthenticationCache',14,authStatusURL,null);
      error.setDescription("[CHROME] Unable to clear authentication cache. Please close Browser to complete Logoff. (HTTP Status = '" + XHR.status + "')");
      throw error;
    }    	
  }
  catch(e) {
  	throw new xfilesException('userManagement.chromeClearAuthenticationCache',14,target,e);
  }
 
}

function clearAuthenticationCache() {

  try {
    self.document.execCommand("ClearAuthenticationCache");
  }
  catch (e) {
  	if (!window.chrome) {
    	ffxClearAuthenticationCache();
    }
    else {
    	chromeClearAuthenticationCache();
  	}
  }

  var xfilesSoapManager = null;
  xslProcessorCache = new Array();
  setHttpUsername();

}

function doLogoff(evt)
{
	try {
		
    evt = (evt) ? evt : ((window.event) ? window.event : "")
    clearAuthenticationCache();
  }
  catch (e) {
    var error = new xfilesException('userManagement.doLogoff',12, null, e);
    throw error;
  }
  
}

function processAuthentication(XHR) {

	/*
	**
	** Note that since the document is not recognized as xml we have to parse the responseText rather than create a new instance from responseXML
	**
	*/

  XHR.send(null);
 
  if (XHR.status == 200) {
    var usernameXML = new xmlDocument().parse(XHR.responseText);
    httpUsername = usernameXML.getDocumentElement().firstChild.nodeValue;
    /*
    try { 
      xfilesSoapManager = new soapServiceManager();
    } catch (e) {
    	try {
    		var test = loadXMLDocument('/XFILES/whoami.xml');
      } catch (e1) {
 	      if (e1.number == -2147024891) {
  	  	  // Access Denied : User Login in inconsistant state...
          var error = new xfilesException('userManagement.processAuthentication',14,null, e);
          error.setDescription("Inconsistant authentication state detected for user " + httpUsername + " : Please close your browser and try again.");
          throw error;
	 		  }
	      else {
	    	  throw e;
	      }      
      }
    }
    */
  }
  else {
  	httpUsername = 'ANONYMOUS';
  	
  }
}

function forceAuthentication() {

  /*
  **
  ** Use protected EPG configuration to invoke WHOAMI Service. 
  ** Use a AJAX GET rather than a DOM load so that an so an unauthenticated session is forced to login in both IE and Firefox.
  ** Reset the value of httpUsername.
  **
  */

  var XHR = createGetRequest('/XFILES/whoami.xml',false);
  procesAuthentication(XHR);

}

function validateUser(restrictedAccessForm) {

  var restrictedAccess = (restrictedAccessForm == "true");

  if (restrictedAccess) {

    if (!isAuthenticatedUser()) {

      /*
      **
      ** Force authentication and reload page.
      **
      */

  	  forceAuthentication()
      reloadPage();
      return false;
    }
  }
   
  return true;

}

function validCredentials(username,password) {

  clearAuthenticationCache();

  try {

    var XHR; 
    var targetURL = "/XFILES/whoami.xml"
    var attemptCount = 0;
    
    do {
      attemptCount++;
      XHR = soapManager.createGetRequest(targetURL , false, username, password);
      processAuthentication(XHR);

      if (XHR.status == 401) {
        return false;
      }

    }
    while ((XHR.status == 12152) && (attemptCount < 2));
 
    if (attemptCount > 2) {
      var error = new xfilesException('userManagement.validCredentials',14,targetURL, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status);
      throw error;
    }

  }
  catch (e) {
    var error = new xfilesException('userManagement.validCredentials',14, resourceURL, e);
    throw error;
  }
  
  return true;
  
}

function validateDBA() {

  try {

    resourceURL = "/xdbconfig.xml"
    var XHR = createGetRequest(resourceURL , false);
    XHR.send(null);

    // alert('XHR(' +targetURL + ' = ') : Status = XHR.status);

    if (XHR.status == 200) {
      window.location.reload(true);
      return true;
    }

    if (XHR.status == 401) {
      showUserErrorMessage("This user is not a DBA. This step cannot be executed.");
      enableCloseButton();
      return false;
    }
  }
  catch (e) {
    var error = new xfilesException('userManagement.validCredentials',14, resourceURL, e);
    throw error;
  }

}

function processsPasswordReset(mgr, message) {

  var successMessage = 'Operation Successful';
  if (typeof message != "undefined") {
    successMessage = message;
  }

  try {
    var soapResponse = mgr.getSoapResponse('userManagement.processsPasswordReset');
    showInfoMessage(successMessage);
    closePopupDialog();

  }
  catch (e) {
    handleException('userManagement.processsPasswordReset',null,e);
  }

}

function openSetPasswordDialog(evt) {
  document.getElementById('newPassword1').value = "";
  document.getElementById('newPassword2').value = "";
  openModalDialog('setPasswordDialog')
}

function doSetPassword(evt) {
  openSetPasswordDialog(evt);
}

function setUserOptions() {

  var pwd1 = document.getElementById('newPassword1').value;
  var pwd2 = document.getElementById('newPassword2').value;

  if ((pwd1) || (pwd2)) {
    if (pwd1 != pwd2) {
      showUserErrorMessage('Password must match');
      document.getElementById('newPassword1').focus;
      return false;
    }
  }

  var resetHomeFolder    = booleanToNumber(document.getElementById('resetHomeFolder').checked)
  var recreateHomePage   = booleanToNumber(document.getElementById('recreateHomePage').checked)
  var resetPublicFolder  = booleanToNumber(document.getElementById('resetPublicFolder').checked)
  var recreatePublicPage = booleanToNumber(document.getElementById('recreatePublicPage').checked)

  try {
    var schema  = "XFILES";
    var packageName = "XFILES_USER_SERVICES";
    var method =  "RESETUSEROPTIONS";
  
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processsPasswordReset(mgr, 'User Updated')}};
  	  	
  	var parameters = new Object;
  	parameters["P_NEW_PASSWORD-VARCHAR2-IN"]   = pwd1
  	parameters["P_RESET_PUBLIC_FOLDER-BOOLEAN-IN"]   = resetPublicFolder
  	parameters["P_RESET_HOME_FOLDER-BOOLEAN-IN"]   = resetHomeFolder
  	parameters["P_RECREATE_PUBLIC_PAGE-BOOLEAN-IN"]   = recreatePublicPage
  	parameters["P_RECREATE_HOME_PAGE-BOOLEAN-IN"]   = recreateHomePage

    mgr.sendSoapRequest(parameters)
  } 
  catch (e) {
    handleException('userManagement.setUserOptions',e,null);
  }
  
}

function addUsersToUserList(optionList) {

	var selectList = document.getElementById('userList');
	selectList.innerHTML = "";
	var width = 0;
	for (var i=0; i< optionList.length; i++) {
	  var user = optionList.item(i);
	  var value = user.firstChild.nodeValue;
	  var option = document.createElement("option");
	  selectList.appendChild(option);
	  option.id = value;
	  option.value = value;
    var text = document.createTextNode(value);
    option.appendChild(text);
    if (width < value.length) {
      width = value.length
    }
 }

 selectList.width = width;

}

function processAdminPrivileges(mgr,evt) {

	var soapResponse = mgr.getSoapResponse('userManagement.processAdminPrivileges');

  var namespaces = xfilesNamespaces; 
  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

  document.getElementById('newUserPassword1').value = "";
  document.getElementById('newUserPassword2').value = "";
  document.getElementById('username').value = "";
  openModalDialog('manageUsersDialog')

  var div
 	div = document.getElementById('dbaOnly');
 	div.style.display="none";
 	div = document.getElementById('xfilesAdmin');
  div.style.display="none";
  div = document.getElementById('noAdminRights');
  div.style.display="block";

  var userList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:UserPrivileges/tns:userList/tns:user",namespaces);
  addUsersToUserList(userList);

  var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:UserPrivileges[tns:dba=1]",namespaces);
  if (nodeList.length == 1) {
  	div = document.getElementById('dbaOnly');
  	div.style.display="block";
  	div = document.getElementById('xfilesAdmin');
   	div.style.display="block";
  	div = document.getElementById('noAdminRights');
   	div.style.display="none";
   	return;
  }

  var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:UserPrivileges[tns:xfilesAdmin=1]",xfilesNamespaces);
  if (nodeList.length == 1) {
  	div = document.getElementById('dbaOnly');
  	div.style.display="none";
	  div = document.getElementById('xfilesAdmin');
  	div.style.display="block";
  	div = document.getElementById('noAdminRights');
   	div.style.display="none";
  	div = document.getElementById('adminOptionButton');
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:UserPrivileges/tns:xfilesAdmin[text()=1 and @withGrant=1]",xfilesNamespaces);
    if (nodeList.length == 1) {
     	div.style.display="block";
    }
    else {
     	div.style.display="none";
    }
   	return;
  }

}

function checkAdminPrivileges(evt) {

  var schema  = "XFILES";
  var packageName = "XFILES_USER_SERVICES";
  var method =  "GETUSERPRIVILEGES";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
 	var XHR  = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processAdminPrivileges(mgr,evt)}};

	var parameters = new Object;
  mgr.sendSoapRequest(parameters);
	
}


function openManageUsersDialog(evt) {
	checkAdminPrivileges(evt);
}

function doManageUsers(evt) {
  openManageUsersDialog(evt);
}

function manageUser(userName, pwd1, pwd2) {

  if (pwd1 != pwd2) {
    showUserErrorMessage('Password must match');
    document.getElementById('newPassword1').focus;
    return false;
  }
  
  try {

    var schema  = "XFILES";
    var packageName = "XFILES_ADMIN_SERVICES";
    var method =  "CREATEXFILESUSER";
  
  	var mgr = soapManager.getRequestManager(schema,packageName,method);    	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { reportSuccess(mgr, 'User Created')}};
  	
  	var parameters = new Object;
  	parameters["P_PRINCIPLE_NAME-VARCHAR2-IN"]   = userName
  	parameters["P_PASSWORD-VARCHAR2-IN"]   = pwd1
  	
    mgr.sendSoapRequest(parameters)
  } 
  catch (e) {
    handleException('userManagement.manageUser',e,null);
  }
  
}

function updateRole(user,role) {

  var schema  = "XFILES";
  var packageName = "XFILES_ADMIN_SERVICES ";
  var method;
  var message;
  
  if (role == 'disabled') {
  	method =  "REVOKEXFILES";
   	message =  'XFiles access revoked from "' + user + '"';
  }
 
  if (role == 'user') {
    method =  "GRANTXFILESUSER";
    message =   'XFiles access emabled for "' + user + '"';
  }
 
  if (role == 'administrator') {
    method =  "GRANTXFILESADMINISTRATOR";
    message =  'XFiles adminstration enabled for "' + user + '"';
  }
 
  var mgr = soapManager.getRequestManager(schema,packageName,method);
  var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { reportSuccess(mgr,message)}};
  
  var parameters = new Object;
  parameters["P_PRINCIPLE_NAME-VARCHAR2-IN"]   = user

  mgr.sendSoapRequest(parameters);
 
}

function setUserRole() {

  try {
		var selectList = document.getElementById('userList');
    var roleList = document.getElementsByName('roleSelector');
    var newRole;

    for (var i = 0; i < roleList.length; i++) {
      if (roleList[i].checked) {
      	newRole = roleList[i].value;
      }
    }

    for (var i = 0; i < selectList.options.length; i++) {
      if (selectList.options[i].selected) {
      	updateRole(selectList.options[i].value, newRole);
      }
    }
  } 
  catch (e) {
    handleException('userManagement.setUserRole',e,null);
  }
}

function doReauthentication(currentUser,URL) {
		
	var authenticatedUser = null;
	try {
   	try {
  		authenticatedUser = getHttpUsername();
   		authenticatedUser = getHttpUsername();
  	} 
  	catch (e) { // Fail with 501 ?
  		authenticatedUser = getHttpUsername();
  	}; 
   	if (authenticatedUser != currentUser) {
      var error = new xfilesException('RestAPI.doReauthentication',7, URL, e);
      error.setDescription('User Mismatch following ReAuthentication : Expected "' + schema + '", found "' + authenticatedUser + '".');
   	  throw error;
	  }  		
  }
  catch (e) {
    var error = new xfilesException('RestAPI.doReauthentication',7, URL, e);
    error.setDescription('Exeception raised while performing ReAuthentication process for "' + schema + '".');
  	throw error;
  }	  	
}