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

package com.alducente.services {
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import com.alducente.services.WSProxy;
	import com.alducente.services.WSCache;
	
	public class WSProxy {
		
		private static var __instance:WSProxy;
		private var __cache:WSCache;
		private var __urlLoader:URLLoader;
		private var __completeEvent:Function;
		private var __callQueue:Array = new Array();
		private var __busyOnCall:Boolean = false;
		private var __cacheResults:Boolean = false;
		private var __request:XML;
		private var __servicePath:String;
		
		public function WSProxy(){
			__cache = WSCache.getInstance();
		}
		
		public static function getInstance():WSProxy{
			if(__instance == null){
				__instance = new WSProxy();
			}
			return __instance;
		}
		
		private function callService(onLoad:Function, request:XML, servicePath:String, action:String):void{
			__request = request;
			__servicePath = servicePath;
			__completeEvent = onLoad;
			
			if(__cacheResults){	
				if(__cache.checkCache(servicePath, request)){
					var response:XML = __cache.getCachedResult(servicePath, request);
					__completeEvent(response);
					return;
				}
			}
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.contentType = "text/xml; charset=utf-8";
			urlRequest.method = "POST";
			urlRequest.url = servicePath;
			var soapAction:URLRequestHeader = new URLRequestHeader("SOAPAction", action);
			urlRequest.requestHeaders.push(soapAction);
			urlRequest.data = request;
			__urlLoader = new URLLoader();
			__urlLoader.addEventListener(Event.COMPLETE, onComplete);
			__urlLoader.load(urlRequest);
		}
		
		private function onComplete(evt:Event):void{
			var response:XML = new XML(__urlLoader.data);
			__completeEvent(response);
			if(__cacheResults){
				__cache.setCachedResult(__servicePath, __request, response);
			}
			__busyOnCall = false;
			if(__callQueue.length > 0){
				callService(__callQueue[0].load, __callQueue[0].req, __callQueue[0].path, __callQueue[0].soapAction);
				__callQueue.splice(0,1);
			}
		}
		
		public function callMethod(onLoad:Function, request:XML, servicePath:String, action:String):void{
			if(!__busyOnCall){
				__busyOnCall = true;
				callService(onLoad, request, servicePath, action);
			} else {
				__callQueue.push({load: onLoad, req: request, path: servicePath, soapAction: action});
			}
		}
		
		public function set cacheResults(cache:Boolean):void{
			__cacheResults = cache;
		}
		
		public function clearCache():void{
			__cache.flushCache();
		}
		
	}
	
}