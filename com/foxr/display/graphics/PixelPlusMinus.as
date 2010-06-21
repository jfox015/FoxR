package com.foxr.display.graphics
{
	/**
	 *	This class draws both pixel pluses ( + ) and minuses ( - ).
	 * 
	 * @author 	Jeff Fox
	 * 
	 */
	public class PixelPlusMinus extends Graphic {
		
		public static const	PLUS:Number = 0;
		public static const	MINUS:Number = 1;
		
		private var _type:Number = PLUS;
		/*----------------------
		/	C'TOR
		/---------------------*/
		/**
		 *  Contructs a new instance of PixelPlusMinus.
		 */
		public function PixelPlusMinus() {
			super();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *	Defione the type of symbol to be drawn. Option are:
		 *  <ul>
		 * 		<li>PLUS</li>
		 * 		<li>MINUS</li>
		 *  </ul>
		 *  @since 1.0
		 *  @see	#PLUS PLUS
		 *  @see	#MINUS MINUS
		 *
		 */
		public function get type():Number { return _type; }
		public function set type(t:Number):void { _type = t; draw(); }
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
			var x:Number = 0;
			var y:Number = 0;
			var middle:Number = (_size / 2) - .5;

			switch (_type) {
				case MINUS:
					for (var i:Number=0; i<_size; i++) {
						drawSquare(i, middle, 1);
					} // END for
					break;
				case PLUS:
				default:
					for (var j:Number=0; j<_size; j++) {
						drawSquare(j, middle, 1);
						drawSquare(middle, j, 1);
					} // END for
					break;
			}
		}
	}
}