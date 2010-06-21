package com.foxr.factory 
{
	import com.foxr.util.log.*;
	import com.foxr.data.GlobalConstants;
	
	/**
	 * Implements the factory pattern for creating new Log Objects.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class LogFactory {
		
		/*-----------------------------------
		/	VARIABLES
		/----------------------------------*/
		// static variables
		/**
		 * Static name property.
		 */
		private static var NAME:String = "LogFactory.";
		/**
		 * Singleton instance.
		 */
		private static var _singleton:LogFactory = null;
		/**
		 * Concrete child instances.
		 */
		private static var _instances:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new LogFactory instance.
		 *
		 */
		public function LogFactory() {
			_instances = new Object();
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Creates a concrete instance of a child log object and returns it.
		 * @param 		type	A valid log type to be created
		 * @return  	An instance of the chosen log implementation
		 * @since		1.0
		 * 
		 */
		public function getLoggerbyName(type:String):ILog {
			switch(type) {
				case GlobalConstants.LOG_ACTIVELOG:
					if (_instances[GlobalConstants.LOG_ACTIVELOG] == null) {
						_instances[GlobalConstants.LOG_ACTIVELOG]= new ActiveLog();
					}
					return _instances[GlobalConstants.LOG_ACTIVELOG];
					break;
				case GlobalConstants.LOG_FIREBUG:
					if (_instances[GlobalConstants.LOG_FIREBUG] == null) {
						_instances[GlobalConstants.LOG_FIREBUG]= new FireBug();
					}
					return _instances[GlobalConstants.LOG_FIREBUG];
					break;
				case GlobalConstants.LOG_LUMINICBOX:
					if (_instances[GlobalConstants.LOG_LUMINICBOX] == null) {
						_instances[GlobalConstants.LOG_LUMINICBOX]= new LuminicBox();
					}
					return _instances[GlobalConstants.LOG_LUMINICBOX];
					break;
				case GlobalConstants.LOG_DEFAULT:
				default:
					if (_instances[GlobalConstants.LOG_DEFAULT] == null) {
						_instances[GlobalConstants.LOG_DEFAULT]= new Log();
					}
					return _instances[GlobalConstants.LOG_DEFAULT];
					break;	
			} // END switch
		}
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return Object - the instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():LogFactory {
			if ( _singleton == null) _singleton = new LogFactory(); // END if
			return _singleton;
		}
	}
}