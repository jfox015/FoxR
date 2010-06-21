package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.*;
	import com.foxr.display.graphics.Box;
	import com.foxr.display.graphics.PixelCheck;
	
	import flash.events.*;
	import flash.net.URLVariables;
	/**
	 * Draws a standard Checkbox button.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class Checkbox extends SelectableComponent {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var button:Box = null;
		
		private var check:PixelCheck = null;		
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Checkbox instance
		 *
		 */
		public function Checkbox() {
			super();	
			button = Box(addElement('button', Box, { x:0, y:0 }));
			check = PixelCheck(addElement('check', PixelCheck, { size:10, visible:false } ));
			size = 16;
			button.color = 0xFFFFFF;
			button.borderWidth = 1;
			button.borderColor = 0x000000;
			check.color = _checkedColor;
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/	
		public override function get className():Class { return Checkbox; }
		/**
		 *	Applies or removes a drop shadow to the current Checkbox object.
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
				check.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				txt.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				button.alpha = check.alpha = txt.alpha = 1.0;
			} else {
				button.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				check.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				txt.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				button.alpha = check.alpha = txt.alpha = 0.6;
			}
		}
		/**
		 * Sets the size of the checkbox button. 
		 * @since	1.0
		 * @param	s	The objects size in pixels
		 * @return		The objects size in pixels
		 */
		public function set size(s:Number):void { 
			button.size = s;
			// standard x, y position of checkbox and check mark
			check.x = button.x + (((button.size / 2) + (button.borderWidth * 2)) - (check.size / 2));
			check.y = button.y + (((button.size / 2) + (button.borderWidth * 2)) - (check.size / 2)) - 1;
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
			_width = button.size + _padding + txt.width;
			_height = txt.height > button.size ? txt.height : button.size;
			bkgd.visible = false;
			txt.visible = true;
			check.visible = _checked;
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
		protected override function drawChecked(b:Boolean):void { check.visible = b; }
		/**
		 * 	Sets the text position after a size has been set for the button component.
		 *	@since	1.0
		 */
		protected override function update():void {
			txt.x = button.size + (_padding * 2);
			if (txt.textHeight > button.height) {
				txt.y = 0;
				button.y = (txt.textHeight / 2) - (button.height / 2);
			} else {
				button.y = 0;
				txt.y = (button.height / 2) - (txt.textHeight / 2);
			} // END if
		}
		/**
		 * 	Handles a mouse down event for the object.
		 *	@since	1.0
		 */
		private function mouseDown(e:Event):void { 
			check.alpha = _checkedAlpha;
			check.color = _checkedColor;
			this.checked(!_checked); 
			// Automatically report this objects variable values to the parent form if it exists
			if (parentObj.toString().toLowerCase().indexOf('form') != -1) {
				parentObj = Form (parentObj);
				var vars:URLVariables = null;
				if (isChecked()) {
					vars = new URLVariables(this.variable + '=' + this.value);
				} else {
					vars = new URLVariables(this.variable + '=');
				} // END if
				parentObj.variable = vars.toString();
			} // END if
		}
	} // END class
} // END package