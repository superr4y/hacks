// The proxyRequest and proxyResponse functions will be called for all requests  and responses made via ZAP, 
// excluding some of the automated tools
// If they return 'false' then the corresponding request / response will be dropped. 
// You can use msg.setForceIntercept(true) in either method to force a break point

// Note that new proxy scripts will initially be disabled
// Right click the script in the Scripts tree and select "enable"  
eval(''+new String(org.apache.tools.ant.util.FileUtils.readFully(new java.io.FileReader(
                    '/home/user/bin/hacks/zap_scripts/test.js'))));


function proxyRequest(msg) {
	return true
}

function proxyResponse(msg) {
    body = "<html><head><script>var out = document.getElementById('out');out.innerHTML = '";
    body += msg.getResponseBody().toString();
    body += "';</script></head><body><div id='out'></div></body></html>";
    msg.setResponseBody(body);
    println(test());
	return true
}



