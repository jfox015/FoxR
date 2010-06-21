package com.foxr.display.components
{
	//import external classes
	import com.foxr.display.*;
	import com.foxr.display.components.List;
	import com.foxr.display.graphics.Box;
	import com.foxr.display.graphics.PixelCheck;
	import com.foxr.event.CascadingMenuEvent;
	import flash.text.TextFormat;
	
	import flash.events.*;
	import flash.net.URLVariables;
	
	/**
	 * CascadingMenu is a specialized object that allows you to draw menus in a 
	 * cascading format.
	 * <p />
	 * At it's technical roots, the Cascading menu is simply a series of FoxR <b>List</b> 
	 * objects that are connected and can be drawn allowing one list to open another and 
	 * further child lists. 
	 * <p />
	 * There are currently no restrictions on the number of top level nor child menus that 
	 * can be created using this element.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class CascadingMenu extends CompoundElement {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var menuElem:Element = null;
		private var _buildingMenu:Boolean = false;
		private var _menuList:ComponentDataList = null;
		private var _menuQueue:Array = null;
		private var _loaded:Boolean = false;
		private var _menuStyle:Object = null;
		private var _menuItemStyle:Object = null;
		private var _menuItemTextStyle:TextFormat = null;
		private var _value:* = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new CascadingMenu instance
		 *
		 */
		public function CascadingMenu() {
			super();	
			this.removeChild(getChildByName('txt'));
			menuElem = addElement('menuElem', Element);
			_menuQueue = new Array();
			
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/	
		public function set menuList(ml:ComponentDataList):void {
			_menuList = ml;
			if (parentObj != null) buildMenu('root',_menuList); // END if
		}
		
		public function get menusLoaded():Boolean { return _loaded; }
		public function set menuStyle(s:Object):void { _menuStyle = s; }
		/**
		 *	Applies a default set of proeprties to the individual list objects. Thee can be overriden 
		 *  in the supplied ComponentDataList object passed to the list as creation time.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set menuItemStyle(s:Object):void { _menuItemStyle = s; }
		
		public function set menuItemTextStyle(s:TextFormat):void { _menuItemTextStyle = s; }
		/**
		 * Sets the size of the CascadingMenu button. 
		 * @since	1.0
		 * @param	s	The objects size in pixels
		 * @return		The objects size in pixels
		 */
		public function get size():Number {  return _menuList.length; }
		
		public function get value():* {  return _value; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * <i>Internal class method, made public for functional reasons.</i>
		 * <br /><br />
		 * Requests CascadingMenu to add a new submenu. A base menu called 'root' is created by default
		 * but all child menus must have a unique identifier. This method is most often called by the 
		 * loadWithArray() and loadWithXML().
		 * <br /><br />
		 * When there are a number of menus to be built for a class instance, this method creates a 
		 * queue where requests are sent while the class is busy building a menu.
		 * @since	1.0
		 * @param	id				The menu identifier
		 * @param	menuOptions		Array of menu options. Must conform to List options requirements.
		 * @param	parent			The parent menu (if applicable)
		 */
		public function buildMenu(id:String, menuOptions:ComponentDataList = null, parent:Object = null):void {
			// If no menu build is in progress, build the menu now
			// Otherwise add it to the queue
			if (!_buildingMenu) {
				_buildingMenu = true;
				constructMenu(id, menuOptions, parent);
			} else {
				_menuQueue.push({menuId:id,options:menuOptions,parentMenu:parent}); // END if
			} // END if
		}
		/**
		 * 	Hides the root menu list.
		 *	@since	1.0
		 */
		public override function hide():void {
			showMenu('none');
			List(menuElem.getChildByName('root')).hide();
		}
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			bkgd.visible = true;
			reset();
			buildMenu('root', _menuList);
		} // END function
		
		public function onCustomEvent(value:*):void {
			_value = value;
			dispatchEvent(new CascadingMenuEvent(CascadingMenuEvent.MENU_CUSTOM_EVENT));
		}
		/**
		 * Resets the object to it's inital state.
		 * @since	1.0
		 */
		public function reset():void {
			while (menuElem.numChildren > 0) {
				menuElem.removeChildAt(0);
			} // END while
		}
		/**
		 * 	Displays the root menu list.
		 *	@since	1.0
		 */
		public override function show():void {
			List(menuElem.getChildByName('root')).show();
		}
		/**
		 * Function to display a particular menu. This method is generally called from the individual 
		 * menu items themselves, but can be utilized to open a particualr menu if you know the menus
		 * id.
		 * @since	1.0
		 * @param	id			The menu identifier
		 * @param	targetX		The X coordinate to display the menu at.
		 * @param	targetY		The Y coordinate to display the menu at.
		 */
		public function showMenu(id:String,targetX:Number = -1,targetY:Number = -1):void {
			
			for (var i:Number = (menuElem.numChildren - 1); i > 0; i--) {
				var tmpItem:List = List(menuElem.getChildAt(i));

				// TODO, this mehtod currently handles one level of child menus, but does not contain a recursive 
				// methiod to walk up a menu tree back to root to prevent menus from closing.
				if (tmpItem.name != id && tmpItem.name != 'root') {
					var hideItem:Boolean = true;
					// RECURSIVE MENU PARENT CHECK
					// First make sure this isn't a call to close all open menus
					if (menuElem.getChildByName(id) != null) {
						var parentList:String = id;
						while (true) {
							if (List(menuElem.getChildByName(parentList)).parentList != null) {
								parentList = List(menuElem.getChildByName(parentList)).parentList.toString();
								if (tmpItem.name == parentList) {
									hideItem = false;
									break;
								} // END if
							} else {
								break;
							} // END if
						} // END while
					} // END if
					if (hideItem) tmpItem.hide(); // END if
				} // END if
			} // END for
			var listToActivate:List = List(menuElem.getChildByName(id));
			if (listToActivate != null) {
				if (targetX != -1) listToActivate.x = targetX; // END if
				if (targetY != -1) listToActivate.y = targetY; // END if
				listToActivate.show();
			} // END if
		}
		/*--------------------------------------
		/	PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * A sub method to do the actual menu building work. Because only one menu can be built at
		 * a time, this method encapsulates the actual guts of the menu building. Once the current
		 * menu being built is loaded, this method pings <i>testQueue</i> to see if there are any 
		 * further menus waiting to be built. If so, this method is called again.
		 * @since	1.0
		 * @param	id				The menu identifier
		 * @param	menuOptions		Array of menu options. Must conform to List options requirements.
		 * @param	parent			The parent menu (if applicable)
		 */
		private function constructMenu(id:String, menuOptions:ComponentDataList = null, parent:Object = null):void {
			if (menuOptions != null) {
				var tmpMenuList:List = List(menuElem.addElement(id, List,{visible:false},_menuStyle));
				tmpMenuList.addEventListener(Event.COMPLETE, testQueue); // END if
				if (_menuItemStyle != null) tmpMenuList.itemStyle = _menuItemStyle; // END if
				if (_menuItemTextStyle != null) tmpMenuList.itemTextStyle = _menuItemTextStyle;
				tmpMenuList.parentList = parent;
				tmpMenuList.dataList = menuOptions;
			} else {
				_buildingMenu = false;
				gpm.log.debug("constructMenu, empty options list received. Build aborted");
			}
		}
		/**
		 * Called when the current menu is built and loaded. Tests if the menu queue has any menus
		 * waiting to be built and if so, send a <i>constructMenu</i> request and removes that
		 * item from the queue. Once all items in the queue are removed, the cycle ends.
		 * @since	1.0
		 */
		private function testQueue(e:Event):void {
			var tmpList:List = List(e.currentTarget);
			tmpList.removeEventListener(Event.COMPLETE, testQueue);
			if (tmpList.name == 'root') {
				_loaded = true;
				width = tmpList.width;
				height = tmpList.height;
				dispatchEvent(new CascadingMenuEvent(CascadingMenuEvent.MENU_CREATED));
			} // END if
			
			if (_menuQueue.length > 0) {
				var thisItem:Object = _menuQueue.shift();
				this.constructMenu(thisItem.menuId,thisItem.options,thisItem.parentMenu);
			} else {
				_buildingMenu = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}// END if
		}
	} // END class
} // END package