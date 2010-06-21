package com.foxr.util
{
	/**
	 * A utiliy class that converts lat/long values into x/y values.
	 * <p />
	 * Adapted from Java Map Plotting Code originally written by Todd Lynch.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author	Todd Lynch &lt;todd@shifteight.com&gt;
	 * @author	Jeff Fox &lt;jfox@aeoliandigital.com&gt;
	 *
	 */
	public class MapPlotter {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/	
		// CONST
		public static const PROJECTION_PLATECARRE:String = "platecarre";
    	public static const PROJECTION_MERCATOR:String = "mercator";
    	// PRIVATE VARS
    	private var _upperLeftLatitude:Number;
	    private var _upperLeftLongitude:Number;
	    private var _lowerRightLatitude:Number;
	    private var _lowerRightLongitude:Number;
	    private var _pixelHeight:int;
	    private var _pixelWidth:int;
	    private var _projection:String = PROJECTION_PLATECARRE;
		/*------------------------
		/	C'TOR
		/-----------------------*/
		/**
		 * Contructs a new MapPlotter instance.
		 * @param	upperLeftLatitude	Upper Left Latitude
		 * @param	upperLeftLongitude	Upper Left Longitude
		 * @param	lowerRightLatitude	Lower Right Latitude
		 * @param	lowerRightLongitude	Lower Right Longitude
		 * @param	pixelHeight	Map height
		 * @param	pixelWidth	Map Width
		 * @param	projection	(OPTIONAL) Projection Type
		 */
		public function MapPlotter(upperLeftLatitude:Number, upperLeftLongitude:Number, 
		lowerRightLatitude:Number, lowerRightLongitude:Number, pixelHeight:int, pixelWidth:int, projection:String = '') {
			_upperLeftLatitude = upperLeftLatitude;
    		_upperLeftLongitude = upperLeftLongitude;
    		_lowerRightLatitude = lowerRightLatitude;
   			_lowerRightLongitude = lowerRightLongitude;
			_pixelHeight = pixelHeight;
    		_pixelWidth = pixelWidth;
    		if (projection != '') _projection = projection;
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Assigns and returns a projection type. 
		 * @param	projection	Projection Type
		 * @return	Projection Type
		 */
		public function get projection():String { return _projection; }
		public function set projection(p:String):void { _projection = p; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Converts the passed lat/long values into a corresponding x.y and returns 
		 * as an object
		 * @param	longitude	Point Longitude
		 * @param	latitude	Point Latitude
		 * @return	Object contaiing converted x.y point
		 */
		public function plotPoint(longitude:Number, latitude:Number):Object {
			switch (_projection) {
    			case PROJECTION_MERCATOR:
    				latitude = ((latitude * -1) + 90);
    				longitude +=180;
    				break;
    			case PROJECTION_PLATECARRE:
    			default:
	    			break;
   			} // END switch
			var x:Number = Math.round((_pixelWidth * (longitude - _upperLeftLongitude)) / (_lowerRightLongitude - _upperLeftLongitude));
			var y:Number = Math.round((_pixelHeight * (latitude - _upperLeftLatitude)) / (_lowerRightLatitude - _upperLeftLatitude ));
			return {x:x,y:y};
		}
	}
}