package com.foxr.model 
{
	//import external classes
	import com.foxr.data.GlobalConstants;
	//import com.foxr.data.GlobalDataManager;
	import com.foxr.net.adapter.IAdapter;
	import com.foxr.net.IDataRequester;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.factory.AdapterFactory;
	import com.foxr.util.Utils;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import flash.events.*;
	
	/**
	 * An abstract base class for all proxy's in the application that require 
	 * adpater connection support.
	 * 
	 * @author		Jeff Fox
	 * @version		1.4
	 * @see			com.foxr.net.adapater.Adapter Adapter
	 * 
	 */
	public class BaseProxy extends Proxy implements IProxy, IDataRequester {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var NAME:String = 'BaseProxy';
		
		protected var _requestType:String = "";
		
		protected var adapter:Adapter = null;
		
		protected var _adapterParams:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new BaseProxy instance.
		 *
		 */
		public function BaseProxy(proxyName:String = null,data:Object = null) { 
			var thisName:String = proxyName != null ? proxyName : NAME;
			super(thisName, data);
			facade = Facade.getInstance();
		}
		/**
		 * @param	p Paramter object containing simply key value pairs.
		 * @return	Current parameters object
		 */
		public function get adapterParams():Object { return _adapterParams; }
		public function set adapterParams(p:Object):void { _adapterParams = p; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Fired once a request has received a response from the Adapter.
		 * @param	responseObj	Generic request object containing error details
		 */
		public function onRequestComplete(responseObj:Object):void { 
			sendNotification(Adapter.STATUS_REQUEST_COMPLETE);
			handleDataResponse(responseObj);
			_requestType = "";
		}
		/**
		 * Fired once a request has received a failed response from the Adapter.
		 * @param	responseObj	Generic response object containing error details
		 */
		public function onRequestFail(responseObj:Object):void { 
			trace(responseObj);
			sendNotification(Adapter.STATUS_CONNECTION_FAULT);
		}
		/**
		 * Fired if a request fails to make a connection to an externla data source.
		 * @param	responseObj	Generic response object containing error details
		 */
		public function onConnectFail(e:Event):void { 
			adapter.removeEventListener(Adapter.ERROR_EVENT, onConnectFail);
			sendNotification(Adapter.STATUS_CONNECTION_FAULT);
		}
		/**
		 * Submits a data request to the selected Adapter.
		 * <p />
		 * @param	requestObj		Generic request object
		 * @param	requestType		The request type
		 * @param	adapterType		The adapter type to be used
		 * @param	requester		The object making the request
		 * @since	1.0
		 */
		public function requestData(requestObj:Object,requestType:String,adapterType:String = '',requester:IDataRequester = null):void { 
			//sendNotification(Adapter.START_EVENT);
			if (adapterType == '') adapterType = GlobalConstants.ADAPTER_XML;
			_requestType = requestType;
			adapter = AdapterFactory.getInstance().getAdapterbyType(adapterType);
			adapter.addEventListener(Adapter.ERROR_EVENT, onConnectFail);
			try {
				adapter.callService(requestObj, requestType, requester,_adapterParams)
			} catch (e:Error) {
				trace("An error occured during invokation of data request for " + requestType + ", error = " + e);
			} // END try/catch
		}
		/**
		 * Called from onRequestComplete to return the data response 
		 * back to the requester for processing.
		 * <p />
		 * @param 	data	The object returned from the adapter layer call
		 * @since	1.0
		 * @see		#onRequestComplete()
		 * 
		 */
		public function handleDataResponse(responseObj:Object):void { }
	}
}