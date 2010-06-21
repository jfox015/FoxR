package com.foxr.net.adapter
{

	//import com.foxr.data.GlobalDataManager;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.net.RemotingConnection;
	import com.foxr.net.IDataRequester;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.net.XMLLoader;
	import com.foxr.util.Utils;
	import com.foxr.util.XMLObjectOutput;
	
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * Custom Adapter extension that loads XML files by means of the XMLLoader 
	 * class. 
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class AdapterXML extends Adapter {
		
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		public static const  NAME:String = 'AdapterXML';
		
		private static const MODE_SIMPLE_LOAD:String = 'simple';
		private static const MODE_SEND_AND_LOAD:String = 'send';
		
		protected var _xmlPath:String = '';	
		
		protected var _mode:String = MODE_SIMPLE_LOAD;
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 *  Contructs a new AdapterXML instance.
		 */
		public function AdapterXML() {
			super();
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
			if (remoteFunction.indexOf('http') == -1) {
				var xmlLoad:XMLLoader = new XMLLoader();
				xmlLoad.addEventListener(Event.COMPLETE, onXMLLoaded);
				xmlLoad.load(remoteFunction, requestObj.toString() , XMLLoader.XML_TYPE_OBJECT);
			} else {
				_mode = MODE_SEND_AND_LOAD;
				var urlReq:URLRequest = new URLRequest(remoteFunction);
				urlReq.method = URLRequestMethod.POST;
				urlReq.contentType = "text/xml; charset=UTF-8";
				urlReq.data = new XML(XMLObjectOutput.objectToXML(requestObj));;
				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, onXMLLoaded);
				loader.load(urlReq);
			}
		}
		/**
		 * Called when the XML Loader responds back with data.
		 * @param	result	Object containing th result data
		 * @since	1.0
		 */
		protected function onResult(result:Object):void { 
			if (result.__error == null || result.__error == false) {
				if (_requester != null) _requester.onRequestComplete(result);
				this.dispatchEvent(new Event(Adapter.COMPLETE_EVENT));
			} else {
				onFault(result);
			}
		}
		/**
		 * Handle an unsuccessfull XML call. This is method is dedined by the responder. 
		 * @param	fault	Object containing th fault result data
		 * @since	1.0
		 */
		protected function onFault(fault:Object):void {
			this.dispatchEvent(new Event(Adapter.ERROR_EVENT));
		}
		/**
		 * Event handler for the URLLoader.COMPLETE event.
		 * @param	e	Event response
		 * @since	1.0
		 */
		private function onXMLLoaded(e:Event):void {
			if (_mode == MODE_SIMPLE_LOAD) {
				XMLLoader(e.currentTarget).removeEventListener(Event.COMPLETE, onXMLLoaded);
				onResult(XMLLoader(e.currentTarget).getXMLData(_requestId));
			} else {
				loader.removeEventListener(Event.COMPLETE, onXMLLoaded);
				var xout:XMLObjectOutput = new XMLObjectOutput();
				onResult(xout.XMLToObject(XML(URLLoader(e.currentTarget).data)));
			}
		}
		
	}
}