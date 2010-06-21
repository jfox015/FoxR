/**
* ...
* @author Carlo Alducente
* @version 1.1
* Using this class will enable you to use web services without having to create SOAP requests manually.
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
	
	import com.alducente.services.WSDL;
	import com.alducente.services.WSMethod;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import com.alducente.services.WSProxy;
	
	public dynamic class  WebService extends EventDispatcher{
		private var __wsdl:WSDL;
		private var __availableMethods:Array;
		private var __proxy:WSProxy;
		
		public function WebService(){
			__proxy = WSProxy.getInstance();
		};
			
		private function wsdlComplete(methods:Array):void{
			__availableMethods = methods;
			var a:Number;
			for(a=0;a<__availableMethods.length;a++){
				var method:WSMethod = new WSMethod();
				this[__availableMethods[a].name] = method.createMethod(__availableMethods[a].name, __availableMethods[a].param, __availableMethods[a].targetNS, __availableMethods[a].servicePath, __availableMethods[a].soapAction);
			}
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		public function connect(wsdl:String):void{
			__wsdl = new WSDL(wsdl);
			__wsdl.getWSDL(wsdlComplete);
		}
		
		public function clearCache():void{
			__proxy.clearCache();
		}
		
		public function get availableMethods():Array{
			return __availableMethods;
		}
		
		public function set cacheResults(cache:Boolean):void{
			__proxy.cacheResults = cache;
		}
	}
	
}