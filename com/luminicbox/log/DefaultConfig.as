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
	import com.luminicbox.log.*;
	
	/**
	* Abstract class for creating Logger instances with default publishers ( TracePublisher and ConsolePublisher ).
	*/
	public class DefaultConfig {
		/**
		* Creates a Logger instance with the default publisher: TracePublisher and ConsolePublisher.
		* @param id String ( optional ) Used for the logger ID.
		* @param maxDepth Number ( optional ) The max depth for the publishers. The default value is 3.
		* @return A Logger instance.
		*/
		public static function getLogger( id:String="", maxDepth:Number=3 ):Logger {
			var log:Logger = new Logger( id );
			var tp:TracePublisher = new TracePublisher();
			var cp:ConsolePublisher = new ConsolePublisher();
			tp.maxDepth = maxDepth;
			cp.maxDepth = maxDepth;
			log.addPublisher( tp );
			log.addPublisher( cp );
			return log;
		}
		
	}
	
}