package com.foxr.display.components
{
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.buttons.ScrollbarButton;
	import com.foxr.display.graphics.Box;
	import com.foxr.display.graphics.Triangle;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * Draws a scrollbar.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author	Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 */
	public class Scrollbar extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Vertical orientation contant
		 * @const	ORIENTATION_VERTICAL:String
		 */
		public static const ORIENTATION_VERTICAL:String = 'vertical';
		/**
		 * Horizontal orientation contant
		 * @const	ORIENTATION_HORIZONTAL:String
		 */
		public static const ORIENTATION_HORIZONTAL:String = 'horizontal';
		// OBJECTS
		/**
		 * Scroll target
		 * @var	target:Object
		 */
		private var _target:Element = null;
		/**
		 * Scroll handle
		 * @var	handle:Box
		 */
		private var handle:Box  = null;
		/**
		 * Top Button
		 * @var	btnTop:ScrollbarButton
		 */
		private var btnTop:ScrollbarButton = null;
		/**
		 * Bottom Button
		 * @var	_scrollTopX:Number
		 */
		private var btnBottom:ScrollbarButton = null;
		/**
		 * Scroll Timer
		 * @var	scrollTimer:Timer
		 */
		private var scrollTimer:Timer = null;
		// PROPERTIES
		/**
		 * Orientation
		 * @var	_orientation:String
		 */
		private var _orientation:String = ORIENTATION_VERTICAL;
		/**
		 * Scroll Top X
		 * @var	_scrollTopX:Number
		 */
		private var _scrollTopX:Number = 0;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollbarButton instance
		 *
		 */
		public function Scrollbar() {
			super();
			scrollTimer = new Timer(1);
			btnTop = ScrollbarButton(addElement('btnTop',ScrollbarButton,{x:0,direction:'up'}));
			handle = Box(addElement('handle',Box,{x:0}));
			btnBottom = ScrollbarButton(addElement('btnBottom',ScrollbarButton,{x:0,direction:'down'}));
			this.width = 16;
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/	
		/**
		 *  Overrides the default enabled method. Eneabled and disables the scrollbar
		 *  and all child components.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
			e ? this.alpha = 1.0 : this.alpha = .60;
			handle.buttonMode = e; handle.useHandCursor = e; handle.mouseChildren = !e;
			btnTop.enabled = btnBottom.enabled = e;
			if (e) {
				btnTop.addEventListener(MouseEvent.MOUSE_DOWN,onScrollButtonUpMouseDown);
				btnTop.addEventListener(MouseEvent.MOUSE_UP,onScrollButtonUpMouseUp);
				btnTop.addEventListener(MouseEvent.MOUSE_OUT,onScrollButtonUpMouseUp);
				btnBottom.addEventListener(MouseEvent.MOUSE_DOWN,onScrollButtonDownMouseDown);
				btnBottom.addEventListener(MouseEvent.MOUSE_UP,onScrollButtonDownMouseUp);
				btnBottom.addEventListener(MouseEvent.MOUSE_OUT,onScrollButtonDownMouseUp);
				handle.addEventListener(MouseEvent.MOUSE_DOWN,onHandlePress);
				handle.addEventListener(MouseEvent.MOUSE_UP,onHandleRelease);
				handle.addEventListener(MouseEvent.MOUSE_OUT,onHandleRelease);
			} else {
				btnTop.removeEventListener(MouseEvent.MOUSE_DOWN,onScrollButtonUpMouseDown);
				btnTop.removeEventListener(MouseEvent.MOUSE_UP,onScrollButtonUpMouseUp);
				btnTop.removeEventListener(MouseEvent.MOUSE_OUT,onScrollButtonUpMouseUp);
				btnBottom.removeEventListener(MouseEvent.MOUSE_DOWN,onScrollButtonDownMouseDown);
				btnBottom.removeEventListener(MouseEvent.MOUSE_UP,onScrollButtonDownMouseUp);
				btnBottom.removeEventListener(MouseEvent.MOUSE_OUT,onScrollButtonDownMouseUp);
				handle.removeEventListener(MouseEvent.MOUSE_DOWN,onHandlePress);
				handle.removeEventListener(MouseEvent.MOUSE_UP,onHandleRelease);
				handle.removeEventListener(MouseEvent.MOUSE_OUT,onHandleRelease);
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
			if (_orientation == Scrollbar.ORIENTATION_HORIZONTAL) {
				btnTop.width = btnTop.height = h;
				btnBottom.width = btnBottom.height = h;
				handle.width = h;
			} // END if
		}
		/**
		 * Applies and returns the orientation of the scrollbar.
		 * @since	1.0
		 * @param	w	The object orientation (vertical, horizontal)
		 * @return		The object orientation
		 *
		 */
		public function get orientation():String{ return _orientation; }
		public function set orientation(o:String):void { 
			_orientation = o; }
		/**
		 * Applies the passed color to the child scrollbar button arrows.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 *
		 */
		public function set scrollbarArrowColor(c:uint):void { 
			btnTop.arrowColor = c; 
			btnBottom.arrowColor = c; 
		}
		/**
		 * Applies the passed color to the child buttons elements background property.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 *
		 */
		public function set scrollbarButtonColor(c:uint):void { 
			btnTop.backgroundColor = c; 
			btnBottom.backgroundColor = c; 
		}/**
		 * Applies the passed color to the child handle elements background property..
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 *
		 */
		public function set scrollbarHandleColor(c:uint):void { 
			handle.color = c; 
		}
		/**
		 * Applies the passed color to the child background element.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 *
		 */
		public function set scrollbarTrackColor(c:uint):void { this.backgroundColor = c; }
		
		//Not yet supported - will they be?
		/**
		 * Not currently supported.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 *
		 */
		public function set scrollbar3dlightColor(c:uint):void { }
		/**
		 * Not currently supported
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 *
		 */
		public function set scrollbarDarkshadowColor(c:uint):void { }
		/**
		 * Not currently supported. Use the highlightColor property instead.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @see com.foxr.display.components.Component.highlightColor
		 *
		 */
		public function set scrollbarHighlightColor(c:uint):void {  }
		/**
		 * Not currently supported.. Use the shadowColor property instead.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @see com.foxr.display.components.Component.shadowColor
		 *
		 */
		public function set scrollbarShadowColor(c:uint):void { }
		/**
		 * Not currently used.<p />
		 * This method allows you to set a top margin for the scrolling object. If this property is 
		 * not set, the scrollbar assumes the top of the scrolling objects parent to be the top point 
		 * for scrolling.
		 * @since	1.4
		 * @param	x	The margin (top x point) for the scrolling object
		 * @deprecated
		 * 
		 */
		public function set scrollTopX(x:Number):void { _scrollTopX = x;}
		/**
		 * Sets the scrollbar's syncronization target.
		 * @since	1.0
		 * @param	t	Target Element
		 *
		 */
		public function set target(t:Element):void {	
			if (t != null) _target = t;
			calculateHandleSize();
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
			if (_orientation == Scrollbar.ORIENTATION_VERTICAL) {
				btnTop.width = btnTop.height = w;
				btnBottom.width = btnBottom.height = w;
				handle.width = w;
			} // END if 
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * 
		 * @since	1.0
		 *
		 */
		public function disableHandle(d:Boolean):void {
			handle.buttonMode = handle.useHandCursor = !d; handle.mouseChildren = d;
			if (d) {
				if (handle.hasEventListener(MouseEvent.MOUSE_DOWN))
					handle.removeEventListener(MouseEvent.MOUSE_DOWN,onHandlePress); // END if
				if (handle.hasEventListener(MouseEvent.MOUSE_UP))	
					handle.removeEventListener(MouseEvent.MOUSE_UP,onHandleRelease); // END if
				if (handle.hasEventListener(MouseEvent.MOUSE_OUT))
					handle.removeEventListener(MouseEvent.MOUSE_OUT,onHandleRelease); // END if
			} else {
				if (!handle.hasEventListener(MouseEvent.MOUSE_DOWN))
					handle.removeEventListener(MouseEvent.MOUSE_DOWN,onHandlePress); // END if
				if (!handle.hasEventListener(MouseEvent.MOUSE_UP))
					handle.removeEventListener(MouseEvent.MOUSE_UP,onHandleRelease); // END if
				if (!handle.hasEventListener(MouseEvent.MOUSE_OUT))
					handle.removeEventListener(MouseEvent.MOUSE_OUT,onHandleRelease); // END if
			} // END if
		}
		/**
		 * Placeholder method for child objects to execute once they have been added to the movie
		 * stage. This helps with acessing global variable from Main and parent objects.
		 * @since	1.0
		 *
		 */
		public override function objReady(e:Event):void { 
			// Set default size parmms
			bkgd.visible = true;
			btnTop.y = 0;
			this.enabled = true;
			calculateHandleSize();	
		} // END function
		/*------------------------
		/	PRIVATE FUNCTIONS
		/-----------------------*/
		/**
		 * Draws the scrollbar depending on the orientation.
		 * @since	1.0
		 */
		private function calculateHandleSize():void {
			switch(_orientation) {
				case ORIENTATION_HORIZONTAL:
					btnTop.direction = Triangle.DIRECTION_LEFT;
					btnBottom.direction = Triangle.DIRECTION_RIGHT;
					btnBottom.x = _width - btnBottom.width;
					btnBottom.y = 0;
					bkgd.height = height;
					bkgd.width = width;
					handle.height = height;
					if (_target != null)
						handle.width = int((this.width-(btnTop.width*2))*(this.width/(_target.width)));
					else
						handle.width = (this.width - (btnTop.width * 2)); // END if
					handle.y = 0;
					handle.x = btnTop.width;
					break;
				case ORIENTATION_VERTICAL:
				default:
					btnTop.direction = Triangle.DIRECTION_UP;
					btnBottom.direction = Triangle.DIRECTION_DOWN;
					btnBottom.x = 0;
					btnBottom.y = _height - btnBottom.height;
					bkgd.height = height;
					bkgd.width = width;
					handle.width = width;
					if (_target != null){
						handle.height = int((this.height-(btnTop.height*2))*(this.height/(_target.height)));
					}
					else{
						handle.height = ((this.height - (btnTop.height * 2)) / 2);
					} // END if
					handle.x = 0;
					handle.y = btnTop.height;
					break;
			} // END switch
		} // END function
		/*-----------------------
		/ HANDLE SCROLL EVENTS
		/----------------------*/
		/**
		 * Handles a mouse down event for the scroll up button.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onScrollButtonUpMouseDown(e:Event):void { 
			scrollTimer.addEventListener(TimerEvent.TIMER,scrollUp);
			scrollTimer.start();
		}
		/**
		 * Handles a mouse up and out event for the scroll up button which cancels scrolling.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onScrollButtonUpMouseUp(e:Event):void { 
			scrollTimer.removeEventListener(TimerEvent.TIMER,scrollUp);
			scrollTimer.stop();
		}
		/**
		 * If the handle can move, moves the handle up and synronizes scrolling with the target object.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function scrollUp(e:Event):void {
			switch(_orientation) {
				case ORIENTATION_HORIZONTAL:
					if (handle.x > btnTop.width) { handle.x--; syncScrollWithTarget();  }
					else if (handle.x < btnTop.width) handle.x = btnTop.width; // END if
					break;
				case ORIENTATION_VERTICAL:
				default:
					if (handle.y > btnTop.height) { handle.y--; syncScrollWithTarget();  }
					else if (handle.y <= btnTop.height) handle.y = btnTop.height; // END if
					break;
			} // END switch
		}
		/**
		 * Handles a mouse down event for the scroll down button.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onScrollButtonDownMouseDown(e:Event):void { 
			scrollTimer.addEventListener(TimerEvent.TIMER,scrollDown);
			scrollTimer.start();
		}
		/**
		 * Handles a mouse up and out event for the scroll down button which cancels scrolling.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onScrollButtonDownMouseUp(e:Event):void { 
			scrollTimer.removeEventListener(TimerEvent.TIMER,scrollDown);
			scrollTimer.stop();
		}
		/**
		 * If the handle can move, moves the handle down and synronizes scrolling with the target object.
		 * @since	1.0
		 * @param	e	Event
		 */
		public function scrollDown(e:Event):void {
			var floor:Number = 0;
			switch(_orientation) {
				case ORIENTATION_HORIZONTAL:
					floor = ((width - btnBottom.width) - handle.width);
					if (handle.x < floor) { handle.x++; syncScrollWithTarget(); }
					else if (handle.x > floor) handle.x = floor; // END if
					break;
				case ORIENTATION_VERTICAL:
				default:
					floor = ((height - btnBottom.height) - handle.height);
					if (handle.y < floor) { handle.y++; syncScrollWithTarget(); }
					else if (handle.x > floor) handle.x = floor; // END if
					break;
			} // END switch
		}
		/**
		 * Handles the mouse pressing on the scroll handle object.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onHandlePress(e:Event):void { 
			var bounds:Rectangle = null;
			switch(_orientation) {
				case ORIENTATION_HORIZONTAL:
					bounds = new Rectangle(btnTop.width,0,((this.width - (btnTop.width + btnBottom.width)) - handle.width),0);
					break;
				case ORIENTATION_VERTICAL:
				default:
					bounds = new Rectangle(0,btnTop.height,0,((this.height - (btnTop.height + btnBottom.height)) - handle.height));
					break;
			} // END switch
			handle.startDrag(false,bounds); 
			handle.addEventListener(MouseEvent.MOUSE_MOVE,onHandleScroll);
		}
		/**
		 * Handles the mouse releasing the scroll handle object.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onHandleRelease(e:Event):void { 
			handle.removeEventListener(MouseEvent.MOUSE_MOVE,onHandleScroll);
			handle.stopDrag(); 
		}
		/**
		 * Handles the mouse dragging the scroll handle object.
		 * @since	1.0
		 * @param	e	Event
		 */
		private function onHandleScroll(e:Event):void { syncScrollWithTarget(); }
		/**
		 * Syncronizs the scrolling of the scrollbar handle (dragged or moved by button click)
		 * with the target object. The target object must not be null for this method to properly
		 * execute.
		 * @since	1.0
		 */
		private function syncScrollWithTarget():void {
			if (_target != null) {
				var scrollTrack:Number = 0;
				var scrollPerc:Number = 0;
				switch(_orientation) {
					case ORIENTATION_HORIZONTAL:
						scrollTrack = this.width - ((btnTop.width * 2));
						scrollPerc = ((handle.x - btnTop.width) / (scrollTrack - handle.width));
						_target.x = -(scrollPerc * (_target.width - this.width));
						
						break;
					case ORIENTATION_VERTICAL:
					default:
						scrollTrack = this.height - ((btnTop.height * 2));
						scrollPerc = ((handle.y - btnTop.height) / (scrollTrack - handle.height));
						_target.y = -(scrollPerc * (_target.height-this.height))
						
						break;
				} // END switch
			} // END if
		} // END function
	}  // END class
} // END package