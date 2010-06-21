package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.Component;
	import flash.events.Event;
	/**
	 * Draws a standard SelectableComponent button.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class SelectableComponent extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		protected var _checkedAlpha:Number = 1.0;
		
		protected var _checkedColor:Number = 0x000000;
		
		protected var _checked:Boolean = false;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new SelectableComponent instance
		 *
		 */
		public function SelectableComponent() {
			super();	
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/		
		/**
		 * The alpha of the dot that shows when the control is clicked.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get checkedAlpha():Number{ return _checkedAlpha; }
		public function set checkedAlpha(a:Number):void { _checkedAlpha = a; }
		/**
		 * The color of the dot that shows when the control is clicked.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get checkedColor():Number{ return _checkedColor; }
		public function set checkedColor(c:Number):void { _checkedColor = c; }
		/**
		 * Applies a text value to the object. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set string(t:String):void { 
			super.string = t;
			update();
		}
		/**
		 * Applies a text value to the object. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set text(t:String):void { 
			super.text = t;
			update()
		}		
		// Setters that serve no purpose in these objects
		public override function set height(h:Number):void { _height = h; }
		
		public override function set width(w:Number):void { _width = w; }
		
		public override function set textAlign(a:String):void { _alignment = a; }
		
		public override function set verticalAlign(a:String):void { _verticalAlignment = a; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Applies a checked setting to the object.
		 *	@since	1.0
		 * 	@param	c	TRUE or FALSE 
		 */
		public function checked(c:Boolean):void { 
			_checked = c; 
			drawChecked(c);
		}
		/**
		 * 	Returns the current checked state of the object.
		 *	@since		1.0
		 * 	@return		TRUE or FALSE 
		 */
		public function isChecked():Boolean { return _checked; }
		/**
		 * 	Applies a selected setting to the object.
		 *	@since	1.0
		 * 	@param	s	TRUE or FALSE 
		 */
		public function selected(s:Boolean):void {
			checked(s);
			enabled = !s;
		}
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Show or hide the "checked" state graphic here.
		 *	@since	1.0
		 * 	@param	b	TRUE or FALSE 
		 */
		protected function drawChecked(b:Boolean):void { }
		/**
		 * 	override this method to set the text position after a size has been set 
		 *  for the button component.
		 *	@since	1.0
		 */
		protected function update():void { }
	} // END class
} // END package