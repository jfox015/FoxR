package com.foxr.display.graphics 
{
	//import external classes
	import com.foxr.display.content.Image;
	import com.foxr.display.*;
	import com.foxr.util.Utils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * The Box Element is a simple class for drawing squares and rectangles. 
	 * 
	 * 
	 * @author		Jeff Fox
	 * @version		1.0.10
	 * @see			com.fox.display.graphics.Graphic Graphic
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Box extends Graphic {
		/**
		 * Normal Corner Const
		 * @const	CORNER_NORMAL:String
		 */
		public static const CORNER_NORMAL:String = 'normal';
		/**
		 * Rounded Corner Const
		 * @const	CORNER_ROUNDED:String
		 */
		public static const CORNER_ROUNDED:String = 'rounded';
		/**
		 * Box Sprite
		 * @var box:Sprite
		 */
		private var box:Sprite = null;
		/**
		 * Background Image
		 * @var bgImage:Element*
		 */
		private var bgImage:Image = null;
		/**
		 * Corner Type
		 * @var _cornerType:String
		 */
		private var _cornerType:String = CORNER_NORMAL;
		/**
		 * Elipse Width
		 * @var _elipseWidth:Number
		 */
		private var _elipseWidth:Number = 5;
		/**
		 * Elipse Height
		 * @var _elipseHeight:Number
		 */
		private var _elipseHeight:Number = -1;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Box instance
		 *
		 */
		public function Box() {
			box = new Sprite();
			addChild(box);
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a backgroud image to the box. The image size should match the dimensions of the
		 * instantiated object otherwise the boxes background shape will show past the images boundaries.
		 * @since	1.0
		 * @param	path	The image path
		 */
		public function set backgroundImage(path:String):void {
			bgImage = addElement('bgImage',Image,{x:0,y:0}) as Image;
			bgImage.src = path;
		}
		/**
		 * Applies a new serting for the boxes corner type.
		 * @since	1.0
		 * @param	t	Corner type - normal or rounded
		 */
		public function get cornerType():String { return _cornerType; }
		public function set cornerType(t:String):void { _cornerType = t; }
		/**
		 * Applies an elipse width setting for use with rounded corners. Used in cojunction with 
		 * cornerType set to rounded.
		 * @since	1.0
		 * @param	e	Elipse width in pixels
		 */
		public function get elipseWidth():Number { return _elipseWidth; }
		public function set elipseWidth(e:Number):void { _elipseWidth = e; }
		/**
		 * Applies an elipse height setting for use with rounded corners. If no value is specified, the 
		 * value to elipseWidth is used instead.
		 * @since	1.0
		 * @param	e	Elipse height in pixels
		 */
		public function get elipseHeight():Number { return _elipseHeight; }
		public function set elipseHeight(e:Number):void { _elipseHeight = e; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Draws the box object.
		 * @since	1.0
		 */
		public override function draw():void {
			box.graphics.clear();
			// If a border width has been passed, drawn a line style
			if (_bdrWidth != 0) box.graphics.lineStyle(_bdrWidth, _bdrColor, _bdrAlpha); // END if
			// SET FILL TYPE
			if (_gradientStyle != null) {
				// If no matrix has been created and we have a width and height value, create a matrix for the 
				// gradient object
				if (_gradientStyle.matrix == undefined && (width != 0 && height != 0)) {
					var matr:Matrix = new Matrix();
  					matr.createGradientBox(width, height, _gradientStyle.rotation,0,0);
  					_gradientStyle.matrix = matr;
				} // END if
				box.graphics.beginGradientFill(_gradientStyle.type,_gradientStyle.colors,_gradientStyle.alphas,
				_gradientStyle.ratios,_gradientStyle.matrix,_gradientStyle.spreadMethod,_gradientStyle.interpolationMethod,
				_gradientStyle.focalPointRatio);
			} else {
				box.graphics.beginFill(_color,_alpha);
			} // END if 
			// SET CORNER TYPE
			if (_cornerType == CORNER_NORMAL) 
				box.graphics.drawRect(0, 0, _width, _height);
			else {
				if (_elipseHeight != -1) _elipseHeight = _elipseWidth;
					box.graphics.drawRoundRect(0,0,width,height,_elipseWidth,_elipseHeight);
			} // END if
			box.graphics.endFill();
		} // END function
	} // END class
} // END package