package com.foxr.display.graphics
{
	import flash.display.Sprite;
	
	/**
	 *	This class draws a cross mark "X".
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author 	Jeff Fox
	 * 
	 */
	public class PixelCross extends Graphic {
				
		public function PixelCross() {
			draw();
		}
		
		public override function draw():void {
			while (numChildren > 0) {
				removeChildAt(0);
			} // END while
			var x:Number = 0;
			var y:Number = 0;
			for (var i:Number=0; i<_size; i++) {
				drawSquare(i, i, 1);
				drawSquare(((_size-1)-i), i,1);
			} // END for
		}
	}
}