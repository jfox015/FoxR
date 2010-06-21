package com.foxr.display.graphics 
{
	//import external classes
	import flash.display.Sprite;
	import com.foxr.display.*;
	import com.foxr.util.Utils;
	/**
	 * The Border Element is a simple class for drawing squares and rectangles with 
	 * only a frame and no background area. Use this class instead of Box to draw 
	 * borders when a transparent inner area is required. 
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author		Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Border extends Graphic {
		/**
		 * Box Sprite
		 * @var box:Sprite
		 */
		private var border:Sprite = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Box instance
		 *
		 */
		public function Border() {
			border = new Sprite();
			addChild(border);
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Draws the box object.
		 * @since	1.0
		 */
		public override function draw():void {
			border.graphics.clear();
			// If a border width has been passed, drawn a line style
			if (_bdrWidth != 0) {
				border.graphics.lineStyle(_bdrWidth, _bdrColor, _bdrAlpha); 
				// DRAW BORDER
				border.graphics.moveTo(0, 0);
				border.graphics.moveTo(width, 0);
				border.graphics.moveTo(width, height);
				border.graphics.moveTo(0, height);
				border.graphics.moveTo(0, 0);
			}// END if
		} // END function
	} // END class
} // END package