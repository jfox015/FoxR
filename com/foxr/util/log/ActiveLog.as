package com.foxr.util.log
{

	import com.foxr.util.log.ILog;
	import com.foxr.util.log.Log;
	import flash.external.ExternalInterface;  
	/**
	 * An alternative logging class that sends log messages to the ActiveLog ActiveX Control 
	 * in Internet Explorer.
	 * <b>NOTE: </b> You must run your flash application within the Internet Explorer web 
	 * browser for messages to be properly captured.
	 * 
	 * @author	Jeff Fox
	 * @version	1.0.
	 */
	public class ActiveLog extends Log implements ILog {  
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private static var _singleton:ActiveLog = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ActiveLog instance.
		 *
		 */
		public function ActiveLog() { enabled = true; }
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return 	The instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():ActiveLog {
			if ( _singleton == null) _singleton=new ActiveLog(); // END if
			return _singleton;
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Send a log message to the ActiveLog console.
		 * @param	func	Function name
		 * @param	param	Log message
		 */
		public override function callLog(func:String, param:String):void {  
			ExternalInterface.call("ActiveLog.Trace", param, func); 
		}
		
	}
}