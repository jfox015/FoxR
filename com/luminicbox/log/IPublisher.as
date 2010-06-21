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
	import com.luminicbox.log.LogEvent;
	
	/**
	* Basic publisher interface. All publishers must implement it.
	*/
	public interface IPublisher {
		
		/**
		* Publishes the supplied LogEvent.<br />
		* The task this method must acomplish depends on the publisher.
		*/
		function publish( e:LogEvent ):void;
		
		/**
		* Returns the publisher's type or name.
		*/
		function toString():String;
	}
	
}