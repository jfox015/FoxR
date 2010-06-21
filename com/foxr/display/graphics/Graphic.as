package com.foxr.display.graphics 
{
	//import external classes
	import flash.display.Sprite;
	import com.foxr.display.*;
	import com.foxr.util.Utils;
	import flash.geom.Matrix;
	
	/**
	 * Abstract parent calss for all simple vector drawing objects available in 
	 * the FoxR framework.
	 * <p />
	 * This class provides the base methods and properties shared by all FoxR 
	 * gtaphic sub classes. 
	 * 
	 * @author	Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class Graphic extends Element {
		/**
		 * ALPHA
		 * @var _alpha	Number*
		 */
		protected var _alpha:Number = 1.0;
		/**
		 * COLOR
		 * @var _color	Number
		 */
		protected var _color:Number = -1;
		/**
		 * BORDER WEIGHT
		 * @var _bdrWeight	Number
		 */
		protected var _bdrWidth:Number = 0;
		/**
		 * BORDER ALPHA
		 * @var _bdrAlpha	Number
		 */
		protected var _bdrAlpha:Number = 1.0;
		/**
		 * BORDER COLOR
		 * @var _bdrColor:Number
		 */
		protected var _bdrColor:Number = 0x000000;
		/**
		 * GRADIENT STYLE OBJECT.
		 * @var _gradientStyle:Object
		 */
		protected var _gradientStyle:Object = null;
		/**
		 * SIZE
		 * @var _size:Number
		 */
		protected var _size:Number = 0;
		/**
		 * SCALE X 
		 * @var _scaleX:Number
		 */
		protected var _scaleX:Number = -1;
		/**
		 * SCALE Y
		 * @var _scaleY:Number
		 */
		protected var _scaleY:Number = -1;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new Graphic instance
		 *
		 */
		public function Graphic() {	} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alpha (transparency) of the object. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The current alpha value
		 */
		public override function get alpha():Number { return _alpha; }
		public override function set alpha(a:Number):void { _alpha = a; draw(); }
		/**
		 * Changes the width of the object. 
		 * @since	1.0
		 * @param	b	The width in pixels
		 */
		public override function set width(w:Number):void { super.width = w; draw(); }
		/**
		 * Changes the height of the object. 
		 * @since	1.0
		 * @param	b	The height in pixels
		 */
		public override function set height(h:Number):void { super.height = h; draw(); }
		/**
		 * Changes the alpha (transparency) of the objects border. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The current border alpha value
		 */
		public function get borderAlpha():Number { return _bdrAlpha; }
		public function set borderAlpha(a:Number):void { _bdrAlpha = a; draw(); }
		/**
		 * If borderWeight is set, this changes the color of the objects border. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get borderColor():Number { return _bdrColor; }
		public function set borderColor(b:Number):void { _bdrColor = b; draw(); }
		/**
		 * Changes the width (size) of the objects border. 
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public function get borderWidth():Number { return _bdrWidth; }
		public function set borderWidth(b:Number):void { _bdrWidth = b; draw(); }
		/**
		 * Changes the main foregorund color of the object. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function get color():Number { return _color; }
		public function set color(c:Number):void { _color = c; draw(); }
		/**
		 * Shortcut method for setting the objects size for a proportional shape. 
		 * @since	1.0
		 * @param	s	The objects size n pixels
		 * @return		The objects size in pixels
		 */
		public function set gradientStyle(s:Object):void { 
			if (s.type != null && (s.colors != null && s.colors.length > 0) && s.alphas != null && s.ratios != null)  {
				if (s.rotation != null && (width != 0 && height != 0)) {
					var matr:Matrix = new Matrix();
  					matr.createGradientBox(width, height, s.rotation,0,0);
  					s.matrix = matr;
					//trace("Matrix = " + matr);
  				} // End if
				_gradientStyle = s;  
				draw();
			} // END if
		} 
		/**
		 * Shortcut method for setting the objects size for a proportional shape. 
		 * @since	1.0
		 * @param	s	The objects size n pixels
		 * @return		The objects size in pixels
		 */
		public function get size():Number  { return _size; }
		public function set size(s:Number):void { _size = _height = _width = s; draw(); }
		/**
		 * Sets the grtaphics xScale property 
		 * @since	1.0
		 * @param	s	The scale %
		 * @return		The scale %
		 */
		public override function get scaleX():Number  { return _scaleX; }
		public override function set scaleX(s:Number):void { _scaleX = s; draw(); }
		/**
		 * Sets the grtaphics yScale property 
		 * @since	1.0
		 * @param	s	The scale %
		 * @return		The scale %
		 */
		public override function get scaleY():Number  { return _scaleY; }
		public override function set scaleY(s:Number):void { _scaleY = s; draw(); }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Draws the object. This method is empty in the static graphic object and
		 * overridden by all children.
		 * @since	1.0
		 */
		public function draw():void { } // END function
		/*------------------------
		/	PROTECTED FUNCTIONS
		/-----------------------*/
		/**
		 *	Draws a square object.
		 *  @since 1.0
		 *  @param	x	X position
		 *  @param	y	Y Positon
		 *  @param	s	Size in pixels
		 *
		 */
		protected function drawSquare(x:Number, y:Number, s:Number):void {
			var square:Sprite = new Sprite();
			square.graphics.beginFill(_color);
			square.graphics.drawRect(x,y,s,s);
			square.graphics.endFill();
			addChild(square);
		} // END function
		
	} // END class
} // END package