package com.foxr.display.buttons
{
	//import external classes
	import com.foxr.display.buttons.StandardButton;
	import com.foxr.display.graphics.Triangle;
	import flash.events.*;
	/**
	 * Adds an arrow to the standard button for use in the  Scrollbar object.
	 * @author			Jeff Fox
	 * @version			1.0.3
	 * @see				com.foxr.display.components.Scrollbar Scrollbar
	 *
	 */
	public class ScrollbarButton extends StandardButton {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const SIZE_TYPE_UNIFORM:String = 'uniform';
		
		public static const ARROW_SCALE_NOSCALE:String = 'noscale';
		public static const ARROW_SCALE_SCALE_X:String = 'scalex';
		public static const ARROW_SCALE_SCALE_Y:String = 'scaley';
		public static const ARROW_SCALE_SCALE_ALL:String = 'scaleall';
		/**
		 * ARROW.
		 * @var arrow:Triangle
		 */
		private var arrow:Triangle = null;
		/**
		 * ARROW SCALING.
		 * @var _scaleMode:Number
		 */
		private var _scaleMode:String = ARROW_SCALE_SCALE_ALL;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollbarButton instance
		 *
		 */
		public function ScrollbarButton() {
			super();
			removeChild(getChildByName('txt'));
			arrow = Triangle(addElement('arrow', Triangle, { size:4, direction:Triangle.DIRECTION_UP } ));
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies the specified color to the objects arrow.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get arrowColor():Number { return arrow.color; }
  		public function set arrowColor(c:Number):void { arrow.color = c; }
  		/**
		 * Applies the size properties to the objects arrow.
		 * @since	1.0
		 * @param	c	The size in pixels.
		 */
		public function get arrowSize():Number { return arrow.size; }
  		public function set arrowSize(s:Number):void { arrow.size = s; }
  		/**
		 * Applies the specified scale mode to the object.
		 * @since	1.0
		 * @param	c	The scale mode property.
		 */
		public function get arrowScaleMode():String { return _scaleMode; }
  		public function set arrowScaleMode(s:String):void { _scaleMode = s; }
		/**
		 * Sets the arrows direction. This avoids having to rotate the object and thus 
		 * having it's x.y positioning be off-axis.
		 * @since	1.0
		 * @param	d	The arrow direction (up, down, left or right)
		 */
		public function get direction():String { return arrow.direction; }
  		public function set direction(d:String):void { arrow.direction = d; }
  		/**
		 *  Sets the _enabled flag.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void{ 
			super.enabled = e;
			this.buttonMode = this.useHandCursor = e; 
			this.mouseChildren = !e;
			if (e) {
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} // END if
		}
  		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set height(h:Number):void { 
			super.height = h; 
			bkgd.height = h;
			if (this._scaleMode == ARROW_SCALE_SCALE_Y || this._scaleMode == ARROW_SCALE_SCALE_ALL) 
				arrow.height = h - (_padding * 3);
			render();
		}
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 * 
		 */
		public override function set width(w:Number):void { 
			super.width = w;
			bkgd.width = w; 
			if (this._scaleMode == ARROW_SCALE_SCALE_X || this._scaleMode == ARROW_SCALE_SCALE_ALL) 
				arrow.width = w - (_padding * 3);
			render();
			if (this.sizeType == SIZE_TYPE_UNIFORM && this.height != w)
				this.height = w;
		}
  		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Overrides the default Element.render() function to redraw the items elelents.
		 * @since	1.0
		 * @param	w The object width in pixels
		 * @see		com.foxr.display.Element#render()
		 */
		protected override function render():void {
			super.render();
			arrow.x = (this.width / 2) - (arrow.size / 2);
			arrow.y = (this.height / 2) - (arrow.size / 2);
			//gpm.log.debug("Arrow size = " + arrow.size);
			//gpm.log.debug("this.width = " + this.width);
			//gpm.log.debug("arrow.x = " + arrow.x);
		}
		/**
		 * Overrides default objectReady method.
		 * @since	1.0
		 * @see		com.foxr.display.Element#objReady()
		 */
		public override function objReady(e:Event):void { 
			super.objReady(e);
			bkgd.visible = true;
			txt.visible = false;
			arrow.visible = true;
			this.enabled = true;
		} // END function
	}
}