package com.foxr.net.adapter
{

	import com.foxr.model.GlobalProxyManager;
	import com.foxr.net.IDataRequester;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.util.Utils;
	import flash.display.Loader;
	
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * Custom Adapter extension that simplfies sending data request over HTTP. 
	 * Note that this class does not have a visual representation, so it is not 
	 * recommended for use in loaded external image or SWF formats that will need 
	 * to be added to the stage. It can be used, however, to load images in which 
	 * the data will be parsed via the Bitmap or BitmapData objects.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @version			1.0
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class AdapterHTTP extends Adapter {
		
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		public static const NAME:String = "AdapterHTTP";
		
		public static const SUBMIT_SEND_AND_RECEIVE:String = 'sendReceive';
		public static const SUBMIT_SEND_TO_URL:String = 'sendToURL';
		
		public static const DATA_ASCII:String = 'ascii';
		public static const DATA_BINARY:String = 'binary';
		public static const DATA_VARIABLES:String = 'variables';
		
		protected var _method:String = URLRequestMethod.POST;
		protected var _submitType:String = SUBMIT_SEND_AND_RECEIVE;
		protected var _dataType:String = DATA_ASCII;
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 *  Contructs a new AdapterHTTP instance.
		 */
		public function AdapterHTTP() {
			super();
		}
		/*------------------------
		/	SET/GET FUNCTIONS
		/-----------------------*/
		/**
		 * Applies the type of response data expected to be returned.
		 * <ul>
		 * <li>DATA_ASCII - Flat text, XML, TXT, HTML files</li>
		 * <li>DATA_BINARY - SWF, PNG, JPG, GIF, etc</li>
		 * <li>DATA_VARIABLES - URL Encoded Variables</li>
		 * </ul>
		 * <p />
		 * @since	1.0
		 */
		public function get dataType():String { return _dataType; }
		public function set dataType(t:String):void { _dataType = t; }
		/**
		 * Applies the HTTP action method to the adapter.
		 * @since	1.0
		 */
		public function get method():String { return _method; }
		public function set method(m:String):void { _method = m; }
		/**
		 * Applies the type of submission that shoudl be performed. Valid 
		 * types are:
		 * <ul>
		 * <li>SUBMIT_SEND_TO_URL - Performs a one way submission, ignoring repsonses</li>
		 * <li>SUBMIT_SEND_AND_RECEIVE - Sends the request and waits for a response</li>
		 * </ul>
		 * <p />
		 * @since	1.0
		 */
		public function get submitType():String { return _submitType; }
		public function set submitType(t:String):void { _submitType = t; }
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
			var urlVars:URLVariables = new URLVariables();
			for (var param:String in requestObj) {
				urlVars[param] = escape(requestObj[param]);
				trace(param + " = " + escape(requestObj[param]));
			}
			var urlReq:URLRequest = new URLRequest(remoteFunction);
			urlReq.method = _method;
			urlReq.data = urlVars;
			if (_submitType == SUBMIT_SEND_TO_URL) {
				sendToURL(urlReq);
			} else {
				loader = new URLLoader();
				switch (_dataType) {
					case DATA_BINARY:
						loader.dataFormat = URLLoaderDataFormat.BINARY;
						break;
					case DATA_VARIABLES:
						loader.dataFormat = URLLoaderDataFormat.VARIABLES;
						break;
					case DATA_ASCII:
					default:
						loader.dataFormat = URLLoaderDataFormat.TEXT;
						break;
				}				
				loader.addEventListener(Event.COMPLETE, onResult);
				loader.load(urlReq);
			}
		}
		/**
		 * Called when the XML Loader responds back with data.
		 * @param	result	Object containing th result data
		 * @since	1.0
		 */
		protected function onResult(e:Event):void { 
			var rslt:Object = URLLoader(e.currentTarget).data;
			if (rslt != null) {
				if (_requester != null) _requester.onRequestComplete(rslt);
				this.dispatchEvent(new Event(Adapter.COMPLETE_EVENT));
			} else {
				onFault({error:"No data was returned by the server."});
			}
		}
		/**
		 * Handle an unsuccessfull XML call. This is method is dedined by the responder. 
		 * @param	fault	Object containing th fault result data
		 * @since	1.0
		 */
		protected function onFault(fault:Object):void {
			trace("XML Adapter, onFoult, error message = " + fault.error);
			this.dispatchEvent(new Event(Adapter.ERROR_EVENT));
		}
	}
}