package com.foxr.display
{
	import caurina.transitions.*;
	
	import com.foxr.display.*;
	import com.foxr.display.CompoundElement;
	
	import flash.events.*;
	import flash.utils.Timer;
	/**
	 * An element extension that draws a small hovering box or tool tip over a given visual
	 * element.
	 * 
	 * @author			Jeff Fox
	 * @version			1.2
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * @see				com.foxr.display.Element Element
	 *
	 */
	public class ToolTip extends CompoundElement {
		
		private var _direction:String = "left";
		private var _duration:Number = 3;
		private var _timer:Timer;
		private var _fadeTime:Number = 3;
		private var _fadeDelay:Number = 0;
		private var _visibleAlpha:Number = 0.9;
		private var _offsetX:Number = -1;
		private var _offsetY:Number = -1;
		private var _dynamicPosition:Boolean = true;
		
		/**
		 * Creates a new instance of ToolTip.
		 * 
		 */		
		public function ToolTip() {
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible = false;
			this.alpha = 0;
			this.textAlign = ALIGN_LEFT;
			this.verticalAlign = VALIGN_MIDDLE;
		}
		/**
		 * Sets the duration of time that the ToolTip object appears.
		 * @param	time	
		 * @return 	The time value
		 * 
		 */		
		public function get duration():Number { return _duration; }
		public function set duration(time:Number):void { _duration = time; }
		/**
		 * Sets a whether the item should dynamically position itself relative to the 
		 * calling object.
		 * @param	p	TRUE or FALSE
		 * @return 	TRUE or FALSE
		 * 
		 */		
		public function get dynamicPosition():Boolean { return _dynamicPosition; }
		public function set dynamicPosition(p:Boolean):void { _dynamicPosition = p; }
		/**
		 * Set's the time (in seconds) for the object to fade in and out.
		 * @param	time	
		 * @return 	The time value
		 * 
		 */		
		public function get fadeTime():Number { return _fadeTime; }
		public function set fadeTime(time:Number):void { _fadeTime = time; }
		
		/**
		 * Set's the delay time (in seconds) until the object fades in or out.
		 * @param	delay	
		 * @return 	The delay value
		 * 
		 */
		public function get fadeDelay():Number { return _fadeDelay; }
		public function set fadeDelay(delay:Number):void { _fadeDelay = delay; }
		/**
		 * Sets an applicable X offset value.
		 * @param o	The X offset value.
		 * @retuen 	The X offset value.
		 * 
		 */
		public function get offsetX():Number { return _offsetX; }
		public function set offsetX(o:Number):void { _offsetX = o; }
		/**
		 * Sets an applicable Y offset value.
		 * @param o	The Y offset value.
		 * @retuen 	The Y offset value.
		 */
		public function get offsetY():Number { return _offsetY; }
		public function set offsetY(o:Number):void { _offsetY = o; }
		/**
		 * Sets an applicable X position value.
		 * @param xVal	The X position value.
		 * @retuen 		The X position value.
		 * 
		 */
		public function get positionX():Number { return this.x; }
		public function set positionX(xVal:Number):void { this.x= xVal; }
		/**
		 * Sets an applicable Y position value.
		 * @param yVal	The Y position value.
		 * @retuen 		The Y position value.
		 * 
		 */
		public function get positionY():Number { return this,y; }
		public function set positionY(yVal:Number):void { this.y = yVal; }
		
		/**
		 * Applies a CopyProxy String value to the object.
		 * @param s	CopyProxy String argument
		 * @see		com.foxr.model.CopyProxy CopyProxy
		 * 
		 */		
		public override function set string(s:String):void {
			super.string = s;
			update();
		}
		/**
		 * Applies a text value to the ToolTip.
		 * @param t	Text Value
		 * 
		 */		
		public override function set text(t:String):void {
			super.text = t;
			update();
		}
		/**
		 * Set's the alpha visibility value.
		 * @param 	Number	The alpha setting in x.x format
		 * @return			The alpha setting in x.x format
		 * 
		 */				
		public function get visibleAlpha():Number { return _visibleAlpha; }
		public function set visibleAlpha(a:Number):void { _visibleAlpha = a; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Displays the Tool Tip and anchors it to the last X,y mouse position.
		 * @param	e	Event reponse object
		 * @since		1.0
		 * 
		 */		
		public function showToolTip(e:MouseEvent):void {
			var caller:Element = Element(e.currentTarget);
			if (_dynamicPosition) {
				this.x = e.localX + (caller.x);
				if (_offsetX != -1) this.x += _offsetX;
				this.y = e.localY + (caller.y);
				if (_offsetY != -1) this.y += _offsetY;
			} // END if
			if ((this.x + this.width) > gpm.visualConfig.width) {
				this.x -= (((this.x + this.width) - gpm.visualConfig.width) + _padding);
			} else if (this.x < 0) {
				this.x = _padding;
			} // END if
			if ((this.y + this.height) > gpm.visualConfig.height) {
				this.y -= (((this.y + this.height) - gpm.visualConfig.height) + _padding);
			} else if (this.y < 0) {
				this.y = _padding;
			} // END if
			if (parent.getChildIndex(parent.getChildByName(this.name)) != parent.numChildren - 1) {
				parent.setChildIndex(parent.getChildByName(this.name),parent.numChildren - 1);
				/*var index:Number = 0;
				for (var i:Number = 0; i < parent.numChildren; i++) {
					var child:Element = Element(parent.getChildAt(i));
					if (child.name != this.name)
						parent.setChildIndex(child,index); // END if
				} // END for*/
			} // END if
			visible = true;
			//alpha = 1.0;
			Tweener.addTween (this, { alpha:_visibleAlpha, time: _fadeTime, delay:0 , onComplete:function():void { onShow(); }} );
		}
		/**
		 * Hides the Tool Tip object.
		 * @param	e	Event Reponse Object
		 * @since		1.0
		 * 
		 */		
		public function hideToolTip(e:Event):void {
			_timer.stop();
			Tweener.addTween(this,  { alpha:0, time: _fadeTime, delay:0 , onComplete:function():void { onShow(); } });
		}
		/**
		 * Fired when the object is added to the stage.
		 * @since	1.0
		 *
		 */
		public override function objReady(e:Event):void { 
			bkgd.visible = true;
			txt.visible = true;
		} // END function
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * Refreshes the layout based on copy, style or other changes.
		 * @since	1.0
		 *
		 */
		private function update():void {
			super.width = (txt.textWidth + (_padding * 4));
			super.height = (txt.textHeight + (_padding * 2));
			textAlign = _alignment;
			verticalAlign = _verticalAlignment;
		}
		/**
		 * If a <b>duration</b> has been set, sets a timer ovject to close the tool tip
		 * after that number of seconds.
		 * @since	1.0
		 *
		 */
		private function onShow():void {
			if( _timer != null ) { _timer.stop() };
			if (_duration != 0) {
				_timer = new Timer(_duration*1000, 1);
				_timer.addEventListener("timer", hideToolTip );
				_timer.start();
			} // END if
		}
		/**
		 * Sets the objects visibility to false.
		 * @since	1.0
		 *
		 */
		private function onHide():void {
			visible = false;
		}
	}
}