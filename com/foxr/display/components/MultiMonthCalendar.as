package com.foxr.display.components {

	import com.foxr.display.buttons.NavigateButton;
	import com.foxr.display.buttons.CalendarNavigateButton;
	import com.foxr.display.buttons.StandardButton;
	import com.foxr.display.components.Calendar;
	import com.foxr.display.TextElement;
	import com.foxr.util.*;
	import flash.text.TextFormat;
	
	import flash.events.*;
	/**
	 * This control displays two embedded Calendar objects in side by side fashion to show two months
	 * at a time. it allows the user to browse forward and back months and see a summary of their selections.
	 * <p />
	 * <b>UI Notes</b>:<br />
	 * When embedded within a Form object, this control displays a 
	 * submit button as well.
	 * <p />
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 * @version			1.09
	 * 
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * @see				com.foxr.display.components.Form Form
	 * 
	*/
	public class MultiMonthCalendar extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		
		// Constants
		/**
		 * All Dates Available.
		 * @const	AVAILABLE_ALL:Number
		 */
		public static const AVAILABLE_ALL:Number = 0;
		/**
		 * Dates After _today Available.
		 * @const	AVAILABLE_AFTER_TODAY:Number
		 */
		public static const AVAILABLE_AFTER_TODAY:Number = 1;
		/**
		 * Dates after _startDate available
		 * @const	AVAILABLE_AFTER_DATE:Number
		 */
		public static const AVAILABLE_AFTER_DATE:Number = 2;
		/**
		 * Calendar Copy PAth
		 * @const	CALENDAR_COPY_PATH:String
		 */
		public static const CALENDAR_COPY_PATH:String = 'global.general.elements.calendar.';
		
		
		// STAGE OBJECTS		
		/**
		 * Left Calendar.
		 * @var	calLeft:Calendar
		 */
		private var calLeft:Calendar = null;
		/**
		 * Right Calendar.
		 * @var	calRight:Calendar
		 */
		private var calRight:Calendar = null;
		/**
		 * Back Month Button.
		 * @var	btnBackMonth:CalendarNavigateButton
		 */
		private var btnBackMonth:CalendarNavigateButton = null;
		/**
		 * Ahead Month Button.
		 * @var	btnAheadMonth:CalendarNavigateButton
		 */
		private var btnAheadMonth:CalendarNavigateButton = null;
		/**
		 * Clear Button.
		 * @var	btnClear:StandardButtonn
		 */
		private var btnClear:StandardButton = null;
		/**
		 * Submit Button.
		 * @var	btnClear:StandardButtonn
		 */
		private var btnSubmit:StandardButton = null;
		/**
		 * Selected Date.
		 * @var	txtSelectedDates:TextElement
		 */
		private var txtSelectedDates:TextElement = null;
		/**
		 * Selected Date Length.
		 * @var	txtSelectedLength:TextElement
		 */
		private var txtSelectedLength:TextElement = null;
		// DATA VARS
		/**
		 * Selection Start Date.
		 * @var	_dateStart:Date
		 */
		private var _dateStart:Date = null;
		/**
		 * Selection End Date.
		 * @var	_dateEnd:Date
		 */
		private var _dateEnd:Date = null;
		/**
		 * Calendar Start Date.
		 * @var	_startDate:Date
		 */
		private var _startDate:Date = null;	
		/**
		 * Start Date Type.
		 * @var	_startDateType:Number
		 */
		private var _startDateType:Number = AVAILABLE_ALL;
		/**
		 * Todays Date minus time.
		 * @var	_today:Date
		 */
		private var _today:Date = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new MultiMonthCalendar instance
		 *
		 */
		public function MultiMonthCalendar() {
			
			// capture todays date
			var tmpToday:Date = new Date();
			_today = new Date(tmpToday.getFullYear(),tmpToday.getMonth(),tmpToday.getDate());
			
			// Calendar Objects
			calLeft = Calendar(addElement('calLeft', Calendar,{embedded:true} ));
			calRight = Calendar(addElement('calRight', Calendar,{embedded:true}));
			
			// navigation Buttons
			btnBackMonth = CalendarNavigateButton(addElement('btnBackMonth', CalendarNavigateButton,{width:12,height:12,type:NavigateButton.BACKWARD}));
			btnAheadMonth = CalendarNavigateButton(addElement('btnAheadMonth', CalendarNavigateButton, { width:12,height:12,type:NavigateButton.FORWARD } ));
			
			// Clear Button
			btnClear = StandardButton(addElement('btnClear', StandardButton, { text:'Clear Calendar', backgroundColor:0xFFFFFF } ));
			btnClear.addEventListener(MouseEvent.CLICK, onClearClick);
			
			// Selected date fields
			txtSelectedDates = TextElement(addElement('txtSelectedDates', TextElement));
			txtSelectedLength = TextElement(addElement('txtSelectedLength', TextElement));
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Overrides the default property to apply background properties to the object.
		 * @param	c	The color in 0x000000 format.
		 * @since	1.0
		 */
		public override function set backgroundColor(c:Number):void { super.backgroundColor = c; bkgd.visible = true; }
		/**
		 * Defines the css style object for the objects buttons.
		 * @param	h	The height ihn pixels.
		 * @since	1.0
		 */
		public function set buttonsStyle(s:Object):void { 
			btnClear.applyProperties(s);
			btnSubmit.applyProperties(s);
		}
		/**
		 * Defines the css text format object for the objects buttons.
		 * @param	h	The height ihn pixels.
		 * @since	1.0
		 */
		public function set buttonsTextStyle(s:TextFormat):void { 
			btnClear.textStyle = s;
			btnSubmit.textStyle = s;
		}
		/**
		 * Defines the height of the text input portion of the control.
		 * @param	h	The height ihn pixels.
		 * @since	1.0
		 */
		public function set calendarStyle(s:Object):void { 
			calLeft.applyProperties(s); 
			calRight.applyProperties(s);
		}
		/**
		 *	Applies a css class name argument to be used to style the embedded text field.
		 *  @param	c	CSS Text Format Class
		 *  @since 	0.2.1
		 */
		public override function set cssTextClass(c:String):void { 
			super.cssTextClass = c; 
			txtSelectedDates.cssClass = txtSelectedLength.cssClass = c;
			calLeft.cssTextClass = c;
			calRight.cssTextClass = c;
		}	
		/**
		 * Sets the users selection and based on status vars, updates the calendar display.
		 * @param	d	The selected date
		 * @since	1.0
		 */
		public function set date(d:Date):void { 
			var strStartDate:String = ' ';
			var strEndDate:String = ' ';
			if (d != null) {
				// IF no start date has been defined, define it
				var rightDate:Date = null;
				if (_dateStart == null) {
					checkStart(d);
				// if we have a start date, but no end date, define it
				} else if (_dateStart != null && _dateEnd == null) {
					checkEnd(d);
				// if we have both start and end dates selected, clear the calendar and set a new starting date			
				} else if (_dateStart != null && _dateEnd != null) {
					reset();
					date = d;
				} // END if
			} else {
				reset();
			} // End if
			
			strStartDate = (_dateStart != null) ? DateUtils.localizeDate(_dateStart) : ' ';
			strEndDate = (_dateEnd != null) ? DateUtils.localizeDate(_dateEnd) : ' ';
			
			if (gpm.copy.getCopyString(CALENDAR_COPY_PATH+'calSelectedDates')) 
				txtSelectedDates.setDynamicString(CALENDAR_COPY_PATH+'calSelectedDates',{'{DATE_START}':strStartDate,'{DATE_END}':strEndDate});
			else
				txtSelectedDates.text = strStartDate + " - " + strEndDate; // END if
				
			var selectedLen:Number = 0;
			selectedLen = (_dateStart != null && _dateEnd != null) ? int(Math.abs(_dateStart.getTime() - _dateEnd.getTime()) / (((1000 * 60) * 60) * 24)): 0;
			if (gpm.copy.getCopyString(CALENDAR_COPY_PATH+'calSelectedLength')) {
				txtSelectedLength.setDynamicString(CALENDAR_COPY_PATH+'calSelectedLength',{'{DAYS_LEN}':selectedLen.toString()}); // END if
			} else 
				txtSelectedLength.text = selectedLen.toString(); // END if
				
			value = {start:_dateStart, end:_dateEnd};
			
			if (_dateEnd != null) dispatchEvent(new Event(Event.SELECT));
		}
		/**
		 * Overrides the default height function to set the vertical alignment of the calendar elements.
		 * @param	h	The height in pixels
		 * @since	1.0
		 */
		public override function set height(h:Number):void { 
			super.height = h;
			bkgd.height = h;
		}
		/**
		 * Applies non-localized dynamic text to the calendars label text element.
		 * @param	t	The text string
		 * @since	1.0
		 */
		public function set labelText(t:String):void { 
			txt.text = t; 
			if (t != '') {
				txt.visible = true; 
			}
			updateLayout(); 
		}
		/**
		 * Applies a localized copy string ID to the calendars label text element.
		 * @param	s	Localized copy string ID
		 * @since	1.0
		 */
		public function set labelString(s:String):void { 
			txt.string = s; 
			gpm.log.debug(name + " labelString = " + s);
			if (s != '' && txt.text != '') {
				txt.visible = true; 
			}
			gpm.log.debug(name + ".txt string path  = " + s);
			gpm.log.debug(name + ".txt.text = " + txt.text);
			gpm.log.debug(name + ".txt.font = " + txt.style.font);
			updateLayout(); 
		}
		/**
		 * Sets thew first date available for selection if other than today.
		 * @param	sd	The starting date object
		 * @return		The starting date object
		 * @since	1.0
		 */
		public function get startDate():Date { return calLeft.startDate; }
		public function set startDate(d:Date):void { _startDate = d; }
		/**
		 * Applies and returns which type of start date this calendar supports. options are:
		 * <ul>
		 * 		<li><b>All</b> - All dates are available, even if in the past</li>
		 * 		<li><bAfter Today</b> - Any date after the current date only</li>
		 * 		<li><b>After Start Date</b> - After a specified starting date only</li>
		 * </ul>
		 * @param	t	The Starting daste type
		 * @return		The Starting daste type
		 * @since	1.0
		 */
		public function get startDateType():Number { return _startDateType; }
		public function set startDateType(t:Number):void { _startDateType = t; }
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
			txtSelectedDates.style = txtSelectedLength.style = s; 
			calLeft.textStyle = calRight.textStyle = s;
			btnClear.textStyle = s;
			btnSubmit.textStyle = s;
		}
		/**
		 * Overrides the default width function to set the horizontal alignment of the calendar elements.
		 * @param	w	The width in pixels
		 * @since	1.0
		 */
		public override function set width(w:Number):void {
			super.width = w;
			bkgd.width = w;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the base date of the calendar based on the user clicking the forward and 
		 * back navigation buttons.
		 * @param	d	The selected date
		 * @since	1.0
		 */
		public function changeDate(d:Date):void {
			if (d != null) {
				calLeft.date = d;
				calRight.date = new Date(d.getFullYear(), d.getMonth() + 1, d.getDate());
				btnBackMonth.date = new Date(d.getFullYear(), d.getMonth() - 1, d.getDate());
				btnAheadMonth.date = new Date(d.getFullYear(), d.getMonth() + 1, d.getDate());
				checkStart();
				checkEnd();
			} // END if
		}
		/**
		 * Fired once the ovject has been added to the stage and is in the ActiveDisplay list.
		 * @param	e	Event Object
		 * @since	1.0
		 */
		public override function objReady(e:Event):void{
			super.objReady(e);
			// APPLY CSS VALUES IF THEY EXIST
			if (gpm.css.getStyle('button_clear_calendar') != null) btnClear.applyProperties(gpm.css.getStyle('button_clear_calendar'));
			if (gpm.css.getStyle('button_submit_calendar') != null) btnClear.applyProperties(gpm.css.getStyle('button_submit_calendar'));
			// APPLY LOCALIZED COPY STRINGS IF THEY EXIST
			if (gpm.copy.getCopyString(CALENDAR_COPY_PATH+'calSelectedLength')) txtSelectedLength.setDynamicString(CALENDAR_COPY_PATH+'calSelectedLength',{'{DAYS_LEN}':'0'});
			if (gpm.copy.getCopyString(CALENDAR_COPY_PATH+'calSelectedDates')) txtSelectedDates.setDynamicString(CALENDAR_COPY_PATH+'calSelectedDates',{'{DATE_START}':'','{DATE_END}':''});
			updateLayout();
			show();
		}		
		/**
		 * Resets calendar selections and reinitializes.
		 * @param	e	Event Object
		 * @since	1.0
		 */
		public function reset():void {
			_dateStart = null;
			_dateEnd = null;
			
			var leftStart:Date = null;
			switch (_startDateType) {
				case AVAILABLE_AFTER_TODAY:
					leftStart = _today;
					break;
				case AVAILABLE_AFTER_DATE:
					leftStart = _startDate;
					break;
				default:
					break;
			}
			calLeft.date = calLeft.startDate = leftStart;
			calRight.date = new Date(leftStart.getFullYear(), leftStart.getMonth() + 1, leftStart.getDate());
			calLeft.selectedDate = calRight.startDate = calRight.selectedDate = null;
		}
		/**
		 * Overrides the default show() method and adds a startup decision of which inital date to display..
		 * @param	e	Event Object
		 * @since	1.0
		 */
		public override function show():void{
			if (_startDate != null) changeDate(_startDate) 
			else changeDate(_today);
			super.show();
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies a selection ending date value (if passed) and if an end date value exists,
		 * updates the calendards display to show it.
		 * @param	d	Date Object (Optional)
		 * @since	1.0
		 */
		private function checkEnd(d:Date=null):void {
			var rightDate:Date = calRight.date;
			var leftDate:Date = calLeft.date;
			if (d != null) _dateEnd = new Date(d.getFullYear(), d.getMonth(), d.getDate());
			// Assure selected end date is within visible time window
			if (_dateEnd != null) {
				if (_dateEnd.getTime() >= new Date(leftDate.getFullYear(), leftDate.getMonth(), 1).getTime() && 
				_dateEnd.getTime() < new Date(rightDate.getFullYear(), rightDate.getMonth() + 1, 1).getTime()) {
					// check if selected end date appears in left or right calendars
					if (_dateEnd.getTime() < new Date(calRight.date.getFullYear(), calRight.date.getMonth(), 1).getTime()) {
						calLeft.selectedEndDate = _dateEnd;
					} else {
						if (_dateStart.getTime() < new Date(calRight.date.getFullYear(), calRight.date.getMonth(), 1).getTime()) {
							calRight.selectedDate = _dateStart;
						}
						calLeft.selectedEndDate = _dateEnd;
						calRight.selectedEndDate = _dateEnd;
					} // END if
				} // END if
			} // END if
		}
		/**
		 * Applies a selection starting date value (if passed) and if an start date value exists,
		 * updates the calendards display to show it. This method also updates the child calendars
		 * display in the case that no starting selection date value has been applied.
		 * @param	d	Date Object (Optional)
		 * @since	1.0
		 */
		private function checkStart(d:Date=null):void {
			var rightDate:Date = calRight.date;
			var leftDate:Date = calLeft.date;
			if (d != null)_dateStart = new Date(d.getFullYear(), d.getMonth(), d.getDate());
			// Assure selected end date is within visible time window
			if (_dateStart != null) {
				if (_dateStart.getTime() >= new Date(leftDate.getFullYear(), leftDate.getMonth(), 1).getTime() && 
				_dateStart.getTime() < new Date(rightDate.getFullYear(), rightDate.getMonth() + 1, 1).getTime()) {
					// diable all dates prior to the selected start date
					// first detemrine which child calendar the selected date falls under
					if (_dateStart.getTime() < new Date(rightDate.getFullYear(), rightDate.getMonth(), 1).getTime()) {
						// start date is in left calendar
						calLeft.startDate =  calLeft.selectedDate = _dateStart;
						calRight.date = new Date(_dateStart.getFullYear(), _dateStart.getMonth() + 1, _dateStart.getDate());
						calRight.selectedDate = null;
					} else {
						// diable all items in left calendar
						calLeft.startDate =  calLeft.selectedDate = null;
						calLeft.enabled = false;
						calRight.startDate =  calRight.selectedDate = _dateStart;
					} // END if
				} else if (_dateStart.getTime() > new Date(rightDate.getFullYear(), rightDate.getMonth() + 1, 1).getTime()) {
					// if the selected start date if off the visible area and in the future, disable both calendars
					// there is no ele for the other condition as the calendar will be active in that case
					calLeft.startDate =  calLeft.selectedDate = null;
					calLeft.enabled = false;
					calRight.startDate =  calRight.selectedDate = null;
					calRight.enabled = false;
				} // END if
			} else {
				// NO START DATE VALUE. ASSURE CALENDAR IS PROPERLY DISPLAYED
				// assure the calendars are enabled and disabled proeprly based on the start date type variable
				calLeft.startDate = calLeft.selectedDate = calRight.startDate = calRight.selectedDate = null;
				if (_startDateType != AVAILABLE_ALL) {
					var testDate:Date = null;
					switch (_startDateType) {
						case AVAILABLE_AFTER_TODAY:
							testDate = _today;
							break;
						case AVAILABLE_AFTER_DATE:
							testDate = _startDate;
							break;
						default:
							break;
					}
					// Perform tests
					if (testDate != null) {
						if (testDate.getTime() >= new Date(leftDate.getFullYear(), leftDate.getMonth(), 1).getTime() && 
						testDate.getTime() < new Date(rightDate.getFullYear(), rightDate.getMonth() + 1, 1).getTime()) {
							 if (testDate.getTime() < new Date(rightDate.getFullYear(), rightDate.getMonth(), 1).getTime()) {
								 calLeft.startDate = testDate;
							 } else {
								 calLeft.enabled = false;
								 calRight.startDate = testDate;
							 }
						} else if (testDate.getTime() < new Date(leftDate.getFullYear(), leftDate.getMonth(), 1).getTime()) {
							calLeft.enabled = calRight.enabled = true;
						} else {
							calLeft.enabled = calRight.enabled = false;	
						}
					}
				} else {
					calLeft.enabled = calRight.enabled = true;
				}
			} // END if
		}
		/**
		 * Redraws the objects layouit based on contents properties.
		 * @since	1.0
		 */
		private function updateLayout():void {
			
			// Set calendar and nav button horizontal positions
			btnBackMonth.x = _padding;
			calLeft.x = (btnBackMonth.x + btnBackMonth.width) + _padding;
			calRight.x = ((calLeft.x + calLeft.width) + _padding);
			btnAheadMonth.x = ((calRight.x + calRight.width) + _padding);

			// DRAW LABELS Y POSITION AND UPDATE TOP PAD IS THERE IS TEXT
			var topPad:Number = _padding;
			if (txt.text != '') {
				txt.y = _padding;
				topPad += (txt.y + txt.textHeight) + _padding;
			} // END if
			
			// Start Y positioning
			calLeft.y = topPad;
			calRight.y = topPad;
			btnBackMonth.y = calLeft.y + (calLeft.height / 2);
			btnAheadMonth.y = calLeft.y + (calLeft.height / 2);
			
			// position Clear Button
			var bottomGutter:Number = btnClear.height + (_padding * 2);
			btnClear.x = (_width / 2) - (btnClear.width / 2);
			btnClear.y = (calLeft.y + calLeft.height) + _padding;
			
			// If status fields have text values, position them
			var bottomPad:Number = _padding; 
			if (txtSelectedDates.text != '' && txtSelectedLength.text != '') {
				txtSelectedDates.x = txtSelectedLength.x = _padding;
				txtSelectedDates.y = (btnClear.y + btnClear.height) + _padding;
				txtSelectedLength.y = (txtSelectedDates.y + txtSelectedDates.height);
				bottomPad += ((txtSelectedDates.textHeight + txtSelectedLength.textHeight) + 2) + _padding;
			} // END if
			
			// Set teh objects width and height based on all above UI objects
			width = (btnAheadMonth.x + btnAheadMonth.width) + _padding;
			height = (((calLeft.height + (_padding * 2)) + bottomPad) + bottomGutter) + topPad;
			
			// center the text label at the top of the control if it has text
			if (txt.text != '')
				txt.x = (_width / 2) - (txt.textWidth / 2); // END if
		}
		/**
		 * ON CLEAR CLICK.
		 * Event handler for the Clear button clcik event.
		 * @since	1.0
		 */
		private function onClearClick(e:Event):void { date = null; }
	}
	
}