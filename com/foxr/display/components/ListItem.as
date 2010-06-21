package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.controller.Application;
	import com.foxr.display.*;
	import com.foxr.display.buttons.*;
	import com.foxr.display.graphics.*;
	import com.foxr.display.content.Image;
	import com.foxr.event.ElementEvent;
	import com.foxr.event.CascadingMenuEvent;
	import com.foxr.util.Utils;
	import flash.net.URLRequest;
	
	import flash.events.*;
	import flash.net.navigateToURL;
	import flash.text.*;
	
	/**
	 * An individual List item object. Provides a base for creating custom
	 * List items.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 * 
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class ListItem extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		// CONSTANTS
		public static const BULLET_TYPE_NONE:String = 'none';
		public static const BULLET_TYPE_ARROW:String = 'arrow';
		public static const BULLET_TYPE_DOT:String = 'dot';
		public static const BULLET_TYPE_CUSTOM:String = 'custom';
		
		public static const BULLET_DISPLAY_NEVER:String = 'never';
		public static const BULLET_DISPLAY_ALWAYS:String = 'always';
		public static const BULLET_DISPLAY_MOUSEOVER:String = 'mousover';
		
		public static const DIVIDER_VISIBLE:String = 'visible';
		public static const DIVIDER_HIDDEN:String = 'hidden';
		
		public static const POINTER_TYPE_NONE:String = 'none';
		public static const POINTER_TYPE_ARROW:String = 'arrow';
		public static const POINTER_TYPE_DOT:String = 'dot';
		public static const POINTER_TYPE_CUSTOM:String = 'custom';
		
		public static const POINTER_DISPLAY_NEVER:String = 'never';
		public static const POINTER_DISPLAY_ALWAYS:String = 'always';
		public static const POINTER_DISPLAY_MOUSEOVER:String = 'mousover';
		
		public static const ACTION_NAVIGATE_TO_URL:String = 'url';
		public static const ACTION_SELECT:String = 'select';
		public static const ACTION_OPEN_MENU:String = 'openChildList';
		public static const ACTION_CUSTOM:String = 'custom';
		public static const ACTION_CHANGE_PAGE:String = 'changePage';
		public static const ACTION_CHANGECHILDPAGE:String = 'changeChildPage';
	
		public static const EVENT_CLICK:String = 'click';
		public static const EVENT_MOUSEOVER:String = 'mouceover';
		public static const EVENT_MOUSEOUT:String = 'mouseout';
		/**
		 * Bullet
		 * @var bullet:Element
		 */
		protected var bullet:Element = null;
		/**
		 * Bullet Asset
		 * @var _bulletAsset:String
		 */
		protected var _bulletAsset:String = '';
		/**
		 * Bullet Color
		 * @var _bulletColor:Number
		 */
		protected var _bulletColor:Number = -1;
		/**
		 * Bullet Display
		 * @var _bulletDisplay:String
		 */
		protected var _bulletDisplay:String = BULLET_DISPLAY_NEVER;
		/**
		 * Button Hover Color
		 * @var _bulletHoverColor:Number
		 */
		protected var _bulletHoverColor:Number = -1;
		/**
		 * Bullet Style
		 * @var _bulletStyle:Object
		 */
		protected var _bulletStyle:Object = null;
		/**
		 * Bullet Type
		 * @var _bulletType:String
		 */
		protected var _bulletType:String = BULLET_TYPE_NONE;
		/**
		 * Pointer
		 * @var pointer:Element
		 */
		protected var pointer:Element = null;
		/**
		 * Pointer Asset
		 * @var _pointerAsset:String
		 */
		protected var _pointerAsset:String = '';
		/**
		 * Pointer Color
		 * @var _pointerColor:Number
		 */
		protected var _pointerColor:Number = -1;
		/**
		 * Pointer Arrow Color
		 * @var _pointerHoverColor:Number
		 */
		protected var _pointerHoverColor:Number = -1;
		/**
		 * Pointer Display
		 * @var _pointerDisplay
		 */
		protected var _pointerDisplay:String = POINTER_DISPLAY_NEVER;
		/**
		 * Pointer Style
		 * @var _pointerStyle:Object
		 */
		protected var _pointerStyle:Object = null;
		/**
		 * Pointer Type
		 * @var _bulletType:String
		 */
		protected var _pointerType:String = POINTER_TYPE_NONE;
		
		/** HEADER SUPPORT **/
		/**
		 * Divider Line
		 * @var divLine:Box
		 */
		protected var divLine:Box = null;
		
		protected var _dividerLine:String = DIVIDER_HIDDEN;
		/**
		 * Header
		 * @var _heightType:String
		 */
		protected var _header:Boolean = false;
		
		/** CASCADING MENU SUPPORT **/
		/**
		 * Menu Action
		 * @var _action:String
		 */
		protected var _action:String = ACTION_SELECT;
		/**
		 * Menu Event handler
		 * @var _eventHandler:String
		 */
		protected var _eventHandler:String = EVENT_CLICK;
		
		/** TEXT COLOR STYLES **/
		/**
		 * Normal Color
		 * @var _normalColor:Number
		 */
		protected var _normalColor:Number = -1;
		/**
		 * Hover Color
		 * @var _hoverColor:Number
		 */
		protected var _hoverColor:Number = -1;
		/**
		 * No Value Color
		 * @var _novalueColor:Number
		 */
		protected var _novalueColor:Number = -1;
		
		/** BACKGROUND COLOR STYLES **/
		/**
		 * Hover Background Color
		 * @var _hoverBackgroundColor:Number
		 */
		protected var _hoverBackgroundColor:Number = -1;
		/**
		 * Normal Background Color
		 * @var _normalBackgroundColor:Number
		 */
		protected var _normalBackgroundColor:Number = -1;
		
		/** SIZE TYPE SETTINGS **/
		/**
		 * Width Type
		 * @var _widthType:String
		 */
		protected var _widthType:String = List.WIDTH_SIZETOLIST;
		/**
		 * Height Type
		 * @var _heightType:String
		 */
		protected var _heightType:String = List.HEIGHT_FIXED;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ListItem instance
		 *
		 */
		public function ListItem() {
			super();
			_alignment = ALIGN_LEFT;
			_verticalAlignment = VALIGN_MIDDLE;
			bullet = addElement('bullet', Element,{visible:false});
			pointer = addElement('pointer', Element, { visible:false } );
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Sets the click action of the ListItem object. Default action is ACTION_SELECT
		 * which sets the item to selected and applies it's value to the parent List object 
		 * (if the item is embedded in a list)
		 * Valid options are:
		 * <ul>
		 * 	<li>ACTION_NAVIGATE_TO_URL</li>
		 * 	<li>ACTION_CUSTOM</li>
		 * 	<li>ACTION_CHANGE_PAGE</li>
		 * 	<li>ACTION_CHANGECHILDPAGE</li>
		 * 	<li>ACTION_OPEN_MENU</li>
		 * 	<li>ACTION_SELECT</li>
		 * </ul>
		 * @param	a	A valid item Action.
		 * @param		The action value.
		 * @since	1.0
		 * 
		 */
		public function get action():String { return _action; }
		public function set action(a:String):void { _action = a; }
		/**
		 * Changes the alignment of the objects text field. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get textAlign():String { return _alignment; }
		public override function set textAlign(a:String):void {
			super.textAlign = a;
			pointer.x = ((width - pointer.width) - _padding);
			if (_pointerType == POINTER_TYPE_ARROW) pointer.x -= 5;
			bullet.x = _padding;
			//trace(this.name + "align, a = " + a + ", width = " + width);
			switch (a) {
				/*case 'center':
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						bullet.x = (txt.x - ((bullet.width / 2) - (_padding / 2)));
						txt.x += ((bullet.width / 2) + (_padding / 2));
					}
					if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
						if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
							bullet.x -= (bullet.x - ((pointer.width / 2) - (_padding / 2)));	
						}
						txt.x -= (txt.x - ((pointer.width / 2) - (_padding / 2)));
						pointer.x = ((txt.x + txt.textWidth) + _padding);
					}
					break;*/
				case 'right':
					if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
						txt.x -= (pointer.width + _padding);
					}
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						bullet.x = (txt.x - (bullet.width + _padding));
					}
					//trace("align right, txt.x = " + txt.x + " txt.x + txt.width = " + (txt.x + txt.width));
					break;
				case 'left':
				default:
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						txt.x += ((bullet.x + bullet.width) + _padding);
					}
					//if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
					//	pointer.x = ((txt.x + txt.textWidth) + _padding * 2);
					//}
					//trace("align left, txt.x = " + txt.x + " txt.x + txt.width = " + (txt.x + txt.width));
					break;
			} // END switch*/
		} // END function
		/**
		 * Sets the bullet color value.
		 * @param	c	Color in 0x000000 format
		 * @return		Color in 0x000000 format
		 * @since	1.0
		 */
		public function get bulletColor():Number{ return _bulletColor;  }
		public function set bulletColor(c:Number):void { _bulletColor = c; highlight(false);  }
		/**
		 * Sets the bullet hover color value.
		 * @param	c	Color in 0x000000 format
		 * @return		Color in 0x000000 format
		 * @since	1.0
		 */
		public function get bulletHoverColor():Number{ return _bulletHoverColor;  }
		public function set bulletHoverColor(c:Number):void { _bulletHoverColor = c;  }
		/**
		 * Sets the bullet asset path.
		 * @param	d	bullet assett path
		 * @return		bullet assett path
		 * @since	1.0
		 */
		public function get bulletAsset():String{ return _bulletAsset;  }
		public function set bulletAsset(a:String):void { 
			_bulletAsset = a;
			gpm.log.debug("_bulletAsset = " + _bulletAsset);
			gpm.log.debug("bullet.getChildByName('elem') = " + bullet.getChildByName('elem'));
			if (_bulletAsset != '' && bullet.getChildByName('elem') != null) {
				var tmpElem:Image = Image(bullet.getChildByName('elem'));
				tmpElem.src = _bulletAsset;
				tmpElem.addEventListener(Event.COMPLETE, onCustomAssetLoaded);
			} // END if
		}
		/**
		 * Sets the bullet display type.
		 * @param	d	Bullet display type
		 * @return		Bullet display type
		 * @since	1.0
		 */
		public function get bulletDisplay():String{ return _bulletDisplay;  }
		public function set bulletDisplay(d:String):void { _bulletDisplay = d;  
			if (bullet.getChildByName('elem') != null) {
				var bulletElem:Element = Element(bullet.getChildByName('elem'));
				switch (_pointerDisplay) {
					case BULLET_DISPLAY_ALWAYS:
						bulletElem.visible = true;
						break;
					case BULLET_DISPLAY_MOUSEOVER:
					case BULLET_DISPLAY_NEVER:
						bulletElem.visible = false;
						break;
				} // END switch
				updateSize();
			}
		}
		/**
		 * Sets a style object to the bullet object.
		 * @param	s	Style object
		 * @since	1.0
		 */
		public function set bulletStyle(s:Object):void { _bulletStyle = s; 
			if (bullet.getChildByName('elem') != null) {
				switch (_bulletType) {
					case BULLET_TYPE_ARROW:
					case BULLET_TYPE_DOT:
						Graphic(bullet.getChildByName('elem')).applyProperties(s);
						break;
					case BULLET_TYPE_CUSTOM:
						Image(bullet.getChildByName('elem')).applyProperties(s);
						break;
					default:
						break;
				} // END switch
				updateSize();
			}
		}
		/**
		 * Sets the bullet display type.
		 * @param	d	Bullet display type
		 * @return		Bullet display type
		 * @since	1.0
		 */
		public function get bulletType():String{ return _bulletType;  }
		public function set bulletType(t:String):void { _bulletType = t;  
			addSpecialElement('bullet',t);
		}
		public function set childMenu(m:String):void {  }
		/**
		 *  Adds a divider line beneath the list item object.
		 *  @param	d	TRUE or FALSE
		 *  @since 1.0
		 */
		public function set dividerLine(d:String):void {
			_dividerLine = d;
			if (_dividerLine == DIVIDER_VISIBLE && (height != 0 || txt.textHeight != 0))
				drawDividerLine();
		}
		/**
		 *  Sets the _enabled flag.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void { 
			if (header == false && (this.value == null && _novalueColor != -1)) {
				e = false;
				var tf:TextFormat = new TextFormat();
				tf.color = _novalueColor;
				txt.style = tf;
			} // END if
			_enabled = e; 
			this.buttonMode = e; this.useHandCursor = e; this.mouseChildren = !e;
			txt.hover = e ? 'hover' : 'none';
			if (e) {
				this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				this.addEventListener(MouseEvent.CLICK,onMouseClick);
			} else {
				this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				this.removeEventListener(MouseEvent.CLICK,onMouseClick);
			} // END if
		} // END function
		/**
		 * 	Choose whether to perform menu action on rollover, rollout or release. 
		 *  @since 1.5
		 *  @param	e	Event to respond to, <i>release</i>, <i>rollout</i> or <i>rollover</i> 
		 */
		public function get eventHandler():String { return _eventHandler; }
		public function set eventHandler(e:String):void { _eventHandler = e; }
		/**
		 *	Specified whether this item should be drawn as a header or regualr list item.
		 *  @param	h	TRUE or FALSE
		 *  @return		The header value
		 *  @since 	1.9
		 */
		public function get header():Boolean { return _header; }
		public function set header(h:Boolean):void { _header = h; }
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
		 * Changes the color of the objects background. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function set hoverBackgroundColor(c:Number):void { _hoverBackgroundColor = c; }
		/**
		 * Changes the color of the text on rollOver. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function set hoverColor(c:Number):void { _hoverColor = c; } 
		/**
		 * Changes the color of the text when ther eis no value applied to the item. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public function set novalueColor(c:Number):void { _novalueColor = c; }
		/**
		 * Sets the pointer color value.
		 * @param	c	Color in 0x000000 format
		 * @return		Color in 0x000000 format
		 * @since	1.0
		 */
		public function get pointerColor():Number{ return _pointerColor;  }
		public function set pointerColor(c:Number):void { _pointerColor = c; highlight(false);  }
		/**
		 * Sets the pointer hover color value.
		 * @param	c	Color in 0x000000 format
		 * @return		Color in 0x000000 format
		 * @since	1.0
		 */
		public function get pointerHoverColor():Number{ return _pointerHoverColor;  }
		public function set pointerHoverColor(c:Number):void { _pointerHoverColor = c;  }
		/**
		 * Sets the pointer asset path.
		 * @param	d	pointer assett path
		 * @return		pointer assett path
		 * @since	1.0
		 */
		public function get pointerAsset():String{ return _pointerAsset;  }
		public function set pointerAsset(a:String):void { _pointerAsset = a;
			if (_pointerAsset != '' && pointer.getChildByName('elem') != null) {
				var tmpElem:Image = Image(pointer.getChildByName('elem'));
				tmpElem.src = _pointerAsset;
				tmpElem.addEventListener(Event.COMPLETE, onCustomAssetLoaded);
			} // END if
		}
		/**
		 * Sets the pointer display type.
		 * @param	d	pointer display type
		 * @return		pointer display type
		 * @since	1.0
		 */
		public function get pointerDisplay():String{ return _pointerDisplay;  }
		public function set pointerDisplay(d:String):void { _pointerDisplay = d; 
			if (pointer.getChildByName('elem') != null) {
				var pointElem:Element = Element(pointer.getChildByName('elem'));
				switch (_pointerDisplay) {
					case POINTER_DISPLAY_ALWAYS:
						pointElem.visible = true;
						break;
					case POINTER_DISPLAY_MOUSEOVER:
					case POINTER_DISPLAY_NEVER:
						pointElem.visible = false;
						break;
				} // END switch
				updateSize();
			}
		}
		/**
		 * Sets a style object to the pointer object.
		 * @param	s	Style object
		 * @since	1.0
		 */
		public function set pointerStyle(s:Object):void { _pointerStyle = s;
			//gpm.log.debug("pointerStyle = " + _pointerStyle);
			//Utils.traceObject(_pointerStyle);
			if (pointer.getChildByName('elem') != null) {
				switch (_pointerType) {
					case POINTER_TYPE_ARROW:
					case POINTER_TYPE_DOT:
						Graphic(pointer.getChildByName('elem')).applyProperties(s);
						break;
					case POINTER_TYPE_CUSTOM:
						Image(pointer.getChildByName('elem')).applyProperties(s);
						break;
					default:
						break;
				} // END switch
				updateSize();
			}
		}
		/**
		 * Sets the pointer display type.
		 * @param	d	pointer display type
		 * @return		pointer display type
		 * @since	1.0
		 */
		public function get pointerType():String{ return _pointerType;  }
		public function set pointerType(t:String):void { _pointerType = t;
			addSpecialElement('pointer',t);
		}
		/**
		 * Applies a text value to the object. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set string(t:String):void { 
			super.string = t;
			updateSize();
		}
		/**
		 * Applies a text value to the object. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function set text(t:String):void { 
			super.text = t;
			updateSize();
		}
		/**
		 * Applies a text format style to the object. 
		 * @since	1.0
		 * @param	s	TextFormat style object
		 * @return		TextFormat style object
		 */
		public override function set textStyle(s:TextFormat):void { 
			super.textStyle = s;
			updateSize();
		}
		/**
		 * Changes the vertical alignment of the objects text field. 
		 * @since	1.0
		 * @param	a	The alignment (top, middle or bottom)
		 * @return		The alignment (top, middle or bottom)
		 */
		public override function get verticalAlign():String { return _verticalAlignment; }
		public override function set verticalAlign(a:String):void {
			super.verticalAlign = a;
			switch (a) {
				case 'middle':
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						bullet.y = (bkgd.height / 2) - (bullet.height / 2);
					}
					if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
						pointer.y = (bkgd.height / 2) - (pointer.height / 2);
						if (_pointerType == POINTER_TYPE_ARROW) pointer.y -= 5;
					}
					break;
				case 'bottom':
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						bullet.y = (bkgd.height - bullet.height) - _padding;
					}
					if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
						pointer.y = (bkgd.height - pointer.height) - _padding;
					}
					break;
				case 'top':
				default:
					if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
						bullet.y = _padding;
					}
					if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
						pointer.y = _padding;
					}
					break;
			} // END switch
		} // END function
		/**
		 *	Applies the type of width sizing attribute to the object. Setting a width to fixed keeps the list 
		 *  a fixed size despite the width of any child elements. Size to list or Proporational will resize 
		 *  the list to accomidate the widest ListItem.
		 *  @param	t	The width type
		 *  @since 	1.5
		 */
		public function get widthType():String { return _widthType; }
		public function set widthType(t:String):void { _widthType = t; }
		/**
		 *	Applies the item width to the divider line.
		 *  @param	t	The width type
		 *  @since 	1.5
		 */
		public override function set width(w:Number):void { 
			super.width = w; 
			if (_dividerLine == DIVIDER_VISIBLE) drawDividerLine();
			textAlign = _alignment;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Applies a highlighted setting to the object.
		 *	@since	1.0
		 * 	@param	s	TRUE or FALSE 
		 */
		public function highlight(h:Boolean):void {
			var txtF:TextFormat = new TextFormat();
			
			if (h && this.value != null) {
				
				/** SET HIGHLIGHTED ITEM VIEW **/
				
				if (_normalColor == -1) _normalColor = txt.color; // END if
				if (_hoverColor != -1) {
					txtF.color = _hoverColor;
					txt.style = txtF;
				} // END if
				if (_normalBackgroundColor == -1) _normalBackgroundColor = bkgd.color; // END if
				if (_hoverBackgroundColor != -1)
					bkgd.color = _hoverBackgroundColor;
				if (_bulletDisplay != BULLET_DISPLAY_NEVER) {
					if (_bulletColor == -1) {
						switch (_bulletType) {
							case BULLET_TYPE_ARROW:
							case BULLET_TYPE_DOT:
								_bulletColor = Graphic(bullet.getChildByName('elem')).color;
								break;
							default:
								break;
						} // END switch
					} // END if
					if (_bulletHoverColor != -1) {
						switch (_bulletType) {
							case BULLET_TYPE_ARROW:
							case BULLET_TYPE_DOT:
								Graphic(bullet.getChildByName('elem')).color = _bulletHoverColor;
								break;
							default:
								break;
						} // END switch
					} // END if
					if (!bullet.visible) bullet.visible = true; // END if
				} // END if
				if (_pointerDisplay != POINTER_DISPLAY_NEVER) {
					if (_pointerColor == -1) {
						switch (_pointerType) {
							case POINTER_TYPE_ARROW:
							case POINTER_TYPE_DOT:
								_pointerColor = Graphic(pointer.getChildByName('elem')).color;
								break;
							default:
								break;
						} // END switch
					} // END if
					if (_pointerHoverColor != -1) {
						switch (_pointerType) {
							case POINTER_TYPE_ARROW:
							case POINTER_TYPE_DOT:
								Graphic(pointer.getChildByName('elem')).color = _pointerHoverColor;
								break;
							default:
								break;
						} // END switch
					} // END if
					if (!pointer.visible) pointer.visible = true;
				} // END if
			} else {
				
				/** REVERT TO NORMAL ITEM VIEW **/
				if (_normalColor != -1 && txt.color != _normalColor) {
					txtF.color = _normalColor;
					txt.style = txtF;
				} // END if
				if (_normalBackgroundColor != -1 && bkgd.color != _normalBackgroundColor)
					bkgd.color = _normalBackgroundColor; // END if
				if (_bulletColor != -1) {
					switch (_bulletType) {
						case BULLET_TYPE_ARROW:
						case BULLET_TYPE_DOT:
							Graphic(bullet.getChildAt(0)).color = _bulletColor;
							break;
						default:
							break;
					} // END switch
				} // END if
				if (_bulletDisplay != BULLET_DISPLAY_ALWAYS) bullet.visible = false; // END if
				if (_pointerColor != -1) {
					switch (_pointerType) {
						case POINTER_TYPE_ARROW:
							case POINTER_TYPE_DOT:
							Graphic(pointer.getChildAt(0)).color = _pointerColor;
							break;
						default:
							break;
					} // END switch
				} // END if
				if (_pointerDisplay != POINTER_DISPLAY_ALWAYS) pointer.visible = false; // END if
			} // END if
		}
		/**
		 * 	Applies a selected setting to the object.
		 *	@since	1.0
		 * 	@param	s	TRUE or FALSE 
		 */
		public function selected(s:Boolean):void {
			this.enabled = !s;
			this.highlight(s);
		}
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			txt.visible = true;	
			if (_bulletDisplay == BULLET_DISPLAY_ALWAYS && _bulletType != BULLET_TYPE_NONE) 
				bullet.visible = true; // END if
			if (_pointerDisplay == POINTER_DISPLAY_ALWAYS && _pointerType != POINTER_TYPE_NONE) 
				pointer.visible = true; // END if
			if (_dividerLine == DIVIDER_VISIBLE) drawDividerLine();
		} // END function
		/*--------------------------------------
		/	protected FUNCTIONS
		/-------------------------------------*/
		protected function addSpecialElement(elemType:String, specialType:String):void {
			var elemClass:Class = null;
			switch (specialType) {
				case BULLET_TYPE_ARROW:
				case POINTER_TYPE_ARROW:
					elemClass = PixelArrow;
					break;
				case BULLET_TYPE_DOT:
				case POINTER_TYPE_DOT:
					elemClass = Circle;
					break;
				case BULLET_TYPE_CUSTOM:
				case POINTER_TYPE_CUSTOM:
					elemClass = Image;
					break;
				default:
					break;
			} // END switch
			
			if (elemClass != null) {
				var targetElem:Element = null;
				var targetStyle:Object = null;
				var targetFunction:Function = null;
				switch(elemType) {
					case 'bullet':
						targetElem = bullet;
						targetStyle = _bulletStyle;
						targetFunction = onBulletAdded;
						break;
					case 'pointer':
						targetElem = pointer;
						targetStyle = _pointerStyle;
						targetFunction = onPointerAdded;
						break;
					default:
						break;
				} // END switch
				if (targetElem != null) {
					while (targetElem.numChildren > 0)
						targetElem.removeChildAt(0); // END while
					//targetElem.addEventListener(ElementEvent.ELEMENT_ADDED, targetFunction);
					var tmpElem:Element = Element(targetElem.addElement('elem', elemClass, targetStyle));
					
					//trace("tmpElem = " + tmpElem);
					targetElem.width = tmpElem.width;
					targetElem.height = tmpElem.height;
					if ((elemType == 'bullet' && _bulletDisplay == BULLET_DISPLAY_ALWAYS) || (elemType == 'pointer' && 
					_pointerDisplay == POINTER_DISPLAY_ALWAYS)) {
						targetElem.visible == true;
					}
					if (specialType == BULLET_TYPE_CUSTOM || specialType == POINTER_TYPE_CUSTOM) {
						var tmpImg:Image = Image(tmpElem);
						var assetpath:String = '';
						if (specialType == BULLET_TYPE_CUSTOM && _bulletAsset != '') {
							assetpath = _bulletAsset;
						} else if (specialType == POINTER_TYPE_CUSTOM && _pointerAsset != '') {
							assetpath = _pointerAsset;
						}
						tmpImg.src = assetpath;
						tmpImg.addEventListener(Event.COMPLETE, onCustomAssetLoaded);
					} else {
						updateSize();
					} // END switch
				} // END if
			} // END if
		}
		protected function drawDividerLine():void {
			if (_dividerLine == DIVIDER_VISIBLE) {
				if (divLine == null) {
					var h:Number = (height != 0) ? (height - (_padding + 2)) : (txt.textHeight + (_padding + 2));
					divLine = Box(addElement('divLine',Box,{x:0, y:h, width:this.width,height:1,color:0x000000,alpha:1.0}));
				} else {
					if (height != 0 && divLine.y != (height - (_padding + 2)))
						divLine.y = (height - (_padding + 2));
					else if (txt.textHeight != 0 && divLine.y != (txt.textHeight + (_padding + 2)))
						divLine.y = (txt.textHeight + (_padding + 2));
					divLine.width = this.width;
				} // END if
			} else {
				if (divLine != null) divLine.visible = false;
			} // END if
		}
		/**
		 * 	Handles cascading menu action events
		 * 	@since	1.5
		 */
		protected function fireEvent():void {
			trace("fireEvent");
			trace("parentObj.parent = " + parentObj.parent);
			trace("_action = " + _action);
			//if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
			//	List(parentObj.parent).closeMenus();
			
			var val:String = '';
			//var val:String = (this.value != null) ? this.value.toString() : '';
			//trace("Value = " + this.value.toString());
			switch(_action) {
				case ACTION_NAVIGATE_TO_URL:
					navigateToURL(new URLRequest(val));
					dispatchEvent(new CascadingMenuEvent(CascadingMenuEvent.MENU_CLOSE));
					break;
				case ACTION_CHANGE_PAGE:
					sendNotification(Application.CHANGE_PAGE,val);
					break;
				case ACTION_CHANGECHILDPAGE:
					dispatchEvent(new CascadingMenuEvent(CascadingMenuEvent.MENU_CHANGE_CHILD));
					break;
				case ACTION_OPEN_MENU:
					// Action handled by List.highlightedIndex at this time
					break;
				case ACTION_CUSTOM:
					trace("Custom action. firing event");
					dispatchEvent(new CascadingMenuEvent(CascadingMenuEvent.MENU_CUSTOM_EVENT));
					break;
				case ACTION_SELECT:
				default:
					if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
						parentObj.parent.selectedIndex = Number(this.name.substring(5)); // END if
					break;
			} // END switch
		}
		
		protected function onBulletAdded(e:Event):void {
			trace(this.name + "bullet added.");
			bullet.removeEventListener(ElementEvent.ELEMENT_ADDED, onBulletAdded);
			trace("bullet.numChildren = " + bullet.numChildren);
			trace("bullet.getChildByName('elem') = " + bullet.getChildByName('elem'));
			var bulletElem:Element = Element(bullet.getChildByName('elem'));
			trace("bulletElem = " + bulletElem);
			if (bulletElem != null) {
				trace("bulletElem.width = " + bulletElem.width);
				bullet.width = bulletElem.width;
				bullet.height = bulletElem.height;
				bullet.visible = (_bulletDisplay == BULLET_DISPLAY_ALWAYS) ? true: false;
			} // END if
			trace("bullet.width = " + bullet.width);
			trace("bullet.height = " + bullet.height);
			updateSize();
		}
		protected function onMouseOver(e:Event):void { 
			if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
				parentObj.parent.highlightedIndex = Number(this.name.substring(5)); // END if
			if (_eventHandler == EVENT_MOUSEOVER) {
				fireEvent();
			} // END if
		} // END function
		protected function onMouseOut(e:Event):void { 
			if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
				parentObj.parent.highlightedIndex = -1; // END if
			if (_eventHandler == EVENT_MOUSEOUT) {
				fireEvent();
			} // END if
		} // END function 
		
		protected function onMouseClick(e:Event):void {
			if (_eventHandler == EVENT_CLICK) {
				fireEvent();
			} // END if
		}
		protected function onPointerAdded(e:Event):void {
			pointer.removeEventListener(ElementEvent.ELEMENT_ADDED, onPointerAdded);
			var pointElem:Element = Element(pointer.getChildByName('elem'));
			if (pointElem != null) {
				pointer.width = pointElem.width;
				pointer.height = pointElem.height;
				pointer.visible = (_pointerDisplay == POINTER_DISPLAY_ALWAYS) ? true: false;
			} // END if
			updateSize();
		}
		protected function onCustomAssetLoaded(e:Event):void {
			var currElem:Image = Image(e.currentTarget);
			var tmpElem:Element = Element(currElem.parent);
			currElem.removeEventListener(Event.COMPLETE, onCustomAssetLoaded);
			tmpElem.width = currElem.width;
			tmpElem.height = currElem.height;
			currElem.visible = true;
			updateSize();
		}
		/**
		 * 	Sets the objects sizeproperties after a text value has been set.
		 *	@since	1.0
		 */
		protected function updateSize():void {
			//trace(this.name + " updateSize(), _widthType = " + _widthType);
			if (_widthType != List.WIDTH_FIXED)  {
				//trace(this.name + ", txt.textWidth  = " + txt.textWidth);
				var tmpWidth:Number = txt.textWidth + (_padding * 4);
				//trace(this.name + ", tmpWidth  = " + tmpWidth);
				if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
					//trace(this.name + " updateSize(), bullet.width = " + bullet.width);
					tmpWidth += (bullet.width + _padding * 4);
				}
				if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
					//trace(this.name + " updateSize(), pointer.width = " + pointer.width);
					tmpWidth += (pointer.width + _padding * 4);
				} // END if
				width = Math.round(tmpWidth);
				if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
					List(parentObj.parent).updateListWidth(width); // END if
			} else {
				if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
					width = List(parentObj.parent).width; // END if
			} // END if
			if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
				//trace("parent list width = " + List(parentObj.parent).width); // END if
			//trace(this.name + ", width = " + width);
			if (_heightType != List.HEIGHT_FIXED) {
				var tmpHeight:Number = txt.textHeight + (_padding * 4);
				if (_bulletDisplay != BULLET_DISPLAY_NEVER && _bulletType != BULLET_TYPE_NONE) {
					if ((bullet.height + (_padding * 4)) > tmpHeight) {
						tmpHeight = (bullet.height  + (_padding * 4));
					} // END if
				} // END if
				if (_pointerDisplay != POINTER_DISPLAY_NEVER && _pointerType != POINTER_TYPE_NONE) {
					if ((pointer.height + (_padding * 4)) > tmpHeight) {
						tmpHeight = (pointer.height  + (_padding * 4));
					} // END if
				} // End if
				this.height = Math.round(tmpHeight);
				
			} else {
				if (parentObj.parent.toString().toLowerCase().indexOf('list') != -1)
					height = List(parentObj.parent).height; // END if
			}  // END if
			textAlign = _alignment;
			verticalAlign = _verticalAlignment;
			objReady(new Event(Event.ADDED_TO_STAGE));
		}
	} // END class
} // END package