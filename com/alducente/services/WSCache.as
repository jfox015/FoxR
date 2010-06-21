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
	
	import com.alducente.services.WSCache;

	public class WSCache {
		
		private static var __instance:WSCache;
		private var __cache:Array;
		
		public function WSCache(){
			__cache = new Array();
		};
		
		public static function getInstance():WSCache{
			if(__instance == null){
				__instance = new WSCache();
			}
			return __instance;
		}
		
		public function checkCache(target:String, req:XML):Boolean{
			var a:Number;
			for(a=0;a<__cache.length;a++){
				if(__cache[a].service == target && String(__cache[a].request) == String(req)){
					return true;
				}
			}
			return false;
		}
		
		public function getCachedResult(target:String, req:XML):XML{
			var a:Number;
			for(a=0;a<__cache.length;a++){
				if(__cache[a].service == target && String(__cache[a].request) == String(req)){
					return __cache[a].response;
				}
			}
			return null;
		}
		
		public function setCachedResult(target:String, req:XML, resp:XML):void{
			if(!checkCache(target, req)){
				__cache.push({service: target, request: req, response: resp});
			}
		}
		
		public function flushCache():Boolean{
			__cache = new Array();
			return true;
		}
	}
	
}