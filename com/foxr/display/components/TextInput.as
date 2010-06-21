package com.foxr.display.components
{
	import com.foxr.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	/**
	 * A custom TextInput control which allows the user to enter text.
	 * <p />
	 * Unlike standard text iinput boxes, this control has the built in ability to display a 
	 * list of "suggestions" as well restricting the user to only select an option displayed 
	 * in the list.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 *
	 */
	 public class TextInput extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		//CONSTANTS
		/**
		 * No input Restriction
		 * @const RESTRICT_NONE:String
		 */
		public static const RESTRICT_NONE:String = 'none'
		/**
		 * Limit to List Restriction
		 * @const RESTRICT_LIMIT_TO_LIST:String
		 */
		public static const RESTRICT_LIMIT_TO_LIST:String = 'limitToList'
		/**
		 * Validation Format
		 * @var	_format:String
		 */
		private var _format:String = ',';
		/**
		 * Item seperator
		 * @var	_seperator:String
		 */
		private var _seperator:String = ',';
		/**
		 * Suggestion Array
		 * @var	_suggestions:Array
		 */
		private var _suggestions:Array = null;
		/**
		 * Suggestion List
		 * @var	_suggestionList:List
		 */
		private var suggestionList:List = null;
		/**
		 * Suggestion List Array
		 * @var	_suggestionListArray:Array
		 */
		private var _suggestionListData:ComponentDataList = null;
		/**
		 * Suggestion List Delay
		 * @var	_suggestionListDelay:Number
		 */
		private var _suggestionListDelay:Number = 0;
		/**
		 * Suggestion List Style
		 * @var	_suggestionListStyle:Object
		 */
		private var _suggestionListStyle:Object = null;
		/**
		 * Suggestion List item Style
		 * @var	_suggestionListItemStyle:Object
		 */
		private var _suggestionListItemStyle:Object = null;
		/**
		 * Suggestion List Item Text Style
		 * @var	_suggestionListItemTextStyle:TextFormat
		 */
		private var _suggestionListItemTextStyle:TextFormat = null;
		/**
		 * Stored string
		 * @var	_storedString:String
		 */
		private var _storedString:String = '';
		/**
		 * Input Restriction
		 * @var	_restriction:String
		 */
		private var _restriction:String = RESTRICT_NONE;
		/**
		 *Suggestion List Delay Timer
		 * @var	_listTimer:Timer
		 */
		private var _listTimer:Timer = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new TextInput instance
		 *
		 */
		public function TextInput() {
			super();
			enabled = true;
			_suggestions = [];
		} // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public override function get className():Class { return TextInput; }
		/**
		 * Enabled the password obstrufication method of the TextField object.
		 * @since	1.0
		 * @param	d	TRUE or FALSE
		 *
		 */
		public function get displayAsPassword():Boolean { return txt.displayAsPassword; }
		public function set displayAsPassword(d:Boolean):void { txt.displayAsPassword = d; }
		/**
		 *  Enable or Disables the TextInput control. The text field in this control reverts
		 * 	to a readOnly field when enabled i set to FALSE.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @since 1.3
		 */
		public override function set enabled(e:Boolean):void { 
			_enabled = e;
			txt.selectable = e;
			if (e) {
				txt.type = TextFieldType.INPUT;
				if (!txt.hasEventListener(FocusEvent.FOCUS_IN))
					txt.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			} else {
				txt.type = TextFieldType.DYNAMIC;
				if (txt.hasEventListener(FocusEvent.FOCUS_IN))
					txt.removeEventListener(FocusEvent.FOCUS_IN,onFocusIn);
				if (txt.hasEventListener(FocusEvent.FOCUS_OUT))
					txt.removeEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			} // END if
		} 		
		/**
		 * Applies a form validation format to the text field.
		 * @since	1.0
		 * @param	f	The Form validation type
		 * @return		The Form validation type value
		 * @see			com.foxr.display.components.form
		 *
		 */
		public function get format():String {  return _format; }
		public function set format(f:String):void {  _format = f; }
		
		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	h The object height in pixels
		 *
		 */
		public override function set height(h:Number):void { 
			super.height = h; 
			bkgd.height = h; 
			txt.height = h;
		}
		/**
		 * Appies an input restriction onto the object. Valid options are TextInput.RSTRICT_NONE or
		 * TextInput.RESTRICT_LIMIT_TO_LIST.
		 * @since	1.0
		 * @param	r	The restriction setting
		 */
		public function get restriction():String { return _restriction; }
		public function set restriction(r:String):void { _restriction = r; }
		/**
		 * Appies a charcter to seperate unique words within the field for suggestion and restriction
		 * matching.
		 * @since	1.0
		 * @param	s	The seperator charcter
		 */
		public function get seperator():String { return _seperator; }
		public function set seperator(s:String):void { if (s == 'SPACE') s = ' '; _seperator = s; }
		/**
		 * Applies a list of key word suggestions to the TextInput field. When applied, this 
		 * object will listen for the keyDown event and test the values entered against those in this
		 * array.
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public function set suggestions(sl:Array):void {
			if (sl != null && sl.length > 0) {
				_suggestions = sl;
				suggestionList = List(addElement('suggestionList',List,{visible:false,x:0,y:(bkgd.height + 1),width:bkgd.width,widthType:List.WIDTH_FIXED}));
				if (_suggestionListStyle != null) suggestionList.applyProperties(_suggestionListStyle);
				if (_suggestionListItemStyle != null) suggestionList.itemStyle = _suggestionListItemStyle;
				if (_suggestionListItemTextStyle != null) suggestionList.itemTextStyle = _suggestionListItemTextStyle;
				txt.addEventListener(KeyboardEvent.KEY_DOWN,onTextKeyUp);
				_listTimer = new Timer(_suggestionListDelay);
			} else {
				_suggestions = [];
				suggestionList = null;
				if (txt.hasEventListener(KeyboardEvent.KEY_DOWN)) 
					txt.removeEventListener(KeyboardEvent.KEY_DOWN,onTextKeyUp); // END if
				if (this.getChildByName('suggestionList') != null)
					removeChild(this.getChildByName('suggestionList'));
			} // END if
		} 
		/**
		 * Applies a fontAndCopy string to the object. This helps to apply font styles 
		 * to the text field.
		 * @since	1.0
		 * @param	s	A fontAndCopy string ID
		 */
		public override function set string(s:String):void { txt.string = s; }
		/**
		 * The time to delay the display of the suggestions list.
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public function set suggestionListDelay(time:Number):void { _suggestionListDelay = time; }
		/**
		 * The style aplied to the suggestion list object.
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public function set suggestionListStyle(s:Object):void { 
			_suggestionListStyle = s; 
			if (suggestionList != null) suggestionList.applyProperties(s);  
		}
		/**
		 * The style applied to individual suggestion list items.
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public function set suggestionListItemStyle(s:Object):void { 
			_suggestionListItemStyle = s; 
			if (suggestionList != null) suggestionList.itemStyle = s;  }
		/**
		 * The style applied to the suggestion list itme text.
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public function set suggestionListItemTextStyle(s:TextFormat):void { 
			_suggestionListItemTextStyle = s; 
			if (suggestionList != null) suggestionList.itemTextStyle = s;  
		}
		/**
		 * Returns the textWidth value of the object textField. 
		 * @since	1.0
		 * @return	The textWidth in pixels
		 */
		public function get textHeight():Number { return txt.textHeight; }
		/**
		 * Returns the textWidth value of the object textField. 
		 * @since	1.0
		 * @return	The textWidth in pixels
		 */
		public function get textWidth():Number { return txt.textWidth; }
		/**
		 * Applies a 
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set value(v:*):void { 
			super.value = v;
			if (txt.text == '' || txt.text != String(v.toString())) {
				txt.text = String(v.toString());
			}
		}
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void { 
			super.width = w; 
			bkgd.width = w; 
			txt.width = w;
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Placeholder method for child objects to execute once they have been added to the movie
		 * stage. This helps with acessing global variable from Main and parent objects.
		 * @since	1.0
		 *
		 */
		public override function objReady(e:Event):void { 
			super.objReady(e);
			bkgd.visible = true; 
			txt.visible = true; 
			txt.wordWrap = false;
			txt.autoSize = TextFieldAutoSize.NONE;
			txt.height = this.height;
			txt.width = this.width;
		} // END function
		/**
		 * Resets the object to it's inital state.
		 * @since	1.0
		 *
		 */
		public function reset():void {
			suggestions = [];
			_storedString = '';
			txt.text = '';
			this.value = '';
		}
		/**
		 * Sets focus to the child text field.
		 * @since	1.0
		 *
		 */
		public function setFocus():void {
			txt.setFocus();
		}
		/*--------------------------------------
		/	PRIVATE EVENT FUNCTIONS
		/-------------------------------------*/
		/**
		 * Extracts unique words from the passed array dropping any duplicates. 
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function extractUniqueWords(words:Array):Array {
			var arrayOut:Array = new Array();
			for( var i:Number = 0; i < words.length; i++){
				var match:Boolean = false;
				for( var j:Number = 0; j < arrayOut.length; j++ ){
					if( words[i] == arrayOut[j] || words[i] == " ") {
						match = true;
						break;
					} // END if
				} // END for
				if(!match)
					arrayOut.push(words[i]);
			} // END for
			return arrayOut;
		}
		/**
		 * Handles the list loading event. 
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function onListLoaded(e:Event):void { 
			suggestionList.removeEventListener(Event.COMPLETE,onListLoaded);
		}
		/**
		 * Handles the user selecting a list item. 
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function onListSelect(e:Event):void { ;
			var outStr:String = _storedString;
			if (outStr != '') outStr += _seperator;
			txt.text = outStr + e.currentTarget.value;
			_storedString = txt.text;
			suggestionList.visible = false;
			onFocusOut(new Event(Event.COMPLETE));
		}
		/**
		 * Handles the text element gaining focus. Not currently implemented.
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function onFocusIn(e:Event):void { 
			if (!txt.hasEventListener(FocusEvent.FOCUS_OUT))
				txt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		} // END function
		/**
		 * Handles the object losing focus (I.E. the user entering their text and moving on)
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function onFocusOut(e:Event):void { 
			if (txt.hasEventListener(FocusEvent.FOCUS_OUT)) 
				txt.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			if ((_suggestions.length > 0) && (suggestionList != null && suggestionList.visible == false)) {
				// Validate input
				if (_restriction == RESTRICT_LIMIT_TO_LIST) {
					var strOut:String = '';
					var words:Array = extractUniqueWords(txt.text.split(_seperator));
					for(var i:int = 0; i < words.length;i++){
						var match:Boolean = false;
						for(var j:int = 0; j < _suggestions.length; j++ ){
							if( _suggestions[j].value == words[i]){
								match = true;
								break;
							} // END if
						} // END for
						if(match) {
							var sep:String = strOut.length > 0 ? sep = _seperator : '';
							strOut += sep + words[i];
						} // END if
					} // END for
					_storedString = strOut;
					txt.text = strOut;
				} else {
					_storedString = txt.text;
				} // END if
			} // END if
			// Automatically report this objects variable values to the parent form if it exists
			if (parentObj.toString().toLowerCase().indexOf('form') != -1) {
				parentObj = Form(parentObj);
				var vars:URLVariables = new URLVariables(this.variable+'='+txt.text);
				parentObj.variable = vars.toString();
				this.value = txt.text;
			} // END if
		} // END function
		/**
		 * Handles the key up event or when the user types something into the field. If a 
		 * list of suggestions has been added to the object, this method parses the text 
		 * entered to detemine if a list of sugesstions should be displayed.
		 * @since	1.0
		 * @param	e	Event passed from the EventListener
		 */
		private function onTextKeyUp(e:KeyboardEvent):void { 
			if (txt.text.length > 0 && suggestionList != null) {
				// PARSE NEW INPUT
				var newText:String = '';
				// if the selected seperator is present, break on it, otheriwse, use the stored string
				// length as the starting point for new text
				if (txt.text.lastIndexOf(_seperator) != -1) 
					newText = txt.text.substr(txt.text.lastIndexOf(_seperator) + 1);
				else 
					newText = txt.text.substr(_storedString.length);
				// If we have valid new text to analyse, proceed
				// otheriwse, make sure to hide the suggestion list
				if (newText.length > 0 && newText != _seperator) {
					var tmpSuggestions:Array = [];
					// search the suggestion array for a match
					for( var i:Number = 0; i < _suggestions.length; i++){
						if( _suggestions[i].value.substr(0, newText.length) == newText.toLowerCase() ){
							tmpSuggestions = tmpSuggestions.concat(_suggestions[i]);
						} // END if
					} // END for	
					// if there are at least one suggestion to display, proceed
					if (tmpSuggestions.length > 0) {
						if (suggestionList.size > 0) suggestionList.reset();
						tmpSuggestions.sort();
						_suggestionListData = new ComponentDataList();
						if (_suggestionListData.addItems(tmpSuggestions)) {
							suggestionList.dataList = _suggestionListData;
							suggestionList.addEventListener(Event.SELECT, onListSelect); 
							// if the list is not visible, proceed with showing it
							if (suggestionList.visible == false) {
								// if there is a delay set, set the time and wait for the timer event
								if (_suggestionListDelay > 0) {
									_listTimer.addEventListener(TimerEvent.TIMER,onListTimer);
									_listTimer.start();
								// otherwise, show it immediately
								} else {
									onListTimer(new Event(TimerEvent.TIMER));
								} // END if
							} // END if
						} else {
							trace("ERROR: An error occured when setting suggestion items to the sugesstion data list object.");
						} // END if
					} else {
						suggestionList.visible = false;
					} // END if
				} else {
					suggestionList.visible = false;
				}  // END if
			} else if (suggestionList != null && suggestionList.visible == true) {
				suggestionList.visible = false;
				if (e.keyCode == 8) _storedString = '';
			} // END if
			
			gpm.log.debug(this.name + " onTextKeyUp = ");
			gpm.log.debug(this.name + ", txt.text = " + txt.text);
			gpm.log.debug(this.name + " value = " + this.value);
		} // END function
		/**
		 * Handles a timer event for the list display delay. Shows the suggestions list.
		 * @since	1.0
		 */
		private function onListTimer(e:Event):void {
			suggestionList.y = bkgd.height;
			suggestionList.visible = true;
			if (_listTimer.running) _listTimer.stop();
		}
	} // END class
} // END package