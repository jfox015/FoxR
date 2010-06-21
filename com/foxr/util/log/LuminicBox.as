package com.foxr.util.log
{

	import com.foxr.util.log.ILog;
	import com.foxr.util.log.Log;
	import com.luminicbox.log.Logger;
	import com.luminicbox.log.ConsolePublisher;
	/**
	 * An alternative logging class that sends log messages to the a LuminicBox Publisher 
	 * Console.
	 * <p />
	 * <b>NOTE: </b> You must run your flash application within a Web browser for LuminicBox log 
	 * messages to be properly captured.
	 * 
	 * @author	Jeff Fox
	 * @version	1.0
	 */
	public class LuminicBox extends Log implements ILog {  
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private static var _singleton:LuminicBox = null;
		
		private var _logger:Logger = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new LuminicBox instance.
		 *
		 */
		public function LuminicBox() { 
			super();
			_logger = new Logger('appLogger');
			_logger.addPublisher(new ConsolePublisher());
		}
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
		public static function getInstance():LuminicBox {
			if ( _singleton == null) _singleton=new LuminicBox(); // END if
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
			_logger[func](param); 
		}
		
	}
}