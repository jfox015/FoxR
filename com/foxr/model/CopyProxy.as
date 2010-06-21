package com.foxr.model {
	
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.*;
	
	import com.foxr.controller.Application;
	import com.foxr.util.XMLObjectOutput;
	
	import com.foxr.data.GlobalConstants;
	import com.foxr.util.Utils;
	import com.foxr.util.StringUtils;
	
	/**
	* The CopyProxy is responsible for loading, stroing and providing simple access to 
	* XML based copy content that is stored in one or more externla XML files.
	* <p />
	* Copy XML files are loaded and converted to simple key/value objects on GPM init()
	* and stored within the classes _data property.
	* <p />
	* Access to copy strings is performed using simple object notation detailing the 
	* path to the copy node that matches the original XML structure.
	* 
	* @author 		Jeff Fox
	* @version		2.1.2
	*/
	public class CopyProxy extends BaseProxy {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var NAME:String = 'CopyProxy';
		
		// private vars
		private var urlLoader:URLLoader = null;
		private var loader:Loader = null;
		
		private var _fontList:Array = null;
		private var _xmlCopyList:Array = null;
		
		private var _fontPath:String = 'media/';
		private var _xmlPath:String = 'xml/';
		
		private var xmlToObject:XMLObjectOutput = null;
		/*-----------------------------------
		/	CONSTRUCTOR
		/----------------------------------*/
		/**
		 * Creates a new instance of CopyProxy
		 */
		public function CopyProxy() { 
			super(NAME, new Object());
		}
		/**
		 * Method to retrieve copy from an external xml file(s)).
		 * @param	xmlFiles	Array of Copy XML files to be loaded.
		 * @since	1.0
		 */
		public function init(xmlFiles:Array, xmlPath:String,fontList:Array = null, fontPath:String = ''):void{
			_xmlCopyList = xmlFiles;
			_xmlPath = xmlPath;
			if (fontList != null) _fontList = fontList;
			if (fontPath != '') _fontPath = fontPath;
			loadCopy();
		}
		/*----------------------------
		/	PUBLIC FUNCTIONS
		/---------------------------*/
		/**
		 * Returns a specific chunk of the sorted copy object to the user. Depending 
		 * on the path specified as argument, the returned object could be in the form of an array
		 * or an object, based on the setup of the copy XML file.
		 * <p />
		 * To retrieve the value from the block, the caller must use either <code>.value</code> or 
		 * <code>.attributes.(attribute name)</code> to access the string value.
		 * <p />
		 * In the case of list values, Utils.toArray should be used to standardize handling in the 
		 * case of a single value vs multiple values. This is because XMLToObject automatically 
		 * converts like-named nodes into an array, but leaves singletons as objects. In the case 
		 * of known singleton returns, object notation is fine.
		 * <p />
		 * To access a single string value rather than a full object, use <i>getCopyString</i> instead.
		 * 
		 * @param 	path	The string path to the copy being requested
		 * @return			An object containing child copy objects and data
		 * @since	1.0
		 * @todo figure out why data[path] wasn't working with dot syntax items
		 */
		public function getCopyBlock(path:String):Object {
			var tmpCopyObj:Object = null;
			var pathArr:Array = path.split(".");
			if (data[pathArr[0]]) {
				var count:Number = 0;
				tmpCopyObj = data[pathArr[0]];
				while (true) {
					tmpCopyObj = getCopyChild(tmpCopyObj, pathArr[count]);
					if (tmpCopyObj) {
						count++;
						if (count == pathArr.length) break; // END if
					} else {
						trace(NAME + "getCopyBlock, " + pathArr[count] + " not found in specified path.");
						break;
					} // END if
				} // END while
			} else {
				trace(NAME + "getCopyBlock, " + pathArr[0] + " not found in copy object list.");	
			} // END if
			return tmpCopyObj;
		}
		/**
		 * Returns a string of the value located at path. To retrive a block of copy, for instance for 
		 * a full section, as an object or array, use <i>getCopyBlock</i> instead.
		 * @param 	path - the string path to the copy being requested
		 * @return	string of the value located at path
		 * @since	1.0
		 */
		public function getCopyString(path:String):String {
			var tmpObj:Object = getCopyBlock(path);
			return (tmpObj != null) ? tmpObj.value.toString() : '';
		}
		/**
		 * Applies a strings ID and dynamic data to be spliced into the string. Dynamic fields should be wrapped in { } and
		 * match values in the copy XML file. 
		 * @since	1.0
		 * @param	path - the string path to the copy being requested
		 * @param	dataValues	Object contaiig the key/value pairs to be replaced
		 * @return	String with key tokens replaced with passed values
		 */
		public function getDynamicCopyString(path:String, dataValues:Object):String {
			var tmpStr:String = getCopyString(path);
			if (tmpStr != '') {
				for (var key:String in dataValues) {
					if (tmpStr.search(key) != -1) {
						tmpStr = StringUtils.replace(tmpStr, key, dataValues[key]);
					} // END if
				} // EnD for
				return(tmpStr);
			} else {
				return ('');
			} // END if
		}
		/*----------------------------
		/	PRIVATE FUNCTIONS
		/---------------------------*/
		/**
		 * Returns a copy object with childName that is a child of the passed CopyObj.
		 * @see		#getCopyBlock
		 * @since	1.0
		 * 
		 */
		private function getCopyChild(copyObj:Object,childName:String):Object {
			var outObj:Object = null;
			try {
				outObj = (copyObj[childName]) ? copyObj[childName] : null;
			} catch (e:Error) {
				trace(NAME + "getCopyChild, error = " + e);
			}
			return outObj;
		}
		/**
		 * loaddata builds an SERequest object, populates its data and then sends it to requestData
		 * which is inherited from BaseModel
		 * @since	1.0
		 */
		private function loadCopy():void {
			// LOAD XML COPY
			if (urlLoader == null) urlLoader = new URLLoader(); // END if
			urlLoader.addEventListener(Event.COMPLETE, onCopyLoaded);
			//var gpm:GlobalProxyManager = facade.retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			//gpm.log.debug("Copy path = " + _xmlPath + _xmlCopyList[0].value);
			urlLoader.load(new URLRequest(_xmlPath + _xmlCopyList[0].value));
		}
		/**
		 * onCopyLoaded is called upon successful copy XML file loading
		 * @param 	e	Event	Event response object
		 * @since	1.0
		 * 
		 */
		private function onCopyLoaded(e:Event):void {
			urlLoader.removeEventListener(Event.COMPLETE, onCopyLoaded);
			
			if (data == null) data = new Object(); // END if
			if (xmlToObject == null) xmlToObject = new XMLObjectOutput(); // END if
			
			var rawXML:XML = new XML(urlLoader.data);
			data[rawXML.localName()] = xmlToObject.XMLToObject(rawXML);         
			
			_xmlCopyList.shift();
			if (_xmlCopyList.length > 0) loadCopy();	
			else {
				sendNotification(Application.COPY_LOADED);
				if (_fontList.length > 0)
					loadFont();  // END if
			} // END if
		}
		/**
		 * loadFont loads all specified external font files
		 * @since	1.0
		 */
		private function loadFont():void {
			// LOAD XML COPY
			if (loader == null) loader = new Loader(); // END if
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFontLoaded);
			loader.load(new URLRequest(_fontPath + _fontList[0].value));
		}
		/**
		 * Called upon successful font file loading
		 * @param 	e	Event	Event response object
		 * @since	1.0
		 * 
		 */
		private function onFontLoaded(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFontLoaded);
			_fontList.shift();
			if (_fontList.length > 0)
				loadFont();
			else
				sendNotification(Application.FONTS_LOADED); // END if
		}
	}	
}