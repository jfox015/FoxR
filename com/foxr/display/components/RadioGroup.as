package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import flash.events.*;
	import flash.text.TextFormat;
	
	/**
	 * The Radio Group is a collection of radio buttons, grouped together so as to 
	 * allow them to function the same way radio buttons do in HTML WEb pages.
	 * <p />
	 * Radio Group takes specifications for each radio button via the ComponentDataList 
	 * object.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class RadioGroup extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Data List
		 * @var	_dataList:ComponentDataList
		 */
		private var _dataList:ComponentDataList = null;
		
		private var _radios:Element = null;
		
		private var _radioStyle:Object = null;
		
		private var _radioTextStyle:TextFormat = null;
		/* INTERACTION VARS */
		private var _selectedItem:Radio = null;
		
		private var _selectedIndex:Number = -1;
		
		private var _highlightedIndex:Number = -1;
		
		private var dispatcher:EventDispatcher = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new RadioGroup instance
		 *
		 */
		public function RadioGroup() {
			super();
			_dataList = new ComponentDataList();
			this.removeChild(this.getChildByName('txt'));
			dispatcher = new EventDispatcher();
			_radios = addElement('_radios',Element,{x:0,y:0});
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public override function get className():Class { return RadioGroup; }
		/**
		 *	Assigns a data list object as the source for the lists items.
		 *  @param	dl	A ComponentDataList object
		 *  @since 	1.0
		 *  
		 */
		public function set dataList(dl:ComponentDataList):void { 
			_dataList = dl;
			if (parentObj != null) {
				reset();
				setItems();
			} // END if
		}
		/**
		 *	Enabls or disabled the list control. Setting this proeprty to false will unselect
		 *  any selected items.
		 *  @param	Boolean	e	TRUE or FALSE
		 *  @return	Boolean	TRUE or FALSE
		 *  @since 	1.0
		 *  
		 */	
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
			var listSize:Number = this.size;
			if (listSize > 0) {
				for (var i:Number = 0; i < listSize; i++) {
					var item:Radio = Radio(_radios.getChildAt(i));
					if (item != _selectedItem) item.enabled = e; // END if
				} // END for
			} // END if
		}
		/**
		 *	Sets and returns the selected index of the list. This property works in
		 *  conjunction with the highlightedIndex property, but it is seperate, 
		 *  meaning that an option may be selected, but may not necesarily be highlighted.
		 *  @param	Number	i	The index of an item to select
		 *  @return	Number	The index of the currently selected item
		 *  @since 	1.0
		 *  
		 */
		public function get selectedIndex():Number { return _selectedIndex }
		public function set selectedIndex(i:Number):void {
			_selectedIndex = i;
			if (_selectedItem != null) _selectedItem.checked(false);
			// MAKE SURE THE INDEX IS A VLAID NUMBER
			if (i != -1) {
				_selectedItem = Radio(_radios.getChildAt(i));
				_selectedItem.checked(true);
				value = _selectedItem.value;
				dispatchEvent(new Event(Event.SELECT));
			} else {
				throw(new Error("The index specified is not a valid value for this list."));
			} // END if
		}
		/**
		 *	Returns the number of items in the current list.
		 *  @return	The number of items in the list
		 *  @since 	1.0
		 *  
		 */
		public function get size():Number { return _dataList.length; }
		/**
		 *	Sets and returns the highlighted index of the list. This property works in
		 *  conjunction with the selectedIndex property, but it is seperate, meaning that
		 *  an option may be highlighted, but not necesarily selected.
		 *  @param	i	The index of an item to highlight
		 *  @return		The index of the currently highlighted item
		 *  @since 	1.0
		 *  
		 */
		public function get highlightedIndex():Number { return _highlightedIndex }
		public function set highlightedIndex(i:Number):void {
			_highlightedIndex = i;
			for (var j:Number = 0; j < _radios.numChildren; j++) {
				if (j != _selectedIndex) { 
					var tmpRadio:Radio = Radio(_radios.getChildAt(j));
					(j == i) ? tmpRadio.checked(true) : tmpRadio.checked(false); 
				}// END if
			} // END for
		}
		/**
		 *	Applies a properties object for the radio items. This is a global style setting that can be overridden
		 *  per radio item if necessary.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set radioStyle(s:Object):void { _radioStyle = s; }
		/**
		 *	Applies a text format for the radio items text fields. This is a global style setting that can be overridden
		 *  per radio item if necessary.
		 *  @param	s	TextFormat Object
		 *  @since 	1.0
		 *  
		 */
		public function set radioTextStyle(s:TextFormat):void { _radioTextStyle = s; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Resets the object to it's inital state.
		 * @since	1.0
		 */
		public function reset():void {
			while (_radios.numChildren > 0) {
				_radios.removeChildAt(0);
			} // END while
		}
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void { 
			if (_dataList != null) {
				reset();
				setItems();
			} // END if
		} // END function
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies radios to the object.
		 * @since	1.0
		 */
		private function setItems():void {
			if (_dataList != null) {
				var len:Number = _dataList.length;
				var currItem:Radio = null;
				var optY:Number = 0;
				try {
					for (var i:Number = 0; i < len; i++) {
						currItem = Radio(_radios.addElement('radio_'+i,Radio));
						if (_radioStyle != null) currItem.applyProperties(_radioStyle); // END if
						if (_radioTextStyle != null) currItem.textStyle = _radioTextStyle; // END if
						currItem.applyProperties(_dataList.getItemAt(i));
						currItem.y = optY;
						optY += currItem.height;
						currItem.enabled = true;
					} // END for
					dispatchEvent(new Event(Event.COMPLETE));
				} catch (e:Error) {
					trace("List -> Error is setItems(). Error for item " + currItem.name + " = " + e);
				} // END try/catch
			}// END if
		}
	} // END class
} // END package