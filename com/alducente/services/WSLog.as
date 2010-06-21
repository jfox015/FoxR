/**
* ...
* @author Default
* @version 0.1
*/

package com.alducente.services {
	
	public class WSLog {
		
		private static var __instance:WSLog;
		private var __logList:Array;
		
		public function WSLog(){
			__logList = new Array();
		}
		
		public static function getInstance():WSLog{
			if(__instance == null){
				__instance = new WSLog();
			}
			return __instance;
		}
		
		public function addToLog(t:Number, m:String):void{
			__logList.push({time: t, message: m});
		}
	}
	
}