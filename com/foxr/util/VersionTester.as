package com.foxr.util
{
	import flash.system.Capabilities;
	/** 
	 * This class is used to test the version of the FlashPlayer the movie is being 
	 * viewed with and match it against a minimum required value that is specified in 
	 * the GlobalConfig.as file located in the com.foxr.data folder of the project.
	 *
	 * @author		Jeff Fox
	 * @version 	2.0
	 */
	public class VersionTester{
		/** 
		 * Tests the current FlashPlayer version to see if it is greater than or 
		 * equal to the minimum required version for the movie.
		 * 
		 * @param 	versionNeeded 	The minimum flash version required
		 * @return	TRUE if meets minimum version requirements, FALSE if not
		 * @since 	1.0
		 */
		public static function testVersion(versionNeeded:String):Boolean {
			var hasPlayer:Boolean = false;
			var ver:String = Capabilities.version;
			ver = StringUtils.replace(ver,",",".");
			ver = ver.substring(ver.indexOf(" ")+1);
			ver = ver.substring(0,ver.lastIndexOf(".")-1);
			var finalVer:Array = ver.split(".");
			var needVer:Array = versionNeeded.split(".");
			// TEST MAJOR
			if (int(finalVer[0]) >= int(needVer[0])) {
				// TEST MINOR, if applicable
				if (finalVer[1] != undefined && needVer[1] != undefined) {
					if (int(finalVer[1]) >= int(needVer[1])) {
						if (finalVer[2] != undefined && needVer[2] != undefined) {
							if (int(finalVer[2]) >= int(needVer[2])) {
								hasPlayer = true;
							} // END if	
						} else {
							hasPlayer = true;
						} // END if	
					} // END if	
				} else {
					hasPlayer = true;
				}// END if
			} // END if
			if (!hasPlayer) 
				trace("Version Test Error: Minimum Required Flash Player version not met. " + versionNeeded + " was required, found player version " + Capabilities.version);  // END if
			return(hasPlayer);
		} // END function
	} // END class
} // END package