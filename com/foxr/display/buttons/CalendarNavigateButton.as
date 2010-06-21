package com.foxr.display.buttons {

	import com.foxr.display.components.Calendar;
	import com.foxr.display.components.MultiMonthCalendar;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * An extention of NavigateButton that adds date support and 
	 * linkage to both Caldar and multi month calendar objects.
	 * <p />
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * @see				com.foxr.display.components.Calendar Calendar
	 * @see				com.foxr.display.components.MultiMonthCalendar MultiMonthCalendar
	 * @see				com.foxr.display.buttons.NavigateButton NavigateButton
	 *
	 */
	public class CalendarNavigateButton extends NavigateButton {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Date Object
		 * @var _date:Date
		 */
		private var _date:Date = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ScrollbarButton instance
		 *
		 */
		public function CalendarNavigateButton() { super(); }
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies the buttons date for navigation purposes.
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public function set date(d:Date):void { _date = (d != null) ? d : new Date(); }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * @since	1.0
		 * @param	e	Event response object
		 *
		 */
		protected override function onMouseClick(e:MouseEvent):void {
			if (parentObj.toString().toLowerCase().indexOf('multimonthcalendar') != -1) {
				MultiMonthCalendar(parent).changeDate(_date);
			} else if (parentObj.toString().toLowerCase().indexOf('calendar') != -1) {
				Calendar(parent).date = _date;
			}
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}