package com.foxr.display.buttons {

	import com.foxr.display.components.*;
	import flash.text.TextFormat;
	
	import flash.events.*;
	/**
	 * An extension of StandardButton that adds date display
	 * specific style set/gets and date handling functionality. This object is designed to work
	 * exclusively as a child object of the the Calendar
	 * class. Independant usage is not recommended.
	 * 
	 * <p />
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * @see				com.foxr.display.buttons.StandardButton StandardButton
	 * @see				com.foxr.display.ctonrols.Calendar Calendar
	 *
	*/
	public class CalendarDateButton extends StandardButton {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STAGE OBJECTS
		// DATA VARS
		/**
		 * Date Object
		 * @var _date:Date
		 */
		private var _date:Date = null;
		/**
		 * Today date value
		 * @var _today:Date
		 */
		private var _today:Date = null;
		/**
		 * Highlighted Flag
		 * @var _highlighted:Boolean
		 */
		private var _highlighted:Boolean = false;
		/**
		 * Peristsnet Highlight Flag
		 * @var _persistent:Boolean
		 */
		private var _persistent:Boolean = false;
		
		// STYLES
		/**
		 * Enabled Background Color
		 * @var _clrBgEnabled:Number
		 */
		private var _clrBgEnabled:Number = 0xEEEEEE;
		/**
		 * Disabled Background Color
		 * @var _clrBgDisabled:Number
		 */
		private var _clrBgDisabled:Number = 0xDDDDDD;
		/**
		 * Today Background Color
		 * @var _clrBgToday:Number
		 */
		private var _clrBgToday:Number = 0xCCCCFF;
		/**
		 * Selected Background Color
		 * @var _clrBgSelected:Number
		 */
		private var _clrBgSelected:Number = 0xFFFFCC;
		/**
		 * Selected Range End Background Color
		 * @var _clrBgSelectRangeEnd:Number
		 */
		private var _clrBgSelectRangeEnd:Number = 0xFFFFEE;
		/**
		 * Highlighted Background Color
		 * @var _clrBgHighlighted:Number
		 */
		private var _clrBgHighlighted:Number = 0xCCFFCC;
		
		/**
		 * Enabled Border Color
		 * @var _clrBdrEnabled:Number
		 */
		private var _clrBdrEnabled:Number = 0x999999;
		/**
		 * Disabled Border Color
		 * @var _clrBdrDisabled:Number
		 */
		private var _clrBdrDisabled:Number = 0xCCCCCC;
		/**
		 * Today Border Color
		 * @var _clrBdrToday:Number
		 */
		private var _clrBdrToday:Number = 0x000060;
		/**
		 * Selected Border Color
		 * @var _clrBdrSelected:Number
		 */
		private var _clrBdrSelected:Number = 0xCC0000;
		/**
		 * Selected Range End Border Color
		 * @var _clrBdrSelectRangeEnd:Number
		 */
		private var _clrBdrSelectRangeEnd:Number = 0xCC0000;
		/**
		 * Highlighted Border Color
		 * @var _clrBdrHighlighted:Number
		 */
		private var _clrBdrHighlighted:Number = 0x006000;
		
		/**
		 * Enabled Text Color
		 * @var _clrTxtEnabled:Number
		 */
		private var _clrTxtEnabled:Number = 0x000000;
		/**
		 * Disabled Text Color
		 * @var _clrTxtDisabled:Number
		 */
		private var _clrTxtDisabled:Number = 0x888888;
		/**
		 * Today Text Color
		 * @var _clrTxtToday:Number
		 */
		private var _clrTxtToday:Number = 0x000060;
		/**
		 * Selected Text Color
		 * @var _clrTxtSelected:Number
		 */
		private var _clrTxtSelected:Number = 0xCC0000;
		/**
		 * Selected Range End Text Color
		 * @var _clrTxtSelectRangeEnd:Number
		 */
		private var _clrTxtSelectRangeEnd:Number = 0xCC0000;
		/**
		 * Highlighted Text Color
		 * @var _clrTxtHighlighted:Number
		 */
		private var _clrTxtHighlighted:Number = 0x006000;
		
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new CalendarDateButton instance
		 *
		 */
		public function CalendarDateButton() { 
			sizeType = SIZE_FIXED;
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *  Sets the color of background for the object normal state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public override function get backgroundColor():Number { return _clrBgEnabled;  }
		public override function set backgroundColor(c:Number):void { _clrBgEnabled = c;  }
		/**
		 *  Sets the color of border for the object normal state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public override function get borderColor():Number { return _clrBdrEnabled;  }
		public override function set borderColor(c:Number):void { _clrBdrEnabled = c;  }
		/**
		 *  Sets the objects date object value and redraws the styles based on the value.
		 *  @param		d	Flash Date object
		 *  @return			Flash Date object
		 *  @since 		1.0
		 */
		public function get date():Date { return _date; } 
		public function set date(d:Date):void {
			var tmpDate:Date = new Date();
			_today = new Date(tmpDate.getFullYear(),tmpDate.getMonth(),tmpDate.getDate());
			_date = d;

			if (d != null) {
				txt.text = String(d.getDate());
				//gpm.log.debug(name + " Start Date = " + Calendar(parent).startDate + ", this Date = " + txt.text);
				var txtFrmt:TextFormat = new TextFormat();
				// IF this date is the same as the parent Calendar's selected date, set color cheme to SELECTED
				if (Calendar(parent).selectedDate != null && d.getTime() == Calendar(parent).selectedDate.getTime()) { 
					enabled = true;
					select();
				} else if (d.getTime() == _today.getTime()) { 
					enabled = true;
					bkgd.color = _clrBgToday; 
					bkgd.borderColor  = _clrBdrToday;
					txtFrmt.color = _clrTxtToday;
					txt.style = txtFrmt;
				} else {
					if (Calendar(parent).startDate) 
						this.enabled = (d.getTime() >= Calendar(parent).startDate.getTime()) ? true : false;
					else	
						enabled = true;
				}// END if
			} else {
				txt.text = '';
				this.enabled = false;
			} // END if
		}
		/**
		 *  Sets the color of background when in the diaabled state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get disabledBackgroundColor():Number { return _clrBgDisabled;  }
		public function set disabledBackgroundColor(c:Number):void { _clrBgDisabled = c; }
		/**
		 *  Sets the color of border when in the diaabled state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get disabledBorderColor():Number { return _clrBdrDisabled;  }
		public function set disabledBorderColor(c:Number):void { _clrBdrDisabled = c; }
		/**
		 *  Sets the color of text when in the diaabled state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get disabledTextColor():Number { return _clrTxtDisabled;  }
		public function set disabledTextColor(c:Number):void { _clrTxtDisabled = c; }
		/**
		 *  Enables and disables the object.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void {
			// Double check the enabled state against the objects _date property. 
			// Null _date buttons are always disabled
			e = (e && _date != null) ? true : false;
			_enabled = e;
			if (e) {
				if (!this.hasEventListener(MouseEvent.CLICK))
					this.addEventListener(MouseEvent.CLICK, onMouseClick); // END if
				if (!this.hasEventListener(MouseEvent.MOUSE_OVER))	
					this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver); // END if
				if (!this.hasEventListener(MouseEvent.MOUSE_OUT))		
					this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut); // END if
			} else {
				if (this.hasEventListener(MouseEvent.CLICK))
					this.removeEventListener(MouseEvent.CLICK, onMouseClick); // END if
				if (this.hasEventListener(MouseEvent.MOUSE_OVER))	
					this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver); // END if
				if (this.hasEventListener(MouseEvent.MOUSE_OUT))		
					this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut); // END if
			} // END if
			this.useHandCursor = this.buttonMode = e;
			this.mouseChildren = !e;
			bkgd.color = e ?  _clrBgEnabled : _clrBgDisabled;
			bkgd.borderColor = e ?  _clrBdrEnabled : _clrBdrDisabled;
			var txtFrmt:TextFormat = new TextFormat();
			txtFrmt.color = e ? _clrTxtEnabled : _clrTxtDisabled;
			txt.style = txtFrmt;
		}
		/**
		 * Changes the height of the object. 
		 * @since	1.0
		 * @param	b	The height in pixels
		 * @return		The height in pixels
		 */
		public override function set height(h:Number):void {
			super.height = h;
			txt.y = (h / 2) - (txt.textHeight / 2);
		}
		/**
		 *  Sets the color of background when in the highlited state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get highlightedBackgroundColor():Number { return _clrBgHighlighted;  }
		public function set highlightedBackgroundColor(c:Number):void { _clrBgHighlighted = c; }
		/**
		 *  Sets the color of border when in the highlited state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get highlightedBorderColor():Number { return _clrBdrHighlighted;  }
		public function set highlightedBorderColor(c:Number):void { _clrBdrHighlighted = c; }
		/**
		 *  Sets the color of text when in the highlited state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get highlightedTextColor():Number { return _clrTxtHighlighted;  }
		public function set highlightedTextColor(c:Number):void { _clrTxtHighlighted = c; }
		/**
		 *  Sets the color of background when in the selected state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get selectedBackgroundColor():Number { return _clrBgSelected;  }
		public function set selectedBackgroundColor(c:Number):void { _clrBgSelected = c; }
		/**
		 *  Sets the color of border when in the selected state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get selectedBorderColor():Number { return _clrBdrSelected;  }
		public function set selectedBorderColor(c:Number):void { _clrBdrSelected = c; }
		/**
		 *  Sets the color of text when in the selected state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get selectedTextColor():Number { return _clrTxtSelected;  }
		public function set selectedTextColor(c:Number):void { _clrTxtSelected = c; }
		/**
		 *  Sets the color of text when in the normal state.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get textColor():Number { return _clrTxtEnabled;  }
		public function set textColor(c:Number):void { _clrTxtEnabled = c;  }
		/**
		 *  Sets the color of background when in the object displays the current date.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get todayBackgroundColor():Number { return _clrBgToday;  }
		public function set todayBackgroundColor(c:Number):void { _clrBgToday = c; }
		/**
		 *  Sets the color of border when in the object displays the current date.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get todayBorderColor():Number { return _clrBdrToday;  }
		public function set todayBorderColor(c:Number):void { _clrBdrToday = c; }
		/**
		 *  Sets the color of text when in the object displays the current date.
		 *  @param		c	Color in 0x00000 format
		 *  @return			Color in 0x00000 format
		 *  @since 		1.0
		 */
		public function get todayTextColor():Number { return _clrTxtToday;  }
		public function set todayTextColor(c:Number):void { _clrTxtToday = c; }
		/**
		 * Changes the width of the object. 
		 * @since	1.0
		 * @param	b	The width in pixels
		 */
		public override function set width(w:Number):void {
			super.width = w;
			txt.x = (w / 2) - (txt.textWidth / 2);
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Fired when the object has been added to the stage. 
		 * @since	1.0
		 * @param	e	Event Response Object
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			bkgd.color = _clrBgEnabled;
			bkgd.borderWidth = 1;
			bkgd.borderColor = _clrBdrEnabled;
			var txtFrmt:TextFormat = new TextFormat();
			txtFrmt.color = _clrTxtToday;
			txt.style = txtFrmt;
			txt.visible = true;
			bkgd.visible = true;
		}
		/**
		 * Applies the object highlighted styles if h is set to <code>true</code> and the normal  
		 * styles otherwise. Set <code>persistant</code> to TRUE if the highlight should persist 
		 * even on mouse off.
		 * @param	h			TRUE or FALSE
		 * @param	persistent	TRUE or FLASE
		 * @since 	1.0
		 */
		public function highlighted(h:Boolean, persistent:Boolean = false):void {
			_highlighted = h;
			_persistent = persistent;
			bkgd.color = h ? _clrBgHighlighted : _clrBgEnabled;
			bkgd.borderColor = h ?  _clrBdrHighlighted : _clrBdrEnabled;
			if (!bkgd.visible) bkgd.visible = true;
			var txtFrmt:TextFormat = new TextFormat();
			txtFrmt.color = h ? _clrTxtHighlighted : _clrTxtEnabled;
			txt.style = txtFrmt;
		}
		/**
		 * Returns the current highlight state
		 * @param	TRUE or FLASE
		 * @since 	1.0
		 */
		public function isHighlighted():Boolean { return _highlighted; }
		/**
		 * If enabled, this method sets the objects styles to selected range end 
		 * values.
		 * @since 	1.0
		 */
		public function rangeEndSelect():void { 
			if (enabled) {
				bkgd.color = _clrBgSelectRangeEnd; 
				bkgd.borderColor = _clrBdrSelectRangeEnd; 
				_persistent = true;
				var txtFrmt:TextFormat = new TextFormat();
				txtFrmt.color = _clrTxtSelectRangeEnd;
				txt.style = txtFrmt;
			} // END if
		}
		/**
		 * If enabled, this method sets the objects styles to the selected values.
		 * @since 	1.0
		 */
		public function select():void { 
			if (enabled) {
				bkgd.color = _clrBgSelected; 
				bkgd.borderColor = _clrBdrSelected; 
				_persistent = true;
				var txtFrmt:TextFormat = new TextFormat();
				txtFrmt.color = _clrTxtSelected;
				txt.style = txtFrmt;
			} // END if
		}
		/**
		 * If enabled, this method sets the objects styles back to a default state. if the object displays 
		 * the current date, it applie the today styles.
		 * @since 	1.0
		 */
		public function unselect():void { 
			if (enabled && _date != null) {
				bkgd.color = (_date.getTime() == _today.getTime()) ? _clrBgToday : _clrBgEnabled; 
				bkgd.borderColor = (_date.getTime() == _today.getTime()) ? _clrBdrToday : _clrBdrEnabled; 
				_persistent = false;
				var txtFrmt:TextFormat = new TextFormat();
				txtFrmt.color = (_date.getTime() == _today.getTime()) ? _clrTxtToday : _clrTxtEnabled; 
				txt.style = txtFrmt;
			}
		}
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Overrides the deault mouseover to highlight the current item.
		 * @param	e	MouseEvent object
		 * @since 	1.0
		 */
		protected override function onMouseOver(e:MouseEvent):void { if (!isHighlighted()) highlighted(true); }
		/**
		 * Overrides the deault mouseout to un-highlight the current item.
		 * @param	e	MouseEvent object
		 * @since 	1.0
		 */
		protected override function onMouseOut(e:MouseEvent):void {  if (isHighlighted() && !_persistent) highlighted(false); }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Handles the mouse click event. If the current item is a child of a Calendar object, it 
		 * passes the internal date object to the calendar. The object also fires a SELECT event.
		 * @param	e	MouseEvent object
		 * @since 	1.0
		 * @see		com.foxr.diaplsy.components.Calendar
		 */
		private function onMouseClick(e:MouseEvent):void {
			if (parentObj.toString().toLowerCase().indexOf('calendar') != -1)
				Calendar(parent).selectDate(date); // END if
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}