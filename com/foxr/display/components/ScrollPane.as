package com.foxr.display.components {
	
	import com.foxr.display.Element;
	import com.foxr.display.graphics.Box;
	import com.foxr.event.ElementEvent;
	import com.foxr.util.Utils;
	
	import flash.events.Event;
	/**
	 * The scrollpane object draws a scrollable "Window" object to the stage. The contents of 
	 * the scrolpanes child content_elem object can be masked so the object can be shaped to 
	 * fit within areas of a specific size.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 */

	public class ScrollPane extends Component {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STAGE OBJECTS		
		/**
		 * Overflow scroll
		 * @const OVERFLOW_SCROLL:String
		 */
		public static var OVERFLOW_SCROLL:String = 'scroll';
		/**
		 * Overflow auto
		 * @const OVERFLOW_AUTO:String
		 */
		public static var OVERFLOW_AUTO:String = 'auto';
		/**
		 * Scrollable content container
		 * @var	content_mc:UIElement
		 */
		protected var content_elem:Element = null;
		/**
		 * Scrollbar
		 * @var	scrollbar:Scrollbar
		 */
		protected var scrollbar:Scrollbar = null;
		/**
		 * Scrollbar Style
		 * @var	_scrollbarStyle:Object
		 */
		protected var _scrollbarStyle:Object = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollPane instance
		 *
		 */
		public function ScrollPane() {
			super();
			this.removeChild(getChildByName('txt'));
			content_elem = addElement('content_elem', Element);
			content_elem.addEventListener(ElementEvent.ELEMENT_ADDED, onElementAdded);
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the width (size) of the objects border. For the scrollpane it also shifts 
		 * the content inside the scrollpane to the width of the border.
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public override function set borderWidth(w:Number):void { 
			super.borderWidth = w; 
			content_elem.x = content_elem.y = (w / 2);
			setOverflow();
		}
		/**
		 * Override this method when implementing the addition of child content.
		 * @param	contentObj	Object
		 * @since	1.0
		 */
		public function get content():Element { return content_elem; }
		/**
		 * Sets or returns an object containing style properties for the scrollbar component.
		 * @param	s	Style properties object
		 * @return		The current style properties as an object
		 * @since	1.0
		 */
		public function get scrollbarStyle():Object { return _scrollbarStyle; }
		public function set scrollbarStyle(s:Object):void { _scrollbarStyle = s; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Checks the size of the content_mc based on it's lodaed child content and determines, based on overflow 
		 * settings whethr or not to show the scrollbar.
		 * @since	1.0
		 */
		public function refresh():void {
			if (((content_elem.y + content_elem.height) > this.height)
			&& (overflow == OVERFLOW_SCROLL || overflow == OVERFLOW_AUTO)) {
				drawScrollbar();
			} else {
				removeScrollbar();
			} // END if
			setOverflow(content_elem);
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/	
		/**
		 * If the scrollbar is needed, the scrollbar is drawn and attached.
		 * @since	1.0
		 */
		protected function drawScrollbar():Number {
			if (scrollbar == null) this.scrollbar = Scrollbar(addElement('scrollbar',Scrollbar));
			if (_scrollbarStyle != null) scrollbar.applyProperties(_scrollbarStyle);
			scrollbar.x = width;	
			if (sizeType == SIZE_FIXED) scrollbar.x -= scrollbar.width;
			scrollbar.height = this.height;
			scrollbar.target = this.content_elem;
			return scrollbar.width;
		} // END function
		/**
		 * Removes the scrollbar from the object.
		 * @since	1.0
		 */
		protected function removeScrollbar():void {
			if (this.getChildByName('scrollbar') != null)
				this.removeChild(this.getChildByName('scrollbar'));
		}
		/**
		 * Applies overflow settngs to the object.
		 * @since	1.0
		 */
		protected override function setOverflow(targetObj:Element = null):void {
			if (_width > 0 && _height > 0) {
				if (_overflow != Element.OVERFLOW_VISIBLE) {
					var scrollWidth:Number = 0;
					switch (_overflow) {
						case OVERFLOW_SCROLL:
							if (targetObj != null) {
								scrollWidth = drawScrollbar();
								scrollbar.enabled = targetObj.height > _height ? true : false;
							} // End if
							break;
						case OVERFLOW_AUTO:
							// Add the scrollbar
							if (targetObj != null && targetObj.height > _height)
								scrollWidth = drawScrollbar(); // END if
							break;
						default:
							break;
					} // END SWITCH
					if (_mask == null)
						this.mask = _mask = addElement('_mask', Box,{x:content_elem.x,y:content_elem.y,width:_width+scrollWidth,height:(_height-borderWidth),color:0x000000});
					else
						_mask.applyProperties({width:_width+scrollWidth,height:(_height-borderWidth)});
				} else {
					if (_mask != null) this.removeChild(this.getChildByName('_mask')); // END if
					this.mask = null;
				} // END if
			} // END if
		} // END function
		// EVENT HANDLERS
		private function onElementAdded(e:Event):void {
			for (var i:Number = 0; i < content_elem.numChildren; i++) {
				if (content_elem.getChildAt(i).height > content_elem.height)
					content_elem.height = content_elem.getChildAt(i).height; // END if
			} // END for
			refresh();
		}
	}
	
}