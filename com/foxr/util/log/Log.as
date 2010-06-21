package com.foxr.util.log
{ 
	import flash.events.EventDispatcher;
  
	/**
	 * Base class for all Log interface in the movie library. Child classes 
	 * should override the callLog() method to call the custom Log output target.
	 * 
	 * @author	Jeff Fox
	 * @version	1.0
	 */
	public class Log extends EventDispatcher implements ILog {  
		  
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		protected static var _singleton:* = null;
		protected static var _enabled:Boolean = false;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Log instance.
		 *
		 */
		public function Log() { enabled = true; }
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *  Sets the enabled state.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public function set enabled(t:Boolean):void{ _enabled = t; }  
		public function get enabled():Boolean { return _enabled } 
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return 	The instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():Log {
			if ( _singleton == null) _singleton=new Log(); // END if
			return _singleton;
		}
		/**
		 * Logs a general log level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function log(s:String):void { if(enabled)callLog('log', s); }  
		/**
		 * Logs a debug level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function debug(s:String):void { if(enabled)callLog('debug', s); }  
		/**
		 * Logs an info level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function info(s:String):void { if(enabled)callLog('info', s); }  
		/**
		 * Logs a warning level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function warn(s:String):void { if(enabled)callLog('warn', s); }  
		/**
		 * Logs an error level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function error(s:String):void { if(enabled)callLog('error', s); }  
		/**
		 * Logs an fatal level message to the console.
		 * @param	s	String message
		 * @since	1.0
		 */
		public function fatal(s:String):void { if(enabled)callLog('fatal', s); }  
		
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * Send a log message to the DefaultLog console.
		 * @param	func	Function name
		 * @param	param	Log message
		 */
		public function callLog(func:String, param:String):void {  
			trace(func + ": " + param)  
		}
	}
}