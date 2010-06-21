package com.foxr.display.buttons {

	import com.foxr.display.Element;
	import com.foxr.display.components.*;
	import com.foxr.display.graphics.Triangle;
	
	import flash.display.Sprite;
	import flash.events.*;
	/**
	 * The navigate Button draws an arrow button for use in creating navigation 
	 * bars and control schemes such as animation or FLV playback.
	 * <p />
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 */
	public class NavigateButton extends StandardButton {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STATIC CONSTANTS
		
		/**
		 * FORWARD.
		 * @const 	FORWARD:String
		 */
		public static const FORWARD:String = 'forward';
		/**
		 * BACKWARD.
		 * @const 	BACKWARD:String
		 */
		public static const BACKWARD:String = 'backward';
		/**
		 * FAST FORWARD.
		 * @const 	FAST_FORWARD:String
		 */
		public static const FAST_FORWARD:String = 'fastForward';
		/**
		 * FAST BACKWARD.
		 * @const 	FAST_BACKWARD:String
		 */
		public static const FAST_BACKWARD:String = 'fastBackward';
		
		// STYLE VARS
		/**
		 * ENABLED BACKGROUND COLOR.
		 * @var _clrBgEnabled:Number
		 */
		protected var _clrBgEnabled:Number = 0xEFEFEF;
		/**
		 * DISABLED BACKGROUND COLOR.
		 * @var _clrBgDisabled:Number
		 */
		protected var _clrBgDisabled:Number = 0xA0A0A0;
		
		/**
		 * ENABLED BORDER COLOR.
		 * @var _clrBdrEnabled:Number
		 */
		protected var _clrBdrEnabled:Number = 0x000000;
		/**
		 * DISABLED BORDER COLOR.
		 * @var _clrBdrDisabled:Number
		 */
		protected var _clrBdrDisabled:Number = 0xDEDEDE;
		
		/**
		 * ENABLED ARROW COLOR.
		 * @var _clrArrowEnabled:Number
		 */
		protected var _clrArrowEnabled:Number = 0x000000;
		/**
		 * DISABLED ARROW COLOR.
		 * @var _clrArrowDisabled:Number
		 */
		protected var _clrArrowDisabled:Number = 0xDEDEDE;
		
		// STAGE OBJECTS
		/**
		 * TRIANGLE 1.
		 * @var tri:Triangle
		 */
		protected var tri:Triangle = null;
		/**
		 * TRIANGLE 2.
		 * @var tri2Triangle
		 */
		protected var tri2:Triangle = null;
		
		// DATA VARS
		/**
		 * NAVIGATION TYPE.
		 * @var _type:String
		 */
		protected var _type:String = FORWARD;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollbarButton instance
		 *
		 */
		public function NavigateButton() {
			super();
			removeChild(getChildByName('txt'));
			tri = Triangle(addElement('tri', Triangle, { color:_clrArrowEnabled,visible:false } ));
			tri2 = Triangle(addElement('tri2', Triangle, { color:_clrArrowEnabled, visible:false } )); 
			//this.applyProperties({padding:4,arrowSize:5,sizeType:SIZE_FIXED } );
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies the specified color to the objects arrow(s).
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get arrowColor():Number { return _clrArrowEnabled; }
  		public function set arrowColor(c:Number):void { _clrArrowEnabled = c; }
		/**
		 * Applies the specified color to the objects background.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		
		public override function get backgroundColor():Number { return _clrBgEnabled;  }
		public override function set backgroundColor(c:Number):void { _clrBgEnabled = c;  }
		/**
		 * Applies the specified color to the objects border.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		
		public override function get borderColor():Number { return _clrBdrEnabled;  }
		public override function set borderColor(c:Number):void { _clrBdrEnabled = c;  }
		/**
		 * Applies the specified color to the objects arrow(s) when the object is disabled.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get disabledArrowColor():Number { return _clrArrowDisabled; }
  		public function set disabledArrowColor(c:Number):void { _clrArrowDisabled = c; }
		/**
		 * Applies the specified color to the objects background when the object is disabled.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get disabledBackgroundColor():Number { return _clrBgDisabled;  }
		public function set disabledBackgroundColor(c:Number):void { _clrBgDisabled = c; }
		/**
		 * Applies the specified color to the objects border when the object is disabled.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get disabledBorderColor():Number { return _clrBdrDisabled;  }
		public function set disabledBorderColor(c:Number):void { _clrBdrDisabled = c; }
		/**
		 * Overrides the default enabled function to enable and sdisable clicking and set style properties.
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set enabled(e:Boolean):void {
			if (e)
				this.addEventListener(MouseEvent.CLICK, onMouseClick);
			else
				this.removeEventListener(MouseEvent.CLICK, onMouseClick); // END if
			this.useHandCursor = this.buttonMode = e;
			this.mouseChildren = !e;
			bkgd.color = e ?  _clrBgEnabled : _clrBgDisabled;
			bkgd.borderColor = e ?  _clrBdrEnabled : _clrBdrDisabled;
			tri.color = tri2.color = e ? _clrArrowEnabled : _clrArrowDisabled;
		}
		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set height(h:Number):void { 
			//h += (_padding * 2); 
			super.height = h;
			bkgd.height = h;
			tri.size = tri2.size = (h - (_padding * 2));
			draw();
		}
		/**
		 * Sets the button type. Types are:
		 * <ul>
		 * 	<li>forward</li>
		 * 	<li>backward</li>
		 * 	<li>fastForward</li>
		 * 	<li>fastBackward</li>
		 * </ul>
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get type():String { return _type;  }
		public function set type(t:String):void { _type = t; width = height = tri.size; }
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void { 
			tri.size = tri2.size = (w - (_padding * 2));
			if (_type == FAST_BACKWARD || _type == FAST_FORWARD)
				w = (w * 2) + (_padding * 3); 
			else
				w = w + (_padding * 2); // END if
			super.width = w;
			bkgd.width = w; 
			
			draw();
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a layout based on style and size params/
		 * @since	1.0
		 *
		 */
		protected function draw():void { 
			tri. y = tri2.y = (height / 2) - (tri.size / 2);
			switch(_type) {
				case FORWARD:
					tri.x = ((width / 2) - (tri.size / 2)) + 1;
					tri.applyProperties( { direction:Triangle.DIRECTION_RIGHT, visible:true } );
					tri2.applyProperties( { visible:false } );
					break;
				case FAST_FORWARD:
					tri.x = _padding;
					tri2.x = (width - (tri2.size + _padding));
					tri.applyProperties( { direction:Triangle.DIRECTION_RIGHT, visible:true } );
					tri2.applyProperties( { direction:Triangle.DIRECTION_RIGHT, visible:true } );
					break;
				case BACKWARD:
					tri2.applyProperties( { visible:false } );
					tri.x = ((width / 2) - (tri.size / 2)) + 1;
					tri.applyProperties( { direction:Triangle.DIRECTION_LEFT, visible:true } );
					break;
				case FAST_BACKWARD:
					tri.x = _padding;
					tri2.x = (width - (tri2.size + _padding));
					tri.applyProperties( { direction:Triangle.DIRECTION_LEFT, visible:true } );
					tri2.applyProperties( { direction:Triangle.DIRECTION_LEFT, visible:true } );
					break;
			} // END switch
		}
		/**
		 * Handles ther mouse click event. Fires a select Event.
		 * @param	e	MouseEvent response object.
		 */
		protected function onMouseClick(e:MouseEvent):void { 
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}