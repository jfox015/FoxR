package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.graphics.Box;
	
	import flash.events.*;
	/**
	 * Abstract base class for all Component objects. IN addition to provide UI 
	 * properties, this class allows all FoxR components to be easily embedded 
	 * into the Form component for streamlined data capture and submissions.
	 * <p />
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class Component extends CompoundElement {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var SIZE_FIXED:String = 'fixed';
		public static var SIZE_TO_CONTENT:String = 'sizeToContent';
		public static var SIZE_TO_CONTAINER:String = 'sizeToContainer';
		/**
		 * 3-D background highlights
		 * @var	bkgd:Box
		 */
		protected var bkgd_3d_left:Box = null;
		protected var bkgd_3d_top:Box = null;
		protected var bkgd_3d_right:Box = null;
		protected var bkgd_3d_bottom:Box = null;
		
		/**
		 * Display Name.
		 * @var	_displayName:String
		 */
		protected var _displayName:String = '';
		/**
		 * 3D Highlight Color
		 * @var	_highlightColor:Number
		 */
		protected var _highlightColor:Number = 0xEFEFEF;
		/**
		 * Validation Pattern
		 * @var	_pattern:String
		 */
		protected var _pattern:String = '';
		/**
		 * Required Flag
		 * @var	_required:Boolean
		 */
		protected var _required:Boolean = false;
		/**
		 * 3D Shadow Color
		 * @var	_shadowColor:Number
		 */
		protected var _shadowColor:Number = 0x000000;
		/**
		 * Size Type
		 * @var	_value:Object
		 */
		protected var _sizeType:String = SIZE_TO_CONTENT;
		/**
		 *Form element variable name
		 * @var	_variable:String
		 */
		protected var _variable:String = '';
		/**
		 * Form element variable value
		 * @var _value:*
		 */
		protected var _value:* = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Component instance
		 *
		 */
		public function Component() { 
			super(); 
			bkgd_3d_left = Box(addElement('bkgd_3d_left', Box, { width:1, visible:false } ));
			bkgd_3d_right = Box(addElement('bkgd_3d_right', Box, { width:1,visible:false } ));
			bkgd_3d_top = Box(addElement('bkgd_3d_top', Box, { height:1,visible:false } ));
			bkgd_3d_bottom = Box(addElement('bkgd_3d_bottom', Box, { height:1,visible:false } ));
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public function get className():Class { return Component; }
		/**
		 * The name to display during form validation.
		 * @param	n	Display name
		 * @return		Display name
		 * @since	1.0
		 * 
		 */
		public function get displayName():String { return _displayName; }
		public function set displayName(n:String):void { _displayName = n; }
		/**
		 * Overrides the default set height property. This method only updates the buttons size if the  
		 * <i>sizeType</i> property is set to BaseComponent.SIZE_FIXED.
		 * Otherwise, it is ignored.
		 * @param	h	The component height in pixels
		 * @since	1.0
		 * 
		 */
		public override function set height(h:Number):void {
			super.height = h;
			bkgd_3d_bottom.y = (h - 1);
			bkgd_3d_right.height = bkgd_3d_left.height = h;
		}
		/**
		 * Applies or returns a value to the 3D highlight color property.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get highlightColor():Number { return _highlightColor; }
		public function set highlightColor(c:Number):void { 
			_highlightColor = c;
			bkgd_3d_left.color = bkgd_3d_top.color = c;
			bkgd_3d_left.visible = bkgd_3d_top.visible = true;
		}
		/**
		 *  Sets or returns the validation apattern that should be applied to the 
		 *  current component at validation time by the Form object.
		 *  @param		p	Form validation pattern arg
		 *  @return			Form validation pattern arg
		 *  @since 1.0
		 */
		public function get pattern():String { return _pattern; }
		public function set pattern(p:String):void { _pattern = p; }
		/**
		 *  Sets or returns whether the object requires a value at submit time when 
		 *  added as a form element.
		 *  @param		r	TRUE or FALSE
		 *  @return			TRUE or FALSE
		 *  @since 1.0
		 */
		public function get required():Boolean { return _required; }
		public function set required(r:Boolean):void { _required = r; }
		/**
		 * Applies or returns a value to the 3D shadow color property.
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 * @since	1.0
		 */
		public function get shadowColor():Number { return _shadowColor; }
		public function set shadowColor(c:Number):void { 
			_shadowColor = c;
			bkgd_3d_right.color = bkgd_3d_bottom.color = c;
			bkgd_3d_right.visible = bkgd_3d_bottom.visible = true; 
		}
		/**
		 *  Assigns the value of the passed argument to the internal variable
		 *  property and also passes this value up to the parent form object.
		 *  @param	String	s	Variable value
		 *  @return	String	Variable value
		 *  @since 1.0
		 */
		public function get sizeType():String { return _sizeType; }
		public function set sizeType(t:String):void { _sizeType = t; }
		/**
		 * Sets and retrives the variable identifier for the Component. The name
		 * is passed as the identifier to the parent form once editing is complete if the 
		 * field is added as a form child.
		 * @since	1.0
		 * @param	v	The variable name
		 * @return		The variable name
		 *
		 */
		public function get variable():String { return _variable; }
		public function set variable(v:String):void { _variable = v; }
		/**
		 *  This property stores the value that gets submitted to the server
		 *  when the control is included in a form object.
		 *  @param	Object	v	A value object
		 *  @return	Object	A value object
		 *  @access public
		 *  @since 1.0
		 */
		public function get value():* { return _value }
		public function set value(v:*):void { _value = v; }
		/**
		 * Overrides the default set width property. This method only updates the buttons size if the  
		 * <i>sizeType</i> property is set to BaseComponent.SIZE_FIXED.
		 * Otherwise, it is ignored.
		 * @param	w	The component width in pixels
		 * @since	1.0
		 * 
		 */
		public override function set width(w:Number):void {	
			super.width = w;
			bkgd_3d_right.x = (w - 1);
			bkgd_3d_top.width = bkgd_3d_bottom.width = w;
		}
	} // END class
} // END package