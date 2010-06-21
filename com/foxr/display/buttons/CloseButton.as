package com.foxr.display.buttons 
{
	
	//import external classes
	import com.foxr.display.graphics.Box;
	import com.foxr.display.graphics.PixelCross;
	import com.foxr.display.graphics.PixelPlusMinus;

	/**
	 * Draws a button that contains text and a close box with a cross.
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class CloseButton extends StandardButton {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * TYPE_CLOSE.
		 * @const TYPE_CLOSE:String
		 */
		public static const TYPE_CLOSE:String = "close";
		/**
		 * TYPE_COLLAPSE.
		 * @const TYPE_COLLAPSE:String
		 */
		public static const TYPE_COLLAPSE:String = "collapse";
		
		public static const STATE_OPEN:String = 'open';
		public static const STATE_CLOSE:String = 'closed';
		/**
		 * Cross Box.
		 * @var crossBox:Box
		 */
		private var _type:String = TYPE_CLOSE;
		/**
		 * Cross Box.
		 * @var crossBox:Box
		 */
		private var crossBox:Box = null;
		/**
		 * Cross.
		 * @var cross:PixelCross
		 */
		private var cross:PixelCross = null;
		/**
		 * Cross.
		 * @var cross:PixelCross
		 */
		private var plus:PixelPlusMinus = null;		
		
		private var _state:String = STATE_OPEN;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new CloseButton instance
		 *
		 */
		public function CloseButton() {
			bkgd.visible = false;
			txt.visible = true;
			txt.text = "Close";
			crossBox = Box(addElement('crossBox', Box,{y:0,width:12,borderWidth:1,borderColor:0x000000}));
			cross = PixelCross(addElement('cross', PixelCross,{color:0x000000,size:10}));
			plus = PixelPlusMinus(addElement('plus', PixelPlusMinus,{color:0x000000,size:10,visible:false}));
			render();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a background color to the cross element.
		 * @since	1.0
		 * @param	c	Color in Ox000000 format
		 */
		public override function set backgroundColor(c:Number):void { crossBox.color = c; }
		/**
		 * . 
		 * @since	1.0
		 * @param	c	Color in Ox000000 format
		 */
		public function set collapseState(s:String):void { 
			_state = s; 
			if (_state == STATE_OPEN) {
				plus.type = PixelPlusMinus.MINUS;
			} else {
				plus.type = PixelPlusMinus.PLUS;
			}
		}
		/**
		 * Changes the height of the object. 
		 * @since	1.0
		 * @param	c	Color in Ox000000 format
		 */
		public function set foregroundColor(c:Number):void {
			cross.color = plus.color = c;
		}
		/**
		 * Changes the height of the object. 
		 * @since	1.0
		 * @param	b	The height in pixels
		 */
		public override function set height(h:Number):void {
			super.height = h;
			crossBox.height = h;
			cross.size = h - 4;
			plus.size = h - 4;
			render();
		}
		/**
		 * Applies a font and copy string to the main text field of the object.
		 * @since	1.0
		 * @param	t	Font and Copy String ID
		 */
		public override function set string(s:String):void { super.string = s; render(); }
		/**
		 * Applies text content to the main text field of the object.
		 * @since	1.0
		 * @param	t	String containing the text copy
		 */
		public override function set text(t:String):void { super.text = t; render(); }
		
		public function set type(t:String):void { _type = t; render(); }
		/*-----------------------------------
		/	PRIVATE FUNCTIONS
		/----------------------------------*/
		/**
		 * Updates the layout of the object based on application of size and content values.
		 * @since 	1.0
		 */
		protected override function render():void {
			txt.x = 0;
			crossBox.x = txt.textWidth + (_padding * 2);
			cross.x = plus.x = crossBox.x + 2;
			cross.y = plus.y = crossBox.y + 2;
			cross.visible = (_type == TYPE_CLOSE)
			plus.visible = (_type == TYPE_COLLAPSE)
			txt.y = (crossBox.height / 2) - (txt.textHeight / 2);
			super.width = txt.textWidth + (crossBox.width + (_padding * 2));
		}
	}
}