package com.foxr.display
{
	//import external classes
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import com.foxr.display.graphics.Box;
	import com.foxr.event.ElementEvent;
	import com.foxr.factory.LogFactory;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.util.log.ILog;

	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.net.*;
	import flash.filters.DropShadowFilter;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Element is a basic display class and serves as a base class for all visual 
	 * elements that will be displayed in FoxR Flash movies. It extends 
	 * Sprite and adds in a number of CSS centric properties 
	 * such as overflow, position and the ability to render drop shadows via Flash Filters. 
	 * <p />
	 * Element contains a basic set of properties and methods to aid in the creation of 
	 * custom display objects using FoxR's special shortcut syntax. 
	 * <p />
	 * @version			1.11
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * @see				flash.display.Sprite Sprite
	 *
	 */
	public class Element extends Sprite {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// CONSTANTS
		/**
		 * Position Absolute
		 * @const POSITION_ABSOLUTE_position:String
		 */
		public static const POSITION_ABSOLUTE:String = 'absolute';
		/**
		 * Position Relative
		 * @const POSITION_RELATIVE:String
		 */
		public static const POSITION_RELATIVE:String = 'relative';
		/**
		 * Position Fixed
		 * @const POSITION_FIXED:String
		 */
		public static const POSITION_FIXED:String = 'fixed';
		/**
		 * Overflow visible
		 * @const OVERFLOW_VISIBLE:String
		 */
		public static const OVERFLOW_VISIBLE:String = 'visible';
		/**
		 * Overflow hidden
		 * @const OVERFLOW_HIDDEN:String
		 */
		public static const OVERFLOW_HIDDEN:String = 'hidden';
		/**
		 * Element Loader
		 * @var	loader:Loader
		 */
		protected var loader:Loader = null;
		/**
		 * Parent Object
		 * @var	parentObj:Object 
		 */
		protected var parentObj:Object = null;
		/**
		 * ADM
		 * @var	gpm:GlobalDataManager
		 */
		protected var gpm:GlobalProxyManager = null;
		/* CSS CLASS
		 * @var	String	_class
		 * @access	private
		 */
		protected var _cssClass:String = '';
		/**
		 * ID
		 * @var _id:String
		 */
		protected var _id:String = "";
		/* ENABLED
		 * @var	Boolean	_enabled
		 * @access	private
		 */
		protected var _enabled:Boolean;
		/* OVERFLOW */
		/**
		 * Overflow Mask
		 * @var	_mask:Element 
		 */
		protected var _mask:Element = null;
		/**
		 * Mask Properties
		 * @var	_maskProperties:Object 
		 */
		protected var _maskProperties:Object = null;
		/**
		 * Object width
		 * @var	_width:Number 
		 */
		protected var _width:Number = 0;
		/**
		 * Object height
		 * @var	_height:Number
		 */
		protected var _height:Number = 0;
		/**
		 * Overflow
		 * @var	_overflow:String
		 */
		protected var _overflow:String = OVERFLOW_VISIBLE;
		/* POSITION */
		/**
		 * Position
		 * @var _position:String
		 */
		protected var _position:String = POSITION_ABSOLUTE;
		/* DROP SHADOW */
		/**
		 * Drop Shadow
		 * @var _dropShadow:Boolean 
		 */
		protected var _dropShadow:String = 'hidden';
		/**
		 * Drop Shadow Style
		 * @var _dropShadowStyle:Object
		 */
		protected var _dropShadowStyle:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Element instance
		 *
		 */
		public function Element() {
			this.addEventListener(Event.ADDED, addedToStage);
			gpm = GlobalProxyManager(Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME));
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *	Applies a css class argument.
		 *  @param	ds	Pass visible to show the drop shadow, or hidden to hide it
		 *  @since 	1.0
		 *  
		 */
		public function get cssClass():String { return _cssClass; }
		public function set cssClass(c:String):void {  _cssClass = c; render(); }	
		/**
		 *	Applies or removes a drop shadow to the current object.
		 *  @param	ds	Pass visible to show the drop shadow, or hidden to hide it
		 *  @since 	1.0
		 *  
		 */
		public function get dropShadow():String { return _dropShadow; }
		public function set dropShadow(ds:String):void { 
			_dropShadow = ds;
			if (ds == 'visible') addDropShadow();
			else if (ds == 'hidden') removeDropShadow(); 
		}
		/**
		 *	Applies a properties object for the objects drop shadow.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set dropShadowStyle(s:Object):void { _dropShadowStyle = s; }
		/**
		 *  Sets the _enabled flag. Child object should override this method to custom eneable or
		 *  disable themselves.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public function get enabled():Boolean { return _enabled }
		public function set enabled(e:Boolean):void { _enabled = e; }
		/**
		 * Changes the height of the object. 
		 * @since	1.0
		 * @param	b	The height in pixels
		 * @return		The height in pixels
		 */
		public override function get height():Number { return _height; }
		public override function set height(h:Number):void { _height = h;  }
		/**
		 * Unique identifier to allow the image to be access by name by outside object at runtime.
		 * @param	n	The image ID string
		 * @return		The image ID string
		 * @since	1.0
		 */
		public function get id():String { return _id; }
		public function set id(i:String):void { _id = i; render(); }
		/**
		 *	The overflow property sets what happens when the content of an element exceeds
		 *  the boundaries of the elements visible area. This property only affects objects
		 *  that have height and width arguments set.
		 *  <p />
		 *  Basic Elements only support the visible and hidden properties. <b>CompoundElement</b> adds support for scrolling of content is 
		 *  overflow occurs.
		 *	<p />
		 *  @param		o	The overflow value (visible, hidden)
		 *  @return		Elements current Overflow value
		 *  @since 		1.0
		 * 	@see		com.foxr.display.CompoundElement CompoundElement
		 *  
		 */
		public function get overflow():String { return _overflow; }
		public function set overflow(o:String):void { _overflow = o; setOverflow(); }
		/**
		 *	Applies positioning attributes to the object.
		 *  @param	p	Position arg - (absolute, relative, fixed) 
		 *  @return		Elements current Position value
		 *  @since 	1.0
		 *  
		 */
		public function get position():String { return _position; }
		public function set position(p:String):void { _position = p; }
		/**
		 *	Supports applying CSS visibility setting to objects.
		 *  @param	v	visible or hidden
		 *  @return		The objects visibility
		 *  @since 	1.0
		 *  
		 */
		public function get visibility():String { return (visible == true) ? 'visible' : 'hidden'; }
		public function set visibility(v:String):void {visible = (v == 'visible') ? true :false; }
		/**
		 * Changes the width of the object. 
		 * @since	1.0
		 * @param	b	The width in pixels
		 * @return		The width in pixels
		 */
		public override function get width():Number { return _width;  }
		public override function set width(w:Number):void { _width = w;  }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Adds a new child element to the existing class.
		 * @since		1.0
		 * @param		id			Unique identifier
		 * @param		className	The class to instaitate
		 * @param		args		(Optional) Properties object
		 * @param		styleClass	(Optional)	CSS Style Object
		 * @return		The new Element instance.
		 */
		public function addElement(id:String, className:Class, args:Object = null, styleClass:Object = null):Element {
			var instance:Element = null;
			try {
				instance = new className(); // will throw an error if c does not descend from Element
				instance.name = id;
				if (args != null) instance.applyProperties(args); // END if
				if (styleClass != null) instance.applyProperties(styleClass); // TODO: FETCH AND APPLY STYLE PROPERTIES HERE 
				//dispatchEvent(new ElementEvent(ElementEvent.ELEMENT_ADDED));
				dispatchEvent(new ElementEvent(ElementEvent.ELEMENT_ADDED));
				addChild(instance);
			} catch (e:Error) {
				trace("Element::addElement -- Error occured during instantiation of element " + id + ". Error = " + e);
			} finally {
				return instance;
			} // END try, catch, finally
		} // END function
		/**
		 * This method adds a new DisplayObject by "attaching" a library element to the current object=. No class
		 * name is required as the class is defined in the library items base class property.
		 * @since		1.10
		 * @param		symbolName	The Library symbol ID
		 * @param		depth		(Otptional) The depth to assign the new object to.
		 * @param		args		(Optional) Properties object
		 * @param		styleClass	(Optional)	CSS Style Object
		 * @return		The new DisplayObject instance.
		 */
		public function addElementFromLibrary(symbolName:String,depth:Number = -1, args:Object = null, styleClass:Object = null):Element {
			var instance:Element = null;
			try {
				var c:Class = getDefinitionByName(symbolName) as Class;
				if (c != null) {
					var tmpElem:Element = new c() as Element;
					if (depth == -1) {
						instance = Element(addChild(tmpElem));
					} else {
						instance = Element(addChildAt(tmpElem, depth));
					} // END if
					if (args != null) {
						for (var i:String in args)
							instance[i] = args[i];
					} // END if
					if (styleClass != null) {
						for (var j:String in styleClass)
							instance[j] = styleClass[j];
					} // END if
				} // END if
				dispatchEvent(new ElementEvent(ElementEvent.ELEMENT_ADDED));
			} catch (e:Error) {
				trace(name+"::addElementFromLibrary -- Error occured during instantiation of Element " + symbolName + ". Error = " + e);
			} finally {
				return instance;
			} // END try, catch, finally
		} // END function
		/**
		 * Applies the set of passed properties to the current element instance.
		 * @since	1.0
		 * @param	p	An valid object contaiing ne or more properties ot be assigned
		 * 
		 */
		public function applyProperties(p:Object):void {
			for (var i:String in p) {
				try {
					this[i] = p[i];
				} catch (e:Error) {
					trace(name+"::applyProperties -- Error occured during application of property " + i + " to element " + this.name + ". Error = " + e);
				}
			} // END for
		} // END function
		/**
		 * Retrieves the custom property of the current object. This method allows you
		 * to get properties of child Elements where calling the local instantiation 
		 * returns an error.
		 * @since	1.0
		 * @param	p	The valid element property
		 * @return		(Variable) The elements property value
		 *
		 */
		public function getProperty(p:String):* {
			try {
				if (this[p] != null) return this[p];
			} catch (e:Error) {
				trace(name+"::getProperty -- Error in request for " + p + " property of " + this.name + ". Error = " + e);
			} // END try, catch
		}
		/**
		 * Loads external media including SWFs, JPG, PNG and static GIF images.
		 * @since	1.0
		 * @param	path	The full path to the asset to be loaded
		 * @param	type	The media type. Must be a valid Flash DisplayObject of Bitmap or MovieClip
		 * @param	target	OPTIONAL - Specifies a target object to load the asset to if other than the current Element
		 * @param	securityDomain	OPTIONAL - A SecurityDomain object if the objects SecurityDomain is one other than currentDomain
		 * @param	applicationDomain	OPTIONAL - A ApplicationDomain object if the loaded objects ApplicationDomain is one other than currentDomain
		 *
		 */
		public function loadExternalContent(path:String,type:Object,target:Object = null,checkPolicyFile:Boolean= false,
											securityDomain:SecurityDomain=null,applicationDomain:ApplicationDomain=null):Loader {
			loader = new Loader();
			var ldrCtx:LoaderContext = null;
			// LOADER CONTEXT SETTINGS
			if (securityDomain != null || applicationDomain != null || checkPolicyFile != false) {
				ldrCtx = new LoaderContext();
				// SET SECUTIRY DOMAIN
				if (securityDomain != null)
					ldrCtx.securityDomain = securityDomain;
				else
					ldrCtx.securityDomain = SecurityDomain.currentDomain; // END if
				// SET APPLICATION DOMAIN
				if (applicationDomain != null)
					ldrCtx.applicationDomain = applicationDomain;
				else
					ldrCtx.applicationDomain = ApplicationDomain.currentDomain; // END if
				if (checkPolicyFile) ldrCtx.checkPolicyFile = true;
			} // END if
			
			// ADD LOAD EVENT LISTENERS
			/*
			if (listeners != null && listeners.length > 0) {
				for (var i:Number = 0; i < listeners.length; i++) {
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, listeners[i]); 
				} // END for
			} // END if
			*/
			
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderComplete );
			
			// FORMAT REQUEST AND LOAD OBJECT
			loader.load(new URLRequest( path ), ldrCtx);
			// IF A TARGET HAS BEEN SPECIFIED, ASSIGN THE LOADED ITEM TO THAT TARGET. OTHERWISE
			// ADD IT TO THE CURRENT ELEMENT AS A CHILD
			// DEVELOEPR TODO: ADD CODE TO RETURN THE LOADED ITEM AS THE SPECIFIED TYPE
			// ALSO TODO: Complete the assignment to a target which is currently not accepted by the CS3 compiler
			
			if (target != null)
				target.addChild(loader.content);
			else
				addChild(loader); // END if
			return loader;
		} // END function
		/**
		 * Fires a Facade.sendNotification() request.
		 * @param	name	Notifocation name
		 * @param	body	Body object
		 * @param	type	Notification Type
		 * @see				org.puremvc.as3.patterns.observer.Notification
		 * @see				org.puremvc.as3.patterns.facade.Facade
		 * @since	1.0
		 *
		 */
		public function sendNotification(name:String, body:Object = null, type:String = null):void {
			Facade.getInstance().sendNotification(name, body, type);
		}
		/**
		 * Turns the current items visibility on.
		 * @since	1.0
		 *
		 */
		public function show():void { this.visible = true; } // END function
		/**
		 * Turns the current items visibility off.
		 * @since	1.0
		 *
		 */
		public function hide():void { this.visible = false; } // END function		
		/**
		 * Placeholder method for child objects to execute once they have been added to the movie
		 * stage. This helps with acessing global variable from Main and parent objects.
		 * @since	1.0
		 *
		 */
		public function objReady(e:Event):void { 
			this.setOverflow();
			this.render();
		} // END function
		/**
		 * 	Fired when the current page is added to the stage.
		 *	@since	1.0
		 */
		public function addedToStage(e:Event):void {
			var paren:Object = e.currentTarget.parent;
			if (paren != null) {
				this.removeEventListener(Event.ADDED,addedToStage);
				parentObj = paren;
				objReady(e);
			} // END if 
        } // END function
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Adds a drop shadow.
		 *	@since	1.0
		 */
		protected function addDropShadow():void {
			if (this.filters.length == 0) {
				var shadowProps:Object = new Object();
				// set shadow defaults
				shadowProps.distance = 5;
				shadowProps.angle = 45;
				shadowProps.color = 0x000000;
				shadowProps.alpha = 0.6
				shadowProps.blurX = 5;
				shadowProps.blurY = 5;
				shadowProps.strength = 1;
				shadowProps.quality = 5;
				shadowProps.inner =  false;
				shadowProps.knockout = false;
				shadowProps.hideObject = false;
				// override defaultd with custom properties
				if (_dropShadowStyle != null) {
					for (var prop:String in _dropShadowStyle)
						shadowProps[prop] = _dropShadowStyle[prop]; // END for
				} // END if
				// create the drop shadow filter amd apply
				var filterArray:Array = new Array();
				filterArray.push(new DropShadowFilter(shadowProps.distance,shadowProps.angle,shadowProps.color000000,
				shadowProps.alpha,shadowProps.blurX,shadowProps.blurY,shadowProps.strength,shadowProps.quality,
				shadowProps.inner,shadowProps.knockout,shadowProps.hideObject));
				this.filters = filterArray;
			} // END if
		}
		/**
		 * 	Removes the objects drop shadow.
		 *	@since	1.0
		 */
		protected function removeDropShadow():void { this.filters = []; }
		/*--------------------------------------
		/	PROTECTED/PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a css style object to the element if it is specified
		 * @since	1.11
		 *
		 */
		protected function render():void {
			if (gpm != null && gpm.css != null) {
				if (gpm.css.getStyle(this.name.toLowerCase()) != null)
					this.applyProperties(gpm.css.getStyle(this.name.toLowerCase()));
				if (this._cssClass != '') 
					this.applyProperties(gpm.css.getStyle(this._cssClass));
			}
		}
		/**
		 * Fires a dispatch, after an external file has been loaded 
		 * @since	1.0
		 *
		 */
		protected function loaderComplete(evt:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			loader.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 	Based on height and width settings and overflow property, determines if a clipping
		 *  mask should be d raw for the item..
		 *	@since	1.0
		 */
		protected function setOverflow(targetObj:Element = null):void {
			if (_width > 0 && _height > 0 && _overflow == OVERFLOW_HIDDEN) {
				if (_mask == null) {
					this.mask = _mask = addElement('_mask', Box, { x:0, y:0, width:_width, height:_height, color:0x000000 } );
				} else {
					if (_maskProperties != null) _mask.applyProperties(_maskProperties);
					this.mask = _mask;
				} // END if
			} else {
				if (_mask != null) this.removeChild(this.getChildByName('_mask'));
				this.mask = null;
			}// END if
		} // END function	
	} // END class
} // END package