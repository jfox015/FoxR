package com.foxr.factory 
{

	/**
	 * Implements the factory pattern for creating new analytics Objects.
	 * <p />
	 * <b>NOTE:</b> This class currently serves as a placeholder for the implementation
	 * of third party analytics tools such as Omniture.
	 * 
	 * @author		Jeff Fox
	 * @version		1.0
	 * 
	 */
	public class AnalyticsFactory {
		
		/*-----------------------------------
		/	VARIABLES
		/----------------------------------*/
		// static variables
		/**
		 * Singleton instance.
		 */
		private static var _singleton:AnalyticsFactory = null;
		/**
		 * Static name property.
		 */
		private static var NAME:String = "AnalyticsFactory.";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new AnalyticsFactory instance.
		 *
		 */
		public function AnalyticsFactory() { }
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Creates a concrete instance of a child analytics object and returns it.
		 * @param 		type	A valid analytics object type to be created
		 * @return  	An instance of the chosen analytics implementation
		 * @since		1.0
		 * 
		 */
		public static function getTrackingApplication(appId:String):* {
			switch(appId) {
				default:
					return null;
			}
		}
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return Object - the instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():AnalyticsFactory {
			if ( _singleton == null) _singleton=new AnalyticsFactory(); // END if
			return _singleton;
		}
	}
}