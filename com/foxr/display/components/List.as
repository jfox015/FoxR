package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import com.foxr.event.CascadingMenuEvent;
	
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.display.Sprite;
	
	/**
	 * The list object is a simple container that can be used to either group and display 
	 * either FoxR ListItem objects or groupings of other objects as well. 
	 * <p />
	 * <h3>Using List with ListItems</h3>
	 * <p>
	 * To display a list of text based ListItem objects in a list, create and pass a 
	 * FoxR <b>DataProvider</b> object as it's source. The list will be rendered 
	 * according to the data as well as any CSS properties that are assgined to it.
	 * </p>
	 * This class is meant to serve as a base class for custom implementations 
	 * of different kinds of organized lists including but not limited to Combo Boxes 
	 * and Cascading Menus.
	 *
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 * @version			3.1.1
	 * 
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	public class List extends ScrollPane {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/* CONSTANTS */
		/**
		 * Width Proportional Const
		 * @const	WIDTH_PROPORTIONAL:String
		 */
		public static const WIDTH_PROPORTIONAL:String = 'proportional';
		/**
		 * Width Fixed Const
		 * @const	WIDTH_FIXED:String
		 */
		public static const WIDTH_FIXED:String = 'fixed';
		/**
		 * Width Size To List Const
		 * @const	WIDTH_SIZETOLIST:String
		 */
		public static const WIDTH_SIZETOLIST:String = 'sizeToList';
		/**
		 * Width Fixed Const
		 * @const	HEIGHT_FIXED:String
		 */
		public static const HEIGHT_FIXED:String = 'fixed';
		/**
		 * Height - Size To List Const
		 * @const	HEIGHT_SIZETOLIST:String
		 */
		public static const HEIGHT_SIZETOLIST:String = 'sizeToList';
		
		/**
		 * Left open menu
		 * @const	MENU_DIRECTION_LEFT:String
		 */
		public static const COLUMNS_MULTIPLE:String = 'multiple';
		/**
		 * bottom open menu
		 * @const	MENU_DIRECTION_TOP:String
		 */
		public static const COLUMNS_SINGLE:String = 'single';
		
		/**
		 * Left open menu
		 * @const	MENU_DIRECTION_LEFT:String
		 */
		public static const MENU_DIRECTION_LEFT:String = 'left';
		/**
		 * bottom open menu
		 * @const	MENU_DIRECTION_TOP:String
		 */
		public static const MENU_DIRECTION_BOTTOM:String = 'bottom';
		
		/* List Object vars */
		/**
		 * Data List
		 * @var	_dataList:ComponentDataList
		 */
		private var _dataList:ComponentDataList = null;
		/**
		 * Height Type
		 * @var	_heightType:String
		 */
		private var _heightType:String = HEIGHT_SIZETOLIST;
		/**
		 * Width Type
		 * @var	_widthType:String
		 */
		private var _widthType:String = WIDTH_SIZETOLIST;
		
		/**
		 * Maximum Items to Display
		 * @var	_maxItemsToDisplay:Number
		 */
		private var _maxItemsToDisplay:Number;
		
		private var listItemArr:Array = null;
		
		/* CHILD ITEM VARS */
		/**
		 * Item Style
		 * @var	_itemStyle:Object
		 */
		private var _itemStyle:Object = null;
		/**
		 * Item Text Style
		 * @var	_itemTextStyle:TextFormat 
		 */
		private var _itemTextStyle:TextFormat = null;
		/**
		 * Header Style
		 * @var	_headerStyle:Object
		 */
		private var _headerStyle:Object = null;
		/**
		 * Header Text Style
		 * @var	_headerTextStyle:TextFormat 
		 */
		private var _headerTextStyle:TextFormat = null;
		/**
		 * Header Text Style
		 * @var	_headerTextStyle:TextFormat 
		 */
		private var _headerDividerLine:String = '';
		
		/* INTERACTION VARS */
		private var _selectedItem:ListItem = null;
		
		private var _selectedIndex:Number = -1;
		
		private var _highlightedIndex:Number = -1;
		
		/* MULTI COLUMN VARS */
		private var	_multiColumn:Boolean = false;
		
		private var _maxColumnCount:Number = 100;
		
		private var _multiColumnWidth:Number = -1;
		
		private var _columnSpacing:Number =_padding;
		
		private var _maxItemsPerColumn:Number = -1;
		
		/* Cascading Menu properties */
		private var _parentList:Object = null;
		
		private var _menuDirection:String = MENU_DIRECTION_LEFT;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new List instance
		 *
		 */
		public function List() {
			super();
			_dataList = new ComponentDataList();
			
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public override function get className():Class { return List; }
		/**
		 *	Assigns a data list object as the source for the lists items.
		 *  @param	dl	A ComponentDataList object
		 *  @since 	1.0
		 *  
		 */
		public function set dataList(dl:ComponentDataList):void { 
			_dataList = dl;
			if (parentObj != null) setItems();
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
					var item:ListItem = ListItem(content_elem.getChildAt(i));
					if (item != _selectedItem) item.enabled = e; // END if
				} // END for
			} // END if
		}
		/**
		 *	Sets a global background color that will be applied to all options by default. To overdide
		 *  the background color for individual options, add backgroundColor attribute to the 
		 *  customStyle property. 
		 *  @param	c	Color in 0x000000 format
		 *  @since 1.0
		 *  
		 */	
		public function set itemBackgroundColor(c:Number):void { _itemStyle.backgroundColor = c; }
		/**
		 *	Applies the maximum number of items that should be displayed. If the multicolumn 
		 * 	property is set to TRUE, this property determines the maximum number of items to display 
		 *  in a column before it spills over into the next one.
		 *  @param	m	TRUE or FALSE
		 *  @return	TRUE or FALSE
		 * 	@since 	1.0
		 */
		public function get maxItemsToDisplay():Number { return _maxItemsToDisplay; }
		public function set maxItemsToDisplay(m:Number):void { _maxItemsToDisplay = m; }
		/**
		 *	Set if the list should be single column (default) or multi column
		 *  @param	m	The column type - single or multicolumn
		 *  @return		The current column type value
		 * 	@since 	1.0
		 */
		public function get columnType():String { return (_multiColumn == true) ? COLUMNS_MULTIPLE: COLUMNS_SINGLE; }
		public function set columnType(t:String):void { _multiColumn = (t == COLUMNS_MULTIPLE) ? true : false; }
		/**
		 *	If <i>multiColumn</i> is set to TRUE, this setting restricts the list to display only the 
		 *  specified number of columns. Bt default, the list will display as many columns as needed based on the 
		 *  <i>maxItemsPerColumn</i>  setting. With a max column setting, any additional list items will not
		 *  be displayed.
		 *  @param	m	Max number of columns
		 *  @return	Max number of columns
		 * 	@since 	1.0
		 */
		public function get maxColumnCount():Number { return _maxColumnCount; }
		public function set maxColumnCount(m:Number):void { _maxColumnCount = m; }
		/**
		 *	If the <i> multicolumn</i>  property is set to TRUE, this property determines the maximum number 
		 *  of items to display in a column before it spills over into the next one.
		 *  @param	m	The number of items to display per column
		 *  @return		The number of items per column setting
		 * 	@since 	1.0
		 */
		public function get maxItemsPerColumn():Number { return _maxItemsPerColumn; }
		public function set maxItemsPerColumn(m:Number):void { _maxItemsPerColumn = m; }
		/**
		 *	Sets a strict column width. By default, columns are autosized by their contents, but this forces
		 *  a consistent width. If the items contained in the list exceed this number, the column will still
		 * 	stretch to fit it's contents.
		 *  @param	w	Column width in pixels
		 *  @return	Column width in pixels
		 * 	@since 	1.0
		 */
		public function get multiColumnWidth():Number { return _multiColumnWidth; }
		public function set multiColumnWidth(w:Number):void { _multiColumnWidth = w; }
		/**
		 *	Sets the space between columns. Default is 8 pixels.
		 *  @param	s	Column spacing in pixels
		 *  @return	Column spacing in pixels
		 * 	@since 	1.0
		 */
		public function get columnSpacing():Number { return _columnSpacing; }
		public function set columnSpacing(s:Number):void { _columnSpacing = s; }
		/**
		 *	Sets or returns a parent list object if this list is used as a child of CsascadingMenu.
		 *  @param	listParent	Parent list object
		 *  @return				Parent list object
		 * 	@since 	1.0
		 */
		public function get parentList():Object { return _parentList; }
		public function set parentList(listParent:Object):void { _parentList = listParent;	}
		/**
		 *	Sets and returns the selected index of the list. This property works in
		 *  conjunction with the <i> highlightedIndex</i>  property, but it is seperate, 
		 *  meaning that an option may be selected, but may not necesarily be highlighted.
		 *  @param	Number	i	The index of an item to select
		 *  @return	Number	The index of the currently selected item
		 *  @since 	1.0
		 *  
		 */
		public function get selectedIndex():Number { return _selectedIndex }
		public function set selectedIndex(i:Number):void {
			_selectedIndex = i;
			if (_selectedItem != null) _selectedItem.selected(false);
			// MAKE SURE THE INDEX IS A VLAID NUMBER
			if (i != -1) {
				_selectedItem = ListItem(content_elem.getChildAt(i));
				_selectedItem.selected(true);
				value = _selectedItem.value;
				dispatchEvent(new Event(Event.SELECT));
			} else {
				throw(new Error("The index specified is not a valid value for this list."));
			} // END if
		}
		/**
		 *	Returns the text value of a selected list item object.
		 *  @return	The objects text value.
		 *  @since 	1.0
		 *  
		 */
		public function get textValue():String {
			var rtnStr:String = '';
			if (_selectedItem != null) 
				rtnStr = _selectedItem.text;
			return rtnStr;
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
			for (var j:Number = 0; j < content_elem.numChildren; j++) {
				if (j != _selectedIndex) { 
					try {
						var tmpListItem:ListItem = ListItem(content_elem.getChildAt(j));
						if (j == i) {
							tmpListItem.highlight(true);
							if (tmpListItem.action == ListItem.ACTION_OPEN_MENU) {
								switch (_menuDirection) {
									case MENU_DIRECTION_BOTTOM:
										CascadingMenu(parentObj.parent).showMenu(tmpListItem.value, (this.x - 1), (this.height + 1));
										break;
									case MENU_DIRECTION_LEFT:
									default:
										CascadingMenu(parentObj.parent).showMenu(tmpListItem.value, ((this.x + this.width) - 1), ((this.y + tmpListItem.y) - 1));
										break;
								} // END switch
							} // END if
						} else {
							tmpListItem.highlight(false);
						} // END if
					} catch (e:Error) { 
						gpm.log.error("List -> highlightedIndex error occured, error = " + e);
					} // END try/catch
				} // END if
			} // END for
		}
		/**
		 *	Applies a properties object for the list items. This is a global style setting that can be overridden
		 *  per list item if necessary.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set itemStyle(s:Object):void { _itemStyle = s; }
		/**
		 *	Applies a properties object for the list items. This is a global style setting that can be overridden
		 *  per list item if necessary.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set itemTextStyle(s:TextFormat):void { _itemTextStyle = s; }
		/**
		 *	Applies a properties object for the lists header(s). Headers sit above list items and can have
		 *  seperate
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set headerStyle(s:Object):void { _headerStyle = s; }
		/**
		 *	Applies a TextFormat to the lists header item(s).
		 *  @param	s	TextFormat object
		 *  @since 	1.0
		 *  
		 */
		public function set headerTextStyle(s:TextFormat):void { _headerTextStyle = s; }
		/**
		 *	Applies a TextFormat to the lists header item(s).
		 *  @param	s	TextFormat object
		 *  @since 	1.0
		 *  
		 */
		public function set headerDividerLine(dl:String):void { _headerDividerLine = dl;}
		
		/**
		 *	Applies the type of height setting to the object. Setting a height to fixed will prevent
		 *  the background from mathcing the size of the list. Setting the object overflow property to
		 *  "hidden" will hide the remaining items. Setting overflow to "scroll" or "auto" will eneabled 
		 *  scrollbars.
		 *  @param	t	The height type
		 *  @since 	1.0
		 */
		public function set heightType(t:String):void { _heightType = t; }
		/**
		 *	Applies the type of width sizing attribute to the object. Setting a width to fixed keeps the list 
		 *  a fixed size despite the width of any child elements. Size to list or Proporational will resize 
		 *  the list to accomidate the widest ListItem.
		 *  @param	t	The width type
		 *  @since 	1.0
		 */
		public function get widthType():String { return _widthType; }
		public function set widthType(t:String):void { _widthType = t; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 *	Returns the value of the specified index..
		 *  @param	index	The number of the item of which value is to be returned
		 *  @return		The items value
		 *  @since 	1.0
		 *  
		 */
		public function getItemValueAt(index:Number):* { return _dataList.getItemAt(index).value; }
		/**
		 * Resets the object to it's inital state.
		 * @since	1.0
		 */
		public function reset():void {
			
			while (content_elem.numChildren > 0) {
				content_elem.removeChildAt(0);
			} // END while
		}
		/**
		 * Set a new global list width based on the size of child items. This mehotd only accepts values that 
		 * are larger than the current value and only if widthType is not set to WIDTH_FIXED.
		 * @param	w	Width in pixels
		 * @since	1.0
		 */
		public function updateListWidth(w:Number):void {
			if (widthType != WIDTH_FIXED && w > width) {
				super.width = content_elem.width = w;
				refresh();
				for (var i:Number = 0; i < content_elem.numChildren; i++) {
					ListItem(content_elem.getChildAt(i)).width = w;
				} // END while
			} // END if
		}
		/**
		 * Resets the Data list property.
		 * @since	1.0
		 */
		public function resetDataList():void {
			if (_dataList != null) _dataList = null; // END if
		}
		/**
		 * Placeholder method for child objects to execute once they have been added to the movie
		 * stage. This helps with acessing global variable from Main and parent objects.
		 * @since	1.0
		 *
		 */
		public override function objReady(e:Event):void { 
			reset();
			setItems();
		} // END function
		/**
		 * Resets the order of items in the list based on their order in the COmponent
		 * Data List.
		 * @since 	3.0
		 */
		 public function repositionItems():void{
		 	if (listItemArr != null) {
				this.reset();
				for(var i:Number = 0; i<listItemArr.length; i++){
					_dataList.addItem(listItemArr[i]);
				}
			}
		 	setItems();
		 }
		/*------------------------
		/	PRIVATE FUNCTIONS
		/-----------------------*/
		/**
		 * Applies items to the list.
		 * Applies items to the list.
		 * @since	1.0
		 */
		public function setItems():void {
			
			listItemArr = new Array();
			if (_dataList != null) {
				
				try {
					var tmpHeight:Number = 0;
					var visibleHeight:Number = 0;
					var tmpWidth:Number = 0;
					var len:Number = _dataList.length;
					//_childOffset = this.numChildren;
					var currItem:ListItem = null;
					var dividerCount:int = 0;
					
					// Begin multicolumn set-up
					var colTmpWidth:Number = 0, colTmpHeight:Number = 0;
					var optX:Number = 0, optY:Number = 0;
					var colItemsDrawn:Number = 0, totalItemsDrawn:Number = 0, columnCount:Number = 1;
					var columnSizes:Array = [], itemsPerColumn:Number = 0, useHeight:Number = 0;
					
					// SET UP NUMBER OF ITEMSPERCOLUMN
					// CHECK ONE, NO ITEMS PER COLUMN LIMIT SET
					// MAX COLUMS DEFINED BUT NO LIMT OF OPTIONS PER COLUMN
					if (_maxColumnCount != 0 && _maxItemsPerColumn == -1) itemsPerColumn = Math.round(len / _maxColumnCount);
					// MAX COLUMNS DEFINED WITH A LIMT OF OPTIONS PER COLUMN
					// If the number of options to be displayed is more than can be displayed within the dictated
					// limits, override the number of items per column to be equal between all.
					else if (_maxColumnCount != 0 && _maxItemsPerColumn != -1) {
						if ((Math.round(_maxItemsPerColumn * _maxColumnCount)) < len) itemsPerColumn = Math.round(len / _maxColumnCount);
						else itemsPerColumn = _maxItemsPerColumn;
					} else if (_maxColumnCount != 0) itemsPerColumn = _maxItemsPerColumn;
					
					//gpm.log.debug(
					//gpm.log.debug(this.name + " multicolumn set? " + _multiColumn);
					for (var i:Number = 0; i < len; i++) {
						// EDIT 1.9 - JF - Added multi column support
						if (_multiColumn) {
							// If we've reach the max number of items for the current column, start
							// a new column and reset our local column vars
							if (colItemsDrawn == itemsPerColumn) { 
								// Update item widths for the preceeding column
								// get starting index for last columns top item
								var startIdx:int = totalItemsDrawn - (colItemsDrawn * columnCount);
								var endIdx:int = startIdx + colItemsDrawn;
								for (var c:Number = startIdx; c < endIdx; c++)
									content_elem.getChildAt(c).width = colTmpWidth; // END for
								
								columnCount++; 
								if (_multiColumnWidth != -1 || _multiColumnWidth < colTmpWidth) 
									optX = tmpWidth += colTmpWidth + _columnSpacing;
								else
									optX = tmpWidth += _multiColumnWidth + _columnSpacing; // END if
								colItemsDrawn = 0; 
								colTmpWidth = 0;
								colTmpHeight = 0;
								optY = 0;
							} // END if
							// If we've reached our column limit, stop looping
							if (columnCount > _maxColumnCount) break;
						} // END if
						
						/*	ADD THE NEW ITEM */
						currItem = ListItem(content_elem.addElement('item_'+i,ListItem,{x:optX}));
						listItemArr.push(_dataList.getItemAt(i));
						
						currItem.widthType = _widthType;
						currItem.heightType = _heightType;
						
						try {
							if (_dataList.getItemAt(i).header != null) {
								// DRAW HEADER ITEM
								if (_headerStyle != null) currItem.applyProperties(_headerStyle); // END if
								if (_headerTextStyle != null) currItem.textStyle = _headerTextStyle; // END if
								// DRAW DIVIDER LINE 
								if (_headerDividerLine != '') currItem.dividerLine = _headerDividerLine;
							} else {
								// DRAW NORMAL ITEM
								if (_itemStyle != null) currItem.applyProperties(_itemStyle); // END if
								if (_itemTextStyle != null) currItem.textStyle = _itemTextStyle; // END if
							} // END if
						} catch (e:Error) { } // END try/catch
						
						// EMEDDED ITEM OBJECT SUPPORT
						if (_dataList.getItemAt(i).toString() != '[object Object]'){ 
							var cl:Class;
							cl = _dataList.getItemAt(i).constructor;
							currItem.addChild(cl(_dataList.getItemAt(i)));
							currItem.height = _dataList.getItemAt(i).height;
						 	currItem.width = _dataList.getItemAt(i).width;
						} else {
							// Normal ListItem element, SET ITEM PROPERTIES
							
							/**** CASCADING MENU SUPPORT ****/
							// NOT SUPPORTED FOR CUSTOM OBJECT ITEMS
							// TEST IF THIS OBJECT HAS A CHILD MENU SPECIFIED
							// IF SO, extract menu specific data and apply to child item
							var dataItem:Object = _dataList.getItemAt(i);
							if (dataItem != null && (dataItem.childMenu != undefined && dataItem.childMenu != null)) {
								// HAS A CHILD MENU, SET IT UP AND ATTACH IT IN THE _childMenus OBJECT
								CascadingMenu(parentObj.parent).buildMenu(dataItem.id,dataItem.childMenu,this.name);
								currItem.action = ListItem.ACTION_OPEN_MENU;
								currItem.applyProperties( { pointerStyle:{direction:'right',size:6,color:0xCC0000}, pointerDisplay:ListItem.POINTER_DISPLAY_ALWAYS,pointerType:ListItem.POINTER_TYPE_ARROW } );
								currItem.value = dataItem.id;
								//currItem.addEventListener(CascadingMenuEvent.MENU_CLOSE, onMenuClose);
							} // END if
							currItem.addEventListener(CascadingMenuEvent.MENU_CUSTOM_EVENT, onCustomEvent);
							//for (var prop:String in dataItem) {
							//	if (prop != 'childMenu' && prop != 'id') 
							//		currItem[prop] = dataItem[prop];
							//} // END for
							currItem.applyProperties(_dataList.getItemAt(i));
						} // END if
						currItem.y = optY;
						currItem.enabled = true;
						optY += currItem.height + _padding;
						
						// count options drawn to list
						colItemsDrawn++;
						totalItemsDrawn++;
						
						// INCREMENT WIDTH and HEIGHT VARS
						if (_multiColumn) {
							if (currItem.width > colTmpWidth) colTmpWidth = currItem.width;
							// For multicolumn, increment the colTmpHeight var until we reach the
							// end if the coilumn
							colTmpHeight += currItem.height + _padding;
							if (_maxItemsPerColumn != -1 && colItemsDrawn == _maxItemsPerColumn) {
								// if we've reached the end of a column and the individual column height 
								// is greater than any preceeding column, use it
								if (colTmpHeight > tmpHeight)
									tmpHeight = colTmpHeight; // END if
							} // END if
						} else {
							if (currItem.width > tmpWidth) tmpWidth = currItem.width; // END if
							// For single column, simply imcrement the list height
							tmpHeight += currItem.height + _padding;
						} // END if
						
						// if we are in the first column, but have drawn all options, set maxLen to the 
						// width of colMaxLen
						if (_multiColumn && columnCount == 1 && totalItemsDrawn == len) { 
							tmpWidth = colTmpWidth; useHeight = tmpHeight;
						} else if (_multiColumn && totalItemsDrawn == len) {
							tmpWidth += colTmpWidth;
						} else if (_multiColumn && (_maxItemsPerColumn != -1 && colItemsDrawn == _maxItemsPerColumn)) {
							useHeight = tmpHeight;
						} // END if
						
					} // END for
					/** DONE DRAWING ITEMS **/
					
					// Select appropriate width to use for the list based on the _widthType property
					var useWidth:Number = 0;
					switch (_widthType) {
						case WIDTH_PROPORTIONAL:
						case WIDTH_SIZETOLIST:
							useWidth = tmpWidth;
							break;
						case WIDTH_FIXED:
							useWidth = width;
							break;
						default:
							break;
					} // END switch
					
					// For single column lists, assure that each items width matches the width of 
					// the list itself
					if (!_multiColumn) {
						for (var d:Number = 0; d < content_elem.numChildren; d++)
							content_elem.getChildAt(d).width = useWidth; // END for
					} // END if
					
					// Update both the content_elem object and List objects widths
					content_elem.width = width = useWidth;
					
					if (useHeight == 0) useHeight = tmpHeight; // END if
					
					content_elem.height = useHeight;
					
					if (this.height < useHeight) {
						if (_heightType == HEIGHT_SIZETOLIST) {
							if (this._overflow == Element.OVERFLOW_VISIBLE) {
								this.height = useHeight;
							} else {
								if (_maxItemsToDisplay != -1 && visibleHeight == 0) {
									this.height = (currItem.height * this._maxItemsToDisplay);
								} else {
									this.height = visibleHeight;
								} // END if
							} // END if
						} // END if
					} else {
						if (_heightType == HEIGHT_FIXED && _maxItemsToDisplay != -1 && 
							 visibleHeight > 0) {
							this.height = visibleHeight;
						} // END if
					} // END if
					
					setOverflow(content_elem);
					
					dispatchEvent(new Event(Event.COMPLETE));
				} catch (e:Error) {
					gpm.log.error("List -> Error is setItems(). Error for item " + currItem.name + " = " + e);
				} // END try/catch
				
			} // END if
		} // END function
		/*-----------------------------------
		/ Cascading Menu Event handlers
		/----------------------------------*/
		public function closeMenus():void { 
			trace("closeMenus");
			trace("parentObj.parent = "  + parentObj.parent);
			if (parentObj.parent.toString().toLowerCase().indexOf('cascadingmenu') != -1) {
				trace("onMenuClose");
				CascadingMenu(parentObj.parent).showMenu('none'); 
			} // END if
		}
		private function onChangeChild(e:Event):void { }
		
		private function onCustomEvent(e:Event):void { 
			trace("List, onCustomEvent");
			if (parentObj.parent.toString().toLowerCase().indexOf('cascadingmenu') != -1) {
				CascadingMenu(parentObj.parent).onCustomEvent(ListItem(e.currentTarget).value);
			} // END if
		} 
		
	} // END class
} // END package