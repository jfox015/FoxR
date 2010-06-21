package com.foxr.model 
{
	//import external classes
	import com.foxr.controller.Application;
	
	import flash.events.Event;
	
	/**
	 * This class is responsible for collecting and sorting the various visual 
	 * attributes of the movie such as size, pages and transition settings.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class VisualConfigProxy extends BaseProxy {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var NAME:String = "VisualConfigProxy";
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _allowSizeOverride:Boolean = false;
		private var _fullScreen:Boolean = false;
		private var _background:Class = null;
		private var _header:Class = null;
		private var _footer:Class = null;
		private var _pageList:Object = null;
		private var _startPage:String = '';
		private var _authorizeResultPage:String = '';
		private var _pageFadeTime:Number = 1;
		private var _imgLogo:String = '';
		private var _flashVars:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new VisualConfigProxy instance.
		 */
		public function VisualConfigProxy() { 
			super(NAME, new Object());
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a set of key/value pairs to the built in properties of the class.
		 * <p />
		 * Any values that do not match preexisting properties of this class are consequently 
		 * dumped into the FlashVars catchall property.
		 * <p />
		 * @param	data	Key/Value pair object of properties.
		 * @since	1.0
		 */
		public override function setData( data:Object ):void {
			if (_flashVars == null) _flashVars = new Object();
			for (var item:String in data) {
				if (data[item] != null) {
					try {
						if (typeof(data[item]) == "object" && data[item].value) {
							this[item] = data[item].value;
						} else {
							this[item] = data[item];
						}
					} catch (e:Error) {
						// NOT A RECOGNIZED VALUE, SO CAPTURE IT TO FLASH VARS
						if (typeof(data[item]) == "object" && data[item].value) {
							_flashVars[item] = data[item].value;
						} else {
							_flashVars[item] = data[item];
						}
					} // END try/catach
				} else {
					// DEV NOTE: THIS ELSE STATEMENT PREVENTS FLASH THROWING A 
					// NULL OBJECT REFERENCE BUT APPLIES THE NULL VALUE TO THE 
					// OBJECT PROEPRTY 
					try {
						this[item] = null;
					} catch (e:Error) {
						// NOT A RECOGNIZED VALUE, SO UPDATE FLASH VARS
						_flashVars[item] = null;
					}
				}
			} // END for
		}
		/**
		 * The width of the movie.
		 * @param	w	Width in pixels
		 * @return 	Width in pixels
		 */
		public function get width():Number { return _width; }
		public function set width(w:Number):void { _width = w; }
		/**
		 * The height of the movie.
		 * @param	w	Height in pixels
		 * @return 	Height in pixels
		 */
		public function get height():Number { return _height; }
		public function set height(h:Number):void { _height = h; }
		
		public function get allowSizeOverride():Boolean { return _allowSizeOverride; }
		public function set allowSizeOverride(o:Boolean):void { _allowSizeOverride = o; }
		
		public function get fullScreen():Boolean { return _fullScreen; }
		public function set fullScreen(f:Boolean):void { _fullScreen = f; }
		
		public function get background():Class { return _background; }
		public function set background(b:Class):void { _background = b; }

		public function get header():Class { return _header; }
		public function set header(h:Class):void { _header = h; }
		
		public function get footer():Class { return _footer; }
		public function set footer(f:Class):void { _footer = f; }
		
		public function get pageList():Object { return _pageList; }
		public function set pageList(l:Object):void { _pageList = l; }

		public function get startPage():String { return _startPage; }
		public function set startPage(p:String):void { _startPage = p; }

		public function get authorizeResultPage():String { return _authorizeResultPage; }
		public function set authorizeResultPage(p:String):void { _authorizeResultPage = p; }

		public function get pageFadeTime():Number { return _pageFadeTime; }
		public function set pageFadeTime(t:Number):void { _pageFadeTime = t; }
		
		public function get imgLogo():String { return  _imgLogo; }
		public function set imgLogo(l:String):void { _imgLogo = l; }
		/**
		 * The FlashVars property is a catch-all object that stores any properties 
		 * assigned to the proxy that do not match a pre-existing property. 
		 * The properties assigned to this object can be determined at any time via 
		 * the listFlashVars() command.
		 * 
		 * @param	v	Data Object
		 * @return	FlashVars object with associated properties.
		 */
		public function get flashVars():Object { return  _flashVars; }
		public function set flashVars(v:Object):void { _flashVars = v; }
		
	}
}