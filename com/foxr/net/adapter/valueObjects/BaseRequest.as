package com.foxr.net.adapter.valueObjects 
{
	import com.foxr.net.IValueObject;
	/**
	 * Abstract base object for AMF adpater Requests.
	 * 
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class BaseRequest implements IValueObject {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var _data:* = null;
		private var _service:String = '';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new BaseRequest instance.
		 *
		 */
		public function BaseRequest() { }
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		public function get data():* { return _data; }
		public function set data(d:*):void { _data = d; }
		
		public function get service():String { return _service; }
		public function set service(s:String):void { _service = s; }
	}
}