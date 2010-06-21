package com.foxr.net.adapter
{
	import org.puremvc.as3.patterns.facade.Facade;
	
	import com.foxr.model.ConfigProxy;
	import com.foxr.event.RemotingEvent;
	import com.foxr.net.RemotingConnection;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.net.IDataRequester;
	import com.foxr.util.Utils;
	
	import flash.events.*;
	import flash.net.*;
	/**
	 * Adapter implementation for AMF.
	 * 
	 * @author		Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public dynamic class AdapterAMF extends Adapter {
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		private static var NAME:String = 'AdapterAMF';
		
		protected var gateway:RemotingConnection = null;
		
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 *  Contructs a new AdapterAMF instance.
		 */
		public function AdapterAMF() {
			super();
			gateway = new RemotingConnection(ConfigProxy(Facade.getInstance().retrieveProxy(ConfigProxy.NAME)).gatewayURL);
		}
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 * Function to pull data from the connected data source. Should be overridden in all child classes
		 * @since	1.0
		 */
		public override function callService(requestObj:Object, remoteFunction:String = '', requester:IDataRequester = null, adapterParams:Object = null):void { 
			super.callService(requestObj, remoteFunction, requester, adapterParams);
			try {
				gateway.addEventListener(RemotingEvent.REMOTING_CONNECTION_FAILURE, onRemotingFailure);
				gateway.call(remoteFunction, new Responder(onResult, onFault), requestObj);
			} catch (e:Error) {
				dispatchEvent(new Event(Adapter.ERROR_EVENT));
			} // END try/catch
		}
		/**
		 * Called if the remoting connection failed.
		 * @param	e	Event response object.
		 * @since	1.0
		 */
		protected function onRemotingFailure(e:Event):void {
			gateway.removeEventListener(RemotingEvent.REMOTING_CONNECTION_FAILURE, onRemotingFailure);
			_responseObj = new Object();
			_responseObj.error = gateway.errors;
			if (_requester != null) _requester.onRequestFail(_responseObj);
			dispatchEvent(new Event(Adapter.ERROR_EVENT));
		}
		/**
		 * Called when the Remote Connection responds back to the service.
		 * @param	result	Object containing th result data
		 * @since	1.0
		 */
		protected function onResult(result:Object):void { 
			if (_requester != null) _requester.onRequestComplete(result);
			this.dispatchEvent(new Event(Adapter.COMPLETE_EVENT));
		}
		/**
		 * Handle an unsuccessfull AMF call. This is method is dedined by the responder. 
		 * @param	fault	Object containing th fault result data
		 * @since	1.0
		 */
		protected function onFault(fault:Object):void {
			if (_requester != null) _requester.onRequestFail(fault);
			this.dispatchEvent(new Event(Adapter.ERROR_EVENT));
		}
	}
}