package com.foxr.display {
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.TextInput;
	import com.foxr.util.*;
	import com.foxr.model.*;
	
	import flash.text.*;
	import flash.events.*;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	/**
	 * The TextElement class is an extension of Element that wraps FoxR framework 
	 * functionality around the Flash textField object. It does this so that text 
	 * elements can be utilized using the same shortcut syntax as other FoxR Elements, 
	 * and to integrate it into the FoxR CopyCat Font & Copy system.
	 * <p />
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 * @version			1.2.1
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class TextElement extends Element {
		
		/*--------------------------------
		/	VARIABLES
		/-------------------------------*/
		// STATIC VARS
		private static const NAME:String = "TextElement";
		/**
		 * FONTLIBRARY_LOADED
		 * @const	FONTLIBRARY_LOADED:String
		 */
		public static const FONTLIBRARY_LOADED:String = "fontLibraryLoaded";
		/**
		 * Hover enabled Constant
		 * @const	HOVER_ENABLED:String
		 */
		public static const HOVER_ENABLED:String = "hover";
		/**
		 * Hover Disabled Constant
		 * @const	HOVER_DIABLED:String
		 */
		public static const HOVER_DIABLED:String = "none";
		/**
		 * Locale
		 * @var	 _link:String 
		 */
		private static var _locale:Locale = null;
		/**
		 * Strings Object.
		 * Stores the font and copy string values
		 * @var	 _strings:Object
		 */
		private static var _strings:Object = null;
		
		// INSTANCE VARS
		/**
		 * TextField
		 * @var	tf:TextField 
		 */
		private var tf:TextField = null;
		/* CSS TEXT CLASS
		 * @var	String	_cssTextClass
		 * @access	private
		 */
		protected var _cssTextClass:String;
		/**
		 * _string
		 * @var	
		 */
		private var _string:String;
		/**
		 * Hover Enabled (TRUE or FALSE)
		 * @var	_hover:Boolean
		 */
		private var _hover:Boolean = true;
		/**
		 * Normal Color
		 * @var	_normalColor:Number
		 */
		private var _normalColor:Number = -1;
		/**
		 *Hover Color
		 * @var	_hoverColor:Number 
		 */
		private var _hoverColor:Number = -1;
		/**
		 * Padding
		 * @var	_padding:Number 
		 */
		private var _padding:Number = 4;
		/**
		 * Link Href
		 * @var	 _link:String 
		 */
		private var _link:String = '';
		/**
		 * Target
		 * @var	_target:String 
		 */
		private var _target:String = '_blank';
		/**
		 * Language Asterisks
		 * @var	_languageAsterisks:Boolean
		 */
		private var _languageAsterisks:Boolean = false;
		/**
		 * Type
		 * @var	_type:String  
		 */
		private var _type:String = 'label';
		/**
		 * Field Format
		 * @var	_fieldFormat:TextFormat
		 */
		protected var _fieldFormat:TextFormat = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new TextElement instance
		 *
		 */
		public function TextElement():void {
			super();
			_fieldFormat =  new TextFormat();
			tf = new TextField();
			tf.selectable = false; 
			tf.multiline = true;
			tf.type = TextFieldType.DYNAMIC;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			//tf.wordWrap = true;
			tf.condenseWhite = false;
			tf.gridFitType = GridFitType.PIXEL;
			addChild(tf);
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies or returns the autoSize value of the text field object
		 * @since	1.0
		 * @param	a	A VAlid textFieldAutoSize value
		 * @return		The autoSize value
		 *
		 */
		public function get autoSize():String { return tf.autoSize; }
		public function set autoSize(a:String):void { tf.autoSize = a; }
		/**
		 * Applies or returns the border value of the text field object
		 * @since	1.0
		 * @param	b	TRUE or FALSE
		 * @return		TRUE or FALSE
		 *
		 */
		public function get border():Boolean { return tf.border; }
		public function set border(b:Boolean):void { tf.border = b; }
		/**
		 * Returns the current borderColor value of the text field object
		 * @since	1.0
		 * @param	c	Color value in 0x000000 format
		 * @return		Color value in 0x000000 format
		 *
		 */
		public function get borderColor():Number { return tf.borderColor; }
		public function set borderColor(c:Number):void { tf.borderColor = c; }
		/**
		 * Returns the current color value of the text field object
		 * @since	1.0
		 * @return	The color in 0x000000 format or -1 if no color value exists
		 *
		 */
		public function get color():Number { 
			var color:Number = -1;
			if (tf != null && tf.getTextFormat() != null && tf.getTextFormat().color != null) 
				color = tf.getTextFormat().color.valueOf(); 
			return color;
		}
		/**
		 *	Applies a css class name argument to be used to style the embedded text field.
		 *  @param	c	CSS Text Format Class
		 *  @since 	1.0
		 *  
		 */
		public function get cssTextClass():String { return _cssTextClass; }
		public function set cssTextClass(c:String):void { _cssTextClass = c; render(); }	
		
		/**
		 * Enables the password obstrufication method of the TextField object.
		 * @since	1.0
		 * @param	d	TRUE or FALSE
		 * @return		TRUE or FALSE
		 *
		 */
		public function get displayAsPassword():Boolean { return tf.displayAsPassword; }
		public function set displayAsPassword(d:Boolean):void { tf.displayAsPassword = d; }
		/**
		 * Overrides the default height property and sizes the child text field to the arg value.
		 * @since	1.0
		 * @param	w	Number	The height of the field in pixels.
		 *
		 */
		public override function set height(h:Number):void {
			super.height = h;
			tf.height = h;
		}
		/**
		 * Allows onMouseOver hover text color switching to be disbaled
		 * @since	1.0
		 * @param	h	HOVER_ENABLED to enabled, HOVER_DISABLED to disable
		 * @return		The current hover value
		 *
		 */
		public function get hover():String { return _hover.toString(); }
		public function set hover(h:String):void { _hover = (h == HOVER_ENABLED) ? true: false; }
		/**
		 * Applies a color to the text on mouse over
		 * @since	1.0
		 * @param	c	The text hover color in 0x000000 format
		 * @return		The text hover color in 0x000000 format
		 *
		 */
		public function get hoverColor():Number { return _hoverColor; }
		public function set hoverColor(c:Number):void { _hoverColor = c; }
		/**
		 * Use this method to enable the display of asterisk following text content to alert users 
		 * to a lack of in-language support for a external linked page. Use this property in combination 
		 * with the <b>link</b> property.
		 * NOTE: Asterisks will only appear in non-english views when this property is set to TRUE.
		 * @since	1.0
		 * @param	a	TRUE to display asterisks and FALSE to hide
		 * @return		TRUE or FALSE
		 *
		 */
		public function get languageAsterisks():Boolean { return _languageAsterisks; }
		public function set languageAsterisks(a:Boolean):void {  _languageAsterisks = a; }
		/**
		 * Applies a href link to the object
		 * @since	1.0
		 * @param	l	The http link
		 * @return		The http link
		 *
		 */
		public function get link():String { return _link; }
		public function set link(l:String):void { _link = l; update(); }
		/**
		 * Applies or returns the multiline value of the text field object
		 * @since	1.0
		 * @param	s	TRUE or FALSE
		 * @return		TRUE or FALSE
		 */
		public function get multiline():Boolean { return tf.multiline; }
		public function set multiline(m:Boolean):void { tf.multiline = m; }
		/**
		 * Applied padding to the boundaries of the object. 
		 * @since	1.0
		 * @param	p	Padding value in pixels
		 * @return		Padding value in pixels
		 */
		public function get padding():Number { return _padding; }
		public function set padding(p:Number):void { _padding = p; update(); }
		/**
		 * Applies or returns the selectable value of the text field object
		 * @since	1.0
		 * @param	s	TRUE or FALSE
		 * @return		TRUE or FALSE
		 */
		public function get selectable():Boolean { return tf.selectable; }
		public function set selectable(s:Boolean):void { tf.selectable = s; }
		/**
		 * Applies a fontAndCopy string to the object. 
		 * @since	1.0
		 * @param	s	A fontAndCopy string ID
		 * @return		The fontAndCopy string ID
		 */
		public function get string():String { return _string; }
		public function set string(s:String):void {
			var tmpStr:String = gpm.copy.getCopyString(s);
			if (tmpStr != null) write(tmpStr, this.style.font);
			else text = s;
		}
		/**
		 * Applies a strings array object to the TextElement. 
		 * @since	1.0
		 * @param	o	Strings object
		 * @return		Strings object
		 */
		public static function get strings():Object { return _strings; }
		public static function set strings(o:Object):void { _strings = o; }
		/**
		 * Applies a TextFormat style object to the objects textField. 
		 * @since	1.0
		 * @param	s	A TextFormat object
		 * @return		A TextFormat object
		 */
		public function get style():TextFormat { return tf.getTextFormat(); }
		public function set style(s:TextFormat):void { 
			if (s != null) {
				_fieldFormat = s;
				update(); 
			}
		}
		/**
		 * Applies or returns the stylesheet value of the text field object
		 * @since	1.0
		 * @param	s	A Stylesheet object
		 * @return	s	A Stylesheet object
		 */
		public function get stylesheet():StyleSheet { return tf.styleSheet; }
		public function set stylesheet(s:StyleSheet):void { tf.styleSheet = s; update(); }
		/**
		 * Applied a href target attribute to the object. Default value is _blank. 
		 * @since	1.0
		 * @param	t	A valid href target (_blank, _self, _parent, _top)
		 * @return		The href target
		 */
		public function get target():String { return _target; }
		public function set target(t:String):void { _target = t; }
		/**
		 * Applied text content to the object's textField. 
		 * @since	1.0
		 * @param	t	A text string
		 * @return		A text property value
		 */
		public function get text():String { if (tf != null) return tf.text; else return null; }
		public function set text(t:String):void { 
			//var font:String = (_strings != null) ? _strings['default_text'].font : '_sans';
			var defFont:String = gpm.config.defaultFont;
			var font:String = (defFont != '') ? defFont : '_sans';
			write(t, font); 
		}
		/**
		 * Returns the textWidth value of the object textField. 
		 * @since	1.0
		 * @return	The textWidth in pixels
		 */
		public function get textHeight():Number { return tf.textHeight; }
		/**
		 * Returns the textWidth value of the object textField. 
		 * @since	1.0
		 * @return	The textWidth in pixels
		 */
		public function get textWidth():Number { return tf.textWidth; }
		/**
		 * Sets the field type. Uses TextFieldType as the value. 
		 * @since	1.0
		 * @param	t	TextFieldType.INPUT or TextFieldType.DYNAMIC
		 * @return		TextFieldType.INPUT or TextFieldType.DYNAMIC
		 */
		public function get type():String { return tf.type; }
		public function set type(t:String):void { tf.type = t; }
		/**
		 * EOverrides the default with and sizes the child text field to the sizeof the object.
		 * @since	1.0
		 * @param	w	Number	The width of the field in pixels.
		 *
		 */
		public override function set width(w:Number):void {
			super.width = w;
			tf.width = w;
		}
		/**
		 * Enabled or disabled word wrap
		 * @since	1.0
		 * @param	w	TRUE or FALSE
		 *
		 */
		public function get wordWrap():Boolean { return tf.wordWrap; }
		public function set wordWrap(w:Boolean):void { tf.wordWrap = w; update(); }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Handles the mouse over event for the object, which changes the text
		 * color to the value specified by hoverColor. If not hover color
		 * change is desired, set the object hover property to FALSE. 
		 * @since	1.8
		 * @param	e	Event passed from the EventListener
		 */
		public function onMouseOver(e:Event):void {
			if (_hover && _hoverColor != -1) {
				var txtF:TextFormat = new TextFormat();
				_normalColor = tf.getTextFormat().color.valueOf();
				txtF.color = _hoverColor;
				tf.setTextFormat(txtF);
			} // END if
		} // END function
		/**
		 * Handles the mouse out event for the object, which turns off 
		 * @since	1.8
		 * @param	e	Event passed from the EventListener
		 */
		public function onMouseOut(e:Event):void {
			if (_hover && _normalColor != -1) {
				var txtF:TextFormat = new TextFormat();
				txtF.color = _normalColor;
				tf.setTextFormat(txtF);
			} // END if
		} // END function
		/**
		 * Handles the mouse down event for the object, which trigger a navigateToURL 
		 * call. This method is only fired if a link property is set.
		 * @since	1.8
		 * @param	e	Event passed from the EventListener
		 */
		public function onMouseDown(e:Event):void {
			if (_link != '') {
				if (_link.search("asfunction:") != -1) {
					var tmpAction:Array = _link.split(":");
					// Flash Function
					parent[tmpAction[1]](e);
				} else {
					navigateToURL(new URLRequest(_link),_target);
				} // END if
			}
		} // END function
		/**
		 * Applies a strings ID and dynamic data to be spliced into the string. Dynamic fields should be wrapped in { } and
		 * match values in the copy XML file. 
		 * @since	1.0
		 * @param	o	Strings object
		 */
		public function setDynamicString(s:String, dataValues:Object):void {
			var tmpStr:String = gpm.copy.getCopyString(s);
			if (tmpStr != null && tmpStr != '') {
				setDynamicText(tmpStr, dataValues);
			} else {
				setDynamicText(s, dataValues);
			} // END if
		}
		public function setDynamicText(t:String, dataValues:Object):void {
			for (var key:String in dataValues) {
				if (t.search(key) != -1) {
					t = StringUtils.replace(t, key, dataValues[key]);
				} // END if
			} // EnD for
			write(t, style.font);
		}

		public function setFocus():void {
			stage.focus = tf;
		}
		public override function objReady(e:Event):void {
			super.objReady(e);
			if (parentObj != null && parentObj.toString().toLowerCase().indexOf('textinput') != -1) {
				tf.autoSize = TextFieldAutoSize.NONE;
			} else {
				tf.autoSize = TextFieldAutoSize.LEFT;
			}
			update();
		}
		/*--------------------------------------
		/	PROTECTED/PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**	
		 * Updates the height and width properties of the text field based on the size of the
		 * text field textWidth and textHeight. Also enabled or disables click handling if a 
		 * link property is set
		 * @since	1.2.1
		 * @see		com.fox.display.Element#render
		 */
		protected override function render():void {
			super.render();
			if (this._cssTextClass != '') 
				this.style = gpm.css.getTextFormat(this._cssTextClass);
		}
		/**	
		 * Updates the height and width properties of the text field based on the size of the
		 * text field textWidth and textHeight. Also enabled or disables click handling if a 
		 * link property is set
		 * @since	1.8
		 */
		private function update():void {
			if (_fieldFormat != null) tf.setTextFormat(_fieldFormat); 
			// TEXT INPUT implementations should not be clickable links or auto adjust their 
			// own heights
			if (parentObj != null && parentObj.toString().toLowerCase().indexOf('textinput') == -1) {
				this.width = tf.width = (tf.textWidth + _padding); 
				this.height = tf.height = (tf.textHeight + _padding);
				if (_link != '' && !this.hasEventListener(MouseEvent.MOUSE_OVER)) {
					this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
					this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					this.buttonMode = true; this.useHandCursor = true; this.mouseChildren = false;
				} else if (_link == '' && this.hasEventListener(MouseEvent.MOUSE_OVER)) {
					this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
					this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					this.buttonMode = false; this.useHandCursor = false; this.mouseChildren = true;
				} //  END if
			} //  END if
		} // END function
		/**	
		 * Sets the appropriate text or fontAndCopy string to the text field and calls the 
		 * update() method
		 * @since	1.0
		 */
		private function write(t:String,fontName:String):void {
			if (fontName == null) fontName = gpm.config.defaultFont;
			tf.defaultTextFormat = new TextFormat(fontName);
			tf.embedFonts = true;
			if ((gpm.config.locale.language != "en" && gpm.config.locale.country != "US") && _languageAsterisks) t += " **"; //  END if
			tf.htmlText = t;
			update();
		} // END function
	}	// END class
} // END package