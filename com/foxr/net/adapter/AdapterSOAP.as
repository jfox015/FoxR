package com.foxr.net.adapter
{

	import com.alducente.services.WebService;
	import com.alducente.xml.NamespaceRemover;
	
	import com.foxr.net.IDataRequester;
	
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * Custom Adapter extension that adds Web Services support to the framework. 
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class AdapterSOAP extends Adapter {
		
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		public static const NAME:String = 'AdapterSOAP';
		protected var _xmlPath:String = '';	
		protected var _ws:WebService = null;	
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 *  Contructs a new AdapterSOAP instance.
		 */
		public function AdapterSOAP() {
			super();
			_ws = new WebService();
		}
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 * Function to pull data from the connected data source. Should be overridden in all child 
		 * classes.
		 * @since	1.0
		 */
		public override function callService(requestObj:Object, remoteFunction:String = '', requester:IDataRequester = null, adapterParams:Object = null):void { 
			super.callService(requestObj, remoteFunction, requester, adapterParams);
			_ws.addEventListener(Event.CONNECT, onServiceConnected);
			_ws.connect(remoteFunction);
			
		}
		/**
		 * Called when the XSOAP connection has been established
		 * @param	evt	Event response object
		 * @since	1.0
		 */
		protected function onServiceConnected(evt:Event):void{
			_ws.removeEventListener(Event.CONNECT, onServiceConnected);
		}
		/**
		 * Called when the XML Loader responds back with data.
		 * @param	result	Object containing th result data
		 * @since	1.0
		 */
		protected function onResult(result:XML):void { 
			if (_requester != null) _requester.onRequestComplete(result);
			this.dispatchEvent(new Event(Adapter.COMPLETE_EVENT));
		}
		/**
		 * Handle an unsuccessfull XML call. This is method is dedined by the responder. 
		 * @param	fault	Object containing th fault result data
		 * @since	1.0
		 */
		protected function onFault(fault:Object):void {
			trace(NAME + ", onFoult, error message = " + fault.__errorMsg);
			this.dispatchEvent(new Event(Adapter.ERROR_EVENT));
		}
	}
}