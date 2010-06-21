package com.foxr.display.components 
{
	import com.foxr.display.TextElement;
	import com.foxr.display.buttons.*;
	import com.foxr.display.graphics.Box;
	import com.foxr.util.DateUtils;
	import flash.text.TextFormat;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	/**
	 * The FoxR Calendar component can be used to display a graphical calendar for one month.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	*/
	public class Calendar extends Component {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STAGE OBJECTS		
		/**
		 * Inner background object.
		 * @var	bkgdGrid:Box
		 */
		private var bkgdGrid:Box = null;
		/**
		 * Month header background object.
		 * @var	bkgdMonthHeader:Box
		 */
		private var bkgdMonthHeader:Box = null;
		/**
		 * Close Button.
		 * @var	btnClose:CloseButton
		 */
		private var btnClose:CloseButton = null;
		/**
		 * Back Year Button.
		 * @var	btnBackYear:CalendarNavigateButton
		 */
		private var btnBackYear:CalendarNavigateButton = null;
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
		 * Ahead Year Button.
		 * @var	btnAheadYear:CalendarNavigateButton
		 */
		private var btnAheadYear:CalendarNavigateButton = null;
		/**
		 * Month label.
		 * @var	txtMonthLabel:TextElement
		 */
		private var txtMonthLabel:TextElement = null;
		
		// DATA VARS
		/**
		 * Object Date.
		 * @var	_date:Date
		 */
		private var _date:Date = null;
		/**
		 * Date Text Style.
		 * @var	_dateTextStyle:TextFormat
		 */
		private var _dateTextStyle:TextFormat = null;
		/**
		 * Act as embedded control.
		 * @var	_embedded:Boolean
		 */
		private var _embedded:Boolean = false;
		/**
		 * Selected Date.
		 * @var	_selectedDate:Date
		 */
		private var _selectedDate:Date = null;
		private var _selectedEndDate:Date = null;
		/**
		 * First available date, if not today.
		 * @var	_startDate:Date
		 */
		private var _startDate:Date = null;
		/**
		 * Today's Date.
		 * @var	_today:Date 
		 */
		private var _today:Date = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Calendar instance
		 *
		 */
		public function Calendar() {
			super();
			_today = new Date();
			_date = _today;
			// Add mouse handling to background to prevent errant clicks through the object
			bkgd.addEventListener(MouseEvent.CLICK, onBlockingClick);
			bkgd.useHandCursor = bkgd.mouseChildren = false;
			bkgd.buttonMode = true;
			
			bkgdGrid = Box(addElement('bkgdGrid', Box ));
			
			bkgdMonthHeader = Box(addElement('bkgdMonthHeader', Box ));
			
			btnClose = CloseButton(addElement('btnClose', CloseButton, { y:_padding, height:14,backgroundColor:0xFFFFFF,borderWidth:0 } ));
			btnClose.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			btnBackYear = CalendarNavigateButton(addElement('btnBackYear', CalendarNavigateButton, { type:NavigateButton.FAST_BACKWARD,
			backgroundColor:0xffffff, borderColor:0x000000, borderWidth:1, height:12, width:12 } ));
			
			btnBackMonth = CalendarNavigateButton(addElement('btnBackMonth', CalendarNavigateButton, { type:NavigateButton.BACKWARD,
			backgroundColor:0xffffff, borderColor:0x000000, borderWidth:1, height:12, width:12} ));
			
			btnAheadMonth = CalendarNavigateButton(addElement('btnAheadMonth', CalendarNavigateButton, { type:NavigateButton.FORWARD,
			backgroundColor:0xffffff, borderColor:0x000000, borderWidth:1, height:12, width:12} ));
			
			btnAheadYear = CalendarNavigateButton(addElement('btnAheadYear', CalendarNavigateButton, { type:NavigateButton.FAST_FORWARD,
			backgroundColor:0xffffff, borderColor:0x000000, borderWidth:1, height:12, width:12} ));
			
			txtMonthLabel = TextElement(addElement('txtMonthLabel', TextElement));
			
			for (var i:Number = 0; i < 7; i++) addElement('lblDOTW_'+i, TextElement, { text:DateUtils.numberToDayOfTheWeekLabels(i+1) } );
			
			for (var j:Number = 0; j < 42; j++) addElement('btnDate_'+j, CalendarDateButton);
			
			setDefaultProperties();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *	Applies a css class name argument to be used to style the embedded text field.
		 *  @param	c	CSS Text Format Class
		 *  @since 	0.2.1
		 */
		public override function set cssTextClass(c:String):void { 
			super.cssTextClass = c; 
			txtMonthLabel.cssClass = c;
		}	
		public function get date():Date { return _date; }
		/**
		 * Sets the date to the calendar object.
		 * @param	d	Date object
		 * @since	1.0
		 */
		public function set date(d:Date):void {
			
			//if (_startDate == null) _startDate = new Date();
			// Boolean flag that determines when to start numbering days
			var bool_startNumFlag:Boolean = false;

			// Date object that is advanced once day numbering has started;
			// set initially to first day of the month of the Date object passed into the function
			var dte_temp:Date = new Date(d.getFullYear(), d.getMonth(), 1);

			// The month of the Date passed into function
			var num_month:Number = d.getMonth();

			// Save the date value as the private var _date
			_date = new Date(d.getFullYear(), d.getMonth(), d.getDate());
						
			// Loop through all 42 Data Button objects
			for (var i:Number = 0; i < 42; i++) {

				// Set the day numbering flag to true if the day of the week of the Date passed into the function is reached
				if ((i == dte_temp.getDay()) && (!bool_startNumFlag)) bool_startNumFlag = true; // END if
				
				// If day numbering has started and the month of the temp date hasn't advanced, set the
				// CalendarDateButton object's date property to the temp date and advance the temp date one day
				var tmpDateBtn:CalendarDateButton = CalendarDateButton(getChildByName('btnDate_' + i));
				if ((bool_startNumFlag) && (dte_temp.getMonth() == num_month)) {
					tmpDateBtn.date = new Date(dte_temp.getFullYear(), dte_temp.getMonth(), dte_temp.getDate());
					dte_temp = new Date(dte_temp.getFullYear(), dte_temp.getMonth(), dte_temp.getDate() + 1);
					tmpDateBtn.addEventListener(Event.SELECT, onDateSelect);
					if (_dateTextStyle != null) tmpDateBtn.textStyle = _dateTextStyle
					// If day numbering hasn't started or is complete, set the CalendarDateButton object's date value to null
				} else {
					tmpDateBtn.date = null;
					tmpDateBtn.removeEventListener(Event.SELECT, onDateSelect);
				} // END if
			} // END for
			
			// Set the string of the month label TextArea equal to the name of the month in the current locale's language 
			txtMonthLabel.text = DateUtils.numberToMonth(d.getMonth() + 1);

			// Append the year to the text in the month label TextArea
			txtMonthLabel.text += ' ' + String(d.getFullYear());

			if (_startDate != null) {
				d = new Date(d.getFullYear() - 1, d.getMonth(), d.getDate());
				// Set the date of the CalendarBackYearButton to a year prior to the date passed into the function
				btnBackYear.date = (d.getTime() >= _startDate.getTime()) ? new Date(d.getFullYear(), d.getMonth(), d.getDate()) : null;
				btnBackYear.enabled = (d.getTime() >= _startDate.getTime());
				
				// Set the date of the CalendarBackMonthButton to a month prior to the date passed into the function
				d = new Date(d.getFullYear() + 1, d.getMonth() - 1, d.getDate());
				btnBackMonth.date = (d.getTime() >= _startDate.getTime()) ? new Date(d.getFullYear(), d.getMonth(), d.getDate()) : null;
				var oneMonthBack:Date = new Date(_startDate.getFullYear(), _startDate.getMonth() -1, _startDate.getDate());
				btnBackMonth.enabled = (d.getTime() > oneMonthBack.getTime());
			} else {
				d = new Date(d.getFullYear() - 1, d.getMonth(), d.getDate());
				// Set the date of the CalendarBackYearButton to a year prior to the date passed into the function
				btnBackYear.date = new Date(d.getFullYear(), d.getMonth(), d.getDate());
				// Set the date of the CalendarBackMonthButton to a month prior to the date passed into the function
				d = new Date(d.getFullYear() + 1, d.getMonth() - 1, d.getDate());
				btnBackMonth.date = new Date(d.getFullYear(), d.getMonth(), d.getDate());
			}
			// Set the date of the CalendarAheadMonthButton to a month after the date passed into the function
			d = new Date(d.getFullYear(), d.getMonth() + 2, d.getDate());
			btnAheadMonth.date = new Date(d.getFullYear(), d.getMonth(), d.getDate());

			// Set the date of the CalendarAheadYearButton to a year after the date passed into the function
			d = new Date(d.getFullYear() + 1, d.getMonth() - 1, d.getDate());
			btnAheadYear.date = new Date(d.getFullYear(), d.getMonth(), d.getDate());
			height = _height;
			width = _width;
		}
		/**
		 * Applies a general text style to all text elements. Overrides the 
		 * default TextStyle property in CompoundElement
		 * 
		 * @param	s	TextFormat object
		 * @see			com.fox.display.CompoundElement
		 * @since		1.0.9
		 */
		public function set dateTextStyle(s:TextFormat):void {
			_dateTextStyle = s;
		}
		/**
		 * Overrides the default enabled to support enabling anf disabling date buttons.
		 * @param	d	Date object
		 * @since	1.0
		 */
		public override function set enabled(e:Boolean):void {
			for (var i:Number = 0; i < 42; i++) {
				var tmpDateBtn:CalendarDateButton = CalendarDateButton(getChildByName('btnDate_' + i));
				tmpDateBtn.enabled = e;
				if (e) {
					if (!tmpDateBtn.hasEventListener(Event.SELECT))
						tmpDateBtn.addEventListener(Event.SELECT, onDateSelect); // END if
				} else {
					if (tmpDateBtn.hasEventListener(Event.SELECT))
						tmpDateBtn.removeEventListener(Event.SELECT, onDateSelect); // END if
				} // END if
			} // END for
		}
		/**
		 * Applies and returns whether this control is embedded in a larger element. Setting this 
		 * property to TRUE disabled the unique functional elements of the control such as the 
		 * close button, label and navigation buttons.
		 * @param	e	TRUE or FALSE
		 * @return	The object embedded state
		 * @since	1.0
		 */
		public function get embedded():Boolean { return _embedded; }
		public function set embedded(e:Boolean):void { 
			_embedded = e;
			txt.visible = btnClose.visible = btnBackYear.visible = btnBackMonth.visible = btnAheadMonth.visible = 
			btnAheadYear.visible = !e;
			if (!e) {
				if (!btnClose.hasEventListener(MouseEvent.CLICK))
					btnClose.addEventListener(MouseEvent.CLICK, onCloseClick) 
			} else {
				if (btnClose.hasEventListener(MouseEvent.CLICK))
					btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick) 
			} // END if
			
			width = _width;
			height = _height;
		}
		/**
		 * Overrides the default height function to set the vertical alignment of the calendar elements.
		 * @param	h	The height in pixels
		 * @since	1.0
		 */
		public override function set height(h:Number):void { 
			super.height = h; 
			
			var contentStartY:Number = 0;
			if (!_embedded) {
				btnClose.y = _padding;
				txt.y = _padding + 2;
				contentStartY = txt.height + _padding;
			} else {
				contentStartY = _padding;
			}
			bkgdGrid.y = contentStartY;
			bkgdGrid.height = h - (contentStartY + (_padding * 2));
			
			bkgdMonthHeader.y = contentStartY;
			var monthLabelsY:Number = 0;
			if (!_embedded) {
				txtMonthLabel.y = btnBackYear.y = btnBackMonth.y = btnAheadMonth.y = btnAheadYear.y = (bkgdGrid.y + (_padding / 2));
				monthLabelsY = ((btnBackYear.y + btnBackYear.height) + _padding) + 2;
				bkgdMonthHeader.height = (btnBackYear.height > txtMonthLabel.textHeight) ? btnBackYear.height + _padding : txtMonthLabel.textHeight + _padding;
			} else {
				txtMonthLabel.y = ((bkgdGrid.y + (_padding / 2)) + 2);
				monthLabelsY = (txtMonthLabel.y + txtMonthLabel.height) + _padding;
				bkgdMonthHeader.height = txtMonthLabel.textHeight + _padding;
			} // END if
			
			var labelHeight:Number = 0;
			for (var i:Number = 0; i < 7; i++) {
				var txtTmp:TextElement = TextElement(this.getChildByName('lblDOTW_' + i));
				txtTmp.y = monthLabelsY;
				if (labelHeight == 0) labelHeight = txtTmp.height; // END if
			} // END for
			
			var gridStartY:Number = monthLabelsY + labelHeight;
			
			var dateButtonArea:Number = 0;
			if (!_embedded) {
				dateButtonArea = bkgdGrid.height - ((btnBackYear.height + _padding) + (labelHeight + _padding));
			} else {
				dateButtonArea = bkgdGrid.height - ((txtMonthLabel.height + _padding) + (labelHeight + _padding));
			} // END if
			
			var bc:Number = 0;
			var dateBtnHeight:Number = (dateButtonArea / 6) - (_padding / 2);
			for (var j:Number = 0; j < 6; j++) {
				for (var k:Number = 0; k < 7; k++) {
					var tmpDateBtn:CalendarDateButton = CalendarDateButton(this.getChildByName('btnDate_' + bc));
					// Set the vertical  positions of the CalendarDateButton objects to create the 1-pixel space between days
					tmpDateBtn.height = dateBtnHeight;
					tmpDateBtn.y = gridStartY;
					// Increment the CalendarDateButton count
					bc++;
				} // END for
				gridStartY += dateBtnHeight + 1;
			} // END for
		}
		/**
		 * Applies non-localized dynamic text to the calendars label text element.
		 * @param	t	The text string
		 * @since	1.0
		 */
		public function set labelText(t:String):void { txt.text = t; }
		/**
		 * Applies a localized copy string ID to the calendars label text element.
		 * @param	s	Localized copy string ID
		 * @since	1.0
		 */
		public function set labelString(s:String):void { txt.string = s; }
		/**
		 * The date choosen to be sent back to the DateSelector parent object..
		 * @param	d	Selected Date object
		 * @since	1.0
		 */
		public function get selectedDate():Date { return _selectedDate; }
		public function set selectedDate(d:Date):void { 
			_selectedDate = d; 
			if (d != null) {
				if (_embedded) {
					if (_date != null && d.getTime() > new Date(_date.getFullYear(), _date.getMonth(), 1).getTime()) {
						var tmpDateBtn:CalendarDateButton = null; 
						for (var i:Number = 0; i < 42; i++) {
							tmpDateBtn = CalendarDateButton(getChildByName('btnDate_' + i));
							if (tmpDateBtn.date != null) {
								if (tmpDateBtn.date.getTime() == d.getTime() && 
								(parentObj.toString().toLowerCase().indexOf('multimonthcalendar') == -1)) tmpDateBtn.select();
								else tmpDateBtn.unselect(); //END if
							} //END if
						} // END for
					} // END if
				} // END if
			} else {
				for (var j:Number = 0; j < 42; j++) {
					tmpDateBtn = CalendarDateButton(getChildByName('btnDate_' + j));
					if (tmpDateBtn.date != null) tmpDateBtn.unselect(); //END if
				} // END for
			} // END if
		}
		/**
		 * The selected end date used to render date block to connect start and end dates for
		 * embedded calendars. Not available for non-embedded objects.
		 * @param	d	Selected Date object
		 * @since	1.0
		 */
		public function set selectedEndDate(d:Date):void { 
			_selectedEndDate = d; 
			if (d != null) {
				if (_embedded) {
					var tmpDateBtn:CalendarDateButton = null; 
					for (var i:Number = 0; i < 42; i++) {
						tmpDateBtn = CalendarDateButton(getChildByName('btnDate_' + i));
						if (tmpDateBtn.date != null) {
							if (_selectedDate != null && (tmpDateBtn.date.getTime() > _selectedDate.getTime() && 
							tmpDateBtn.date.getTime() < d.getTime())) {
								tmpDateBtn.highlighted(true,true);
							} else if (tmpDateBtn.date.getTime() == d.getTime()) { 
								 tmpDateBtn.rangeEndSelect();
							}//END if
						} //END if
					} // END for
				} // END if
			} // END if
		}
		/**
		 * Sets thew first date available for selection if other than today.
		 * @param	sd	The starting date object
		 * @since	1.0
		 */
		public function get startDate():Date { return _startDate; }
		public function set startDate(sd:Date):void { 
			_startDate = sd; 
			if (sd != null) date = sd; else date = _date;
		}
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
			txtMonthLabel.style = s;
			dateTextStyle = s;
		}
		/**
		 * Overrides the default width function to set the horizontal alignment of the calendar elements.
		 * @param	w	The width in pixels
		 * @since	1.0
		 */
		public override function set width(w:Number):void {
			super.width = w;
			// SET sub border width
			btnClose.x = w - (btnClose.width + _padding);
			bkgdGrid.width = bkgdMonthHeader.width = w - (_padding * 2);
			bkgdGrid.x = bkgdMonthHeader.x = _padding;
			txt.width = bkgdGrid.width;
			txt.x = (bkgdGrid.width / 2) - (txt.textWidth / 2);
			
			if (!_embedded) {
				btnBackYear.x = bkgdGrid.x;
				btnBackMonth.x = btnBackYear.x + btnBackYear.width + 2;
				txtMonthLabel.x = (btnBackMonth.x + btnBackMonth.width) + _padding;
				txtMonthLabel.width = bkgdGrid.width - ((btnBackYear.width + btnBackMonth.width + btnAheadMonth.width + 
				btnAheadYear.width) + ((_padding * 2) + 4));
				btnAheadMonth.x = (txtMonthLabel.x + txtMonthLabel.width) + _padding;
				btnAheadYear.x =  (btnAheadMonth.x + btnAheadMonth.width) + 2;
			} else {
				txtMonthLabel.width = bkgdGrid.width;
				txtMonthLabel.x = bkgdGrid.x + _padding;
			} // END if
			
			txtMonthLabel.x = txtMonthLabel.x + ((txtMonthLabel.width / 2) - (txtMonthLabel.textWidth / 2));
			
			// Loop through the day of the week labels to set their widths and position them horizontally
			for (var i:Number=0; i<7; i++) {
				// make temp object
				var txtTmp:TextElement = TextElement(this.getChildByName('lblDOTW_' + i));
				// Set the width of the day of the week label wide enough to overlap its neighbor's border
				txtTmp.width = (bkgdGrid.width - 12) / 7;
				// Position the day of the week labels horizontally with their borders overlap
				var txtTmp2:TextElement = TextElement(this.getChildByName('lblDOTW_' + (i-1)));
				txtTmp.x = (i == 0) ? 9 : (txtTmp2.x + txtTmp2.width) - 1;
			} // END for
			
			var bc:Number = 0;
			var dateBtnSize:Number = (bkgdGrid.width - 26) / 7;
			for (var j:Number=0; j<6; j++) {
				for (var k:Number=0; k<7; k++) {
					// make temp object
					var tmpDateBtn:CalendarDateButton = CalendarDateButton(this.getChildByName('btnDate_' + bc));
					// Set the widths of the CalendarDateButton objects to 2 pixels narrower than the
					// day of the week labels to allow for a 1-pixel space between days
					tmpDateBtn.width = dateBtnSize;
					// Set the horizontal positions of the CalendarDateButton objects to create the 1-pixel space between days
					tmpDateBtn.x = (((bkgdGrid.width - 19)/7) * k) + 10;
					// Increment the CalendarDateButton count
					bc++;
				} // END for
			} // END for
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Date selection handler for passing date values to a parent MultiMonthCalendar object.
		 * @since	1.0
		 */
		public function selectDate(d:Date):void {
			if (d != null) {
				if (_embedded) {
					if (parentObj.toString().toLowerCase().indexOf('multimonthcalendar') != -1)
						MultiMonthCalendar(parent).date = d; //END if
				} //END if
			} //END if
			_selectedDate = d; 
		}
		/**
		 * Show the calendar and initializes it's dispay if no date is set.
		 * @since	1.0
		 */
		public override function show():void{
			super.show();
			if (_date == null) this.date = new Date(); // END if
			for (var i:Number = 0; i < 42; i++) {

				// If day numbering has started and the month of the temp date hasn't advanced, set the
				// CalendarDateButton object's date property to the temp date and advance the temp date one day
				var tmpDateBtn:CalendarDateButton = CalendarDateButton(getChildByName('btnDate_' + i));
				if (_dateTextStyle != null) tmpDateBtn.textStyle = _dateTextStyle
			} // END for
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Sets default black and white style properties to the object.
		 * @since	1.0
		 */
		private function setDefaultProperties():void {
			_padding = 4;
			bkgd.applyProperties( { color:0xFFFFFF } );
			bkgd.visible = true;
			txt.visible = true;
			bkgdGrid.applyProperties( { color:0xDDDDDD,borderWidth:1, borderColor:0xC0C0C0 } );
			bkgdMonthHeader.applyProperties( { color:0xBBBBBB,borderWidth:0} );
			width = 200;
			height = 190;
			txt.text = "Calendar";
			txtMonthLabel.text = DateUtils.numberToMonth(_today.getMonth() + 1);
		}
		/**
		 * Close button click handler.
		 * @since	1.0
		 */
		private function onCloseClick(e:Event):void { 
			if (parentObj.toString().toLowerCase().indexOf('dateselector') != -1) {
				DateSelector(parent).hideCalendar();
			} else {
				hide();
			} // END if
		}
		/**
		 * When a date has been chosen, test if this object is a child of 
		 * {#link com.foxr.display.components.DateSelector} and if so, apply the date value to it and hide. 
		 * Otherwise, fire a select event.
		 * @param	e	Event object
		 */
		private function onDateSelect(e:Event):void { 
			if (parentObj.toString().toLowerCase().indexOf('dateselector') != -1) {
				DateSelector(parent).date = _selectedDate;
				hide(); 
			} else {
				dispatchEvent(new Event(Event.SELECT));
			} // EMD if
		}
		/**
		 * Fired when the click blocking sprite is clicked. Does nothing as this is an empty click catch-all.
		 * @param	e	Event object
		 */
		private function onBlockingClick(e:Event):void { }
	}
	
}