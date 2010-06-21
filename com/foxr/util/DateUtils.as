package com.foxr.util 
{
	import com.foxr.display.TextElement;
	import com.foxr.model.GlobalProxyManager;
	
	import org.puremvc.as3.patterns.facade.Facade;
	/**
	 *	A static utility class to perform various editing functions on dates.
	 *  <p />
	 *  @usage
	 *  <code>
	 *  import com.foxr.util.DateUtils;
	 * 	</code>
	 *  <p />
	 *  @author			Jeff Fox
	 *  @copyright 		2009 Aeolian Digital Studios.
	 *  @langversion 	ActionScript 3.0
	 *  @playerversion 	Flash 9
	 * 
	 */
	public class DateUtils {
		/*--------------------------
		/ 	VARIABLES
		/-------------------------*/
		public static const YEAR_LONG:Number = 0;
		public static const YEAR_SHORT:Number = 1;
	
		public static const DAYSOFWEEK:Array = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		public static const DAYSOFWEEKLABELS:Array = ["","Su","M","T","W","Tr","F","Sa"];
			
		public static const MONTHS:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		
		public static const DAY_STRING_PATH:String = 'global.general.elements.calendar.';
		/*--------------------------
		/	STATIC FUNCTIONS
		/-------------------------*/
		public static function convertStringToDateSpecs(dateStr:String,format:String = ''):Array {
			var month:Number,date:Number,year:Number,hour:Number,minutes:Number,seconds:Number;
			switch(format) {
				// UTC SHORT
				// FORMAT = Sat Dec 01 00:00:00 EST 2007
				case 'utcshort':
				default:
					var dateSpecs:Array = dateStr.split(" ");
					month = DateUtils.stringMonthToNumber(dateSpecs[1]);
					date = parseInt(dateSpecs[2]);
					var time:Array = dateSpecs[3].split(":");
					hour = parseInt(time[0]);
					minutes = parseInt(time[1]);
					seconds = parseInt(time[2]);
					year = parseInt(dateSpecs[5]);
					break;
			} // END switch
			return [year,month,date,hour,minutes,seconds];
		}
		
		public static function stringDayOfWeekToNumber(day:String):Number {
			var dayNum:Number = 0;
			for (var i:Number = 1; i < DAYSOFWEEK.length; i++) {
				var thisDay:String = DAYSOFWEEK[i];
				if (day.length == 3)
					thisDay = DAYSOFWEEK[i].substring(0,3);
				if (thisDay == day) {
					dayNum = i;
					break;
				}
			}
			return dayNum;
		}
		public static function numberToDayOfTheWeek(day:Number):String {
			var rtnStr:String = '';
			var gpm:GlobalProxyManager = Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			var dateStr:String = gpm.copy.getCopyString(DAY_STRING_PATH + 'day_' + day);
			if (dateStr == null){
				try {
					rtnStr = DAYSOFWEEK[day];
				} catch (e:Error) {
					gpm.log.error('DateUtils::numberToDayOfTheWeek error. The day argument passed was not within the valid range.'); // END if
				} // END try/catch
			} else {
				rtnStr = dateStr;
			}
			return rtnStr;
		}
		
		public static function numberToDayOfTheWeekLabels(day:Number):String {
			var rtnStr:String = '';
			var gpm:GlobalProxyManager = Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			var dateStr:String = gpm.copy.getCopyString(DAY_STRING_PATH + 'dayLabel_' + day);
			if (dateStr == null){
				try {
					rtnStr = DAYSOFWEEKLABELS[day];
				} catch (e:Error) {
					gpm.log.error('DateUtils::numberToDayOfTheWeek error. The day argument passed was not within the valid range.'); // END if
				} // END try/catch
			} else {
				rtnStr = dateStr;
			}
			return rtnStr;
		}
		
		public static function stringMonthToNumber(month:String):Number {
			var monthNum:Number = 0;
			for (var i:Number = 0; i < MONTHS.length; i++) {
				var thisMonth:String = MONTHS[i];
				if (month.length == 3)
					thisMonth = MONTHS[i].substring(0,3);
				if (thisMonth == month) {
					monthNum = i;
					break;
				}
			}
			return monthNum;
		}
		
		public static function numberToMonth(month:Number):String {
			var rtnStr:String = '';
			var gpm:GlobalProxyManager = Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			var monthStr:String = gpm.copy.getCopyString(DAY_STRING_PATH + 'month_' + month);
			if (monthStr == null || monthStr == ''){
				try {
					rtnStr = MONTHS[month-1];
				} catch (e:Error) {
					gpm.log.error('DateUtils::numberToMonth error. The month argument passed was not within the valid range.'); // END if
				} // END try/catch
			} else {
				rtnStr = monthStr;
			}
			return rtnStr;
		}
		
		public static function localizeDate(d:Date = null, locale:Locale = null,delimiter:String = "/", yearLen:Number = YEAR_LONG):String { 
			var gpm:GlobalProxyManager = Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			if (locale == null && gpm.config.locale != null) 
				locale = gpm.config.locale;
			if (d == null)
				d = new Date();
			var dateStr:String = '';
			var datePattern:String = Locale.getDateFormatByLocale(locale);
			var patternVars:Array = datePattern.split("/");
			
			for (var i:Number = 0; i < patternVars.length; i++) {
				switch (patternVars[i]) {
					case "m":
						dateStr += d.getMonth()+1;
						break;
					case "d":
						dateStr += d.getDate();
						break;
					case "y":
						var year:String = d.getFullYear().toString();
						if (yearLen == YEAR_SHORT)
							dateStr += year.substring(2,year.length);
						else
							dateStr += year; // END if
						break;
					default:
						break
				} // END switch
				if (i < patternVars.length - 1) dateStr += delimiter;
			} // END for
			return dateStr;
		}
	}// END class
} // END package