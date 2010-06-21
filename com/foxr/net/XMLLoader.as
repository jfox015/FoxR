package com.foxr.net 
{
	
	//import external classes
	import com.foxr.util.XMLObjectOutput;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * A utility network class that loads XML files. This object can handle loading 
	 * files individually via the load() method, or batching mutliple XML files at 
	 * once using addXMLToQueue() to add files and  then calling load().
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class XMLLoader extends EventDispatcher {
		
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		public static var _singleton:XMLLoader = null;
		
		public static const XML_TYPE_E4X:String = 'e4x';
		
		public static const XML_TYPE_OBJECT:String = 'xmlobject';
		
		private var _bytesLoaded:Number = 0;
		
		private var _bytesTotal:Number = 0;
		
		private var _currXMLId:String = '';
		
		private var _currXMLType:String = '';
		
		private var _loader:URLLoader = null;
		
		private var _loadInProgress:Boolean = false;
		
		private var _loadedItems:Object = null;
		
		private var _loadQueue:Array = null;
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 *  Contructs a new XMLLoader instance.
		 */
		public function XMLLoader() {
			_loader = new URLLoader();
			_loadedItems = new Object();
			_loadQueue = new Array();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Returns the number of bytes loaded.
		 * @return	The bytes loaded amount.
		 * @since	1.0
		 */
		public function get bytesLoaded():Number { return _bytesLoaded; }
		/**
		 * Returns the number of bytes total.
		 * @return	The bytes total amount.
		 * @since	1.0
		 */
		public function get bytesTotal():Number { return _bytesTotal; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Add the passed object to the loadQueue.
		 * @param	xmlLoadItem		Object containing id, file and type (optional) properties
		 * @since	1.0
		 * 
		 */		
		public function addXMLToQueue(xmlLoadItem:Object):void{
			if (xmlLoadItem.id != undefined && xmlLoadItem.file != undefined) {
				if (xmlLoadItem.type == undefined) {
					xmlLoadItem.type = XML_TYPE_E4X;
				} // END if
				_loadQueue.push(xmlLoadItem);
			} // END if
		}
		/**
		 * Returns the XML data instance for the passed id or null if the items is not found.
		 * @param	id	The id of the requested XML instance
		 * @return		E$X XML or XML Object
		 */
		public function getXMLData(id:String):* {
			return _loadedItems[id];
		}
		/**
		 * Tells the XML Loader object to perform a load operation. oad tests the load queue 
		 * first for items to load, then check if any arguments were passed to load. If niether 
		 * condiution is true, this methid throw an error.
		 * @param	id	The id of the requested XML instance
		 * @return		E$X XML or XML Object
		 */
		public function load(id:String = '', file:String = '', type:String = ''):void {
			if (_loadQueue.length > 0) {
				loadFromQueue();
			} else {
				if (id != '' && file != ''){	
					loadXML(id, file, type);
				} else {
					throw new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false,
					"XMLLoader, Load() error. Id and/or file arguments missing.");
				} // END if
			} // END if
		}
		
		/**
		 * Called from any class to return the singleton instance of the class
		 * @return XMLLoader - the instance of the class
		 * @since	1.0
		 * 
		 */
		public static function getInstance():XMLLoader {
			if ( _singleton == null) _singleton = new XMLLoader(); // END if
			return _singleton;
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Private internal function that executes the XMl load sequence.
		 * @param	id		Unqiue file identifier (used for multi load operations)
		 * @param	file	path to the file to be loaded
		 * @param	type	XML Type(XML_TYPE_E4X or XML_TYPE_OBJECT)
		 * @since	1.0
		 */
		private function loadXML(id:String, file:String, type:String = ''):void {
			_loadInProgress = true;
			_currXMLId = id;
			_currXMLType = (type != '') ? type: XML_TYPE_E4X;
			if (!_loader.hasEventListener(Event.COMPLETE)) {
				_loader.addEventListener(Event.COMPLETE, onXMLLoaded );
			} // END if
			try {
                _loader.load(new URLRequest(file));
            } catch (e:Error) {
				trace('XMLLoader, LoadXML() error: An error occured during loading of XMl file: ' + file + ", error: " + e);
            } // END if
		}
		/**
		 * Event handler for the loading of an XML file. It creates the sotred XML instance based 
		 * on the type preference and tests the load queue to load another file or dispatch a 
		 * load complete event.
		 * @param	e 	COMPLETE event
		 * @since		1.0
		 */
		private function onXMLLoaded(e:Event):void {
			switch (_currXMLType) {
				case XML_TYPE_OBJECT:
					var xmlObj:XMLObjectOutput = new XMLObjectOutput();
					_loadedItems[_currXMLId] = xmlObj.XMLToObject(new XML(e.currentTarget.data));
					break;
				case XML_TYPE_E4X:
				default:
					_loadedItems[_currXMLId] = new XML(e.currentTarget.data);
					break;
			} // END switch
			_loadInProgress = false;
			_currXMLId = '';
			_currXMLType = '';
			if (_loadQueue.length > 0) {
				_loadQueue.shift();
				loadFromQueue();
			} else {
				if (_loader.hasEventListener(Event.COMPLETE)) {
					_loader.removeEventListener( Event.COMPLETE, onXMLLoaded );
				} // END if
				dispatchEvent(new Event(Event.COMPLETE));
			} // END if
		}
		/**
		 * Tests the _loadQueue property for files to load.
		 * @since	1.0
		 */
		private function loadFromQueue():void {
			if (_loadQueue.length > 0) {
				var xmlLoadObj:Object = _loadQueue[0];
				loadXML(xmlLoadObj.id, xmlLoadObj.file, xmlLoadObj.type);
			} // END if
		}
		/**
		 * Updates the public progress properties with data from the loader object.
		 * @since	1.0
		 */
		private function progressHandler(e:ProgressEvent):void {
			_bytesTotal += e.bytesTotal;
			_bytesLoaded += e.bytesLoaded;
        }
	}
}