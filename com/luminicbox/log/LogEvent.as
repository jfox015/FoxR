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
	import com.luminicbox.log.Level;
	
	/**
	* Represents a log message with information about the object to inspect, its level, the originator logger and other information.<br />
	* THIS CLASS IS USED INTERNALLY. It should only be used when implementing publishers.
	*/
	public class LogEvent {
		
		/**
		* The event's timetamp.
		*/
		public var time:Date;
		/**
		* The originator logger id.
		*/
		public var loggerId:String;
		/**
		* The message level.
		*/
		public var level:Level;
		/**
		* The message or object
		*/
		public var argument:Object;
		
		/**
		* Creates a LogEvent instance.
		* @param loggerId The originators logged id. It may be null.
		* @param argument The message or object to log.
		* @param level The level of the event.
		*/
		public function LogEvent( loggerId:String, argument:Object, level:Level ) {
			this.loggerId = loggerId;
			this.argument = argument;
			this.level = level;
			time = new Date();
		}
		
		/**
		* Serializes the LogEvent object into an object that can be passed to LocalConnection or similar objects.
		* @param logEvent A LogEvent obj.
		* @returns A serialized LogEvent obj.
		*/
		public static function serialize( logEvent:LogEvent ):Object {
			var o:Object = new Object();
			o.loggerId = logEvent.loggerId;
			o.time = logEvent.time;
			o.levelName = logEvent.level.getName();
			o.argument = logEvent.argument;
			return o;
		}
		
		/**
		* Deseriliazes a serialized LogEvent object into a LogEvent obj.
		* @param o The serialized LogEvent obj.
		* @returns A LogEvent obj.
		*/
		public static function deserialize( o:Object ):LogEvent {
			var l:Level = Level[""+o.levelName];
			var e:LogEvent = new LogEvent( o.loggerId, o.argument, l );
			e.time = o.time;
			return e;
		}
		
	}
	
}