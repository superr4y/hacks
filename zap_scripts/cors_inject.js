// The proxyRequest and proxyResponse functions will be called for all requests  and responses made via ZAP, 
// excluding some of the automated tools
// If they return 'false' then the corresponding request / response will be dropped. 
// You can use msg.setForceIntercept(true) in either method to force a break point

// Note that new proxy scripts will initially be disabled
// Right click the script in the Scripts tree and select "enable"  

function proxyRequest(msg) {
	return true
}

function proxyResponse(msg) {
	// Debugging can be done using println like this
	// println('proxyResponse called for url=' + msg.getRequestHeader().toString())
	responseHeader = msg.getResponseHeader();
	responseHeader.setMessage(responseHeader.toString()+"\nAccess-Control-Allow-Origin: *\n"+
		"Access-Control-Allow-Credentials: true\n");
	println("inject cors");

	return true
}
