package com.foxr.net 
{

	import com.foxr.data.GlobalConstants;
	
	import flash.events.*;
	/**
	 * Data Requester Interface.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public interface IDataRequester {
		/**
		 * Fired once a request has received a response from the Adapter.
		 * @param	responseObj	Generic request object containing error details
		 */
		function onRequestComplete(responseObj:Object):void
		/**
		 * Fired once a request has received a failed response from the Adapter.
		 * @param	responseObj	Generic response object containing error details
		 */
		function onRequestFail(responseObj:Object):void
		/**
		 * Submits a data request to the selected Adapter.
		 * <p />
		 * @param	requestObj		Generic request object
		 * @param	requestType		The request type
		 * @param	adapterType		The adapter type to be used
		 * @param	requester		The object making the request
		 * @since	1.0
		 */
		function requestData(requestObj:Object, requestType:String, adapterType:String = '', requester:IDataRequester = null):void
		/**
		 * Called from onRequestComplete to return the data response 
		 * back to the requester for processing.
		 * <p />
		 * @param 	responseObj	The object returned from the adapter layer call
		 * @since	1.0
		 * @see		#onRequestComplete()
		 * 
		 */
		function handleDataResponse(responseObj:Object):void
	}
	
}