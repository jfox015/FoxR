package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.controller.Application;
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.buttons.CloseButton;
	import com.foxr.display.buttons.StandardButton;
	import com.foxr.display.components.Component;
	import com.foxr.display.Element;
	import com.foxr.display.graphics.Box;
	import com.foxr.display.graphics.PixelCross;
	import com.foxr.display.TextElement;
	import com.foxr.event.DialogEvent;
	import com.foxr.view.containers.Message;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * A base class for creating dialog boxes within the framework. Extend to create custom 
	 * dialog boxes.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Dialog extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property
		 * @var		NAME:String
		 */
		private static const NAME:String = 'Dialog';
		/**
		 * Title Bar of Dialog
		 * @var		titleBar:StandardButton
		 */
		protected var titleBar:StandardButton = null;
		/**
		 * Title Bar Text Element
		 * @var		titleBarTxt:TextElement
		 */
		protected var titleBarTxt:TextElement = null;
		/**
		 * Close Button object
		 * @var		btnClose:StandardButton
		 */
		protected var btnClose:StandardButton = null;
		/**
		 * Cross Mark for Close Button
		 * @var		btnCloseCross:PixelCross
		 */
		protected var btnCloseCross:PixelCross = null;
		/**
		 * Container for OK and other dialog buttons
		 * @var		buttonBar:Element
		 */
		protected var buttonBar:Element = null;
		/**
		 * OK Button
		 * @var		btnOK:StandardButton
		 */
		protected var btnOK:StandardButton = null;
		/**
		 *  Show this dialog as a modal flag
		 * @var		_showAsModal:Boolean
		 */
		protected var _showAsModal:Boolean = true;
		
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Dialog instance.
		 */
		public function Dialog() { 
			super();
			
			titleBar = StandardButton(addElement('titleBar', StandardButton, { x:0, y:0,sizeType:SIZE_FIXED } ));
			titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
			titleBar.addEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);
			
			titleBarTxt = TextElement(addElement('titleBarTxt', TextElement, { x:_padding } ));
			
			btnClose = StandardButton(addElement('btnClose', StandardButton, { x:_padding,sizeType:SIZE_FIXED } ));
			btnClose.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			btnCloseCross = PixelCross(addElement('btnCloseCross', PixelCross, { x:_padding, mouseChildren:false } ));
			
			buttonBar = addElement('buttonBar', Element);
			
			btnOK = StandardButton(buttonBar.addElement('btnOK', StandardButton));
			btnOK.addEventListener(MouseEvent.CLICK, onBtnOKClick);
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a font and copy string to the default button of the dialog
		 * @since	1.0
		 * @param	t	Valid font and copy string Identifier
		 *
		 */
		public function set buttonString(s:String):void { btnOK.string = s; }
		/**
		 * Applies text content to the default button of the dialog.
		 * @since	1.0
		 * @param	t	String containing the text copy
		 *
		 */
		public function set buttonText(t:String):void { btnOK.text = t; }
		/**
		 * Applies or returns a value to the alpha property for the close button.
		 * @param	a	Alpha setting in 1.00 format
		 * @return		Alpha setting in 1.00 format
		 * @since	1.0
		 */
		public function get closeButtonAlpha():Number { return btnClose.backgroundAlpha; }
		public function set closeButtonAlpha(a:Number):void { btnClose.backgroundAlpha = a; }
		/**
		 * Applies or returns a value to the color property for the close button.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get closeButtonBackgroundColor():Number { return btnClose.backgroundColor; }
		public function set closeButtonBackgroundColor(c:Number):void { btnClose.backgroundColor = c; }
		/**
		 * Applies or returns a value to the color property for the close button.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get closeButtonForegroundColor():Number { return btnCloseCross.color; }
		public function set closeButtonForegroundColor(c:Number):void { btnCloseCross.color = c; }
		/**
		 * Applies or returns a value to the 3D highlight color property for the close button.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get closeButtonHighlightColor():Number { return btnClose.highlightColor; }
		public function set closeButtonHighlightColor(c:Number):void { btnClose.highlightColor = c; }
		/**
		 * Applies or returns a value to the 3D shadow color property for the close button.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get closeButtonShadowColor():Number { return btnClose.shadowColor; }
		public function set closeButtonShadowColor(c:Number):void { btnClose.shadowColor = c; }
		/**
		 * Applies a font and copy string to the main text field of the object
		 * @since	1.0
		 * @param	t	Valid font and copy string Identifier
		 *
		 */
		public function get showAsModal():Boolean { return _showAsModal; }
		public function set showAsModal(s:Boolean):void { _showAsModal = s; }
		/**
		 * Applies a font and copy string to the main text field of the object
		 * @since	1.0
		 * @param	t	Valid font and copy string Identifier
		 *
		 */
		public override function set string(s:String):void {
			super.string = s;
			updateLayout();
		}
		/**
		 * Applies text content to the main text field of the object
		 * @since	1.0
		 * @param	t	String containing the text copy
		 *
		 */
		public override function set text(t:String):void {
			super.text = t;
			updateLayout();
		}
		/**
		 * Apply an alpha to the dialog title bar
		 * @since	1.0
		 * @param	a	Alpha setting in 1.00 format
		 *
		 */
		public function get titleBarAlpha():Number { return titleBar.backgroundAlpha; }
		public function set titleBarAlpha(a:Number):void { titleBar.backgroundAlpha = a; }
		/**
		 * Apply a color to the dialog title bar
		 * @since	1.0
		 * @param	c	Color in 0x000000
		 *
		 */
		public function get titleBarColor():Number { return titleBar.backgroundColor; }
		public function set titleBarColor(c:Number):void { titleBar.backgroundColor = c; }
		/**
		 * Applies or returns a value to the 3D highlight color property for the title bar.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get titleBarHighlightColor():Number { return titleBar.highlightColor; }
		public function set titleBarHighlightColor(c:Number):void { titleBar.highlightColor = c; }
		/**
		 * Applies or returns a value to the 3D shadow color property for the title bar.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get titleBarShadowColor():Number { return titleBar.shadowColor; }
		public function set titleBarShadowColor(c:Number):void { titleBar.shadowColor = c; }
		/**
		 * Applies a copy library string id to the dialog title bar
		 * @since	1.0
		 * @param	s	copy library string id 
		 *
		 */
		public function set titleBarString(s:String):void { titleBarTxt.string = s; updateLayout(); }
		/**
		 * Applies text content to the dialog title bar
		 * @since	1.0
		 * @param	t	String containing the title bar text copy
		 *
		 */
		public function set titleBarText(t:String):void { titleBarTxt.text = t; updateLayout(); }
		/**
		 * Applies a style object to the dialog title bar
		 * @since	1.0
		 * @param	s	Ttitle bar style object
		 *
		 */
		public function set titleBarTextStyle(s:TextFormat):void { titleBarTxt.style = s; updateLayout(); }
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void {
			super.width = w;
			titleBar.width = w;
			buttonBar.width = txt.width = (w - (_padding * 2));
			updateLayout();
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Hides the dialog object.
		 * @since	1.0
		 *
		 */
		public override function hide():void {
			if (parentObj.toString().toLowerCase().indexOf('message') != -1)
				sendNotification(Application.HIDE_MESSAGE, {name:this.name});
		}
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			bkgd.visible = true;
			txt.visible = true;
			setCopy();
			setStyle();
			updateHeight();
		}
		/**
		 * 	Applies a dynamic copy string to the title bar area.
		 *	@since	1.0
		 *  @see 	com.foxr.display.TextElement#setSynamicString()
		 */
		public function setDynamicTitleBarString(s:String,data:Array):void { 
			titleBarTxt.setDynamicString(s, data);
			updateLayout();
		}
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Applies pre-defined copy to the objects text fields.
		 *	@since	1.0
		 */
		protected function setCopy():void {
			if (gpm.copy.getCopyString(GlobalConstants.TEXT_DIALOG_BUTTON_OK) != null) {
				btnOK.text = gpm.copy.getCopyString(GlobalConstants.TEXT_DIALOG_BUTTON_OK);
			} else {
				btnOK.text = " OK ";
			} // END if
			updateLayout();
		}
		/**
		 * 	Applies pre-defined style classes to the object.
		 *	@since	1.0
		 */
		protected function setStyle():void {
			if (gpm.css.getStyle(GlobalConstants.STYLE_DIALOG) != null) {
				applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_DIALOG));
			} // END if
			if (gpm.css.getStyle(GlobalConstants.STYLE_FORM_BUTTON) != null) {
				btnOK.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_FORM_BUTTON));
			} // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_BUTTON_TEXT) != null) {
				btnOK.textStyle = gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_BUTTON_TEXT);
			} // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_DIALOG_TITLEBAR_TEXT) != null) {
				titleBarTextStyle = gpm.css.getTextFormat(GlobalConstants.STYLE_DIALOG_TITLEBAR_TEXT);
			} // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_DIALOG_TEXT) != null) {
				textStyle = gpm.css.getTextFormat(GlobalConstants.STYLE_DIALOG_TEXT);
			} // END if
			if (gpm.css.getStyle(GlobalConstants.STYLE_DIALOG_CLOSE_BUTTON) != null) {
				btnClose.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_DIALOG_CLOSE_BUTTON));
			} // END if
			updateLayout();
		}
		/**
		 * 	Handles OK button click events
		 *  @param 	e	Event object.
		 *	@since	1.0
		 */
		protected function onBtnOKClick(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_ACCEPT));
			this.hide();
		}
		/**
		 * 	Handles close button click events
		 *  @param 	e	Event object.
		 *	@since	1.0
		 */
		protected function onCloseClick(e:MouseEvent):void {
			dispatchEvent(new DialogEvent(DialogEvent.DIALOG_CLOSE));
			this.hide();
		}
		/**
		 * 	Handles title bar mouse down events.
		 *  @param 	e	Event object.
		 *	@since	1.0
		 */
		protected function onTitleBarMouseDown(e:MouseEvent):void {
			this.startDrag(false, new Rectangle(0, 0, (gpm.visualConfig.width - this.width), 
			(gpm.visualConfig.height - this.height)));
		}
		/**
		 * 	Handles title bar mouse up events.
		 *  @param 	e	Event object.
		 *	@since	1.0
		 */
		protected function onTitleBarMouseUp(e:MouseEvent):void {
			this.stopDrag();
		}
		/**
		 * 	Redraws the layout of the dialog object.
		 *	@since	1.0
		 */
		protected function updateLayout():void {
			titleBar.height = titleBarTxt.textHeight + (_padding * 2);
			
			titleBarTxt.y = (titleBar.height / 2) - (titleBarTxt.textHeight / 2);
			
			btnClose.width = btnClose.height = (titleBar.height - 2);
			btnClose.x = width - (btnClose.width + 1);
			btnClose.y = 1;
			
			btnCloseCross.size = btnClose.width - _padding;
			btnCloseCross.x = (btnClose.x + (_padding / 2));
			btnCloseCross.y = (btnClose.y + (_padding / 2));
			
			if (txt != null && txt.visible) {
				txt.x = (_padding * 2);
				if (txt.textWidth > (width - (_padding * 4))) {
					txt.width = (width - (_padding * 4));
					txt.wordWrap = true;
				} // END if
				txt.y = (titleBar.x + titleBar.height) + (_padding * 4);
			}

			buttonBar.y = (txt.y + (txt.textHeight  + (_padding * 4)));
			btnOK.x = (buttonBar.width / 2) - (btnOK.width / 2);
			buttonBar.height = btnOK.height;
			
		}
		/**
		 * 	Redefines the objects height property based on it's conents.
		 *	@since	1.0
		 */
		protected function updateHeight():void {
			if (_sizeType != SIZE_FIXED) {
				_height = bkgd.height = bkgd_3d_left.height = bkgd_3d_right.height = ((buttonBar.y + buttonBar.height) + ((_padding * 2) + 4));
				bkgd_3d_bottom.y = height - borderWidth;
			}
			sendNotification(Application.MESSAGE_RENDERED, {name:this.name});
		}
	}
	
}