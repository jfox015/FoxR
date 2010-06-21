package com.foxr.display.components
{
	
	//import external classes
	import com.foxr.display.*;
	import flash.events.*;
	import com.foxr.display.buttons.*;
	import com.foxr.display.components.*;
	import flash.text.TextFormat;
	import com.foxr.display.graphics.*;
	import caurina.transitions.Tweener;
	/**
	 * The ComboBox component contains a drop-down list from which the user can select one value. 
	 * Its functionality is similar to that of the SELECT form element in HTML. The ComboBox 
	 * component can be editable, in which case the user can type entries that are not in the list 
	 * into the TextInput portion of the ComboBox component.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 *
	 */
	public class ComboBox extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/* CONSTANTS */
		/**
		 * Display Animation - Fade/Scroll Const
		 * @const	ISPLAYANIM_FADE_SCROLL:String
		 */
		public static const DISPLAYANIM_FADE_SCROLL:String = 'fadeAndScroll';
		/**
		 * Display Animation - Fade Const
		 * @const	DISPLAYANIM_FADE:String
		 */
		public static const DISPLAYANIM_FADE:String = 'fade';
		/**
		 * Display Animation - Scroll Const
		 * @const	DISPLAYANIM_SCROLL:String
		 */
		public static const DISPLAYANIM_SCROLL:String = 'scroll';
		/**
		 * Display Animation - None Const
		 * @const	DISPLAYANIM_NONE:String
		 */
		public static const DISPLAYANIM_NONE:String = 'none';
		/**
		 * Direction Down Const
		 * @const	DIRECTION_DOWN:String
		 */
		public static const DIRECTION_DOWN:String = Triangle.DIRECTION_DOWN;
		/**
		 * Direction Up Const
		 * @const	DIRECTION_UP:String
		 */
		public static const DIRECTION_UP:String = Triangle.DIRECTION_UP;
		/* OBJECTS */
		/**
		 * Button
		 * @var	button:StandardButton
		 */
		private var button:StandardButton = null;
		/**
		 * Arrow Button Object
		 * @var	btnArrow:ScrollbarButton
		 */
		//private var btnArrow:ScrollbarButton = null;
		private var btnArrow:ScrollbarButton = null;
		/**
		 * Combo List
		 * @var	cmbList:List
		 */
		private var cmbList:List = null;
		
		/* PROPERTIES */
		/**
		 * Data List
		 * @var	_dataList:ComponentDataList
		 */
		private var _dataList:ComponentDataList = null;
		/**
		 * Allow Resize
		 * @var	_allowResize:Boolean
		 */
		private var _allowResize:Boolean = false;
		/**
		 * Allow Text Override
		 * @var	_allowTextOverride:Boolean
		 */
		private var _allowTextOverride:Boolean = false;
		/**
		 * Animating
		 * @var	_isAnimating:Boolean
		 */
		private var _isAnimating:Boolean = false;
		/**
		 * Speed
		 * @var	_speed:Number
		 */
		private var _speed:Number = .75;
		/**
		 * Display Animation
		 * @var	_displayAnimation:String
		 */
		private var _displayAnimation:String = DISPLAYANIM_FADE_SCROLL;
		/**
		 * Direction
		 * @var	_direction:String
		 */
		private var _direction:String = DIRECTION_DOWN;
		/**
		 * Width Type
		 * @var	_widthType:String
		 */
		//private var _widthType:String = List.WIDTH_SIZETOLIST;
		
		/* CHILD OBJECT PROPERTIES */
		/**
		 * List Style
		 * @var	_listStyle:Object
		 */
		private var _listStyle:Object = null;
		/**
		 * Item Style
		 * @var	_itemStyle:Object
		 */
		private var _itemStyle:Object = null;
		/**
		 * Item text Style
		 * @var	_itemTextStyle:TextFormat
		 */
		private var _itemTextStyle:TextFormat = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ComboBox instance
		 *
		 */
		public function ComboBox() {
			super();
			cmbList = List(addElement('cmbList',List,{x:0,visible:false,enabled:false}));
			button = StandardButton(addElement('button',StandardButton,{x:0,y:0}));
			//arrow = Triangle(addElement('arrow',Triangle,{direction:_direction}));
			btnArrow = ScrollbarButton(addElement('btnArrow',ScrollbarButton,{direction:_direction,sizeType:SIZE_FIXED}));
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alignment of the objects text field. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get textAlign():String { return _alignment; }
		public override function set textAlign(a:String):void {
			if (a != '') {
				_alignment = a;
				button.textAlign = a;
			} // END if
		} // END function
		/**
		 *	When set to TRUE, this allows the combo box to override the default
		 *  string with a new passed value. Otherwise, the object will refuse
		 *  an external string argument in favor of the value of the selected list option.
		 * 	@author	Jeff Fox
		 * 	@since  1.0
		 *  @param	Boolean	s	TRUE OR FALSE
		 *  @return	Boolean		TRUE OR FALSE
		 */
		public function get allowTextOverride():Boolean { return _allowTextOverride; }
		public function set allowTextOverride(a:Boolean):void { _allowTextOverride = a; }
		/**
		 * Applies if the combo box will allow extrernal objects to resize it.
		 * @since	1.0
		 * @param	r	TRUE of FALSE
		 * @return		TRUE of FALSE
		 */
		public function get allowResize():Boolean { return _allowResize; }
		public function set allowResize(r:Boolean):void { _allowResize = r; }
		/**
		 * Applies the specified color to the objects arrow.
		 * @since	1.0
		 * @param	c	The color in 0x000000 format.
		 */
		public function get arrowColor():uint { return btnArrow.arrowColor; }
  		public function set arrowColor(c:uint):void { btnArrow.arrowColor = c; }
  		/**
		 * Changes the alpha of the objects background. 
		 * @since	1.17
		 * @param	a	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The backgrounds alpha value
		 */
		public override function get backgroundAlpha():Number { return button.backgroundAlpha; }
		public override function set backgroundAlpha(a:Number):void { 
			button.backgroundAlpha = a; 
			btnArrow.backgroundAlpha = a; 
		}
		/**
		 * Changes the color of the objects background. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get backgroundColor():Number { return button.backgroundColor; }
		public override function set backgroundColor(c:Number):void { 
			button.backgroundColor = c; 
			btnArrow.backgroundColor = c; 
		}
		/**
		 * Changes the alpha (transparency) of the objects border. 
		 * @since	1.0
		 * @param	b	The alpha as a percentage of 1 (0.25, 0.5, 0.75, 1.0, etc.)
		 * @return		The borders alpha value
		 */
		public override function get borderAlpha():Number { return button.borderAlpha; }
		public override function set borderAlpha(a:Number):void { 
			button.borderAlpha = a; 
			btnArrow.borderAlpha = a; 
		}
		/**
		 * If borderWeight is set, this changes the color of the objects border. 
		 * @since	1.0
		 * @param	c	The color in 0x000000 format
		 * @return		The color in 0x000000 format
		 */
		public override function get borderColor():Number { return button.borderColor; }
		public override function set borderColor(c:Number):void { 
			button.borderColor = c; 
			btnArrow.borderColor = c; 
		}
		/**
		 * Changes the width (size) of the objects border. 
		 * @since	1.0
		 * @param	b	The border width in pixels
		 * @return		The border width in pixels
		 */
		public override function get borderWidth():Number { return button.borderWidth; }
		public override function set borderWidth(w:Number):void { 
			button.borderWidth = w; 
			btnArrow.borderWidth = w; 
		}
		
		public override function get className():Class { return ComboBox; }
		/**
		 *	Applies a properties object for the combo box control area.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 */
		public function set controlStyle(b:Object):void { button.applyProperties(b); }
		/**
		 *	Assigns a data list object as the source for the lists items.
		 *  @param	dl	A ComponentDataList object
		 *  @since 	1.0
		 *  
		 */
		public function set dataList(dl:ComponentDataList):void { 
			if (_sizeType == SIZE_FIXED) {
				cmbList.widthType = List.WIDTH_FIXED;
			} // END if
			_dataList = dl;
			if (parentObj != null) cmbList.dataList = _dataList; 
		}
		/**
		 * 	Applies a animation style to the opening of the combo boxes child list object. Pptions include:
		 *  <ul>
		 * 		<li>fadeAndScroll</li>
		 * 		<li>fade</li>
		 * 		<li>scroll</li>
		 * 		<li>none</li>
		 * 	</ul>
		 *  <p />
		 *	@since	1.0
		 *  @param	a	The display animation type
		 */
		public function get displayAnimation():String { return _displayAnimation; }		
		public function set displayAnimation(d:String):void { _displayAnimation = d; }
		/**
		 * 	Applies a speed to the opening animation of the combo box list. This property has 
		 *  no effect when <i>displayAnimation</i> is set to 'none'.
		 *	@since	1.0
		 *  @param	a	The display animation speed
		 */
		public function get displaySpeed():Number { return _speed; }		
		public function set displaySpeed(s:Number):void { _speed = s; }
		/**
		 * 	Applies a direction to the combo box list.
		 *	@since	1.0
		 *  @param	d	The list open direction (up or down)
		 */
		public function get direction():String { return _direction; }		
		public function set direction(d:String):void { _direction = d; btnArrow.direction = d; }
		/**
		 *  Sets the _enabled flag. Child object should override this method to custom eneable or
		 *  disable themselves.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean	TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void { 
			super.enabled = e; 
			button.enabled = e;
			btnArrow.useHandCursor = btnArrow.buttonMode = e;
			btnArrow.mouseChildren = !e;
			if (e) {
				button.addEventListener(MouseEvent.CLICK, onClick);
				btnArrow.addEventListener(MouseEvent.CLICK, onClick);
			} else {
				button.removeEventListener(MouseEvent.CLICK, onClick); // END if
				btnArrow.removeEventListener(MouseEvent.CLICK, onClick); // END if
			}
		}
		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set height(h:Number):void {
			super.height = h;
			if (sizeType == SIZE_FIXED) {
				btnArrow.width = btnArrow.height = button.height = h;
			}
			updateLayout();
		}
		/**
		 *	Applies a properties object for the list items. This is a global style setting that can be overridden
		 *  per list item if necessary.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set itemStyle(s:Object):void { cmbList.itemStyle = s; }
		/**
		 *	SET ITEM STYLE.
		 *  Applies a properties object for the list items. This is a global style setting that can be overridden
		 *  per list item if necessary.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set itemTextStyle(s:TextFormat):void { cmbList.itemTextStyle = s; }
		/**
		 *	Applies a properties object for the child list object.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set listStyle(s:Object):void { cmbList.applyProperties(s); }
		/**
		 *	Applies a properties object for the scrollbar.
		 *  @param	s	Style properties object
		 *  @since 	1.0
		 *  
		 */
		public function set scrollbarStyle(s:Object):void { cmbList.scrollbarStyle = s; }
		/**
		 *	Sets and returns the selected index of the list. This property works in
		 *  conjunction with the <i>highlightedIndex</i> property, but it is seperate, 
		 *  meaning that an option may be selected, but may not necesarily be highlighted.
		 *  @param	Number	i	The index of an item to select
		 *  @return	Number	The index of the currently selected item
		 *  @since 	1.0
		 *  
		 */
		public function get selectedIndex():Number { return cmbList.selectedIndex; }
		public function set selectedIndex(i:Number):void { 
			cmbList.selectedIndex = i;
			button.text = _dataList.getItemAt(i).text;
			value = _dataList.getItemAt(i).value;
		}
		/**
		 * Applies a font and copy string id to the combo box control
		 * @since	1.0
		 * @param	t	A valid font and copy string ID
		 *
		 */
		public override function set string(s:String):void { 
			if (sizeType != SIZE_FIXED)
				button.sizeType = SIZE_TO_CONTENT;
			button.string = s;  
			updateSize(); 
		}
		/**
		 * Applies a text string to the combo box control
		 * @since	1.0
		 * @param	t	A valid text string
		 *
		 */
		public override function set text(t:String):void { 
			if (sizeType != SIZE_FIXED)
				button.sizeType = SIZE_TO_CONTENT;
			button.text = t;   
			updateSize(); 
		}
		/**
		 * Applies a text style TextFormat object to the button text area
		 * @since	1.0
		 * @param	t	A valid text string
		 *
		 */
		public override function set textStyle(t:TextFormat):void { button.textStyle = t; }
		/**
		 * Changes the vertical alignment of the objects text field. 
		 * @since	1.0
		 * @param	a	The alignment (top, middle or bottom)
		 */
		public override function set verticalAlign(a:String):void {
			if (a != '') {
				this._verticalAlignment = a;
				button.verticalAlign = a;
				switch (a) {
					case 'middle':
						btnArrow.y = (this.height / 2) - (btnArrow.height / 2);
						break;
					case 'bottom':
						btnArrow.y = (this.height - btnArrow.height) - _padding;
						break;
					case 'top':
					default:
						btnArrow.y = _padding;
						break;
				} // END switch
			} // END if
		} // END function
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void { 
			super.width = w;
			if (sizeType == SIZE_FIXED) {
				cmbList.width = w;
			}
			updateLayout();
		}
		/**
		 * 	This setting determines if the combo box should stay at a fixed width specified by
		 *  the width attribute (fixed) or resize itself to either the contents of the combo box
		 *  control (proportional) or to the size of the items loaded into the child list (sizeToList).
		 * 	@since	1.0
		 *  @param	t	The width type - fixed, proportional or sizeToList
		 * 	@return	The width type
		 */
		//public function get widthType():String { return _widthType; }
		//public function set widthType(t:String):void { _widthType = t; cmbList.widthType = t; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			button.verticalAlign = 'middle';
			button.visible = true;
			btnArrow.visible = true;
			cmbList.visible = false;
			cmbList.x = 0;
			if (_dataList != null) {
				cmbList.reset();
				cmbList.dataList = _dataList; 
			}
			updateLayout();
			enabled = true;
		} // END function
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Redraws the child elements to fit the size of the object.
		 *	@since	1.0
		 */
		private function updateSize():void {
			if (sizeType != SIZE_FIXED) {
				button.sizeType = SIZE_FIXED;
				cmbList.widthType = List.WIDTH_FIXED;
				height = btnArrow.width = btnArrow.height = button.height;
				width = cmbList.width = (button.width + btnArrow.width);
			}
			updateLayout();
		}
		/**
		 * 	Redraws the alignment of the object.
		 *	@since	1.0
		 */
		private function updateLayout():void {
			if (sizeType == SIZE_FIXED) {
				button.width = (width - btnArrow.width);
				btnArrow.x = (width - btnArrow.width);
			} else {
				btnArrow.x = ((button.width + 1) - button.borderWidth);
			} // END if
			button.textAlign = ALIGN_LEFT;
		}
		/**
		 * 	Hanlder for the objects MOUSE.Click Event.
		 *  @param	e	Event object
		 *	@since	1.0
		 */
		private function onClick(e:Event):void {
			
			if (!cmbList.visible) showList(); else hideList(); // END if
		}
		/**
		 * 	Hanlder for the objects MOUSE.Click Event.
		 *  @param	type	String specifiying if the list is being opened or closed.
		 *	@since	1.0
		 */
		private function onListAnimComplete(type:String):void {
			//trace("List animation completed.");
			_isAnimating = false;
			button.enabled = true;
			if (Tweener.getTweens(cmbList).length != 0) Tweener.removeTweens(cmbList); // END if
			cmbList.visible = cmbList.enabled = (type == 'show') ? true : false;
			if (_mask != null) this.removeChild(this.getChildByName('_mask')); // END if
			_mask = null;
			if (this.mask) this.mask = null; // END if
		}
		/**
		 * 	Handler for the items SELECT event..
		 *  @param	e	Event object
		 *	@since	1.0
		 */
		private function onSelect(e:Event):void {
			onListAnimComplete('hide');
			this.value = cmbList.value;
			var orgSizeType:String = sizeType;
			if (allowResize) sizeType = SIZE_TO_CONTENT; else sizeType = SIZE_FIXED;
			if (!_allowTextOverride) text = List(e.currentTarget).textValue;
			if (sizeType != orgSizeType) sizeType = orgSizeType;
			dispatchEvent(new Event(Event.SELECT));
		}
		/**
		 * 	Opens the child list object.
		 *	@since	1.0
		 */
		private function showList():void {
			trace("Combo -> showList()");
			trace("_isAnimating = " + _isAnimating);
			if (!_isAnimating) {
				_isAnimating = true;
				button.enabled = false;
				var startY:Number = 0, endY:Number = 0, maskY:Number = 0;
				// SET ALPHA BASED ON DISPLAY ANIMATION TYPE
				if (_displayAnimation == DISPLAYANIM_FADE_SCROLL || _displayAnimation == DISPLAYANIM_FADE) 
					cmbList.alpha = 0;
				else
					cmbList.alpha = 1.0; // END if
					
				// SET Y POSITIONS BASED ON LIST DIRECTION
				if (_direction == DIRECTION_UP)  { 
					startY = this.height - 1; 
					endY = maskY = -(cmbList.height);
				} else { 
					startY = -(cmbList.height); 
					endY = this.height + 1;
					maskY = 0; 
				} // END if
				
				// APPLY Y POSITON TO COMBO LIST BASED ON DISPLAY ANIMATION TYPE
				if (_displayAnimation == DISPLAYANIM_FADE_SCROLL || _displayAnimation == DISPLAYANIM_SCROLL) 
					cmbList.y = startY;
				else
					cmbList.y = endY; // END if
					
				cmbList.addEventListener(Event.SELECT,onSelect);
				if (_displayAnimation != DISPLAYANIM_NONE) {
					// We ony need a mask if the list will scroll in
					if (_displayAnimation == DISPLAYANIM_FADE_SCROLL || _displayAnimation == DISPLAYANIM_SCROLL)
						this.mask = _mask = addElement('_mask',Box,{x:0,y:maskY,width:this.width,height:this.height + cmbList.height,color:0x000000});
					// Set the list to visible, it iwll be hidden by the mask if were scrolling
					cmbList.visible = true;
					Tweener.addTween(cmbList,{y:endY, alpha: 1.0,time:_speed, delay:0, onComplete:function():void { onListAnimComplete('show'); }});
				} else {
					onListAnimComplete('show');
				} // END if
			} // END if
		} // END function
		/**
		 * 	Opens the child list object.
		 *	@since	1.0
		 */
		private function hideList():void {
			trace("Combo -> hideList()");
			if (!_isAnimating) {
				_isAnimating = true;
				button.enabled = false;
				var newAlpha:Number = 1.0, endY:Number = 0, maskY:Number = 0;
				// SET ALPHA BASED ON DISPLAY ANIMATION TYPE
				if (_displayAnimation == DISPLAYANIM_FADE_SCROLL || _displayAnimation == DISPLAYANIM_FADE) 
					newAlpha = 0; // END if
				// SET Y POSITIONS BASED ON LIST DIRECTION
				if (_direction == DIRECTION_UP)  { 
					maskY = -(cmbList.height);
					endY = this.height - 1;
				} else { 
					endY = -(cmbList.height);
					maskY = 0; 
				} // END if
				// APPLY Y POSITON TO COMBO LIST BASED ON DISPLAY ANIMATION TYPE
				if (_displayAnimation == DISPLAYANIM_FADE) 
					endY = cmbList.y; // END if
					
				cmbList.removeEventListener(Event.SELECT,onSelect);
				if (_displayAnimation != DISPLAYANIM_NONE) {
					// We ony need a mask if the list will scroll in
					if (_displayAnimation == DISPLAYANIM_FADE_SCROLL || _displayAnimation == DISPLAYANIM_SCROLL)
						this.mask = _mask = addElement('_mask',Box,{x:0,y:maskY,width:this.width,height:(this.height + (cmbList.height + (cmbList.borderWidth*2))),color:0x000000});
					Tweener.addTween(cmbList,{y:endY, alpha: newAlpha,time:_speed, delay:0, onComplete:function():void { onListAnimComplete('hide'); }});
				} else {
					onListAnimComplete('hide');
				} // END if
			} // END if
		} // END function
	} // END class
} // END package