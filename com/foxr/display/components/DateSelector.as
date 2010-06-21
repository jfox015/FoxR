package com.foxr.display.components {
	
	import com.foxr.display.*;
	import com.foxr.display.graphics.*;
	import com.foxr.util.*;
	import flash.text.TextFormat;
	
	import flash.events.*;
	/**
	 * The DateSeelctor component displays a field to display a date and a button to 
	 * trigger the opening of a calendar object.
	 * <p />
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */

	public class DateSelector extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Date.
		 * _date:Date
		 * @since	1.0
		 */
		private var _date:Date = null;
		/**
		 * Calendar.
		 * calendar:Calendar
		 * @since	1.0
		 */
		private var calendar:Calendar = null;
		/**
		 * Calndar icon.
		 * calIcon:CalendarIcon
		 * @since	1.0
		 */
		private var calIcon:CalendarIcon = null;
		/**
		 * Locale.
		 * _locale:String
		 * @since	1.0
		 */
		private var _locale:Locale = null;
		/**
		 * Selected Date.
		 * _selectedDate:String
		 * @since	1.0
		 */
		private var _selectedDate:String = '';
		/**
		 * Text Input Box.
		 * txtInput:TextInput
		 * @since	1.0
		 */
		private var txtInput:TextInput = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new DateSelector instance
		 *
		 */
		public function DateSelector() { 
			_locale = gpm.config.locale;
			txtInput = TextInput(addElement('txtInput', TextInput ));
			calIcon = CalendarIcon(addElement('calIcon', CalendarIcon ));
			calendar = Calendar(addElement('calendar', Calendar, { x:20, y:20, visible:false } ));
			if (_date == null) calendar.date = new Date();
			width = 150;
			height = 20;
			enabled = true;
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alpha of the objects background. 
		 * @since	1.17
		 * @param	a	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The backgrounds alpha value
		 */
		public override function get backgroundAlpha():Number { return txtInput.alpha; }
		public override function set backgroundAlpha(a:Number):void { txtInput.alpha = a; }
		/**
		 * Changes the color of the objects background. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get backgroundColor():Number { return txtInput.backgroundColor; }
		public override function set backgroundColor(c:Number):void { txtInput.backgroundColor = c; }
		/**
		 * Changes the alpha (transparency) of the objects border. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The borders alpha value
		 */
		public override function get borderAlpha():Number { return txtInput.borderAlpha; }
		public override function set borderAlpha(a:Number):void { txtInput.borderAlpha=a; }
		/**
		 * If borderWeight is set, this changes the color of the objects border. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get borderColor():Number { return txtInput.borderColor; }
		public override function set borderColor(c:Number):void { txtInput.borderColor=c; }
		/**
		 * Changes the width (size) of the objects border. 
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public override function get borderWidth():Number { return txtInput.borderWidth; }
		public override function set borderWidth(w:Number):void { txtInput.borderWidth=w; }
		/**
		 * Applies dynamic (non-locale) text to the calendar's label. 
		 * @param	The Label String.
		 * @since	1.0
		 */
		public function set calendarLabelText(t:String):void { calendar.labelText = t; }
		/**
		 * Applies locale switchable string ID to the calendar's label. 
		 * @param	The locale library string ID.
		 * @since	1.0
		 */
		public function set calendarLabelString(s:String):void { calendar.labelString = s; }
		/**
		 * Defines the height of the text input portion of the control.
		 * @param	h	The height ihn pixels.
		 * @since	1.0
		 */
		public function set calendarStyle(s:Object):void { calendar.applyProperties(s); }
		
		public override function get className():Class { return DateSelector; }
		/**
		 *	Applies a css class name argument to be used to style the embedded text field.
		 *  @param	c	CSS Text Format Class
		 *  @since 	0.2.1
		 */
		public override function set cssTextClass(c:String):void { 
			super.cssTextClass = c; 
			calendar.cssTextClass = c;
		}	
		/**
		 * Applies and retrives a default date to the control and child calendar object. 
		 * @param	d	Date object.
		 * @return		Objects current Date as a Date object.
		 * @since	1.0
		 */
		public function get date():Date { return _date; }
		public function set date(d:Date):void { 
			_date = d; 
			txtInput.text = DateUtils.localizeDate(_date);
			hideCalendar();
		}
		/**
		 * Returns the i18n formatted date value. 
		 * @return		Objects current Date in locale specific date format.
		 * @since	1.0
		 */
		public function get i18nDate():String { return DateUtils.localizeDate(_date,_locale); }
		/**
		 * overrides the default enabled function to enable and diable child elements. 
		 * @param	e	TRUE or FALSE
		 * @since	1.0
		 */
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
			txtInput.enabled = e;
			calIcon.useHandCursor = calIcon.buttonMode = e;
			calIcon.mouseChildren = !e;
			if (e) {
				calIcon.addEventListener(MouseEvent.CLICK, onCalendarIconClick);
			} else {
				calIcon.removeEventListener(MouseEvent.CLICK, onCalendarIconClick);
			}
		}
		/**
		 * Overrides the default enabled function to enable and diable child elements. 
		 * @param	e	TRUE or FALSE
		 * @since	1.0
		 */
		public function get firstAvailableDate():Date{ return calendar.startDate; }
		public function set firstAvailableDate(d:Date):void { calendar.startDate = d; }
		/**
		 * Defines the height of the text input portion of the control.
		 * @param	h	The height ihn pixels.
		 * @since	1.0
		 */
		public override function set height(h:Number):void {
			super.height = h;
			txtInput.height = h;
			calIcon.y = (txtInput.height / 2) - (calIcon.height / 2);
		}
		/**
		 * Applies non-localized dynamic text to the calendars label text element.
		 * @param	t	The text string
		 * @since	1.0
		 */
		public function set labelText(t:String):void { 
			calendar.text = t;
		}
		/**
		 * Applies a localized copy string ID to the calendars label text element.
		 * @param	s	Localized copy string ID
		 * @since	1.0
		 */
		public function set labelString(s:String):void { 
			calendar.string = s;
		}
		/**
		 * Overrides and returns the locale for the date selector. The default locale is chosen from
		 * the Globals.data.locale object. Changing the locale will affect how the date is both displayed 
		 * and returned by this control.
		 */
		public function get locale():Locale { return _locale; }
		public function set locale(l:Locale):void { _locale = l; }
		/**
		 * Applies a general text style to all text elements. Overrides the 
		 * default TextStyle property in CompoundElement
		 * 
		 * @param	s	TextFormat object
		 * @see			com.fox.display.CompoundElement
		 * @since		1.0.9
		 */
		public override function set textStyle(s:TextFormat):void {
			super.textStyle = s;
			txtInput.textStyle = s;
			calendar.textStyle = s;
		}
		/**
		 * Defines the width of the text input portion of the control.
		 * @param	w	The width ihn pixels.
		 * @since	1.0
		 */
		public override function set width(w:Number):void {
			super.width = w;
			txtInput.width = w;
			calIcon.x = (txtInput.x + txtInput.width) + _padding;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * 	Disables and hides the calendar.
		 *	@since	1.0
		 */
		public function hideCalendar():void { 
			enabled = true;
			calendar.hide(); 
		}
		/**
		 * 	Enables and shows the calendar.
		 *	@since	1.0
		 */
		public function showCalendar():void { 
			enabled = false;
			if (_date != null) calendar.date = new Date(_date.getFullYear(), _date.getMonth(), _date.getDate());
			
			calendar.show(); 
		}
		/**
		 * 	Handles the calendar icon click event.
		 *	@since	1.0
		 */
		public function onCalendarIconClick(e:Event):void {
			if (calendar.visible) hideCalendar();
			else showCalendar();
		}
	} // END class
} // END package