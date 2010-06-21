package com.foxr.display.content
{
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.content.Image;
	import com.foxr.display.graphics.Box;
	import flash.events.*;
	import caurina.transitions.*;
	
	/**
	 * An extension of the base Image object that 
	 * adds properties and methods to animate the Image.
	 * 
	 * @author	Jeff Fox
	 * @version	1.2
	 * @see 	com.foxr.display.content.Image Image
	 *
	 */
	public class MaskableImage extends Image {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const DIR_RIGHT_TO_LEFT:String = 'righttoleft';
		public static const DIR_LEFT_TO_RIGHT:String = 'lefttoright';
		public static const DIR_TOP_TO_BOTTOM:String = 'toptobottom';
		public static const DIR_BOTTOM_TO_TOP:String = 'bottomtotop';
		
		private var _direction:String = DIR_LEFT_TO_RIGHT;
		
		private var _speed:Number = 2;
		
		private var _easing:String = 'easeout';
		
		private var _animating:Boolean = false;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * C'TOR
		 * Construct a new MaskableImage instance
		 *
		 */
		public function MaskableImage() {
			super();	
		} // END function
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Moves the embedded mask of the image in the desired direction.
		 * @param	dir	Direction to move the image.
		 * @since		1.0
		 *
		 */
		public function moveMask(dir:String = ''):void {
			if (dir == '' && _direction != '') dir = _direction;
			if (this.mask != null) {
				switch(dir) {
					case DIR_RIGHT_TO_LEFT:
						this.mask.x = _width;
						animateMask(0,0,_width,_height);
						break;
					case DIR_TOP_TO_BOTTOM:
						this.mask.y = 0;
						animateMask(0,_height,_width,_height);
						break;
					case DIR_BOTTOM_TO_TOP:
						this.mask.y = _height;
						animateMask(0,0,_width,_height);
						break;
					case DIR_LEFT_TO_RIGHT:
					default:
						this.mask.x = 0;
						animateMask(_width,0,_width,_height);
						break;
				} // END switch
			} // END if
		} // END function
		
		public function resizeMask(w:Number,h:Number):void { 
			checkIfTweening();
			if (this.mask != null && (width != this.mask.width || height != this.mask.height)) {
				_animating = true;
				animateMask(this.x,this.y,w,h);
			} // END if
		} // END function
		
		public function animateMask(x:Number, y:Number, w:Number, h:Number):void {
			checkIfTweening();
			Tweener.addTween(this.mask, { x:x, y: y, width:w, height:h , time:_speed , delay:0 , onComplete:function():void { onMaskSizeChanged(); } } );
		} // END function
		
		public function setMask(x:Number,y:Number,width:Number,height:Number):void { 
			if (this.mask == null)
				this.mask = addElement('_mask_'+this.name,Box,{x:x,y:y,width:width,height:height,color:0x000000});
		}  // END function
		
		public function onMaskSizeChanged():void { _animating = false; }
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void { } // END function
		
		private function checkIfTweening():void {
			if (_animating) Tweener.removeTweens(this.mask);
		}
	} // END class
} // END package