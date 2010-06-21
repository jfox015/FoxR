package com.foxr.display.components
{
	/**
	 * The component data list class provides a standard way to store and assign list based
	 * data to list driven objects such as List, 
	 * ComboBox and CascadingMenu. It accepts both XML and array lists of item objects 
	 * and validation to assure the minumum required attrbutes are availble.
	 * 
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 * @see				com.foxr.display.components.List List
	 *
	 */
	public class ComponentDataList {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Data
		 * @var _data:Array
		 */
		private var _data:Array = null;
		/**
		 * Error stack
		 * @var _data:Array
		 */
		private var _errorStack:Array = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ComponentDataList instance
		 *
		 */
		public function ComponentDataList() {
			_data = [];
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Returns the number of data items contained by the object.
		 * @since	1.0
		 * @return			TRUE on success or FALSE on failure
		 */
		public function get length ():Number { return _data.length; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Adds a single object of list attributes to the data list. The object is validated 
		 * for the inclusion of minimum required properties before being added to the data list.
		 * @since	1.0
		 * @param	item	An object of ListItem properties
		 * @return			TRUE on success or FALSE on failure
		 */
		public function addItem(item:Object):Boolean { 
			var rtnObj:Object = validate(item);
			if (rtnObj.status == 0) { _data.push(item); return false;
			} else { trace("Add item operation failed. Status = " + rtnObj.status + ". Error = " + rtnObj.errors);
			return true; }
		}
		/**
		 * Batch function to add multiple list items to the data list. This method accepts list items 
		 * in either XML format or as an array of objects contaiing list properties.
		 * <p />
		 * @usage
		 * <b>Create a new ComponentDataList object:</b><br />
		 * var dp:ComponentDataList = new ComponentDataList();/
		 * <b>Adding item with XML:</b>
		 * var data:XML = <items><item><value>sheraton</value></item>
		 * <item><value>lemeridien</value></item><item><value>whotels</value></item></items>;
	     * dp.addItems(data);
	     * <p />
	     * <b>Add items as an array of objects:</b><br />
	     * var data:Array = [{value:'/whotels/index.html',text:'List Item 1',align:'left',verticalAlign:'middle'},
		 * {value:'/sheraton/index.html',text:'List Item 2',align:'left',verticalAlign:'middle'},
		 * {value:'/sheraton/index.html',text:'List Item 3',align:'left',verticalAlign:'middle'}];
		 * dp.addItems(data);
		 * <p />
		 * 
		 * @since	1.0
		 * @param	item	An object of ListItem properties
		 * @return		TRUE on success or FALSE on failure
		 */
		public function addItems(items:*):Boolean {
			var addError:Boolean = false;
			try {
				if (typeof(items) == 'xml') {	
					var itemNodes:XMLList = items.children();
					for (var i:Number = 0; i < itemNodes.length(); i++) {
						if (!addError) {
							var tmpObj:Object = new Object;
							var itemProps:XMLList = itemNodes[i].children();
							for (var j:Number = 0; j < itemProps.length(); j++) {
								tmpObj[itemProps[j].localName()] = itemProps[j].toString();
							} // END for
							addError = addItem(tmpObj);
						} // END if
					} // END for
				} else if (typeof(items) == 'object' && items.length > 0) {
					for (var k:Number = 0; k < items.length; k++) {
						if (!addError)
							addError = addItem(items[k]); 
						else
							break; // END if
					} // END for
				} // END if
			} catch (e:Error) {
				return false;
			} // END try/catch
			if (!addError) {
				//trace(this + " Items added sucessfully = " + _data.length);
			} else {
				trace("An error occured when adding data items to " + this.toString() + '. Error status = ' + addError);
			} // END if
			return !addError;
		}
		/**
		 * Merges the data list stored internally with another passed as argument.
		 * @since	1.0
		 * @param	l	Array of list data to be merged into the object
		 * @return			The item at the specified index.
		 */
		public function merge(l:Array):Boolean {
			try {
				var tmpArray:Array = _data.concat(l);
				_data = tmpArray;				
			} catch (e:Error) {
				trace("An error occured during list merge operation. Error = " + e);
				return false;
			} // END try/catch
			return true;
		}
		/**
		 * Returns the item at the specified index..
		 * @since	1.0
		 * @param	index	Index of the item to be returned.
		 * @return			The item at the specified index.
		 */
		public function getItemAt(index:Number):Object { return _data[index]; }
		/**
		 * Resets the object to it's inital state.
		 * @since	1.0
		 */
		public function reset():void { _data = []; }
		/**
		 * Creates an Array object representation of the data that the data list contains.
		 * @since	1.0
		 * @return			An Array object representation of the data that the data list contains
		 */
		public function toArray():Array { return _data; }
		/**
		 * Returns the string representation of the specified object..
		 * @since	1.0
		 * @return			A string representation of the specified object.
		 */
		public function toString():String { return '[Object ComponentDataList]'; }
		/*------------------------
		/	PRIVATE FUNCTIONS
		/-----------------------*/
		/**
		 * Validates the item to be added for the basic required attributes.
		 * @since	1.0
		 * @param	item	The item to be tested
		 * @return	Object containing status code and error messaging (if applicable)
		 */
		private function validate(item:Object = null):Object {
			var strOut:String = '';
			if (item != null) {
				strOut += test(item);
			} else {
				for (var obj:Object in _data)
					strOut += test(obj); // END for
			} // END if
			var outObj:Object = new Object();
			if (strOut == '') { outObj.status = 0; outObj.errors = ''; }
			else { outObj.status = 1; outObj.errors = strOut; } // END if
			return outObj;
		}
		/**
		 * Individual test for an validstion item.
		 * @since	1.0
		 * @param	obj	Object to be tested
		 * @return	Test result string.
		 */
		private function test(obj:Object):String {
			var strOut:String = '';
			//if (obj.value == null) strOut += '\nVALUE attrbute is null or missing';
			if (obj.text == null && obj.string == null) strOut += '\nThere is no TEXT or STRING value specified';
			return strOut;
		}
	} // END class
} // END package