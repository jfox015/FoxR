package com.foxr.data
{
	import flash.net.SharedObject;
	import com.foxr.util.Utils;
	
	/**
	 * A static class for managing Flash SharedObjects.
	 * 
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * 
	 */
	public class FlashCookie {
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Deletes a Flash SharedObject file.
		 * @param	id 	SharedObject id
		 * @return	TRUE or FALSE
		 * @since	1.0
		 */
		public static function deleteCookie(id:String):Boolean {
			var so:SharedObject = null;
			try {
				if ((so = SharedObject.getLocal(id)) != null)
					so.clear(); // END if
			} catch (e:Error) {
				return false;
			} // END try/catch
			return true;
		}
		/**
		 * Tests if a specific Flash Cookie exists.
		 * @param	id 	SharedObject id
		 * @return	TRUE or FALSE
		 * @since	1.0
		 */
		public static function flashCookieExists(id:String):Boolean {
			return (SharedObject.getLocal(id) != null);
		}
		/**
		 * Creates a new SharedObject (if the one specified does not exist, and applies the values 
		 * store din the dataObj argument to it's <code>data<code> property.
		 * @param	id		SharedObject id
		 * @param	dataObj	Object containing data values for the SharedObject
		 * @since	1.0
		 */
		public static function setFlashCookie(id:String,dataObj:Object):void {
			var so:SharedObject = SharedObject.getLocal(id);
			for (var dataKey:String in dataObj) {
				so.data[dataKey] = dataObj[dataKey];
			} // END for
			so.flush();
		}
		
		/**
		 * Returns the entire value of the specified SharedObject.
		 * @param	id	SharedObject id
		 * @return	Object of values. Null if SharedObject does not exist or is empty
		 */
		public static function getFlashCookie(id:String):Object {
			var so:SharedObject = SharedObject.getLocal(id);
			var returnObj:Object = null;
			for (var dataKey:String in so.data) {
				if (returnObj == null) returnObj = new Object();
				returnObj[dataKey] = so.data[dataKey];
			} // END for
			return returnObj;
		}
		
		/**
		 * Returns the entire value of the specified SharedObject.
		 * @param	id	SharedObject id
		 * @param	key	Shared object key ID
		 * @return	Mixed value of the key or null if it's does not exist or is empty
		 */
		public static function getFlashCookieValue(id:String,key:String):* {
			var so:SharedObject = SharedObject.getLocal(id);
			for (var dataKey:String in so.data) {
				if (dataKey == key) {
					return so.data[dataKey];
					break;
				} // END if
			} // END for
			return null;
		}
	}
}