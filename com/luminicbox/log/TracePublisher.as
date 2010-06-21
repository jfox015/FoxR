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

package com.luminicbox.log
{
	import flash.display.*;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.StaticText;
	
	import com.luminicbox.log.IPublisher;
	import com.luminicbox.log.LogEvent;
	import com.luminicbox.util.StringUtil;
	
	/**
	* Publishes logging messages into the OUTPUT window of the Macromedia Flash editor.<br />
	* This publisher can only be used inside the Flash editor and uses the trace() command internally.
	*/
	public class TracePublisher implements IPublisher {
		
		private var _maxDepth:Number;
		
		/**
		* Sets the max. inspection depth.<br />
		* The default value is 4.
		* The max. valid value is 255.
		*/
		public function set maxDepth( value:Number ):void { _maxDepth = (_maxDepth>255)?255:value; }
		/**
		* Gets the max. inspection depth
		*/
		public function get maxDepth():Number { return _maxDepth; }
		
		/**
		* Return the publishers type name: "TracePublisher".
		*/
		public function toString():String { return "TracePublisher"; }	
		
		/**
		* Creates a TracePublisher instance with a default max. inspection depth of 4.
		*/
		public function TracePublisher() {
			_maxDepth = 4;
		}
		
		/**
		* Logs a message into the OUTPUT window of the Flash editor.
		*/
		public function publish( e:LogEvent ):void {
			var arg:Object = e.argument;
			var txt:String = "*" + e.level.toString() + "*";
			if( e.loggerId ) txt += ":" + e.loggerId;
			txt += ":";
			txt += analyzeObj( arg,1 );
			trace( txt );
		}

		private function analyzeObj( o:Object, depth:Number ):String {
			var txt:String = "";
			var typeOf:String = typeof( o );
			if( typeOf == "string" ) {
				// STRING
				txt += "\"" + o + "\"";
			} else if( typeOf == "boolean" || typeOf == "number" ) {
				// BOOLEAN / NUMBER
				txt += o;
			} else if( typeOf == "undefined" ) {
				// UNDEFINED
				txt += "( "+typeOf+" )";
			} else {
				// OBJECT
				var stringifyObj:Boolean = false;
				var analyze:Boolean = true;
				if( o is Array ) {
					// ARRAY
					typeOf = "array";
					stringifyObj = false;
				} else if( o is Date ) {
					// DATE
					typeOf = "date";
					analyze = false;
					stringifyObj = true;
					
				// DISPLAYOBJECT RELATED
				} else if( o is MovieClip ) {
					// MOVIECLIP
					typeOf = "movieclip";
					stringifyObj = true;
				} else if( o is Loader ) {
					// LOADER
					typeOf = "loader";
					stringifyObj = true;
				} else if( o is Sprite ) {
					// SPRITE
					typeOf = "sprite";
					stringifyObj = true;
				} else if( o is Stage ) {
					// STAGE
					typeOf = "stage";
					stringifyObj = true;
				} else if( o is DisplayObjectContainer ) {
					// DISPLAYOBJECTCONTAINER
					typeOf = "displayobjectcontainer";
					stringifyObj = true;
				} else if( o is SimpleButton ) {
					// SIMPLEBUTTON
					typeOf = "simplebutton";
					stringifyObj = true;
				} else if( o is TextField ) {
					// TEXTFIELD
					typeOf = "textfield";
					stringifyObj = true;
				} else if( o is AVM1Movie ) {
					// AVM1MOVIE
					typeOf = "avm1movie";
					stringifyObj = true;
				} else if( o is Bitmap ) {
					// BITMAP
					typeOf = "bitmap";
					stringifyObj = true;
				} else if( o is InteractiveObject ) {
					// INTERACTIVEOBJECT
					typeOf = "interactiveobject";
					stringifyObj = true;
				} else if( o is MorphShape ) {
					// MORPHSHAPE
					typeOf = "morphshape";
					stringifyObj = true;
				} else if( o is Shape ) {
					// SHAPE
					typeOf = "shape";
					stringifyObj = true;
				} else if( o is StaticText ) {
					// STATICTEXT
					typeOf = "statictext";
					stringifyObj = true;
				} else if( o is Video ) {
					// VIDEO
					typeOf = "video";
					stringifyObj = true;
				} else if( o is DisplayObject ) {
					// DISPLAYOBJECT
					typeOf = "displayobject";
					stringifyObj = true;
					
				// XML RELATED
				} else if( o is XMLList ) {
					// XMLLIST
					typeOf = "xmllist";
					analyze = false;
					stringifyObj = true;
				} else if( o is XML ) {
					// XML
					typeOf = "xml";
					analyze = false;
					stringifyObj = true;
				}
				txt += "( " + typeOf + " ) ";
				if( stringifyObj ) txt += o.toString();
				if( analyze && depth <= _maxDepth ) {
					var txtProps:String = "";
					for( var prop:String in o ) {
						txtProps += "\n" +
							StringUtil.multiply( "\t", ( depth+1 ) ) +
							prop + ":" +
							analyzeObj( o[prop], ( depth+1 ) );
					}
					if( txtProps.length > 0 ) txt += "{" + txtProps + "\n" + StringUtil.multiply( "\t", depth ) + "}";
				}
			}
			return txt;
		}
		
	}
	
}