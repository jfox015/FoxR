package com.foxr.display.content
{
	//import external classes
	import com.foxr.display.Element;
	import com.foxr.util.Utils;
	import flash.display.BitmapData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.registerClassAlias;
	/**
	 * The Image class replicates the properties of the HTML IMage tag and 
	 * can be used to add addional features and interactivity to graphical 
	 * elements within the movie.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 */
	public class Image extends Element {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const TYPE_STATIC:String = 'static';
		public static const TYPE_LINEAR:String = 'linear';
		public static const TYPE_INTERACTIVE:String = 'interactive';
		/**
		 * Analytics Id
		 * @var _animating:Boolean
		 */
		protected var _analyticsId:String = "";
		/**
		 * Link href
		 * @var _href:String
		 */
		protected var _href:String = "";
		/**
		 * Window target
		 * @var _target:String
		 */
		protected var _target:String = "";
		/**
		 * Image type
		 * @var _type:String
		 */
		protected var _type:String = "";
		/**
		 * File Source path
		 * @var _src:String
		 */
		protected var _src:String = "";
		/**
		 * Title
		 * @var _title:String
		 */
		protected var _title:String = "";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * C'TOR
		 * Construct a new Image instance
		 *
		 */
		public function Image() {
			super();	
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Sets an ID to be used by the Analystics Model to track events such as impressions and/or clicks.
		 * @param	id	Analytics tracking ID
		 * @return		Analytics tracking ID
		 * @since	1.0
		 */
		public function get analyticsId():String { return _analyticsId; }
		public function set analyticsId(id:String):void { _analyticsId = id; }
		/**
		 * Applies an HTTP href attribute to the image. This can be used to implement click through actions.
		 * @param	h	A Valid HTTP href argument
		 * @return		A Valid HTTP href argument
		 * @since	1.0
		 */
		public function get href():String { return _href; }
		public function set href(h:String):void { _href = h; }
		/**
		 * Returns an object containing the load progress details of the image asset.
		 * @return	Object containing bytes, bytesLoaded, and bytesTotal properties.
		 * @since	1.0
		 */
		public function get loadProgress():Object {
			var returnObj:Object = null;
			if (loader != null) {
				returnObj = new Object();
				returnObj.bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
				returnObj.bytesTotal = loader.contentLoaderInfo.bytesTotal;
			}  // END if
			return returnObj;
		}
		/**
		 * Returns the content property of the Image's loader object. This allows 
		 * direct manipluation of the loaded image and access to assign it event 
		 * handlers.
		 * <p />
		 * This method return <code>null</code> is the loader's content is not yet
		 * fully loaded.
		 * <p />
		 * @return 	Loader DisplayObject object
		 * @since	1.0
		 */
		public function get loaderContent():DisplayObject { 
			var content:DisplayObject = null;
			if (loader.contentLoaderInfo.bytesLoaded == loader.contentLoaderInfo.bytesTotal) {
				content = loader.content;
			} // END if
			return content;
		}
		/**
		 * Image source path. By default, the image uses the default image path, but this can be overriden 
		 * with the inclusion of an absolute path "http://" argument.
		 * @param	s	Path to the external image content
		 * @return		Path to the external image content
		 * @since	1.0
		 */
		public function get src():String { return _src; }
		public function set src(s:String):void { 
			if (s != '') {
				if (this.numChildren > 0) {
					while (numChildren > 0) {
						removeChildAt(0);
					} // END while
				} // END if
				var path:String = '';
				var checkPolicy:Boolean = false;
				if (src.indexOf("http://") == -1 || src.indexOf("https://") == -1) {
					path = gpm.config.mediaPath + s;
				} else {
					path = s;
					checkPolicy = true;
				} // END if
				loader = loadExternalContent(path, Element, null, checkPolicy);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				_src = s;
			} // END if
		}
		/**
		 * Sets an ID to be used by the Analystics Model to track thins such as impressions and clicks.
		 * @param	t	HTML Target value (_blank, _new, _self, _top)
		 * @return		HTML Target value
		 * @since	1.0
		 */
		public function get target():String { return _target; }
		public function set target(t:String):void { _target = t; }
		/**
		 * A caption string that appears over the image on mouseover as a tooltip.
		 * @param	t	Title string
		 * @return		Title string
		 * @since	1.0
		 */
		public function get title():String { return _title; }
		public function set title(t:String):void { _title = t; }
		/**
		 * Applies or return the images type. Images can be static (no animations or playback), linear 
		 * (linear playback only) or interactive (not yet supported)
		 * @param	t	The image type (static, linear, interactive)
		 * @return		The image type 
		 * @since	1.0
		 */
		public function get type():String { return _type; }
		public function set type(t:String):void { _type = t; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Creates a deep copy clone of the current image.
		 * @return		Deep Copy Duplicate Image object
		 * @since	1.0
		 */
		public function duplicate():Image {
			var img:Image = new Image();
			img.src = this.src;
			img.width = this.width;
			img.height = this.height;
			img.id = this.id;
			return img;
		}
		/**
		 * Fired once the embedded image binary is fuily loaded and concurently fires 
		 * a Event.COMPLETE event.
		 * @param	e	Event response object
		 * @since	1.0
		 */
		protected function onImageLoaded(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	} // END class
} // END package