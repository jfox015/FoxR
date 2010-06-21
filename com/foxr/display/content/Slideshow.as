package com.foxr.display.content
{
	//import external classes
	import caurina.transitions.*;
	
	import com.foxr.display.*;
	import com.foxr.display.content.ImageCollection;
	import com.foxr.display.content.Image;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * Loads and transitions through a series of images. Slideshow is used to rotate through a set of 
	 * static graphics, which can be in any supported image format. it is not intended to load "movie" 
	 * files that will need to play and may have a seperate running time than the Slideshows internal 
	 * interval timer.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 */
	public class Slideshow extends ImageCollection implements IAnimator {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const DIRECTION_FORWARD:String = 'forward';
		public static const DIRECTION_BACKWARD:String = 'backward';
		
		public static const	PLAYBACK_LINEAR:String = 'linear';
		public static const	PLAYBACK_RANDOM:String = 'random';
		public static const	PLAYBACK_CUSTOM:String = 'custom';
		/**
		 * Auto play flag.
		 */
		protected var _autoPlay:Boolean = false;
		/**
		 * Stores a custom playback order.
		 */
		protected var _customPlaylist:Array = null;
		/**
		 * Active (visible) image index
		 */
		protected var _currIndex:Number = 0;
		/**
		 * Default index to begin play with at startup
		 */
		protected var _defaultIndex:Number = 0;
		/**
		 * The playback direction.
		 */
		protected var _direction:String = DIRECTION_FORWARD;
		
		protected var _intervalSpeed:Number = 3500;
		
		protected var _itemsPlayed:Array = null;
		/**
		 *Defines if the object is currently animating.
		 */
		protected var _isAnimating:Boolean = false;
		
		protected var _playbackType:String = PLAYBACK_LINEAR;
		
		protected var _transitionDelay:Number = 0;
		
		protected var _transitionSpeed:Number = 3;
		
		protected var _repeat:Number = 0;
		
		protected var timer:Timer = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Slideshow instance
		 *
		 */
		public function Slideshow() {
			super();	
			_itemsPlayed = new Array();
		} // END function
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	
		 *  Applies or returns an autoPLay value.
		 *  @param	a	TRUE or FALSE
		 *  @return		TRUE or FALSE
		 *	@since	1.0
		 */
		public function get autoPlay():Boolean { return _autoPlay; }
		public function set autoPlay(a:Boolean):void { _autoPlay = a; }
		/**
		 * 	
		 *  Applies or returns a custom playback order for the slidehow.
		 *  @param	l	Array of indexes
		 *  @return		Playlist value
		 *	@since	1.0
		 */
		public function get customPlaylist():Array { return _customPlaylist; }
		public function set customPlaylist(l:Array):void { _customPlaylist = l; }
		/**
		 * 	
		 *  Returns the currently selected index value.
		 *  @return		Currently selected index value
		 *	@since	1.0
		 */
		public function get currentIndex():Number { return _currIndex; }
		/**
		 * 	
		 *  Applies and returns the default index value to display.
		 *  @param	i	Default index value
		 *  @return		Current default index value
		 *	@since	1.0
		 */
		public function get defaultIndex():Number { return _defaultIndex; }
		public function set defaultIndex(i:Number):void { _defaultIndex = i; }
		/**
		 * 	Applies and returns the playback direction (forward or backwards).
		 * 	Options are:
		 *  <p />
		 *  <ul>
		 * 		<li>DIRECTION_FORWARD</li>
		 * 		<li>DIRECTION_BACKWARD</li>
		 *  </ul>
		 * 	<p />
		 *  @param	i	Direction value
		 *  @return		Direction value
		 *	@since	1.0
		 */
		public function get direction():String { return _direction; }
		public function set direction(d:String):void { _direction = d; }
		/**
		 * 	Applies and returns the time that should elapse between the display 
		 *  of slidehow elements.
		 *  @param	s	Interval speed in seconds
		 *  @return		Interval speed in seconds value
		 *	@since	1.0
		 */
		public function get intervalSpeed():Number { return _intervalSpeed; }
		public function set intervalSpeed(s:Number):void { _intervalSpeed = s; }
		/**
		 * 	Applies and returns the playback type. This detemrines how the slideshow 
		 *  chooses the next item in the playback sequence.
		 * 	Options are:
		 *  <p />
		 *  <ul>
		 * 		<li>PLAYBACK_LINEAR -  One item afetr another int he order added to the image collection</li>
		 * 		<li>PLAYBACK_RANDOM - Each item is choosen randomly</li> 
		 * 		<li>PLAYBACK_CUSTOM - Uses the value of customPlaylist to determine the order.</li>
		 *  </ul>
		 * 	<p />
		 *  <b>NOTE:</b> If the type is set to PLAYBACK_CUSTOM and customPlaylist is not set, the 
		 *  object reverts to PLAYBACK_LINEAR.
		 * 	<p />
		 *  @param	t	Playback type
		 *  @return		Playback type value
		 *	@since	1.0
		 */
		public function get playbackType():String { return _playbackType; }
		public function set playbackType(t:String):void { _playbackType = t; }
		/**
		 * 	Specify how many times the slideshow should repeat the playback of 
		 *  the playlist.
		 *  @param	r	Number of repeats
		 *  @return		Number of repeats value
		 *	@since	1.0
		 */
		public function get repeat():Number { return _repeat; }
		public function set repeat(r:Number):void { _repeat = r; }
		/**
		 * 	Applies or returns the number of seconds that should elapse before a transition 
		 *  between slideshow takes place.
		 *  @param	d	Delay in seconds
		 *  @return		transitionDelay value
		 *	@since	1.0
		 */
		public function get transitionDelay():Number { return _transitionDelay; }
		public function set transitionDelay(d:Number):void { _transitionDelay = d; }
		/**
		 * 	Applies or returns the speed of seconds that should elapse as a transition 
		 *  between slideshow takes place.
		 *  @param	s	Speed in seconds
		 *  @return		transitionSpeed value
		 *	@since	1.0
		 */
		public function get transitionSpeed():Number { return _transitionSpeed; }
		public function set transitionSpeed(s:Number):void { _transitionSpeed = s; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Run the transition sequence.
		 *	@since	1.0
		 */
		public function animate(oldIndex:Object,newIndex:Object):void { 
			var oldImg:Image = Image(this.getChildByName('img_'+oldIndex));
			var newImg:Image = Image(this.getChildByName('img_'+newIndex));
			setChildIndex(newImg, numChildren -1);
			newImg.alpha = 0;
			newImg.show();
			
			Tweener.addTween(newImg, { alpha:1.0 , time:_transitionSpeed , delay:_transitionDelay, 
			onComplete:function():void { onImageShown(oldImg); }}  );
		}
		/**
		 * 	Returns the animating state of the slidehwo.
		 *	@since	1.0
		 */
		public function isAnimating():Boolean { return _isAnimating; }
		/**
		 * 	Navigates to the first item in the slidewhow.
		 *	@since	1.0
		 */
		public function first():void { 
			var continuePlay:Boolean = _isAnimating;
			if (_isAnimating) stop();
			var oldIndex:Number = _currIndex;
			var newIndex:Number = _currIndex = 0;
			animate(oldIndex,newIndex);
			if (continuePlay) play();
		}
		/**
		 * 	Navigates to the last item in the slidewhow.
		 *	@since	1.0
		 */
		public function last():void { 
			var continuePlay:Boolean = _isAnimating;
			if (_isAnimating) stop();
			var oldIndex:Number = _currIndex;
			var newIndex:Number = _currIndex = (numChildren - 1);
			animate(oldIndex,newIndex);
			if (continuePlay) play();
		}
		/**
		 * 	Selectes the next image to animate in the sequence.
		 *	@since	1.0
		 */
		public function next():void { 
			var oldIndex:Number = _currIndex;
			var newIndex:Number = 0;
			// CHoose next image based on playback settings
			_currIndex++;
			if (_currIndex >= numChildren) _currIndex = 0; 
			switch (_playbackType) {
				case PLAYBACK_RANDOM:
					newIndex = getRandomIndex();
					break;
				case PLAYBACK_CUSTOM:
					if (_customPlaylist != null) {
						newIndex = _customPlaylist[_currIndex];
					}
					break;
				case PLAYBACK_LINEAR:
				default:
					newIndex = _currIndex;
					break;
			} // END switch
			animate(oldIndex,newIndex);
		} 
		/**
		 * 	Method to pause image animations.
		 *	@since	1.0
		 */
		public function pause():void { stop(); }
		/**
		 * 	Starts the animation.
		 *	@since	1.0
		 */
		public function play():void { 
			if (timer == null) timer = new Timer(_intervalSpeed, _repeat);
			timer.addEventListener(TimerEvent.TIMER, onPlayTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onPlayComplete);
			timer.start();
			_isAnimating = true;
		} 
		/**
		 * 	Plays a specific item in the collection. 
		 *  <p />
		 * 	<b>NOTE</b> Calling this method will stop any running animations in favor 
		 *	of choosing the new item.
		 *	@since	1.0
		 */
		public function playItem(itemIndex:Number):void {
			// ignore this request if the passed index matches the current index
			if (itemIndex != _currIndex) {
				if (_isAnimating) stop();
				var oldIndex:Number = _currIndex;
				var newIndex:Number = _currIndex = itemIndex;
				animate(oldIndex,newIndex);
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			} // END if
		}
		/**
		 * 	Selectes the previous image to animate in the sequence.
		 *	@since	1.0
		 */
		public function previous():void { 
			var oldIndex:Number = _currIndex;
			var newIndex:Number = 0;
			_currIndex--;
			if (_currIndex < 0) _currIndex = (numChildren - 1); // END if
			switch (_playbackType) {
				case PLAYBACK_RANDOM:
					newIndex = getRandomIndex();
					break;
				case PLAYBACK_CUSTOM:
					if (_customPlaylist != null) {
						newIndex = _customPlaylist[_currIndex];
					} // END if
					break;
				case PLAYBACK_LINEAR:
				default:
					newIndex = _currIndex;
					break;
			} // END switch
			animate(oldIndex,newIndex);
		} 
		/**
		 * 	Method to reset image animations.
		 *	@since	1.0
		 */
		public function reset():void { 
			stop();
			_currIndex = _defaultIndex;
		}
		/**
		 * 	Stops the slideshow.
		 *	@since	1.0
		 */
		public function stop():void { 
			if (timer != null) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onPlayTimer);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onPlayComplete);
			} // END if
			if (_isAnimating) _isAnimating = false; // END if
			
		} 
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Selects a unique random index.
		 * 	@return	Random Index Value.
		 *	@since	1.0
		 */
		protected function getRandomIndex():Number {
			var tmpIndex:Number = Math.floor(Math.random() * numChildren);
			if (_itemsPlayed.length == (numChildren - 1)) {
				_itemsPlayed = new Array();
			} else {
				while (true) {
					var indexPlayed:Boolean = false;
					for (var i:Number = 0; i < _itemsPlayed.length; i++) {
						if (_itemsPlayed[i] == tmpIndex) {
							indexPlayed = true;
							break;
						} // END if
					} // END for
					if (!indexPlayed) {
						break;
					} else {
						tmpIndex = Math.floor(Math.random() * numChildren);
					} // END if			
				} // END while
			} // END if
			_itemsPlayed.push(tmpIndex);
			return tmpIndex;
		}
		/**
		 *  Fired once all images have loaded in.
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
			MaskableImage(this.getChildAt(showIndex)).show();
			dispatchEvent(new Event(Event.COMPLETE));
			if (_autoPlay) play();
		}
		/**
		 *  Fired once the playback timer event occurs.
		 *	@since	1.0
		 */
		protected function onPlayTimer(e:Event):void {
			if (direction == DIRECTION_FORWARD) 
				next();
			else 
				previous(); // END if
		}
		/**
		 *  Fired once an items playback has completed.
		 *	@since	1.0
		 */
		protected function onPlayComplete(e:Event):void {
			stop();
		}
		/**
		 *  Fired once the current image object is visible.
		 *	@since	1.0
		 */
		protected function onImageShown(oldImg:Image):void {
			oldImg.hide();
			dispatchEvent(new Event(Event.COMPLETE));
		}
	} // END class
} // END package