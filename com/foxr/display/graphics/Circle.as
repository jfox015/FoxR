package com.foxr.display.graphics 
{
	//import external classes
	import flash.display.Sprite;
	import com.foxr.display.*;
	
	/**
	 * The Circle Element is a class to be used for drawing circles. 
	 * 
	 * @author	Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Circle extends Graphic {
		/**
		 * @var circle	Sprite
		 */
		private var circle:Sprite = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Circle instance
		 *
		 */
		public function Circle() {
			circle = new Sprite();
			addChild(circle);
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Set the overall size (circumfrance) of the circle object.
		 * @param	s	Size in pixels.
		 * @since	1.0
		 */
		public override function set size(s:Number):void {
			_size = s;
			this.width = this.height = (_size * 2);
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Draws the circle object.
		 * @since	1.0
		 */
		public override function draw():void {
			circle.graphics.clear();
			if (_bdrWidth != 0) circle.graphics.lineStyle(_bdrWidth, _bdrColor, _bdrAlpha);
			// SET FILL TYPE
			if (_gradientStyle != null)
				circle.graphics.beginGradientFill(_gradientStyle.type,_gradientStyle.colors,_gradientStyle.alphas,
				_gradientStyle.ratios,_gradientStyle.matrix,_gradientStyle.spreadMethod,_gradientStyle.interpolationMethod,
				_gradientStyle.focalPointRatio);
			else
				circle.graphics.beginFill(_color,_alpha);  
			circle.graphics.drawCircle(2, 2, _size);
			circle.graphics.endFill();
		} // END function
	} // END class
} // END package