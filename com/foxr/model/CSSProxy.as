package com.foxr.model
{	
	import com.foxr.controller.Application;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.util.Utils;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.interfaces.IProxy;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	/**
	 * This class is responsible for collecting and loading the CSS Styles for the 
	 * application.
	 * 
	 * @author		Jeff Fox
	 * @version		1.2.1
	 * 
	 */
	public class CSSProxy extends BaseProxy {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var NAME:String = 'CSSProxy';
		/**
		 * Loader Object
		 * @var _loader:URLLoader
		 */
		private var _loader:URLLoader = null;
		/**
		 * CSS File Load Path
		 * @var _cssLoadPath:String
		 */
		private var _cssLoadPath:String = 'media/css/';
		/**
		 * CSS File List
		 * @var dataFileList:Array
		 */
		private var _dataFileList:Array = null;
		/*--------------------------------------
		/	C'TOR
		/-------------------------------------*/
		/**
		 * Construct a new CSSProxy instance.
		 *
		 */
		public function CSSProxy() {
			super(NAME, new Object());
			_loader = new URLLoader();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies the full path (relativly from the compiled SWF) to the location 
		 * of the movies CSS files. Typically this is simply "xml/" (which is 
		 * the default value of this property).
		 * @param	path	Full relative path to the CSS file(s).
		 * @return	Stored path to the CSS file(s).
		 */
		public function get cssLoadPath():String { return _cssLoadPath; }
		public function set cssLoadPath(path:String):void {
			_cssLoadPath = path;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Method to retrieve css from an external file9s).
		 * @param	cssFiles	Array of CSS Stylesheets to be loaded.
		 */
		public function getExternalCSS(cssFiles:Array = null):void {
			if (_dataFileList == null)
				_dataFileList = cssFiles;
			loadCSS();
		}
		/**
		 * Method to retrieve a single style object from the Proxy.
		 * @param	selector	The selector name.
		 * @return	Object with CSS Style propeties
		 */
		public function getStyle(selector:String):Object {
			return data[selector];
		}
		/**
		 * Returns a TextFormat object of selector within the loaded stylesheet
		 * @param	selector	The name of the text selector
		 * @return	TextFomrat Object
		 */
		public function getTextFormat(selector:String):TextFormat {
			if (data[selector] != undefined) {
				var tmpStyleObj:StyleSheet = new StyleSheet();
				var tmpTf:TextFormat = tmpStyleObj.transform(data[selector]);
				if (data[selector].color != undefined) tmpTf.color = data[selector].color;
				if (data[selector].leading != undefined) tmpTf.leading = data[selector].leading;
				if (data[selector].font != undefined) tmpTf.font = data[selector].font;
				return tmpTf;
			} else {
				return null;
			} // END if
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Loads the stylesheet specified at dataFileList position 0
		 */
		private function loadCSS():void {
			if (_dataFileList[0] != null && _dataFileList[0].value != '') {
				_loader.load(new URLRequest(_cssLoadPath + _dataFileList[0].value));
			} else {
				trace(NAME + ".loadCSS->ERROR! No file name was specified in dataFileList.");
			} // END if
			_loader.addEventListener(Event.COMPLETE, onCSSLoaded);
		}
		/**
		 * Handles when the current CSS Stfylesheet is loaded and calls apply CSS.
		 */
		private function onCSSLoaded(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onCSSLoaded);
			applyCSS(e.currentTarget.data);		
		}
		/**
		 * Handles when the current CSS Stfylesheet has been applied to the internal 
		 * data object. it removes the currnent file name value from the file list 
		 * array. if the array contains addition file names, this method calls 
		 * loadCSS(), otherwise it dispatches a COMPLETE event.
		 */
		private function onCSSApplied():void {
			_dataFileList.shift();
			if (_dataFileList.length > 0) 
				loadCSS();	
			else 
				sendNotification(Application.CSS_LOADED,{type:'css'}); // END if
		}
		/**
		 * Event handler for CSS loaded event. Parses the styles loaded from the external style sheet and
		 * 
		 * @param	e	Load Event data
		 */
		private function applyCSS(css:String):void {
			var gpm:GlobalProxyManager = facade.retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			
			var tmpStyle:StyleSheet = new StyleSheet();
			tmpStyle.parseCSS(css);
			
			var isId:Boolean = false;
			var isClass:Boolean = false;
			// Loop through the selectors in the loaded stylesheet
			for (var i:Number = 0; i < tmpStyle.styleNames.length; i++) {
				
				isId = false;
				isClass = false;
				
				// Create the property of this object so it can be referenced directly
				var obj:String = new String(tmpStyle.styleNames[i]);
				
				// EDIT 1.2.1 8/19/09 - JF
				// TEST if ID (#) assignment operator exists
				// If so, parse it out and assign them to specific sub arrays
				if (obj.substr(0,1).indexOf("#") != -1) {
					obj = new String(obj.substr(1, obj.length));
					isId = true;
				}
				
				// if the current Selector has not already been added to the object, create it. Subsequent 
				// style loads override the inital loaded values.
				if (data[obj] == undefined) 
					data[obj] = new Object();
				
				// Loopp through the individual selectors properties
				for (var styleProp:String in tmpStyle.getStyle(obj)) {
					
					var subObj:String = new String(styleProp);
					data[obj][subObj] = tmpStyle.getStyle(obj)[styleProp];
					// Convert Array based CSS values to actual arrays
					try {
						if (data[obj][subObj].toString().indexOf('[') != -1) {
							// Remove brackets
							var tmpStr:String = data[obj][subObj].toString();
							tmpStr = tmpStr.substring(1,tmpStr.length - 1);
							var tmpArray:Array = tmpStr.split(',');
							// Assure properties within array are valid css properties
							for (var j:Number = 0; j < tmpArray.length; j++)
								tmpArray[j] = validateCSS(tmpArray[j]); // END for	
							data[obj][subObj] = tmpArray;
						} else {
							data[obj][subObj] = validateCSS(data[obj][subObj]);
						}
						// END if
					} catch (e:Error) {
						trace('CssStyles::onCSSLoaded -- Error parsing CSS arrays. Error: ' + e);
					} // END try/catch
				} // END for
			} // END for
			onCSSApplied();
		}
		/**
		 * Checks the CSS for HTML specific properties not supported in Flash and converts them to
		 * Flash friendly values.
		 * @param	value	The property value to be validated
		 * @return	Validated value in type required or original value unchanged
		 */
		private function validateCSS(value:String):* {
			if (value != null && value != '') {
				var myPattern:RegExp;
				var pattern:RegExp = new RegExp(/^(.*?)\.[a-z]{1,4}$/);
				if (value.indexOf('#')!= -1) {
					// Replace hexidecimal code with 0x and output a Number
					myPattern = /#/;
					value = value.replace(myPattern,'0x');
					return Number(value);
				} else if (value.search('px') != -1){
					// Remove "px" from pixel positoning or size values as they are not supported
					myPattern = /px/;
					value = value.replace(myPattern, '');
					return Number(value);
				} else if (value.search('pt') != -1){
					// Remove "px" from pixel positoning or size values as they are not supported
					myPattern = /pt/;
					value = value.replace(myPattern, '');
					return Number(value)
				} else if (value.search('0x') != -1 || (value.indexOf('.') != -1 && value.search(pattern) == -1) || parseInt(value).toString() != 'NaN') {
					return Number(value);
				} else { 
					// Return value as it was received
					return value;
				} // END if
			} else {
				return value;
			} // END if
		}
	}
}