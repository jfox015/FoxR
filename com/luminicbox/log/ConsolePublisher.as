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
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.display.*;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.StaticText;
	
	import com.luminicbox.log.IPublisher;
	import com.luminicbox.log.LogEvent;
	
	/**
	* Publishes logging messages into the FlashInspector (if available)<br />
	* This publisher can be used in any enviroment as long as the FlashInspector is running. It can be used from inside the Flash editor or from the final production enviroment. This allows to see the logging messages even after the final SWF is in production.
	*/
	public class ConsolePublisher implements IPublisher {
		
		private var _version:Number=0.1;
		private var _maxDepth:Number;
		
		/**
		* Sets the max. inspection depth.<br />
		* The default value is 4.
		* The max. valid value is 255.
		*/
		public function set maxDepth( value:Number ):void { _maxDepth = ( _maxDepth>255 )?255:value; }
		/**
		* Gets the max. inspection depth
		*/
		public function get maxDepth():Number { return _maxDepth; }
		
		/**
		* Return the publishers type name: "ConsolePublisher".
		*/
		public function toString():String { return "ConsolePublisher"; }
		
		/**
		* Creates a ConsolePublisher instance with a default max. inspection depth of 4.
		*/
		public function ConsolePublisher() {
			_maxDepth = 4;
		}
		
		/**
		* Serializes and sends a log message to the FlashInspector window.
		*/
		public function publish( e:LogEvent ):void {
			var o:Object = LogEvent.serialize( e );
			o.argument = serializeObj( o.argument,1 );
			var lc:LocalConnection = new LocalConnection();
			lc.addEventListener( StatusEvent.STATUS, onStatus );
			lc.send( "_luminicbox_log_console", "log", o );
		}
		
		private function serializeObj(o:Object, depth:Number):Object {
			var type:Object = getType( o );
			var serial:Object = new Object();
			if( !type.inspectable ) {
				serial.value = o;
			} else if( type.stringify ) {
				serial.value = o+"";
			} else {
				if( depth <= _maxDepth ) {
					if( type.name == "movieclip" || type.name == "loader" || type.name == "sprite" || type.name == "stage" || type.name == "displayobjectcontainer" || type.name == "simplebutton" || type.name == "textfield" || type.name == "avm1movie" || type.name == "bitmap" || type.name == "interactiveobject" || type.name == "morphshape" || type.name == "shape" || type.name == "statictext" || type.name == "video" || type.name == "displayobject" ) serial.id = o + "";
					var items:Array = new Array();
					if( o is Array ) {
						for( var pos:Number=0; pos<o.length; pos++ ) items.push( {property:pos,value:serializeObj( o[pos], (depth+1) )} );
					} else {
						for( var prop:String in o ) items.push( {property:prop,value:serializeObj( o[prop], (depth+1) )} );
					}
					serial.value = items;
				} else {
					serial.reachLimit =true;
				}
			}
			serial.type = type.name;
			return serial;
		}
		
		
		private function getType( o:Object ):Object {
			var typeOf:String = typeof( o );
			var type:Object = new Object();
			type.inspectable = true;
			type.name = typeOf;
			if( typeOf == "boolean" || typeOf == "function" || typeOf == "number" || typeOf == "string" || typeOf == "undefined" ) {
				type.inspectable = false;
			} else if( o is Array ) {
				// ARRAY
				type.name = "array";
			} else if( o is Date ) {
				// DATE
				type.inspectable = false;
				type.name = "date";
				
			// DISPLAYOBJECT RELATED
			} else if( o is MovieClip ) {
				// MOVIECLIP
				type.name = "movieclip";
			} else if( o is Loader ) {
				// LOADER
				type.name = "loader";
			} else if( o is Sprite ) {
				// SPRITE
				type.name = "sprite";
			} else if( o is Stage ) {
				// STAGE
				type.name = "stage";
			} else if( o is DisplayObjectContainer ) {
				// DISPLAYOBJECTCONTAINER
				type.name = "displayobjectcontainer";
			} else if( o is SimpleButton ) {
				// SIMPLEBUTTON
				type.name = "simplebutton";
			} else if( o is TextField ) {
				// TEXTFIELD
				type.name = "textfield";
			} else if( o is AVM1Movie ) {
				// AVM1MOVIE
				type.name = "avm1movie";
			} else if( o is Bitmap ) {
				// BITMAP
				type.name = "bitmap";
			} else if( o is InteractiveObject ) {
				// INTERACTIVEOBJECT
				type.name = "interactiveobject";
			} else if( o is MorphShape ) {
				// MORPHSHAPE
				type.name = "morphshape";
			} else if( o is Shape ) {
				// SHAPE
				type.name = "shape";
			} else if( o is StaticText ) {
				// STATICTEXT
				type.name = "statictext";
			} else if( o is Video ) {
				// VIDEO
				type.name = "video";
			} else if( o is DisplayObject ) {
				// DISPLAYOBJECT
				type.name = "displayobject";
			// XML RELATED
			} else if( o is XMLList ) {
				// XMLLIST
				type.name = "xmllist"
				type.stringify = true;
			} else if( o is XML ) {
				// XML
				type.name = "xml";
				type.stringify = true;
			}
			return type;
		}
		
		
		private function onStatus( e:StatusEvent ):void
		{
			
			if ( e.level == "error" ) trace( "LocalConnection.send() failed\nMake sure the FlashInspector is running\n" );
			
		}
		
	}
	
}