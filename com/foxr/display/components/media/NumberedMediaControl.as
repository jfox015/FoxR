package com.foxr.display.components.media
{
	//import external classes
	
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.buttons.StandardButton;
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
	 * A media playback control that displays playback links as numbers representing 
	 * the number of elements loading into the corresponding media collection.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class NumberedMediaControl extends MediaControl implements IMediaControl {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var _buttonProperties:Object = null;
		
		private var _selectedIndex:Number;
		
		private var _highlightedIndex:Number;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new NumberedMediaControl instance.
		 *
		 */
		public function NumberedMediaControl() { 
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
		//public function get buttonConfig():String { return _buttonConfig; }
		//public function set buttonConfig(c:String):void { _buttonConfig = c; }
		/**
		 * Selects how many navigation elements are displayed for CONTROL_PLAYBACK. 
		 * @param	c	Button Config value.
		 * @return		Button Config value.
		 * @since	1.0
		 */
		public function get buttonProperties():Object { return _buttonProperties; }
		public function set buttonProperties(p:Object):void{
			if (p != null) {
				_buttonProperties = p;
			} else {
				_buttonProperties = new Object();	
				_buttonProperties.backgroundColor= bkgd.color;
				_buttonProperties.verticalAlign= 'middle';
				_buttonProperties.textAlign = 'center';
				var tmptf:TextFormat = new TextFormat();
				tmptf.color = 0x000000;
				_buttonProperties.textStyle = tmptf;
				_buttonProperties.hoverBackgroundColor = 0x000000;
				_buttonProperties.hoverTextColor = 0xFFFFFF;
			}
		}
		/**
		 *  Sets the parent enabled flag and enables or disables the child elements.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean		TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
			
			for (var i:Number = 0; i < buttonBar.numChildren; i++) {
				var chldBtn:StandardButton = StandardButton(buttonBar.getChildAt(i));
				chldBtn.enabled = e;
				if (e) {
					chldBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
				} else {
					chldBtn.removeEventListener(MouseEvent.CLICK, onButtonClick);
				} //END if
			}
		}
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
			trace("NumberedControl, target = " + _target);
			if (target != null) {
			
				// Remove all children save for the background
				super.draw();
				
				// Apply styles if available
				if (gpm.css.getStyle(GlobalConstants.STYLE_MEDIA_NUMBERED_CTRL) != null) {
					applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_MEDIA_NUMBERED_CTRL));
				} // END if
				var txtStyle:TextFormat = null;
				if (gpm.css.getTextFormat(GlobalConstants.STYLE_MEDIA_NUMBERED_CTRL_TEXT) != null) {
					txtStyle = gpm.css.getTextFormat(GlobalConstants.STYLE_MEDIA_NUMBERED_CTRL);
				} // END if
				
				// Do some math to determine the size of the controller
				var buttonWidth:Number = 0;
				var buttonheight:Number = (buttonBar.height - (borderWidth * 2));
				var nextX:Number = borderWidth;
				var padSize:Number = 0;
				var buttonCount:Number = target.itemsLoaded();
				
				//trace(this + " draw Numbered Control");
				//trace(this + " buttonCount = " + buttonCount);
				
				if (sizeType == SIZE_FIXED) {
					//trace(this + " buttonBar.width = " + buttonBar.width + ", ((buttonBar.width - (borderWidth * 2)) / buttonCount) = " + ((buttonBar.width - (borderWidth * 2)) / buttonCount));
					buttonWidth = ((buttonBar.width - (borderWidth * 2)) / buttonCount);
					//trace(this + " buttonWidth = " + buttonWidth);
					var usedBarSpace:Number = (buttonBar.width - (buttonWidth *  buttonCount));
					var paddingSpace:Number = (buttonBar.width - usedBarSpace);
					padSize = (paddingSpace / buttonCount);
				} // END if
				
				/* -----Begin drawing the buttons----- */
				for(var j:Number = 0; j < buttonCount; j++){
					//try{
					var tmpButton:StandardButton = StandardButton(buttonBar.addElement('button' + j, StandardButton,
					{ x:nextX,text: (j + 1), textStyle:txtStyle,height: buttonheight }, buttonProperties));
					tmpButton.y = (buttonBar.height / 2) - (tmpButton.height / 2);
					if (sizeType == SIZE_FIXED) {
						tmpButton.sizeType = SIZE_FIXED;
						tmpButton.width = buttonWidth;
					} // END if
					nextX += tmpButton.width;
				} // END for
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
			target.playItem(buttonBar.getChildIndex(buttonBar.getChildByName(e.currentTarget.name)));
			
		}
	}
	
}