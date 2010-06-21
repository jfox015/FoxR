package com.foxr.display.buttons {

	import com.foxr.display.Element;
	import com.foxr.display.components.*;
	import com.foxr.display.graphics.Triangle;
	import com.foxr.display.graphics.PixelPause;
	
	import flash.display.Sprite;
	import flash.events.*;
	/**
	 * This class draws a standard play arrow and pause marker for use in the 
	 * libraries media control elements (namely MediaPlaybackControl).
	 * <p />
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *  
	 * @see				com.fox.display.components.media.MediaPlaybackControl MediaPlaybackControl
	 *
	 */
	public class PlayPauseButton extends StandardButton {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STATIC CONSTANTS
		/**
		 * PAUSED STATE.
		 * @const 	STATE_PAUSED:String
		 */
		public static const STATE_PAUSED:String = 'paused';
		/**
		 * PLAYING STATE.
		 * @const 	STATE_PLAYING:String
		 */
		public static const STATE_PLAYING:String = 'playing';
		
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
		 * ENABLED FOREGORUND COLOR.
		 * @var _clrForegroundEnabled:Number
		 */
		protected var _clrForegroundEnabled:Number = 0x000000;
		/**
		 * DISABLED FOREGORUND COLOR.
		 * @var _clrForegroundDisabled:Number
		 */
		protected var _clrForegroundDisabled:Number = 0xDEDEDE;
		
		/**
		 * TRIANGLE.
		 * @var tri:Triangle
		 */
		protected var tri:Triangle = null;
		/**
		 * PAUSE ICON.
		 * @var pauseIcon:PixelPause
		 */
		protected var pauseIcon:PixelPause = null;
		
		// DATA VARS
		/**
		 * DISPLAY STATE.
		 * @var _state:String
		 */
		protected var _state:String = STATE_PAUSED;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollbarButton instance
		 *
		 */
		public function PlayPauseButton() {
			super();
			removeChild(getChildByName('txt'));
			tri = Triangle(addElement('tri', Triangle, { direction:Triangle.DIRECTION_RIGHT,color:_clrForegroundEnabled,visible:false } ));
			pauseIcon = PixelPause(addElement('pauseIcon', PixelPause, { color:_clrForegroundEnabled,visible:false } ));
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies the specified color to the objects arrow(s).
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get foregroundColor():Number { return _clrForegroundEnabled; }
  		public function set foregroundColor(c:Number):void { _clrForegroundEnabled = c; }
		/**
		 * Applies the specified color to the objects arrow(s) when the object is disabled.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get disabledForegroundColor():Number { return _clrForegroundDisabled; }
  		public function set disabledForegroundColor(c:Number):void { _clrForegroundDisabled = c; }
		/**
		 * Applies the specified size to the objects arrows.
		 * @since	1.0
		 * @param	s	The size of the objects control icons
		 */
		public function get foregroundSize():Number { return tri.size; }
  		public function set foregroundSize(s:Number):void { tri.size = pauseIcon.width = pauseIcon.height = (s - (_padding * 2)); }
  		/**
		 * Applies the specified background color to the objects icon(s).
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public override function get backgroundColor():Number { return _clrBgEnabled;  }
		public override function set backgroundColor(c:Number):void { _clrBgEnabled = c;  }
		/**
		 * Applies the specified disabled state background color to the objects icon(s).
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get disabledBackgroundColor():Number { return _clrBgDisabled;  }
		public function set disabledBackgroundColor(c:Number):void { _clrBgDisabled = c; }
		/**
		 * Applies the specified border color to the objects icon(s).
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public override function get borderColor():Number { return _clrBdrEnabled;  }
		public override function set borderColor(c:Number):void { _clrBdrEnabled = c;  }
		/**
		 * Applies the specified disabled state border color to the objects icon(s).
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
				bkgd.addEventListener(MouseEvent.CLICK, onMouseClick);
			else
				bkgd.removeEventListener(MouseEvent.CLICK, onMouseClick); // END if
			this.useHandCursor = this.buttonMode = e;
			this.mouseChildren = !e;
			bkgd.color = e ?  _clrBgEnabled : _clrBgDisabled;
			bkgd.borderColor = e ?  _clrBdrEnabled : _clrBdrDisabled;
			tri.color = pauseIcon.color = e ? _clrForegroundEnabled : _clrForegroundDisabled;
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
			tri.size = pauseIcon.height = (h - (_padding * 2));
			tri. y = (h / 2) - (tri.size / 2);
			pauseIcon. y = (h / 2) - (pauseIcon.height / 2);
		}
		public function get state():String { return _state;  }
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void { 
			super.width = w;
			bkgd.width = w; 
			tri.size = pauseIcon.width = (w - (_padding * 2))
			tri.x = ((w / 2) - (tri.size / 2)) + 1;
			pauseIcon.x = ((w / 2) - (pauseIcon.width / 2));
		}
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			if (bkgd.visible == false || _clrBgEnabled.toString() == 'NaN') {
				bkgd.applyProperties( { alpha:0.01, color:0xFFFFFF, visible:true} );
			}
			_padding = 4;
			sizeType = SIZE_FIXED;
			changeState(STATE_PLAYING);
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Switches the state of the button to play or pause.
		 * @since	1.0
		 * @param	s	The specified state.
		 *
		 */
		public function changeState(s:String = ''):void { 
			if (s == '') s = _state;
			switch(s) {
				case STATE_PAUSED:
					tri.visible = false;
					pauseIcon.visible = true;
					_state = STATE_PLAYING;
					break;
				case STATE_PLAYING:
					tri.visible = true;
					pauseIcon.visible = false;
					_state = STATE_PAUSED;
					break;
			} // END switch
		}
		/**
		 * Resonds to the user clicking the button. Dispatches a SELECT event up to 
		 * parent objects.
		 * @since	1.0
		 * @param	e	Event object.
		 *
		 */
		protected function onMouseClick(e:MouseEvent):void { 
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}