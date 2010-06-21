package com.foxr.factory 
{
	import com.foxr.net.*;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.net.adapter.AdapterAMF;
	import com.foxr.net.adapter.AdapterHTTP;
	import com.foxr.net.adapter.AdapterXML;
	import com.foxr.data.GlobalConstants;
	/**
	 * Provides adapters for the application adapter workflow.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class AdapterFactory {
		
		/*-----------------------------------
		/	VARIABLES
		/----------------------------------*/
		// static variables
		/**
		 * Static name property.
		 */
		private static var NAME:String = "AdapterFactory.";
		/**
		 * Singleton instance.
		 */
		private static var _singleton:AdapterFactory = null;
		/**
		 * Concrete child instances.
		 */
		private static var _instances:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new AdapterFactory instance.
		 *
		 */
		public function AdapterFactory() {
			_instances = new Object();
		}
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return Object - the instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():AdapterFactory {
			if (_singleton == null) _singleton = new AdapterFactory(); // END if
			return _singleton;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Creates a concrete instance of a child Adapter object and returns it.
		 * @param 		type	A valid adapter type to be created
		 * @return  	An instance of the chosen Adapter implementation
		 * @since		1.0
		 * 
		 */
		public function getAdapterbyType(type:String):Adapter {
			switch(type) {
				case GlobalConstants.ADAPTER_HTTP:
					if (_instances[GlobalConstants.ADAPTER_HTTP] == null)
						_instances[GlobalConstants.ADAPTER_HTTP]= new AdapterHTTP(); // END if 
					return _instances[GlobalConstants.ADAPTER_HTTP];
					break;
				case GlobalConstants.ADAPTER_XML:
				case GlobalConstants.ADAPTER_SOAP:
					if (_instances[GlobalConstants.ADAPTER_XML] == null)
						_instances[GlobalConstants.ADAPTER_XML]= new AdapterXML(); // END if
					return _instances[GlobalConstants.ADAPTER_XML];
					break;
				case GlobalConstants.ADAPTER_AMF:
				default:
					if (_instances[GlobalConstants.ADAPTER_AMF] == null)
						_instances[GlobalConstants.ADAPTER_AMF]= new AdapterAMF(); // END if
					return _instances[GlobalConstants.ADAPTER_AMF];
					break;
			} // END switch
		}
	}
}