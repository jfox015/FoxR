package com.foxr.display 
{
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.*;
	import com.foxr.display.content.Image;
	import com.foxr.display.graphics.Box;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.text.*;
	/**
	 * CompoundElement is a base class for all visual elements that will incorporate 
	 * basic graphic element objects within them to be used for display. This element 
	 * is only to be used for objects that require the two most common primaitive 
	 * element objects (Box, TextElement) to be used.
	 * <p />
	 * This object does not offer any additional functionality over the base Element class, 
	 * but adds numerous properties to customize its two embedded primative Elements.
	 * <p />
	 * @author			Jeff Fox
	 * @version			0.2.1
	 * @see				com.foxr.display.Element Element
	 * @see				com.foxr.display.TextElement TextElement
	 * @see				com.foxr.display.graphics.Box Box
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class CompoundElement extends Element {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// CONSTANTS
		/**
		 * Align Left Constant
		 * @const ALIGN_LEFT:String
		 */
		public static const ALIGN_LEFT:String = 'left';
		/**
		 * Align Center Constant
		 * @const ALIGN_CENTER:String
		 */
		public static const ALIGN_CENTER:String = 'center';
		/**
		 * Align Right Constant
		 * @const ALIGN_RIGHT:String
		 */
		public static const ALIGN_RIGHT:String = 'right';
		/**
		 * Vertical Align Top Constant
		 * @const VALIGN_TOP:String
		 */
		public static const VALIGN_TOP:String = 'top';
		/**
		 * Vertical Align Bottom Constant
		 * @const VALIGN_BOTTOM:String
		 */
		public static const VALIGN_BOTTOM:String = 'bottom';
		/**
		 * Vertical Align Middle Constant
		 * @const VALIGN_MIDDLE:String
		 */
		public static const VALIGN_MIDDLE:String = 'middle';
		//OBJECTS
		/**
		 * Background
		 * @var	bkgd:Box 
		 */
		protected var bkgd:Box = null;
		/**
		 * Text Element
		 * @var	txt:TextElement
		 */
		protected var txt:TextElement = null;
		
		//PROPERTIES
		/**
		 * Padding
		 * @var	_padding:Number
		 */
		protected var _padding:Number = 2;
		/**
		 * Alignment
		 * @var	_alignment:String
		 */
		protected var _alignment:String = ALIGN_LEFT;
		/**
		 * Vertical Alignment
		 * @var	_verticalAlignment:String
		 */
		protected var _verticalAlignment:String = VALIGN_TOP;
		/**
		 * Text Style
		 * @var	_textStyle:TextFormat
		 */
		protected var _textStyle:TextFormat = new TextFormat();
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new CompoundElement instance
		 *
		 */
		public function CompoundElement() {
			bkgd = Box(addElement('bkgd',Box,{x:0,y:0,visible:false}));
			txt = TextElement(addElement('txt',TextElement,{x:_padding,y:_padding,visible:false}));
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alpha of the objects background. 
		 * @since	1.17
		 * @param	a	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The backgrounds alpha value
		 */
		public function get backgroundAlpha():Number { return bkgd.alpha; }
		public function set backgroundAlpha(a:Number):void { bkgd.alpha = a; }
		/**
		 * Changes the color of the objects background. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get backgroundColor():Number { return bkgd.color; }
		public function set backgroundColor(c:Number):void { bkgd.color = c; if (bkgd.visible == false) bkgd.visible = true;  }
		/**
		 * Sets or returns the croner Type fot he background Box object. Valid options are:
		 * <ul>
		 *    <li>Box.CORNER_NORMAL</li>
		 *    <li>Box.CORNER_ROUNDED</li>
		 * </ul>
		 * 
		 * @since	1.0
		 * @param	t	The corner type value
		 * @return		The corner type value
		 */
		public function get backgroundCornerType():String { return bkgd.cornerType; }
		public function set backgroundCornerType(t:String):void { bkgd.cornerType = t; }
		/**
		 * Set in conjunction with backgroundCornerType, sets the height of the corner 
		 * elipse. This property is ignored if the background corner type is set to 
		 * <code>Box.CORNER_NORMAL</code>.
		 * <p />
		 * This property is optional as the Box object uses the value of elipseWidth for 
		 * elipseHEight if not value is specified.
		 * 
		 * @since	1.0
		 * @param	w	Elipse height in pixels
		 * @return		Elipse height in pixels
		 */
		public function get backgroundElipseHeight():Number { return bkgd.elipseHeight; }
		public function set backgroundElipseHeight(h:Number):void { bkgd.elipseHeight = h; }
		/**
		 * Set in conjunction with backgroundCornerType, sets the width of the corner 
		 * elipse. This property is ignored if the background corner type is set to 
		 * <code>Box.CORNER_NORMAL</code>.
		 * 
		 * @since	1.0
		 * @param	w	Elipse width in pixels
		 * @return		Elipse width in pixels
		 */
		public function get backgroundElipseWidth():Number { return bkgd.elipseWidth; }
		public function set backgroundElipseWidth(w:Number):void { bkgd.elipseWidth = w; }
		/**
		 * Changes the gradient style of the objects background. 
		 * @since	1.0
		 * @param	s	Graphic gradient Style object.
		 * @return		background gradient style object.
		 * @see			com.foxr.display.graphics.Graphic Graphic
		 */
		public function set backgroundGradient(s:Object):void { bkgd.gradientStyle = s; if (bkgd.visible == false) bkgd.visible = true;  }
		/**
		 * Sets an image to the background for the object. 
		 * @since	1.0
		 * @param	p	Backrgound image file name
		 */
		public function set backgroundImage(p:String):void { 
			var bkgdImg:Loader = loadExternalContent(p, Element); 
			loader.addEventListener(Event.COMPLETE, onBackgroundLoaded);
			bkgdImg.name = 'bkgdImg';
			if (txt != null) setChildIndex(bkgdImg,getChildIndex(txt));
		}
		/**
		 * Changes the alpha (transparency) of the objects border. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The borders alpha value
		 */
		public function get borderAlpha():Number { return bkgd.borderAlpha; }
		public function set borderAlpha(a:Number):void { bkgd.borderAlpha=a; }
		/**
		 * If borderWeight is set, this changes the color of the objects border. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get borderColor():Number { return bkgd.borderColor; }
		public function set borderColor(c:Number):void { bkgd.borderColor=c; if (bkgd.visible == false) bkgd.visible = true; }
		/**
		 * Changes the width (size) of the objects border. 
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public function get borderWidth():Number { return bkgd.borderWidth; }
		public function set borderWidth(w:Number):void { bkgd.borderWidth=w; if (bkgd.visible == false) bkgd.visible = true;  }
		/**
		 * Applies a new serting for the boxes corner type.
		 * @since	1.0
		 * @param	t	Corner type - normal or rounded
		 */
		public function get cornerType():String { return bkgd.cornerType; }
		public function set cornerType(t:String):void { bkgd.cornerType = t; }
		/**
		 *	Applies a css class name argument to be used to style the embedded text field.
		 *  @param	c	CSS Text Format Class
		 *  @since 	0.2.1
		 */
		public function get cssTextClass():String { return txt.cssTextClass; }
		public function set cssTextClass(c:String):void { txt.cssTextClass = c; }	
		/**
		 * Applies an elipse width setting for use with rounded corners. Used in cojunction with 
		 * <b>cornerType</b> set to rounded.
		 * @since	1.0
		 * @param	e	Elipse width in pixels
		 * @see		com.foxr.display.CompoundElement#cornerType
		 */
		public function get elipseWidth():Number { return bkgd.elipseWidth; }
		public function set elipseWidth(e:Number):void { bkgd.elipseWidth = e; }
		/**
		 * Applies an elipse height setting for use with rounded corners. If no value is specified, the 
		 * value o <b>#elipseWidth</b> is used instead.
		 * @since	1.0
		 * @param	e	Elipse height in pixels
		 * @see		com.foxr.display.CompoundElement#elipseWidth
		 */
		public function get elipseHeight():Number { return bkgd.elipseHeight; }
		public function set elipseHeight(e:Number):void { bkgd.elipseHeight = e; }
		
		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set height(h:Number):void {
			super.height = h; 
			bkgd.height = h; 
			(this.verticalAlign!=null)?this.verticalAlign=this.verticalAlign:''; 
		}
		/**
		 * Applies padding propertyy ot the object
		 * @since	1.0
		 * @param	p	Padding in pixels
		 */
		public function get padding():Number { return _padding; }
		public function set padding(p:Number):void { _padding = p; }
		/**
		 * Applies a font and copy string to the main text field of the object
		 * @since	1.0
		 * @param	t	Valid font and copy string Identifier
		 *
		 */
		public function set string(id:String):void {  txt.string = id; (this.textStyle!=null)?txt.style=this.textStyle : ''; }
		/**
		 * Applies text content to the main text field of the object
		 * @since	1.0
		 * @param	t	String containing the text copy
		 *
		 */
		public function get text():String { return txt.text; }
		public function set text(t:String):void { txt.text=t; (this.textStyle!=null)?txt.style=this.textStyle : '';	}
		/**
		 * Changes the alignment of the objects text field. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get textAlign():String { return _alignment; }
		public function set textAlign(a:String):void {
			if (a != '') {
				_alignment = a;
				//trace(this.name + " align, width = " + width);
				switch (a) {
					case ALIGN_CENTER:
						txt.x = (width / 2) - ((txt.textWidth / 2) + 3);
						break;
					case ALIGN_RIGHT:
						txt.x = (width - (txt.textWidth + (_padding * 2)));
						break;
					case ALIGN_LEFT:
					default:
						txt.x = _padding;
						break;
				} // END switch
			} // END if
		} // END function
		/**
		 * Apply style properties to the dialog's main text area.
		 * @since	1.0
		 * @param	s	A valid TextFormat
		 * @return	TextFormat
		 */
		public function get textStyle():TextFormat{ return _textStyle; }
		public function set textStyle(s:TextFormat):void { 
			_textStyle = s;
			if (txt.text != ''){ txt.style=s;} 
			if (this.textAlign!=null){textAlign=this.textAlign;}
		}
		/**
		 * Changes the vertical alignment of the objects text field. 
		 * @since	1.0
		 * @param	a	The alignment (top, middle or bottom)
		 * @return		The alignment (top, middle or bottom)
		 */
		public function get verticalAlign():String { return _verticalAlignment; }
		public function set verticalAlign(a:String):void {
			if (a != '') {
				_verticalAlignment = a;
				switch (a) {
					case VALIGN_MIDDLE:
						txt.y = (bkgd.height / 2) - (txt.height / 2);
						break;
					case VALIGN_BOTTOM:
						txt.y = (bkgd.height - txt.height) - _padding;
						break;
					case VALIGN_TOP:
					default:
						txt.y = _padding;
						break;
				} // END switch
			} // END if
		} // END function
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void { 
			super.width = w; 
			bkgd.width = w; 
			(this.textAlign!=null)?this.textAlign=this.textAlign:''; 
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/	
		private function onBackgroundLoaded(e:Event):void {
			loader.removeEventListener(Event.COMPLETE, onBackgroundLoaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
	} // END class
} // END package