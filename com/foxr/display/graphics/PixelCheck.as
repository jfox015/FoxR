package com.foxr.display.graphics
{
	//import external classes
	import com.foxr.display.graphics.Graphic;
	
	/**
	 *	This class draws a checkmark.
	 * 
	 * @author 	Jeff Fox
	 * 
	 */
	public class PixelCheck extends Graphic {
		
		/*------------------------
		/	VARIABLES
		/-----------------------*/
		/*----------------------
		/	C'TOR
		/---------------------*/
		/**
		 *  Contructs a new instance of PixelCheck.
		 */
		public function PixelCheck() { }
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 *	Draws the arrow in the set direction.
		 *  @since 1.0
		 *
		 */
		public override function draw():void {
			
			this.graphics.clear();
			//var halfSize:Number = (_size / 2)
			var yVal:Number = 3;
			for (var xVal:Number = 0; xVal < 10; xVal++) {
				var sqrDrawn:Number = 0;
				var thisY:Number = yVal;
				while (sqrDrawn < 4) {
					drawSquare(xVal, thisY, 1);
					thisY++;
					sqrDrawn++;
				}
				if (xVal < 4 && yVal < 7) {
					yVal++;
				} else {
					yVal--;
				}
			}
		}
	}
}