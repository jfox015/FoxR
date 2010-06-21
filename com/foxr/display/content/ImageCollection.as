package com.foxr.display.content
{
	//import external classes
	import com.foxr.display.*;
	import com.foxr.util.Utils;
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * The Image Collection object is a base class for any object that will loads a list of two or more
	 * images (being SWFs, PNGs, JPGs or GIFs) and then utilize them in some fashion. Images are 
	 * instantiated as MaskableImage objects allowing for greater flexibility in animation later.
	 * <p />
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 */
	public class ImageCollection extends Element {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const COLLECTION_IMAGES:String = 'images';
		public static const COLLECTION_ADS:String = 'ads';
		
		/**
		 * Array of Image details objects
		 * @var _imgList:Array
		 */
		protected var _imgList:Array = null;
		/**
		 *Preload flag
		 * @var _preload:Boolean
		 */
		protected var _preload:Boolean = false;
		/**
		 * Graphics Loaded flag
		 * @var _graphicsLoaded:Boolean
		 */
		protected var _graphicsLoaded:Boolean = false;
		/**
		 * Count of images that failed to load
		 * @var _imagesFailed:Number
		 */
		protected var _imagesFailed:Number = 0;
		/**
		 * Cpount of images loaded
		 * @var _imagesLoaded:Number
		 */
		protected var _imagesLoaded:Number = 0;
		/**
		 * Load in progress flag
		 * @var _loadInProgress:Boolean
		 */
		protected var _loadInProgress:Boolean = false;
		/**
		 * Load in progress flag
		 * @var _loadInProgress:Boolean
		 */
		protected var _type:String = COLLECTION_IMAGES;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ImageCollection instance
		 *
		 */
		public function ImageCollection() {
			super();
			_imgList = [];	
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Returns a reference to the image stored at the passed <code>idx</code>.
		 * <p />
		 * @since	1.0
		 * @param	idx	Index of the requested image
		 * @return		Image reference
		 *
		 */
		public function getImageAt(idx:Number):Image {
			return Image(getChildAt(idx));
		}
		/**
		 * Returns a deep copy clone of the image asset at the specified <code>idx</code>. 
		 * This is useful when creating interfaces that display a temporary copy of the 
		 * focus image (such as showing a ghost of the focus image when grabbing to drag 
		 * and drop it).
		 * <p />
		 * @since	1.0
		 * @param	idx	Index of the requested image
		 * @return		Deep copyied Image object
		 *
		 */
		public function getCopyOfImageAt(idx:Number):Image {
			return Image(getChildAt(idx)).duplicate();
		}
		/**
		 * Applies an array of image paths to the object to be loaded. If the preload
		 * property is set to TRUE, images are loaded as soon as the array is set. Otherwise,
		 * the object waits for the loadGraphics() call.
		 * @since	1.0
		 * @param	list	An array of image paths
		 *
		 */
		public function set imageArray(list:Array):void {
			if (list != null && list.length > 0) _imgList = list;
			if (_preload) loadGraphics();
		}
		/**
		 * Returns the actual number of images specified to the object. To get the actual number of 
		 * images successfully loaded, use the imagesLoaded property. To get a list of images that 
		 * failed top load for debug pruposes, use the imagesFailed property.
		 * @since	1.0
		 * @return	The number of images passed to the object to be loaded
		 *
		 */
		public function get imageCount():Number { return _imgList.length; }
		/**
		 * Returns the number of images that failed to load.
		 * @since	1.0
		 * @return	The number of images that could not be loaded
		 *
		 */
		public function get itemsFailed():Number { return _imagesFailed; }
		/**
		 * Applies an XML based list of images to the object. If the preload
		 * property is set to TRUE, images are loaded as soon as the array is set. Otherwise,
		 * the object waits for the loadGraphics() call.
		 * @since	1.0
		 * @param	list	An array of image paths
		 *
		 */
		public function set imageXML(path:String):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			loader.load(new URLRequest(path));
		}
		/**
		 * Determines whether the object preloads its graphics (immedietely once an array of image
		 * paths are set using images or when the load() method is called.
		 * @since	1.0
		 * @param	p	TRUE or FALSE
		 * @return	The objects preload value
		 *
		 */
		public function get preload():Boolean { return _preload; }
		public function set preload(p:Boolean):void { _preload = p; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Manual method of loading the images. Calling this method is uneccessary when preload
		 * is set to TRUE.
		 * @since	1.0
		 *
		 */
		public function load():void {
			loadGraphics();
		}
		/**
		 * Returns the number of images that succesffuly loaded.
		 * @since	1.0
		 * @return	The number of images that succesffuly loaded
		 *
		 */
		public function itemsLoaded():Number { return _imagesLoaded; }
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Fired once all images have loaded in.
		 *	@since	1.0
		 */
		protected function loadComplete():void {
			dispatchEvent(new Event(Event.COMPLETE));
			visible = true; 
		}
		/**
		 * 	Removes exsting children, creates new children and loads the images.
		 *	@since	1.0
		 */
		protected function loadGraphics():void {
			if (_imgList.length > 0) {
				if (this.numChildren > 0) {
					while (numChildren > 0) 
						this.removeChildAt(0); // END while
				} // END if
				_loadInProgress = true;
				for (var i:Number = 0; i < _imgList.length; i++) {
					var tmpimg:MaskableImage = MaskableImage(addElement('img_' + i, MaskableImage,_imgList[i], { visible:false }));
					tmpimg.addEventListener(Event.COMPLETE, onImageLoaded);
				} // END for
			} // END if
		} // END function
		/**
		 *  Handles an image load event. When all images have loaded, 
		 *  this method fires loadComplete().
		 *	@since	1.0
		 */
		protected function onImageLoaded(e:Event):void {
			
			var tmpImg:Image = Image(e.currentTarget);
			if (tmpImg.width > width) width = tmpImg.width; // END if
			if (tmpImg.height > height) height = tmpImg.height; // END if
			
			_imagesLoaded++;
			if (_imagesLoaded == _imgList.length) {
				_graphicsLoaded = true; // END if
				_loadInProgress = false;
				loadComplete();
			} // END if
		}
		/**
		 * 	Handles the completion of XML loading. parses the XML into the _imgList array and if preloading
		 * 	is selected, loads the images.
		 *	@since	1.0
		 *  @todo	Convert this method to use the XML batch loader and return an XML object
		 */
		protected function onXMLLoaded(e:Event):void {
			var xml:XML = new XML(e.currentTarget.data);
			var imgList:XMLList = xml.children();
			// CONVERT XML TO ARRAY
			var listLen:Number = imgList.length();
			for (var i:Number = 0; i < listLen; i++) {
				_imgList.push( { src:imgList[i].@src.toString(), width:parseInt(imgList[i].@width.toString()), height:parseInt(imgList[i].@height.toString()), 
				title:imgList[i].@title.toString(), href:imgList[i].@href.toString(), target:imgList[i].@target.toString(), 
				analyticsId:imgList[i].@analyticsId.toString(), type:imgList[i].@type.toString(),id:imgList[i].@id.toString() });
			} // END for
			if (_imgList.length > 0) {
				if (_preload) loadGraphics(); // END if
			} // END if
		}
	} // END class
} // END package