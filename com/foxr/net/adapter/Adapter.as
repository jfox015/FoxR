package com.foxr.net.adapter
{
	
	//import external classes
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.interfaces.IFacade;
	
	import com.foxr.net.adapter.IAdapter;
	import com.foxr.net.IDataRequester;
	//import com.foxr.data.GlobalDataManager;
	
	import flash.events.*;
	import flash.net.URLLoader;
	/**
	 * Abstract base class for all adapters found in the application.
	 * 
	 * @author		Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Adapter extends EventDispatcher implements INotifier, IAdapter {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const ERROR_EVENT:String = "error";
		public static const COMPLETE_EVENT:String = "complete";
		public static const OPEN_EVENT:String = "open";
		public static const START_EVENT:String = "start";
		public static const PROGRESS_EVENT:String = "progress";
		public static const STATUS_EVENT:String = "httpStatus";
		public static const STATUS_TIMEOUT:String = "serverTimeout";
		public static const STATUS_ILLEGAL_ACCESS:String = "illegalAccessException";
		public static const STATUS_CONNECTION_FAULT:String = "connectionFault";
		public static const STATUS_REQUEST_COMPLETE:String = "connectionFault";
		
		public static const SVC_STATUS_IDLE:Number = 0;
		public static const SVC_STATUS_ERROR:Number = 1;
		public static const SVC_STATUS_SUCCESS:Number = 2;

		protected var loader:URLLoader = null;
		
		protected var _status:Number = SVC_STATUS_IDLE;
		
		protected var facade:IFacade = null;
		
		protected var _dataLoaded:Boolean = false;	
		
		protected var _requestId:String = '';	
		
		protected var _requestObj:* = null;
		
		protected var _responseObj:Object = null;
		
		protected var _requester:IDataRequester = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Adapter instance.
		 *
		 */
		public function Adapter() { 
			facade = Facade.getInstance();
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 * Base function to send external data calls through the concrete adapter instance.
		 * @param	requestObj		Data Request Object cotnaining name value pairs
		 * @param	remoteFunction	The name of the external script or AMF service call
		 * @param	requester		The requesting object
		 * @param	adapterParams	Object containing param for the current Adapter implementation
		 *
		 */
		public function callService(requestObj:Object, remoteFunction:String = '', requester:IDataRequester = null, adapterParams:Object = null):void { 
			if (adapterParams != null && typeof (adapterParams) == 'Object') {
				for (var prop:String in adapterParams) {
					this[prop] = adapterParams[prop];
				}
			}
			_dataLoaded = false;
			_requestId = remoteFunction;
			_requester = (requester != null) ? requester : null;
		}
		/**
		 * Implementation of the Facade sendNotification in the Adapter.
		 * @param	notificationName		The notification name
		 * @param	body					Body data object
		 * @param	type					Request type
		 * @see		org.puremvc.as3.patterns.observer.Notification
		 *
		 */
		public function sendNotification(notificationName:String, body:Object = null, type:String = null ):void { 
			facade.sendNotification(notificationName, body, type);
		}
		
		/*------------------------
		/	PROECTED FUNCTIONS
		/-----------------------*/
		protected function ioErrorHandler(event:IOErrorEvent):void {
			var errorMsg:String = "IO Error occured while loading data, Error: " + event.text;
			trace(errorMsg);
            dispatchEvent(new Event(ERROR_EVENT));
        }
		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			dispatchEvent(new Event(ERROR_EVENT));
        }
        protected function httpStatusHandler(event:HTTPStatusEvent):void {
            dispatchEvent(new Event(STATUS_EVENT));
        }
	}
}