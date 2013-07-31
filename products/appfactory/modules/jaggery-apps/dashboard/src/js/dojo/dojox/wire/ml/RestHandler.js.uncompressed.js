// wrapped by build app
define("dojox/wire/ml/RestHandler", ["dijit","dojo","dojox","dojo/require!dojox/wire/_base,dojox/wire/ml/util"], function(dijit,dojo,dojox){
dojo.provide("dojox.wire.ml.RestHandler");

dojo.require("dojox.wire._base");
dojo.require("dojox.wire.ml.util");

dojo.declare("dojox.wire.ml.RestHandler", null, {
	// summary:
	//		A REST service handler
	// description:
	//		This class serves as a base REST service.
	//		Sub-classes may override _getContent() and _getResult() to handle
	//		specific content types.
	contentType: "text/plain",
	handleAs: "text",

	bind: function(method, parameters, deferred, url){
		// summary:
		//		Call a service method with parameters.
		// description:
		//		A service is called with a URL generated by _getUrl() and
		//		an HTTP method specified with 'method'.
		//		For "POST" and "PUT", a content is generated by _getContent().
		//		When data is loaded, _getResult() is used to pass the result to
		//		Deferred.callback().
		// method:
		//		A method name
		// parameters:
		//		An array of parameters
		// deferred:
		//		'Deferred'
		// url:
		//		A URL for the method
		method = method.toUpperCase();
		var self = this;
		var args = {
			url: this._getUrl(method, parameters, url),
			contentType: this.contentType,
			handleAs: this.handleAs,
			headers: this.headers,
			preventCache: this.preventCache
		};
		var d = null;
		if(method == "POST"){
			args.postData = this._getContent(method, parameters);
			d = dojo.rawXhrPost(args);
		}else if(method == "PUT"){
			args.putData = this._getContent(method, parameters);
			d = dojo.rawXhrPut(args);
		}else if(method == "DELETE"){
			d = dojo.xhrDelete(args);
		}else{ // "GET"
			d = dojo.xhrGet(args);
		}
		d.addCallbacks(function(result){
			deferred.callback(self._getResult(result));
		}, function(error){
			deferred.errback(error);
		});
	},

	_getUrl: function(/*String*/method, /*Array*/parameters, /*String*/url){
		// summary:
		//		Generate a URL
		// description:
		//		If 'method' is "GET" or "DELETE", a query string is generated
		//		from a query object specified to the first parameter in
		//		'parameters' and appended to 'url'.
		//		If 'url' contains variable seguments ("{parameter_name}"),
		//		they are replaced with corresponding parameter values, instead.
		// method:
		//		A method name
		// parameters:
		//		An array of parameters
		// url:
		//		A base URL
		// returns:
		//		A URL
		var query;
		if(method == "GET" || method == "DELETE"){
			if(parameters.length > 0){
				query = parameters[0];
			}
		}else{ // "POST" || "PUT"
			if(parameters.length > 1){
				query = parameters[1];
			}
		}
		if(query){
			var queryString = "";
			for(var name in query){
				var value = query[name];
				if(value){
					value = encodeURIComponent(value);
					var variable = "{" + name + "}";
					var index = url.indexOf(variable);
					if(index >= 0){ // encode in path
						url = url.substring(0, index) + value + url.substring(index + variable.length);
					}else{ // encode as query string
						if(queryString){
							queryString += "&";
						}
						queryString += (name + "=" + value);
					}
				}
			}
			if(queryString){
				url += "?" + queryString;
			}
		}
		return url; //String
	},

	_getContent: function(/*String*/method, /*Array*/parameters){
		// summary:
		//		Generate a request content
		// description:
		//		If 'method' is "POST" or "PUT", the first parameter in
		//		'parameters' is returned.
		// method:
		//		A method name
		// parameters:
		//		An array of parameters
		// returns:
		//		A request content
		if(method == "POST" || method == "PUT"){
			return (parameters ? parameters[0] : null); //anything
		}else{
			return null; //null
		}
	},

	_getResult: function(/*anything*/data){
		// summary:
		//		Extract a result
		// description:
		//		A response data is returned as is.
		// data:
		//		A response data returned by a service
		// returns:
		//		A result object
		return data; //anything
	}
});

});
