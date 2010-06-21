/*
 * Copyright (c) 2005 Pablo Costantini (www.luminicbox.com). All rights reserved.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.luminicbox.util
{
	
	/**
	* Static class containing string utilities.
	*/
	public class StringUtil {
		
		/**
		* Duplicates a given string for the amount of given times.
		* @param str String to duplicate.
		* @paran Amount of time to duplicate.
		*/
		public static function multiply( str:String, n:Number ):String {
			var ret:String = "";
			for( var i:Number=0; i<n; i++ ) ret += str;
			return ret;
		}
		
		/**
		* String replacement function. These implementation causes some perform penalties.
		* @param string Original string
		* @param oldValue A string to be replaced
		* @param newValue A string to replace all occurrences of oldValue.
		*/
		public static function replace( string:String, oldValue:String, newValue:String ):String {
			return string.split( oldValue ).join( newValue );
		}
		
	}
	
}