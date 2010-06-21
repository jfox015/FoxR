package com.foxr.util.log
{ 
	/**
	 * Base interface for the Log object.
	 * 
	 * @author	Jeff Fox
	 * @version	1.0
	 * @see 	com.foxr.util.log.Log
	 */
	public interface ILog {  
		  
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		function log(s:String):void  
		
		function debug(s:String):void  
		
		function info(s:String):void 
		
		function warn(s:String):void  
		
		function error(s:String):void  
		
		function fatal(s:String):void  
		
		function callLog(func:String,param:String):void
	}
}