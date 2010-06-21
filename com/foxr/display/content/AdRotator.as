package com.foxr.display.content 
{
	// import external classes
	import caurina.transitions.Tweener;
	import com.foxr.event.LoginEvent;
	import com.foxr.display.content.Image;
	import flash.display.Sprite;
	import flash.net.URLRequest;
		
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.net.navigateToURL;
	/**
	 * The Ad Rotator object provides a mechanism to load external ads that are 
	 * both static and have playback capabiltires (like Flash ads). The Ad Rotator 
	 * also hooks ad display and click throughs to the analystics engine for 
	 * advanced ad tracking analytics.
	 * <p />
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 */
	public class AdRotator extends Slideshow {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var _target:String = "_blank";
		
		private var _currAd:MovieClip = null;
		
		private var _isAdPlaying:Boolean = false;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new AdRotator instance
		 *
		 */
		public function AdRotator() {
			super();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Override the default HREF target value that is used for ads that do not 
		 * specify a target value.
		 * 
		 * @param	t	HREF target value. Options are:	_blank, _self, _parent, _top
		 * @return		HREF target value
		 * 
		 */
		public function get target():String { return _target }
		public function set target(t:String):void{ _target = t }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/ 
		/**
		 * 	Starts the animation.
		 *	@since	1.0
		 */
		public override function play():void { 
			var idx:Number = _currIndex;
			if (_playbackType == PLAYBACK_CUSTOM &&_customPlaylist != null)
				idx = _customPlaylist[_currIndex]; // END if
			var tmpImg:MaskableImage = MaskableImage(getChildAt(idx));
			switch (tmpImg.type) {
				case Image.TYPE_INTERACTIVE:
					// Not yet supported
					break;
				case Image.TYPE_LINEAR:
					tmpImg.addEventListener(MouseEvent.CLICK, onAdClick);
					tmpImg.buttonMode = tmpImg.useHandCursor = true;
					tmpImg.mouseChildren = false;
					//tmpImg.addEventListener(Event.COMPLETE, onPlaybackComplete);
					if (_currAd != null) {
						_currAd.play();
						_currAd.addEventListener(Event.COMPLETE, onPlaybackComplete);
						_isAdPlaying = true;
					} // END if
					break;
				case Image.TYPE_STATIC:
				default:
					if (timer == null) timer = new Timer(_intervalSpeed, _repeat);
					timer.addEventListener(TimerEvent.TIMER, onPlayTimer);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, onPlayComplete);
					timer.start();
					break;
			} // END switch
		} 
		/**
		 * 	Plays a specific item in the collection. 
		 *  <p />
		 * 	<b>NOTE</b> Calling this method will stop any running animations in favor 
		 *	of choosing the new item.
		 *	@param	itemIndex	Index of the item to display
		 *	@since	1.0
		 */
		public override function playItem(itemIndex:Number):void {
			// ignore this request if the passed index matches the current index
			if (itemIndex != _currIndex) {
				if (_isAnimating) stop();
				var oldIndex:Number = _currIndex;
				var newIndex:Number = _currIndex = itemIndex;
				animate(oldIndex,newIndex);
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}// END if
		}
		/**
		 * 	Stops the slideshow.
		 *	@since	1.0
		 */
		public override function stop():void { 
			var tmpImg:MaskableImage = MaskableImage(getChildAt(_currIndex));
			switch (tmpImg.type) {
				case Image.TYPE_INTERACTIVE:
					// Not yet supported
					break;
				case Image.TYPE_LINEAR:
					tmpImg.removeEventListener(MouseEvent.CLICK, onAdClick);
					tmpImg.buttonMode = tmpImg.useHandCursor = false;
					tmpImg.mouseChildren = true;
					if (_currAd != null) {
						_currAd.stop();
						_currAd.removeEventListener(Event.COMPLETE, onPlaybackComplete);
						_isAdPlaying = false;
					} // END if
					break;
				case Image.TYPE_STATIC:
				default:
					if (timer != null) {
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER, onPlayTimer);
						timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onPlayComplete);
					} // END if
					if (_isAnimating) _isAnimating = false;
					break;
			} // END switch
		}
		/**
		 * 	Fired once all images have loaded in.
		 *	@since	1.0
		 */
		protected override function loadComplete():void { 
			_currIndex = _defaultIndex;
			var showIndex:Number = _currIndex;
			if (playbackType == PLAYBACK_RANDOM) {
				showIndex = getRandomIndex();
			} else if (playbackType == PLAYBACK_CUSTOM) {
				if (_customPlaylist != null) {
					showIndex = _customPlaylist[_currIndex];
				}
			}
			var tmpImg:Image = Image(this.getChildAt(showIndex));
			_currAd = MovieClip(tmpImg.loaderContent);
			tmpImg.show();
			dispatchEvent(new Event(Event.COMPLETE));
			if (_autoPlay) play();
			
		}
		/**
		 * 	Fired once all images have loaded in.
		 *  @param	e	Event
		 *	@since	1.0
		 */
		private function onPlaybackComplete(e:Event):void {
			MovieClip(e.currentTarget).gotoAndStop(1);
			var getIndex:Number =  _currIndex;
			if (playbackType == PLAYBACK_CUSTOM && _customPlaylist != null)
				getIndex = _customPlaylist[_currIndex]; // END if
			var tmpImg:MaskableImage = MaskableImage(getChildAt(getIndex));
			tmpImg.removeEventListener(Event.COMPLETE, onPlaybackComplete);
			switch (tmpImg.type) {
				case Image.TYPE_INTERACTIVE:
					// Not yet supported
					break;
				case Image.TYPE_LINEAR:
				default:
					if (_direction == DIRECTION_BACKWARD)
						previous();
					else
						next(); // END if
					break;
			} // END switch
		}
		/**
		 * 	Fired once all images have loaded in.
		 *  @param	oldImg	Reference to the image currently visible
		 *	@since	1.0
		 */
		protected override function onImageShown(oldImg:Image):void {
			oldImg.hide();
			var newImg:Image = Image(getChildAt(_currIndex));
			_currAd = MovieClip(newImg.loaderContent);
			switch (newImg.type) {
				case Image.TYPE_INTERACTIVE:
					// Not yet supported
					break;
				case Image.TYPE_LINEAR:
					oldImg.removeEventListener(MouseEvent.CLICK, onAdClick);
					oldImg.buttonMode = oldImg.useHandCursor = false;
					oldImg.mouseChildren = true;
					play();
					break;
				case Image.TYPE_STATIC:
				defaultIndex:
					break;
			} // END switch
		}
		/**
		 * 	Fired when a user clicks on a banner ad.
		 * 	@param	e	Event
		 *	@since	1.0
		 */
		private function onAdClick(e:MouseEvent):void {
			var img:Image = Image(e.currentTarget);
			if (img.href != '') {
				var targetStr:String = (img.target != '') ? img.target : _target;
				navigateToURL(new URLRequest(img.href), targetStr);
				if (gpm.config.analytics && img.analyticsId != '') {
					gpm.analytics.trackClick(img.analyticsId);
				} // END i
			} // END if
		}
	}
}