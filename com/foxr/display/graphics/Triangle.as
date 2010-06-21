package com.foxr.display.graphics 
{
	//import external classes
	import flash.display.Sprite;
	import com.foxr.display.*;
	
	/**
	 * The Triangle Element is a simple class for drawing Trianglees. 
	 * 
	 * @author	Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Triangle extends Graphic {
		
		public static const DIRECTION_UP:String = 'up';
		public static const DIRECTION_DOWN:String = 'down';
		public static const DIRECTION_LEFT:String = 'left';
		public static const DIRECTION_RIGHT:String = 'right';
		/**
		 * Triangle SHAPE
		 * @var Triangle	Shape
		 *
		 */
		private var triangle:Sprite = null;
		/**
		 * Direction
		 * @var _dir:String
		 *
		 */
		private var _dir:String = DIRECTION_UP;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * 
		 * Construct a new Triangle instance
		 *
		 */
		public function Triangle() {
			triangle = new Sprite();
			addChild(triangle);
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *	
		 *  Sets the direction property opf the object.
		 *  @since 1.2
		 *  @param		d	Arrow Direction. Accepts up, down, right, left
		 *  @return		Arrow Direction.
		 *
		 */
		public function get direction():String{ return(_dir); }
		public function set direction(d:String):void { _dir = d; draw(); }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 
		 * Draws the trianle object.
		 * @since	1.0
		 */
		public override function draw():void {
			triangle.graphics.clear();
			if (_bdrWidth != 0) triangle.graphics.lineStyle(_bdrWidth, _bdrColor, _bdrAlpha); // END if
			// SET FILL TYPE
			if (_gradientStyle != null)
				triangle.graphics.beginGradientFill(_gradientStyle.type,_gradientStyle.colors,_gradientStyle.alphas,
				_gradientStyle.ratios,_gradientStyle.matrix,_gradientStyle.spreadMethod,_gradientStyle.interpolationMethod,
				_gradientStyle.focalPointRatio);
			else
				triangle.graphics.beginFill(_color, _alpha); // END if
			switch(_dir){
				case DIRECTION_UP:
					triangle.graphics.moveTo(_width / 2, 0);
					triangle.graphics.lineTo(_width, _width);
					triangle.graphics.lineTo(0, _width);
					triangle.graphics.lineTo(_width / 2, 0);
					break;
				case DIRECTION_DOWN:
					triangle.graphics.moveTo(0, 0);
					triangle.graphics.lineTo(_width, 0);
					triangle.graphics.lineTo(_width / 2, _width);
					triangle.graphics.lineTo(0, 0);
					break;
				case DIRECTION_RIGHT:
					triangle.graphics.moveTo(0, 0);
					triangle.graphics.lineTo(_width, _width / 2);
					triangle.graphics.lineTo(0, _width);
					triangle.graphics.lineTo(0, 0);
					break;
				case DIRECTION_LEFT:
					triangle.graphics.moveTo(0, _width / 2);
					triangle.graphics.lineTo(_width, _width);
					triangle.graphics.lineTo(_width, 0);
					triangle.graphics.lineTo(0, _width / 2);
					break;
				default:
					//trace("Invalid directon parameter set. Class: Triangle.");
					break;
				triangle.graphics.endFill();
			} // END switch
			if (_scaleX != -1) triangle.scaleX = _scaleX;
			if (_scaleY != -1) triangle.scaleY = _scaleY;
		} // END function
	} // END class
} // END package