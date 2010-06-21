package com.foxr.util
{
	/**
	 *	A static utility class to perform various editing functions on strings.
	 *  <p />
	 *  @usage
	 *  <code>
	 *  import sw.core.StringUtils;
	 * 
	 *  StringUtils.toTitleCase('THIS IS A TEST STRING');
	 * 
	 *  StringUtils.isIn('findVal',arrayName);
	 * 	</code>
	 *  
	 *  @langversion 	ActionScript 3.0
	 *  @playerversion 	Flash 9
	 *  @author			Jeff Fox
	 *  @version		1.0.5
	 *
	 */
	public class StringUtils {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 *	CHAR_TAB.
		 * 	@since 1.0
		 */
		private static const CHAR_TAB:Number = 9;
		/**
		 *	CHAR_LINEFEED.
		 * 	@since 1.0
		 */
		private static const CHAR_LINEFEED:Number = 10;
		/**
		 *	CHAR_CARRIAGE.
		 * 	@since 1.0
		 */
		private static const CHAR_CARRIAGE:Number = 13;
		/**
		 *	CHAR_SPACE.
		 * 	@since 1.0
		 */
		private static const CHAR_SPACE:Number = 32;
	
		/*--------------------------
		/	STATIC FUNCTIONS
		/-------------------------*/
		/**
		 *	Removes leading whiteCHAR_SPACE and CHAR_CARRIAGE returns from the passed string.
		 *  @param	String	s	The raw string to be parsed
		 *  @return	String	The string without whiteCHAR_SPACE
		 * 	@since 1.0
		 *  @author Federico	federico@infogravity.net
		 *  @static
		 */
		public static function leftTrim(s:String):String {
			s = s.toString();
			var start:Number = 0;
			for (var i:Number = 0; i < s.length; i++) {
				if (s.charCodeAt(i) != CHAR_SPACE && s.charCodeAt(i) != CHAR_TAB
				&& s.charCodeAt(i) != CHAR_LINEFEED  && s.charCodeAt(i) != CHAR_CARRIAGE) {
					start = i;
					break;
				} // END if
			} // END for
			return s.substring(start,s.length);
		}
		/**
		 *	Removes trailing whiteCHAR_SPACE and CHAR_CARRIAGE returns from the passed string.
		 *  <P />
		 *  Fixed technical glitch in method in version 1.8 - JF
		 *  @param	String	s	The raw string to be parsed
		 *  @return	String	The string without whiteCHAR_SPACE
		 * 	@since 1.0
		 *  @author Federico	federico@infogravity.net
		 *  @author	Jeff Fox
		 *  @static
		 */
		public static function rightTrim(s:String):String {
			var end:Number = (s.length - 1);
			for (var i:Number = end; i > 0; i--) {
				if (s.charCodeAt(i) != CHAR_SPACE && s.charCodeAt(i) != CHAR_TAB
				&& s.charCodeAt(i) != CHAR_LINEFEED  && s.charCodeAt(i) != CHAR_CARRIAGE) {
					end = i + 1;
					break;
				} // END if
			} // END for
			return s.substring(0,end);
		}
		/**
		 *	Removes leading and trailing whiteCHAR_SPACE and CHAR_CARRIAGE returns from the passed string.
		 *  @param	String	s	The raw string to be parsed
		 *  @return	String	The string without whiteCHAR_SPACE
		 * 	@since 1.0
		 *  @author Federico	federico@infogravity.net
		 *  @static
		 */
		public static function trim(s:String):String {
			s = s.toString();
			s = StringUtils.leftTrim(s);
			s = StringUtils.rightTrim(s);
			return (s);
		}
		/**
		 *	Finds and replaces the value of find with the value replace in str. Returns
		 *  the modified tring value
		 * 	@param	String	str	The raw string to be parsed
		 * 	@param	String	strFind	The string to be replaced
		 * 	@param	String	strReplace	The new value to be spliced into str
		 *  @return	String	The modified string
		 * 	@since 	1.0.1.2
		 *  @static
		 */
		public static function replace(str:String,strFind:String,strReplace:String):String {
			var arr:Array = str.split(strFind);
			return arr.join(strReplace);
		}
		/**
		 *	Replaces common HTML Entity values with their actual character equivilents
		 * 	@param	String	str	The raw string to be parsed
		 *  @return	String	The modified string
		 * 	@since 	1.0.4
		 *  @static
		 */
		public static function replaceEntities(str:String):String {
			str = StringUtils.replace(str,"&amp;","&");
			str = StringUtils.replace(str,"&Eacute;","É");
			str = StringUtils.replace(str,"&acirc;","â");
			return str;
		}
		/**
		 *	Replaces common URL Encoding values with their actual character equivilents
		 * 	@param	String	str	The raw string to be parsed
		 *  @return	String	The modified string
		 * 	@since 	1.0.1.2
		 *  @access	public
		 *  @static
		 */
		public static function urlDecode(str:String):String {
			str = StringUtils.replace(str,"%26","&");
			str = StringUtils.replace(str,"%0A","&");
			str = StringUtils.replace(str,"%3D","=");
			str = StringUtils.replace(str,"%2F","/");
			str = StringUtils.replace(str,"%7C","|");
			str = StringUtils.replace(str,"+"," ");
			str = StringUtils.replace(str,"%20"," ");
			str = StringUtils.replace(str,"%2C",",");
			str = StringUtils.replace(str,"%3C","<");
			str = StringUtils.replace(str,"%3E",">");
			str = StringUtils.replace(str,"%2E",".");
			str = StringUtils.replace(str,"%5F","_");
			str = StringUtils.replace(str,"%3A",":");
			str = StringUtils.replace(str,"%23","#");
			str = StringUtils.replace(str,"%24","$");
			str = StringUtils.replace(str,"%2B","+");
			str = StringUtils.replace(str,"%2D","-");
			str = StringUtils.replace(str,"%3B",";");
			str = StringUtils.replace(str,"%3F","?");
			str = StringUtils.replace(str,"%40","@");
			str = StringUtils.replace(str,"%5B","[");
			str = StringUtils.replace(str,"%5C","\\");
			str = StringUtils.replace(str,"%5D","]");
			str = StringUtils.replace(str,"%5E","^");
			str = StringUtils.replace(str,"%60","`");
			str = StringUtils.replace(str,"%7B","{");
			str = StringUtils.replace(str,"%7D","}");
			str = StringUtils.replace(str,"%7E","~");
			str = StringUtils.replace(str,"%25","%");
			str = StringUtils.replace(str,"%0D","");
			return str;
		}
		/**
		 *	Replaces common Bulletin Board tags codes to the equivilent
		 *  html tags.
		 * 	@param	String	str	The raw string to be parsed
		 *  @return	String	The modified string
		 * 	@since 	1.0.5
		 *  @static
		 */
		public static function bbCodeToHTML(str:String):String {
			str = StringUtils.replace(str,"[br]","<br>");
			str = StringUtils.replace(str,"[p]","<p>");
			str = StringUtils.replace(str,"[/u]","</u>");
			str = StringUtils.replace(str, "[u]", "<u>");
			str = StringUtils.replace(str,"[/b]","</b>");
			str = StringUtils.replace(str, "[b]", "<b>");
			str = StringUtils.replace(str,"[/strong]","</b>");
			str = StringUtils.replace(str, "[strong]", "<b>");
			str = StringUtils.replace(str,"[/i]","</i>");
			str = StringUtils.replace(str,"[i]","<i>");
			return str;
		}
		/**
		 *	Checks for the exisitence of a string value in a multidimensional array. If the 
		 *  value is found within the first array item, the entire sub array is returned
		 * 	@param	String	str	The string value being searched for
		 *  @param	Array	arrList	The array to search in
		 *  @return	Array	The matching sub array OR null if no match is found
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function isIn(str:String,arrList:Array):Array {
			var tempArray:Array = [], rtnArray:Array = null;
			for(var i:Number=0; i < arrList.length; i++){
				tempArray = arrList[i].split(":");
				if (tempArray[0] == str) {
					rtnArray = tempArray; 
					break; // END IF
				}
			} // END for
			return rtnArray;
		}
		/**
		 *	Checks for the exisitence of a string value in an array. If the 
		 *  value is found, this method returns true. If not, false.
		 * 	@param	String	str	The string value being searched for
		 *  @param	Array	arrList	The array to search in
		 *  @return	Boolean	TRUE or FALSE
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function isInBoolean(str:String,arrList:Array):Boolean {
			for(var i:Number=0; i < arrList.length; i++){
				if (arrList[i] == str) {
					return true;
					break; // END IF
				}
			} // END for
			return false;
		}
		/**
		 *	Transforms the passed string to title case with the first letter of each new word 
		 *  capitalized.
		 * 	@param	String	str	The string value being searched for
		 *  @return	String	The transformed string
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function toTitleCase(s:String):String {
			s = s.toString();// Assure this is a true string
			var str:String = '';
			var prevWhite:Boolean = true;
			for (var i:Number = 0; i < s.length; i++) {
				str += prevWhite ? s.charAt(i).toUpperCase() : s.charAt(i).toLowerCase();
				prevWhite = s.charCodeAt(i)<=CHAR_SPACE;
			} // END for
			return str;
		}
		/**
		 *  Switches the case of each character of the passed string. For example, if each 
		 *  letter is capitalized, this method will return the string in all lower case
		 * 	@param	String	str	The string value being searched for
		 *  @return	String	The transformed string
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function toggleCase(s:String):String {
			s = s.toString();// Assure this is a true string
			var str:String = '';
			for (var i:Number = 0; i<s.length; i++) {
				str += s.charCodeAt(i)<=90 ? s.charAt(i).toLowerCase() : s.charAt(i).toUpperCase();
			} // END for
			return str;
		}
		/**
		 *  Transforms the passed string to sentence case with the first letter of each new line 
		 *  capitalized and all others sets to lower case.
		 * 	@param	String	str	The string value being searched for
		 *  @return	String	The transformed string
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function toSentenceCase(s:String):String {
			s = s.toString();// Assure this is a true string
			var str:String = '';
			var sBreak:Boolean = true;
			for (var i:Number = 0; i<s.length; i++) {
				str += sBreak ? s.charAt(i).toUpperCase() : s.charAt(i).toLowerCase();
				sBreak = (sBreak && s.charCodeAt(i)<=CHAR_SPACE) || "\r\n.,?:;!".indexOf(s.charAt(i)) != -1;
			} // END for
			return str;
		}
		/**
		 *  Clears the extra CHAR_SPACEs and line brakes in the given String
		 * 	@param	String	str	The string value being searched for
		 *  @return	String	The transformed string
		 * 	@since 	1.0.2
		 *  @static
		 */
		public static function toSingleCHAR_SPACE(s:String):String {
			s = s.toString();// Assure this is a true string
			var str:String = '';
			var prevWhite:Boolean = true;
			for (var i:Number = 0; i<s.length; i++) {
				var code:Number = s.charCodeAt(i);
				var white:Boolean = code<=CHAR_SPACE;
				if (white) {
					if (!prevWhite && (code == CHAR_TAB || code == CHAR_SPACE)) 
						str += " "; // END if
				} else
					str += s.charAt(i); // END if
				prevWhite = white;
			} // END for
			return str;
		}
	} // END class
} // END package