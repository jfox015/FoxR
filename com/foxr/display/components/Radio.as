package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.*;
	import flash.events.*;
	import com.foxr.display.graphics.Circle;
	import com.foxr.display.components.RadioGroup;
	
	/**
	 * A base class for selectable (groupable) components like radio buttons.
	 * 
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Radio extends SelectableComponent {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var button:Circle = null;
		
		private var circle:Circle = null;
		
		private var _group:RadioGroup = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Radio instance
		 *
		 */
		public function Radio() {
			super();	
			button = Circle(addElement('button',Circle,{x:0, y:0}));
			circle = Circle(addElement('circle',Circle,{x:0, y:0,visible:false}));
			size = 6;
			button.color = 0xFFFFFF;
			button.borderWidth = 1;
			button.borderColor = 0x000000;
			circle.color = _checkedColor;
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alpha of the radio objects background. 
		 * @since	1.17
		 * @param	a	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The backgrounds alpha value
		 */
		public override function set backgroundAlpha(a:Number):void { button.alpha = a; }
		/**
		 * Changes the color of the radio objects background. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set backgroundColor(c:Number):void { button.color = c; }
		/**
		 * Changes the alpha (transparency) of the radio objects border. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The borders alpha value
		 */
		public override function set borderAlpha(a:Number):void { button.borderAlpha = a; }
		/**
		 * If borderWeight is set, this changes the color of the radio objects border. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set borderColor(c:Number):void { button.borderColor = c; }
		/**
		 * Changes the width (size) of the radio objects border. 
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public override function set borderWidth(w:Number):void { button.borderWidth = w; }		
		/**
		 *	Applies or removes a drop shadow to the current radio object.
		 *  @param	ds	Pass visible to show the drop shadow, or hidden to hide it
		 *  @since 	1.0
		 *  
		 */
		public override function get dropShadow():String { return button.dropShadow; }
		public override function set dropShadow(ds:String):void { button.dropShadow = ds; }
		/**
		 *  Sets the _enabled flag. Child object should override this method to custom eneable or
		 *  disable themselves.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void { 
			super.enabled = e;
			txt.buttonMode = txt.useHandCursor = button.buttonMode = button.useHandCursor = e;
			txt.mouseChildren = button.mouseChildren = !e;
			if (e) {
				button.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				circle.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				txt.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				button.alpha = circle.alpha = txt.alpha = 1.0;
			} else {
				button.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				circle.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				txt.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				button.alpha = circle.alpha = txt.alpha = 0.6;
			} // END if
		}
		/**
		 * Sets the size of the checkbox button. 
		 * @since	1.0
		 * @param	s	The objects size in pixels
		 * @return		The objects size in pixels
		 */
		public function set size(s:Number):void { 
			button.size = s;
			circle.size = (button.size - (((button.borderWidth * 2) + 2) +1));
			// standard x, y position of checked circle for odd sizes
			circle.x = button.x + (((button.size / 2) + (button.borderWidth * 2)) - (circle.size / 2)) - 1;
			circle.y = button.y + (((button.size / 2) + (button.borderWidth * 2)) - (circle.size / 2)) - 1;
			// Add half pixel alignment for even sizes
			if ((s % 2) != 0) { circle.x += .5; circle.y == .5; }
			update();
		}		
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			_width = circle.size + _padding + txt.width;
			_height = txt.height > circle.size ? txt.height : circle.size;
			txt.visible = true;
			circle.visible = _checked;
			button.visible = true;
			enabled = true;
			update();
		} // END function
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Show or hide the "checked" state graphic here.
		 *	@since	1.0
		 * 	@param	b	TRUE or FALSE 
		 */
		protected override function drawChecked(b:Boolean):void { 
			circle.alpha = _checkedAlpha;
			circle.color = _checkedColor;
			circle.visible = b; 
		}
		/**
		 * 	Handles a mouse down event for the object.
		 *	@since	1.0
		 */
		private function mouseDown(e:Event):void {
			if (parentObj.parent.toString().toLowerCase().indexOf('radiogroup') != -1)
				parentObj.parent.selectedIndex = Number(this.name.substring(6)); // END if
		}
		/**
		 * 	Sets the text position after a size has been set for the button component.
		 *	@since	1.0
		 */
		protected override function update():void {
			txt.x = button.size + _padding;
			txt.y = txt.y - txt.height / 2;
		}
		
	} // END class
} // END package