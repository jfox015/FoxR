package com.foxr.net.adapter 
{

	import com.foxr.net.IDataRequester;
	/**
	 * Adpater Interface class.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public interface IAdapter {
		/**
		 * Base function to send external data calls through the concrete adapter instance.
		 * @param	requestObj		Data Request Object cotnaining name value pairs
		 * @param	remoteFunction	The name of the external script or AMF service call
		 * @param	requester		The requesting object
		 * @param	adapterParams	Object containing param for the current Adapter implementation
		 *
		 */
		function callService(requestObj:Object, remoteFunction:String = '', requester:IDataRequester = null, adapterParams:Object = null):void;
	}
	
}