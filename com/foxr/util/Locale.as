package com.foxr.util {
	/**
	 * This object is an almost direct port of the java.utils.Locale class. It provides 
	 * thorough Locale support as well as numerous additional functions for applying 
	 * Locales and locale based conventions to data and object displays.
	 * <p />
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class Locale {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// STATIC VARS
		public static var cache:Object = new Object();
		
		/** Useful constant for language.
		 */
		public static var ENGLISH:Locale = createSingleton("en__", "en", "");

		/** Useful constant for language.
		 */
		public static var FRENCH:Locale = createSingleton("fr__", "fr", "");

		/** Useful constant for language.
		 */
		public static var GERMAN:Locale = createSingleton("de__", "de", "");

		/** Useful constant for language.
		 */
		public static var ITALIAN:Locale = createSingleton("it__", "it", "");

		/** Useful constant for language.
		 */
		public static var JAPANESE:Locale = createSingleton("ja__", "ja", "");

		/** Useful constant for language.
		 */
		public static var KOREAN:Locale = createSingleton("ko__", "ko", "");

		/** Useful constant for language.
		 */
		public static var CHINESE:Locale = createSingleton("zh__", "zh", "");

		/** Useful constant for language.
		 */
		public static var SIMPLIFIED_CHINESE:Locale = createSingleton("zh_CN_", "zh", "CN");

		/** Useful constant for language.
		 */
		public static var TRADITIONAL_CHINESE:Locale = createSingleton("zh_TW_", "zh", "TW");

		/** Useful constant for country.
		 */
		public static var FRANCE:Locale = createSingleton("fr_FR_", "fr", "FR");

		/** Useful constant for country.
		 */
		public static var GERMANY:Locale = createSingleton("de_DE_", "de", "DE");

		/** Useful constant for country.
		 */
		public static var ITALY:Locale = createSingleton("it_IT_", "it", "IT");

		/** Useful constant for country.
		 */
		public static var JAPAN:Locale = createSingleton("ja_JP_", "ja", "JP");

		/** Useful constant for country.
		 */
		public static var KOREA:Locale = createSingleton("ko_KR_", "ko", "KR");

		/** Useful constant for country.
		 */
		public static var CHINA:Locale = SIMPLIFIED_CHINESE;

		/** Useful constant for country.
		 */
		public static var PRC:Locale = SIMPLIFIED_CHINESE;

		/** Useful constant for country.
		 */
		public static var TAIWAN:Locale = TRADITIONAL_CHINESE;

		/** Useful constant for country.
		 */
		public static var UK:Locale = createSingleton("en_GB_", "en", "GB");

		/** Useful constant for country.
		 */
		public static var US:Locale = createSingleton("en_US_", "en", "US");

		/** Useful constant for country.
		 */
		public static var CANADA:Locale = createSingleton("en_CA_", "en", "CA");

		/** Useful constant for country.
		 */
		public static var CANADA_FRENCH:Locale = createSingleton("fr_CA_", "fr", "CA");

		/**
		 * Useful constant for the root locale.  The root locale is the locale whose
		 * language, country, and variant are empty ("") strings.  This is regarded
		 * as the base locale of all locales, and is used as the language/country 
		 * neutral locale for the locale sensitive operations.
		 *
		 * @since 1.0
		 */
		public static var ROOT:Locale = createSingleton("__", "", "");
		
		/**
		 * Display types for retrieving localized names from the name providers.
		 */
		private static var DISPLAY_LANGUAGE:Number = 0;
		private static var DISPLAY_COUNTRY:Number  = 1;
		
		// PRIVATE VARS FOR INSTANCES
		private var _language:String = '';
		private var _country:String = '';
		/*---------------------------------
		/	C'TOR
		/--------------------------------*/
		/**
		 * Creates a new Locale instance.
		 * @param language 	lowercase two-letter ISO-639 code.
		 * @param country 	uppercase two-letter ISO-3166 code.
		 * 
		 */
		public function Locale(language:String='', country:String='') {
			_language = convertOldISOCodes(language);
			_country = country.toUpperCase();
		}
		/*---------------------------------
		/	SET/GET FUNCTIONS
		/--------------------------------*/
		/**
		 * Returns the language code for this locale, which will either be the empty string
		 * or a lowercase ISO 639 code.
		 * <p>NOTE:  ISO 639 is not a stable standard-- some languages' codes have changed.
		 * Locale's constructor recognizes both the new and the old codes for the languages
		 * whose codes have changed, but this function always returns the old code.  If you 
		 * want to check for a specific language whose code has changed, don't do <pre> 
		 * if (locale.getLanguage().equals("he")) 
		 *    ... 
		 * </pre>Instead, do<pre> 
		 * if (locale.getLanguage().equals(new Locale("he", "", "").getLanguage())) 
		 *    ...</pre>
		 * @see #getDisplayLanguage
		 */
		public function get language():String { return _language; }

		/**
		 * Returns the country/region code for this locale, which will
		 * either be the empty string or an uppercase ISO 3166 2-letter code.
		 * @see #getDisplayCountry
		 */
		public function get country():String { return _country; }	
		
		/*---------------------------------
		/	PUBLIC FUNCTIONS
		/--------------------------------*/
		public static function getDateFormatByLocale(l:Locale):String {
			var patternStr:String = '';
			switch (l) {
				case CANADA:
				case UK:
				case FRENCH:
				case CANADA_FRENCH:
				case ITALIAN:
				case ITALY:
				case GERMAN:
				case GERMANY:
					patternStr = 'd/m/y';
					break;
				case JAPAN:
				case JAPANESE:
				case CHINA:
				case CHINESE:
				case KOREA:
				case KOREAN:
				case PRC:
				case TAIWAN:
				case SIMPLIFIED_CHINESE:
				case TRADITIONAL_CHINESE:
					patternStr = 'y/m/d';
					break;
				case ENGLISH:
				case US:
				default:
					patternStr = 'm/d/y';
					break;
			} // END switch
			return patternStr;
		}
		/**
		 * Returns a date format patterns for the passed locale. If the passed arguments are 
		 * not found, the 
		 * @param	language	(Optional) 
		 * @param	country		(Optional)
		 * @return	The date string in variable 'mm/dd/yyyy' format
		 */
		public static function getDateFormatByCode(language:String='', country:String=''):String {
			var dateFormatStr:String = '';
			if (language == '' && country == '') {
				dateFormatStr = Locale.getDateFormatByLocale(cache[language + "_" + country + "_"]);
			} // END if
			return dateFormatStr;
		}
		/**
		 * Returns a <i>Locale</i> constructed from the given
		 * <i>language</i>, <i>country</i> and
		 * <i>variant</i>. If the same <i>Locale</i> instance
		 * is available in the cache, then that instance is
		 * returned. Otherwise, a new <i>Locale</i> instance is
		 * created and cached.
		 *
		 * @param language lowercase two-letter ISO-639 code.
		 * @param country uppercase two-letter ISO-3166 code.
		 * @param variant vendor and browser specific code. See class description.
		 * @return the <i>Locale</i> instance requested
		 * @exception NullPointerException if any argument is null.
		 */
		public static function getInstance(language:String, country:String):Locale {
			if (language == null || country == null) {
				return ROOT;
			} // END if
			var locale:Locale = cache[language + "_" + country + "_"];
			if (locale == null) {
				locale = new Locale(language, country);
				cache[language + "_" + country + "_"] = locale;
			} // END if
			return locale;
		}
		public function toString():String {
			return _language + "_" + _country;
		}
		/*---------------------------------
		/	PRIVATE FUNCTIONS
		/--------------------------------*/
		/**
		 * Creates a <i>Locale</i> instance with the given
		 * <i>language</i> and <i>counry</i> and puts the
		 * instance under the given <i>key</i> in the cache. This
		 * method must be called only when initializing the Locale
		 * constants.
		 */
		private static function createSingleton(key:String, language:String, country:String):Locale {
			var locale:Locale = new Locale(language, country);
			cache[key] = locale;
			return locale;
		}
		/**
		 * Creates a <i>Locale</i> instance with the given
		 * <i>language</i> and <i>counry</i> and puts the
		 * instance under the given <i>key</i> in the cache. This
		 * method must be called only when initializing the Locale
		 * constants.
		 * @param	l	ISO lanaguage code
		 */
		private function convertOldISOCodes(l:String):String { 
			// we accept both the old and the new ISO codes for the languages whose ISO 
			// codes have changed, but we always store the OLD code, for backward compatibility 
			var rtnLang:String = l.toLowerCase();
			if (rtnLang == "he") { 
				return "iw"; 
			} else if (rtnLang == "yi") { 
				return "ji"; 
			} else if (rtnLang == "id") { 
				return "in"; 
			} else { 
				return rtnLang; 
			} // END if
		}
	}
	
}