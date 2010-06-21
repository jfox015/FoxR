package com.foxr.display.components.media
{
	//import external classes
	
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.Element;
	import com.foxr.display.components.Component;
	import com.foxr.display.content.IAnimator;
	import com.foxr.display.ToolTip;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * An Abstract base class used to build specific types of media controllers. Examples include 
	 * a Media Playback Controller to control animations and FLV video and numbered nacigation to 
	 * select specific items to show and hide.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class MediaControl extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/		
		public static const CONTROL_PLAYER:String = 'player';
		public static const CONTROL_NUMBERED:String = 'numbered';
		
		public static const PLACEMENT_TOP_LEFT:String = 'topLeft';
		public static const PLACEMENT_TOP_RIGHT:String = 'topRight';
		public static const PLACEMENT_BOTTOM_LEFT:String = 'bottomLeft';
		public static const PLACEMENT_BOTTOM_RIGHT:String = 'bottomRight';
		public static const PLACEMENT_TOP_CENTER:String = 'topCenter';
		public static const PLACEMENT_BOTTOM_CENTER:String = 'bottomCenter';
		
		protected var buttonBar:Element = null;
		protected var buttonsToolTip:ToolTip = null;
		
		protected var _autoAlign:Boolean = false;
		protected var _drawn:Boolean = false;
		protected var _playerType:String = CONTROL_PLAYER;
		protected var _target:IAnimator = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new MediaControl instance.
		 */
		public function MediaControl() { 
			removeChild(getChildByName('txt'));
			buttonBar = addElement('buttonBar', Element);
			buttonsToolTip = ToolTip(addElement('buttonsToolTip', ToolTip, { visible:false } ));
			sizeType = SIZE_FIXED;
		}
		
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Changes the alignment of the object. Use this property in conjuction with autoAlign 
		 * to have the controller auto aling itself within the parent objects visible area.
		 * @param	position	The physical position of the object.
		 * @return				The physical position of the object value
		 * @since	1.0
		 */
		public override function set textAlign(position:String):void{
			if (this.parentObj != null){
				this.x = 0;
				this.y = 0;
				switch(position){
					case PLACEMENT_TOP_LEFT:		
						break;
					case PLACEMENT_TOP_RIGHT:
						this.x = this.parentObj.width - this.width
						break;
					case PLACEMENT_BOTTOM_LEFT:
						this.y = this.parentObj.height - this.height;
						break;
					case PLACEMENT_BOTTOM_RIGHT:
						this.x = this.parentObj.width - this.width
						this.y = this.parentObj.height - this.height;
						break;
					case PLACEMENT_TOP_CENTER:
						this.x = this.parentObj.width / 2  - this.width / 2;
						break;
					case PLACEMENT_BOTTOM_CENTER:
						this.y = this.parentObj.height - this.height
						this.x = this.parentObj.width / 2  - this.width / 2;
						break; 
					default:
						trace('ERROR :: IMPROPERLY SET POSITION IN ATLASPROMOTIONSCONTROLLER')
				} // END switch
			} // END if
		}
		/**
		 * Set to TRUE ot have the object auto align itself with the parent's visible 
		 * space according to the val;ue of the textAlign property.
		 * @param	a	TRUE or FALSE.
		 * @return		The current auto align value
		 * @since	1.0
		 */
		public function get autoAlign():Boolean { return _autoAlign; }
		public function set autoAlign(a:Boolean):void { _autoAlign = a; }
		/**
		 *  Sets the parent enabled flag and enables or disables the child elements.
		 *  @param	Boolean	e	TRUE OR FALSE
		 *  @return	Boolean		TRUE OR FALSE
		 *  @since 1.0
		 */
		public override function set enabled(e:Boolean):void {
			super.enabled = e;
		}
		/**
		 * Overrides the default height setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object height in pixels
		 *
		 */
		public override function set height(h:Number):void {
			super.height = h;
			buttonBar.height = h;
			if (_drawn) draw();
		}
		/**
		 * 	Selects the type of player to be rendered.
		 *  @param	t	The player type. Either CONTROL_PLAYER or CONTROL_NUMBERED.
		 *  @return		The player type value.
		 *  @since 		1.0
		 */
		public function get playerType():String { return _playerType }
		public function set playerType(t:String):void { _playerType = t; }
		/**
		 * 	An implementation of an iAnimator to contect the cotnroller to.
		 *  @param	t	IAnimator target object.
		 *  @return		IAnimator target object value.
		 *  @since 		1.0
		 */
		public function get target():IAnimator { return _target }
		public function set target(t:IAnimator):void { _target = t; draw(); }
		/**
		 * Overrides the default width setter to set the sizes of the child elements
		 * @since	1.0
		 * @param	w The object width in pixels
		 *
		 */
		public override function set width(w:Number):void {
			super.width = w;
			buttonBar.width = w;
			if (_drawn) draw();
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Executed once the object has been added to the movie stage.
		 * @since	1.0
		 */
		public override function objReady(e:Event):void {
			if (gpm.css.getStyle(GlobalConstants.STYLE_TOOLTIP) != null)
				buttonsToolTip.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_TOOLTIP));
		}
		/**
		 * Decides which type of player to draw and executes it.
		 * @param	e
		 */
		public function draw():void{
			// Remove all children save for the background
			while (buttonBar.numChildren > 0) {
				buttonBar.removeChildAt(0);
			} // END while
		} // END function
		/**
		 * Called when the target obejct has comepleted it's animation. if the current object 
		 * is in a disbaled state, this method will enable this object again.
		 * @param	e	Mouse Event.
		 * @since	1.0
		 */
		public function onAnimationComplete(e:Event):void {
			target.removeEventListener(Event.COMPLETE, onAnimationComplete);
			enabled = true;
		}
	}
	
}