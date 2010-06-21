package com.foxr.display.components.media
{
	//import external classes
	
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.buttons.*;
	import com.foxr.display.Element;
	import com.foxr.display.components.media.MediaControl;
	import com.foxr.display.content.IAnimator;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.display.ToolTip;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * A visual component that displays a bar of playback controls like play/pause, next, previous,
	 * first and last. The object iis configuable so that you can display all buttons, or just the 
	 * play/pause button.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class MediaPlaybackControl extends MediaControl implements IMediaControl {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const BUTTONS_ALL:String = 'all';
		public static const BUTTONS_BASIC:String = 'basic';
		public static const BUTTONS_PLAYPAUSE:String = 'playPause';
		
		private var firstButton:NavigateButton = null;
		private var previousButton:NavigateButton = null;
		private var playPauseButton:PlayPauseButton = null;
		private var nextButton:NavigateButton = null;
		private var lastButton:NavigateButton = null;
		
		private var _buttonConfig:String = BUTTONS_BASIC;
		private var _buttonProperties:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new MediaPlaybackControl instance.
		 *
		 */
		public function MediaPlaybackControl() { 
			super();
		}
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Selects how many navigation elements are displayed for CONTROL_PLAYBACK. 
		 * @param	c	Button Config value.
		 * @return		Button Config value.
		 * @since	1.0
		 */
		public function get buttonConfig():String { return _buttonConfig; }
		public function set buttonConfig(c:String):void { _buttonConfig = c; }
		/**
		 * Selects how many navigation elements are displayed for CONTROL_PLAYBACK. 
		 * @param	c	Button Config value.
		 * @return		Button Config value.
		 * @since	1.0
		 */
		public function get buttonProperties():Object { return _buttonProperties; }
		public function set buttonProperties(p:Object):void{
			if (p!=null) {
				_buttonProperties = p;
			} else {
				//Set up default parameters in case of missing css node
				_buttonProperties = new Object();
				_buttonProperties.backgroundColor = 0xFFFFFF;
				_buttonProperties.arrowColor = 0x000000;
				_buttonProperties.verticalAlign = 'middle';
				_buttonProperties.textAlign = 'center';
			} // END if
		}
		/**
		 *  Sets the parent enabled flag and enables or disables the child elements.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean		TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
			
			firstButton.useHandCursor = firstButton.buttonMode = e;
			previousButton.useHandCursor = previousButton.buttonMode = e;
			nextButton.useHandCursor = nextButton.buttonMode = e;
			lastButton.useHandCursor = lastButton.buttonMode = e;
			
			firstButton.mouseChildren = previousButton.mouseChildren = nextButton.mouseChildren = lastButton.mouseChildren = !e;
			
			if (target != null && !target.isAnimating()) {
				playPauseButton.useHandCursor = playPauseButton.buttonMode = e;
				playPauseButton.mouseChildren = !e;
			}
			if (e) {
				if (firstButton != null) firstButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				if (firstButton != null) firstButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (firstButton != null) firstButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (previousButton != null) previousButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				if (previousButton != null) previousButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (previousButton != null) previousButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (playPauseButton != null && (target != null && !target.isAnimating())) {
					playPauseButton.addEventListener(MouseEvent.CLICK, onButtonClick);
					playPauseButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
					playPauseButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				} // END if
				
				if (nextButton != null) nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				if (nextButton != null) nextButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (nextButton != null) nextButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (lastButton != null) lastButton.addEventListener(MouseEvent.CLICK, onButtonClick);
				if (lastButton != null) lastButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (lastButton != null) lastButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
			} else {
				if (firstButton != null) firstButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
				if (firstButton != null) firstButton.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (firstButton != null) firstButton.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (previousButton != null) previousButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
				if (previousButton != null) previousButton.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (previousButton != null) previousButton.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (playPauseButton != null && (target != null && !target.isAnimating())) {
					playPauseButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
					playPauseButton.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
					playPauseButton.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				} // END if
				
				if (nextButton != null) nextButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
				if (nextButton != null) nextButton.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (nextButton != null) nextButton.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				if (lastButton != null) lastButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
				if (lastButton != null) lastButton.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				if (lastButton != null) lastButton.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
			} // END if
		}
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Executed once the object has been added to the movie stage.
		 * @since	1.0
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			buttonProperties = null;
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Decides which type of player to draw and executes it.
		 * @param	e
		 */
		public override function draw():void{
			if (target != null) {
				// Remove all children save for the background
				super.draw();
				
				// Apply styles if available
				if (gpm.css.getStyle(GlobalConstants.STYLE_MEDIA_PLAYBACK_CTRL) != null) {
					applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_MEDIA_PLAYBACK_CTRL));
				} // END if
				
				// Do some math to determine the size of the controller
				var buttonWidth:Number = (buttonBar.height - (this.borderWidth * 2));
				var buttonCount:Number = 1;
				if (_buttonConfig == BUTTONS_ALL) {
					buttonCount = 5;
				} else if (_buttonConfig == BUTTONS_BASIC) {
					buttonCount = 3;
				} // END if
				
				var usedBarSpace:Number = (buttonBar.width - (buttonWidth *  buttonCount));
				if (_buttonConfig == BUTTONS_ALL) {
					usedBarSpace += buttonWidth;
				}
				var paddingSpace:Number = (buttonBar.width - usedBarSpace);
				var padSize:Number = 0;
				padSize = (paddingSpace / buttonCount);
				
				/* -----Begin drawing the buttons----- */
				// First item Button
				var nextX:Number = int(padSize / 2);
				
				//trace("Button config = " + _buttonConfig);
				var outsideBtnSize:Number = (buttonWidth - int(buttonWidth * .20));
				if (_buttonConfig != BUTTONS_BASIC && _buttonConfig != BUTTONS_PLAYPAUSE) {
					firstButton = NavigateButton(buttonBar.addElement('firstButton', NavigateButton, 
					{x:nextX, width:outsideBtnSize, height:outsideBtnSize, type:NavigateButton.FAST_BACKWARD }, 
					_buttonProperties));
					firstButton.y = (buttonBar, height / 2) - (firstButton.height / 2);
					nextX += (firstButton.width + padSize);
				} // END if
				
				if (_buttonConfig != BUTTONS_PLAYPAUSE) {
					previousButton = NavigateButton(buttonBar.addElement('previousButton', NavigateButton, 
					{x:nextX, width:buttonWidth, height:buttonWidth, type:NavigateButton.BACKWARD }, _buttonProperties));
					previousButton.y = (buttonBar, height / 2) - (previousButton.height / 2);
					nextX += (buttonWidth + padSize);
				} // END if
				
				playPauseButton = PlayPauseButton(buttonBar.addElement('playPauseButton', PlayPauseButton, 
				{x:nextX, width:buttonWidth, height:buttonWidth, foregroundColor:0x000000, 
				verticalAlign:'middle', align:'center', alpha:1.0, hoverBackgroundColor:0x000000 } ));
				playPauseButton.y = (buttonBar, height / 2) - (playPauseButton.height / 2);
				nextX += (buttonWidth + padSize);
				
				if (_buttonConfig != BUTTONS_PLAYPAUSE) {
					nextButton = NavigateButton(buttonBar.addElement('nextButton', NavigateButton, 
					{x:nextX, width:buttonWidth, height:buttonWidth, type:NavigateButton.FORWARD }, _buttonProperties));
					nextX += (buttonWidth + padSize);
					nextButton.y = (buttonBar, height / 2) - (nextButton.height / 2);
				} // END if
				
				if (_buttonConfig != BUTTONS_BASIC && _buttonConfig != BUTTONS_PLAYPAUSE) {
					lastButton = NavigateButton(buttonBar.addElement('lastButton', NavigateButton, 
					{x:nextX, width:outsideBtnSize, height:outsideBtnSize, type:NavigateButton.FAST_FORWARD }, _buttonProperties));
					lastButton.y = (buttonBar, height / 2) - (lastButton.height / 2);
				} // END if
				
				enabled = true;
				_drawn = true;
			} else {
				trace(this.name + " draw(), WARNING, target object is null. Control was not drawn.");
			}
					
		} // END function
		/**
		 * Determines which button called the click action and routes the 
		 * appropriate playback request to the target element.
		 * @param	e	Mouse Event.
		 * @since	1.0
		 */
		private function onButtonClick(e:MouseEvent):void {
			enabled = false;
			target.addEventListener(Event.COMPLETE, onAnimationComplete);
			switch(e.currentTarget.name) {
				case 'firstButton':
					target.first();
					break;
				case 'previousButton':
					target.previous();
					break;
				case 'nextButton':
					target.next();
					break;
				case 'lastButton':
					target.last();
					break;
				default:
					// PLAY/PAUSE BUTTON
					if (target.isAnimating()) {
						target.pause();
					} else {
						target.play();
					}
					playPauseButton.changeState();
					enabled = true;
					break;
			}
		}
		/**
		 * Determines which button called the mouse over action and creates the 
		 * appropriate tooltip text and, if tool tip is enabled, displays it.
		 * @param	e	Mouse Event.
		 * @since	1.0
		 */
		private function onButtonMouseOver(e:MouseEvent):void {
			switch(e.currentTarget.name) {
				case 'firstButton':
					buttonsToolTip.text = "First";
					break;
				case 'previousButton':
					buttonsToolTip.text = "Previous";
					break;
				case 'nextButton':
					buttonsToolTip.text = "Next";
					break;
				case 'lastButton':
					buttonsToolTip.text = "Last";
					break;
				case 'playPauseButton':
					if (playPauseButton.state == PlayPauseButton.STATE_PLAYING) {
						buttonsToolTip.text = "Pause";
					} else {
						buttonsToolTip.text = "Play";
					}
					break;
				default:
					break;
			}
			buttonsToolTip.showToolTip(e);
		}
		/**
		 * If tool tip is enabled, this method hides the tooltip manually.
		 * @param	e	Mouse Event.
		 * @since	1.0
		 */
		private function onButtonMouseOut(e:MouseEvent):void {
			buttonsToolTip.hideToolTip(e);
		}
	}
	
}