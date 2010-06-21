/**
* ...
* @author Carlo Alducente
* @version 1.1
* 
* 
Copyright (c) 2007 Carlo Alducente

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.alducente.services{
	
	import com.alducente.services.WSProxy;

	public dynamic class WSMethod {
		
		private var __action:String;
		private var __servicePath:String;
		private var __methodName:String;
		private var __params:Array;
		private var __targetNamespace:String;
		private var __proxy:WSProxy;
		
		public function WSMethod(){
			__proxy = WSProxy.getInstance();
		};
		
		private function myMethod(loaded:Function, ...args):void{
			var params:String = new String();
			var a:Number;
			for(a=0;a<__params.length;a++){
				var argument:String = "";
				if(args[a] != undefined){
					argument = args[a];
				}
				params += '<' + __params[a] + '>' + argument + '</' + __params[a] + '>';
			}
	  
			var soapRequest:String = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
			soapRequest += '<soap:Body>';
			soapRequest += '<' + __methodName + ' xmlns="' + __targetNamespace + '">';
			soapRequest += params;
			soapRequest += '</' + __methodName + '>';
			soapRequest += '</soap:Body>';
			soapRequest += '</soap:Envelope>';
			
			var request:XML = new XML(soapRequest);
			
			/**
			 * PUT SENDING ACTION HERE
			 */
			__proxy.callMethod(loaded, request, __servicePath, __action);
		}
		
		public function createMethod(name:String, param:Array, ns:String, service:String, action:String):Function{
			__servicePath = service;
			__methodName = name;
			__params = param;
			__targetNamespace = ns;
			__action = action;
			return myMethod;
		}
		
	}
	
}