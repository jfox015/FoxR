package com.foxr.util.log
{

	import com.foxr.util.log.ILog;
	import com.foxr.util.log.Log;
	import flash.external.ExternalInterface;  
	/**
	 * An alternative logging class that sends log messages to the FireFox Firebug extension.
	 * <p />
	 * <b>NOTE: </b> You must run your flash application within a Web browser for Firebug log 
	 * messages to be properly captured.
	 * 
	 * @author	Jeff Fox
	 * @version	1.0
	 */
	public class FireBug extends Log implements ILog {  
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private static var _singleton:FireBug = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new FireBug instance.
		 *
		 */
		public function FireBug() { enabled = true; }
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
		public static function getInstance():FireBug {
			if ( _singleton == null) _singleton=new FireBug(); // END if
			return _singleton;
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Send a log message to the FireBug console.
		 * @param	func	Function name
		 * @param	param	Log message
		 */
		public override function callLog(func:String, param:String):void {  
			ExternalInterface.call("console."+func , param)  
		}
		
	}
}