package com.foxr.util
{
	import com.foxr.model.GlobalProxyManager;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import flash.utils.ByteArray;
	/**
	 * Random Utilies.
	 */
	public class Utils {
		
		public static var TABS:String = "";
		/**
		 * 	Tests whether the player is online (using the http .
		 *	@since	1.0
		 */
		public static function checkOnlineStatus () : Boolean {
			return (GlobalProxyManager(Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME)).config.movieUrl.indexOf("http") != -1);
		}
		/**
		 * 	Returns a clone of the current object.
		 *	@since	1.0
		 */
		public static function clone(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
		/**
		 * Ensures that an object can be used as an array.
		 * If the object is already an array, it simply returns the object.
		 * If the object is not an array, it returns an array in which the only
		 * element is the object.
		 * @param obj Object that you want to be an array.
		 * @return Original object if already an array, or a new array whose only element is the object.
		 */
		public static function toArray(obj:Object):Array {
			return (obj is Array) ? obj as Array : new Array(obj);
		}
		public static function traceObject (obj:Object, outerChar:String="", initialBlockDisplayed:Boolean=true):void {
		
			//var gpm:GlobalDataManager = GlobalDataManager.getInstance();
			// if the variable we are tracing isn't an object, we can just
			// call the regular trace command and bail out.
			if (typeof (obj) != "object")
				return; // END if
			
			// default the "outer character" of a container to be '{'
			// -- the only other choice here is '['
			if (outerChar == "")
				outerChar = '{'; // END if
				
			// initial block is used to signify if the outer character
			// has already been printed to the screen.
			if (initialBlockDisplayed != true)
				trace (TABS + outerChar); // END if
				
			// every time this function is called we'll add another
			// tab to the indention in the output window
			TABS += "\t";
			
			// loop through everything in the object we're tracing
			for (var i:String in obj) {
				
				// determine what's inside...
				//trace("obj [i] = " + obj [i]);
				switch (typeof (obj [i])) {
					case "object" :
						// the variable is another container
						// check to see if the variable is an array.  Arrays
						// have a "pop" method, and objects don't...
						try {
							//trace("node i = " + i);
							if (typeof (obj [i].pop) == "function") {
								// if an array, use the '[' as the outer character
								trace (TABS + i + ": [");
								// recursive call
								traceObject (obj [i] , '[', true);
							} else {
								trace (TABS + i + ": {");
								// recursive call
								Utils.traceObject (obj [i] , '{', true);
							} // END if
						} catch (e:Error) {
							//trace("Obj " + i + " is not type array but type object");
						}
						break;
					case "string" :
					// display quotes
						trace (TABS + i + ": \"" + obj [i] + "\"");
						break;
					default :
					// variable is not an object or string, just trace it out normally
						trace (TABS + i + ": " + obj [i]);
						break;
				} // END switch
			} // END for
			// here we need to displaying the closing '}' or ']', so we bring
			// the indent back a tab, and set the outerchar to be it's matching
			// closing char, then display it in the output window
			TABS = TABS.substr (0, TABS.length - 1);
			outerChar == '{' ? outerChar = '}' : outerChar = ']';
			trace (TABS + "" + outerChar);
		}
	}
}