package com.foxr.display.graphics
{
	
	import com.foxr.display.graphics.Box;
	
	/**
	 *	This class draws a Pause icon.
	 * 
	 * @author 	Jeff Fox
	 * 
	 */
	public class PixelPause extends Graphic {
		/*----------------------
		/	C'TOR
		/---------------------*/
		/**
		 *  Contructs a new instance of PixelPause.
		 */
		public function PixelPause() {
			super();
		}
		/*------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------*/
		/**
		 *	Draws the arrow in the set direction.
		 *  @since 1.0
		 *
		 */
		public override function draw():void {
			while (numChildren > 0) {
				removeChildAt(0);
			} // END while
			// do some math to get graphic dimenstions
			var dim:Number = int(width / 5);
			var leftPause:Box = Box(addElement('leftPause', Box, { x:dim, y:0, width:dim, height:height, color:_color } ));
			var rightPause:Box = Box(addElement('leftPause', Box, { x:(dim * 4), y:0, width:dim, height:height, color:_color } ));
		}
	}
}