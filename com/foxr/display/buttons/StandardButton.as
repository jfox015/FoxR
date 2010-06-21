package com.foxr.display.buttons
{
	//import external classes
	import com.foxr.display.components.Component;
	import flash.events.*;
	import flash.text.TextFormat;
	/**
	 * A simple button object that includes the ability to custom skin, supports 
	 * mouseOver, mouseOut, mouseDown and MouseUp states as well as .
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 */	
	public class StandardButton extends Component {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Background Color
		 * @var	_backgroundColor:Number
		 */
		protected var _backgroundColor:Number = -1;
		/**
		 * Hover Background Color
		 * @var	_hoverBackgroundColor:Number
		 */
		protected var _hoverBackgroundColor:Number = -1;
		/**
		 * Hover Text Color
		 * @var	_hoverTextColor:Number
		 */
		protected var _hoverTextColor:Number = -1;
		/**
		 * Mouse Down Background Color
		 * @var	_mouseDownBackgroundColor:Number
		 */
		protected var _mouseDownBackgroundColor:Number = -1;
		/**
		 * Mouse Down Text Color
		 * @var	_mouseDownTextColor:Number
		 */
		protected var _mouseDownTextColor:Number = -1;
		/**
		 * Mouse Down Highlight Color
		 * @var	_mouseDownHighlightColor:Number
		 */
		protected var _mouseDownHighlightColor:Number = -1;
		/**
		 * Mouse Down Shadow Color
		 * @var	_mouseDownShadowColor:Number
		 */
		protected var _mouseDownShadowColor:Number = -1;
		/**
		 * Text Color
		 * @var	_textColor:Number
		 */
		protected var _textColor:Number = -1;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new StandardButton instance
		 *
		 */
		public function StandardButton() {
			super();
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *  Sets the _enabled flag.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void{ 
			super.enabled = e;
			this.buttonMode = this.useHandCursor = e; 
			this.mouseChildren = !e;
			if (e) {
				if (!this.hasEventListener(MouseEvent.MOUSE_OVER))
					addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (!this.hasEventListener(MouseEvent.MOUSE_OUT))
					addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (!this.hasEventListener(MouseEvent.MOUSE_DOWN))
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				if (!this.hasEventListener(MouseEvent.MOUSE_UP))
					addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} else {
				if (this.hasEventListener(MouseEvent.MOUSE_OVER))
					removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				if (this.hasEventListener(MouseEvent.MOUSE_OUT))
					removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				if (this.hasEventListener(MouseEvent.MOUSE_UP))
					removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} // END if
		}
		/**
		 * Overrides the default set height property. This method only updates the buttons size if the  
		 * sizeType property is set to SIZE_FIXED. Otherwise, it is ignored.
		 * @param	h	The component height in pixels
		 * @since	1.0
		 * 
		 */
		public override function set height(h:Number):void {
			if (sizeType == SIZE_FIXED) {
				super.height = h;
				realign();
			} else {
				_height = h;
			} // END if
		}
		/**
		 * Color of the objects background on mouse hover (mouseOver). 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get hoverBackgroundColor():Number { return _hoverBackgroundColor;  }
		public function set hoverBackgroundColor(c:Number):void { _hoverBackgroundColor = c;  }
		/**
		 * Color of the objects text color on mouse hover (mouseOver). 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get hoverTextColor():Number { return _hoverTextColor;  }
		public function set hoverTextColor(c:Number):void { _hoverTextColor = c;  }
		
		/**
		 * Color of the objects background on mouse press (mouseDown) 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get mouseDownBackgroundColor():Number { return _mouseDownBackgroundColor;  }
		public function set mouseDownBackgroundColor(c:Number):void { _mouseDownBackgroundColor = c;  }
		/**
		 * Color of the objects background on mouse press (mouseDown) 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get mouseDownHighlightColor():Number { return _mouseDownHighlightColor;  }
		public function set mouseDownHighlightColor(c:Number):void { _mouseDownHighlightColor = c;  }
		
		/**
		 * Color of the objects background on mouse press (mouseDown) 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get mouseDownShadowColor():Number { return _mouseDownShadowColor;  }
		public function set mouseDownShadowColor(c:Number):void { _mouseDownShadowColor = c;  }
		/**
		 * Color of the objects text color on mouse press (mouseDown). 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get mouseDownTextColor():Number { return _mouseDownTextColor;  }
		public function set mouseDownTextColor(c:Number):void { _mouseDownTextColor = c;  }
		/**
		 * Applies text content to the main text field of the object and updates the size 
		 * if sizeType is equal to SIZE_TO_CONTENT
		 * @since	1.0
		 * @param	t	String containing the text copy
		 *
		 */
		public override function set text(t:String):void {
			if (txt != null) {
				super.text = t;
				updateSize();
			}
		}
		/**
		 * Apply style properties to the dialog's main text area and updates the size 
		 * if sizeType is equal to SIZE_TO_CONTENT
		 * @since	1.0
		 * @param	s	A valid TextFormat
		 * @return	TextFormat
		 */
		public override function set textStyle(t:TextFormat):void {
			if (txt != null) {
				super.textStyle = t;
				updateSize();
			}
		}
		/**
		 * Applies a font and copy string to the main text field of the object and updates the size 
		 * if sizeType is equal to SIZE_TO_CONTENT
		 * @since	1.0
		 * @param	t	Valid font and copy string Identifier
		 *
		 */
		public override function set string(s:String):void {
			if (txt != null) {
				super.string = s;
				updateSize();
			}
		}
		/**
		 * Overrides the default width to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void {	
			if (sizeType == SIZE_FIXED) {
				super.width = w;
				realign();
			} else {
				_width = w;
			}// END if
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Placeholder method for child objects to execute once they have been added to the movie
		 * stage. This helps with acessing global variable from Main and parent objects.
		 * @since	1.0
		 *
		 */
		public override function objReady(e:Event):void { 
			super.objReady(e);
			bkgd.visible = true;
			if (txt != null) txt.visible = true;		
			if (_backgroundColor!= -1) backgroundColor = _backgroundColor;	
			this.enabled = true
		} // END function
		
		/*-----------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/----------------------------------*/
		/**
		 * 	Handles the mouse down event.
		 *	@since	1.0
		 */
		protected function onMouseDown(e:MouseEvent):void {
			if (this._mouseDownBackgroundColor != -1) {
				if (_backgroundColor == -1) 
					_backgroundColor = bkgd.color;
				bkgd.color = this._mouseDownBackgroundColor;
			} // END if
			var hcolor:Number = -1;
			var scolor:Number = -1;
			if (this.bkgd_3d_left.visible) {
				if (this._mouseDownHighlightColor == -1) {
					hcolor = bkgd_3d_right.color;
					scolor = bkgd_3d_left.color;
				} else {
					hcolor = _mouseDownHighlightColor;
				}
				if (hcolor != -1) 
					bkgd_3d_left.color = bkgd_3d_top.color = hcolor;
			}
			if (this.bkgd_3d_right.visible) {
				if (scolor == -1) {
					scolor = _mouseDownShadowColor;
				}
				if (scolor != -1) 
					bkgd_3d_right.color = bkgd_3d_bottom.color = scolor;
			}
			if (txt != null && this._mouseDownTextColor!= -1) {
				var tf:TextFormat = new TextFormat();
				tf.color = _mouseDownTextColor;
				txt.style = tf;
			} // END if
		}
		/**
		 * 	Handles the mouse up event. Alias for onMouseOut.
		 *	@since	1.0
		 */
		protected function onMouseUp(e:MouseEvent):void {
			this.onMouseOut(e);
			var hcolor:Number = -1;
			var scolor:Number = -1;
			if (this.bkgd_3d_left.visible) {
				if (this._highlightColor == -1) {
					hcolor = bkgd_3d_right.color;
					scolor = bkgd_3d_left.color;
				} else {
					hcolor = _highlightColor;
				}
				if (hcolor != -1) 
					bkgd_3d_left.color = bkgd_3d_top.color = hcolor;
			}
			if (this.bkgd_3d_right.visible) {
				if (scolor == -1) {
					scolor = _shadowColor;
				}
				if (scolor != -1) 
					bkgd_3d_right.color = bkgd_3d_bottom.color = scolor;
			}
		}
		/**
		 * 	Handles the mouse over event.
		 *	@since	1.0
		 */
		protected function onMouseOver(e:MouseEvent):void {
			if (_hoverBackgroundColor != -1) {
				if (_backgroundColor == -1) 
					_backgroundColor = bkgd.color;
				bkgd.color = _hoverBackgroundColor;
			}
			if (txt != null && this._hoverTextColor!= -1) {
				if (_textColor == -1 || (txt.color != -1 && _textColor != txt.color)) _textColor = txt.color;
				var tf:TextFormat = new TextFormat();
				tf.color = _hoverTextColor;
				txt.style = tf;
			}
		}
		/**
		 * 	Handles the mouse out event.
		 *	@since	1.0
		 */
		protected function onMouseOut(e:MouseEvent):void {
			if (this._backgroundColor != -1) {
				bkgd.color = _backgroundColor;
			}
			if (txt != null && this._textColor!= -1) {
				var tf:TextFormat = new TextFormat();
				tf.color = _textColor;
				txt.style = tf;
			}
		}
		/**
		 * 	Performs vertical and horizontal alignment of the object.
		 *	@since	1.0
		 */
		protected function realign():void {
			if (_alignment != null && _alignment != ''){ textAlign = _alignment;}
			if (_verticalAlignment != null && _verticalAlignment != ''){ verticalAlign = _verticalAlignment; }
		}
		/**
		 * 	Updates the size and layoout of the object based on it's content.
		 *	@since	1.0
		 */
		protected function updateSize():void {
			if (sizeType == SIZE_TO_CONTENT) {
				// update the background size
				width = bkgd.width = bkgd_3d_bottom.width = bkgd_3d_top.width = txt.textWidth + ((_padding * 2) + 4);
				bkgd_3d_right.x = (width - 1);
				height = bkgd.height = bkgd_3d_left.height = bkgd_3d_right.height = txt.textHeight + ((_padding * 2) + 4);
				bkgd_3d_bottom.y = height - 1;
				realign();
			} // END if
			realign();
		}
	}
}