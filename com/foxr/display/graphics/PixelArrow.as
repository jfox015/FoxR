package com.foxr.display.graphics
{
	//import external classes
	import com.foxr.display.graphics.Graphic;
	import flash.display.*;
	/**
	 * This class draws a series of pixels in the shape of an arrow.
	 *
	 * @usage
	 * <listing>
	 * import com.foxr.display.graphics.PixelArrow;
	 * 
	 * private var pArr:PixelArrow = null;
	 * 
	 * addElement('arrow',PixelArrow,{size:4,direction:DIRECTION_UP,color:0xAA2000});
	 * </listing>
	 * 
	 * @author 	Jeff Fox
	 *
	 */
	public class PixelArrow extends Graphic {
	
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		public static const DIRECTION_UP:String = 'up';
		public static const DIRECTION_DOWN:String = 'down';
		public static const DIRECTION_LEFT:String = 'left';
		public static const DIRECTION_RIGHT:String = 'right';
		/**
		 *	Arrow Direction.
		 *  @var	_dir
		 */
		private var _dir:String = DIRECTION_LEFT;
		/*----------------------
		/	C'TOR
		/---------------------*/
		/**
		 *  Contructs a new instance of PixelArrow.
		 */
		public function PixelArrow() { 
			// SET DEFAULT PARAMS
			_size = 4; _dir = DIRECTION_LEFT; _color = 0x000000; 
		}
		/*------------------------
		/	SET/GET FUNCTIONS
		/-----------------------*/
		/**
		 *	Sets the direction property opf the object.
		 *  @since 1.2
		 *  @param		d	Arrow Direction. Accepts up, down, right, left
		 *  @return		Arrow Direction.
		 *
		 */
		public function get direction():String { return(_dir); }
		public function set direction(d:String):void { _dir = d; draw(); }
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 *	Draws the arrow in the set direction.
		 *  @since 1.0
		 *
		 */
		public override function draw():void {;
			while (numChildren > 0) {
				removeChildAt(0);
			} // END while
			var x:Number = 0;
			var y:Number = 0;
			switch (_dir) {
				// DRAW DOWN
				case DIRECTION_DOWN:
					for (var i:Number=_size; i>0; i--) {
						for (var j:Number=0; j<i; j++) drawSquare((x+(j*2)), y,1);
						x++; y++;
					} // END for
					break;
				// DRAW UP
				case DIRECTION_UP:
					y = 4;
					for (var k:Number=_size; k>0; k--) {
						for (var l:Number=0; l<k; l++) drawSquare((x+(l*2)), y,1);
						x++; y--;
					} // END for
					break;
				// DRAW LEFT
				case DIRECTION_LEFT:
					x = 4;
					for (var m:Number=_size; m>0; m--) {
						for (var n:Number=0; n<m; n++) drawSquare(x, y+(n*2),1);
						x--; y++;
					} // END for
					break;
				// DRAW RIGHT
				case DIRECTION_RIGHT:
					for (var o:Number=_size; o>0; o--) {
						for (var p:Number=0; p<o; p++) drawSquare(x, y+(p*2),1);
						x++; y++;
					} // END for
					break;
				default: 
					trace("Invalid direction parameter set. Class: PixelArrow.");
					break;
			} // END switch
		} // END function
	} // END class
} // END package