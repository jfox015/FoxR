package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides CascadingMenu specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class CascadingMenuEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const MENU_OPEN:String = 'open';
		public static const MENU_CLOSE:String = 'close';
		public static const MENU_CREATED:String = 'created';
		public static const MENU_CHANGE_CHILD:String = 'changeChild';
		public static const MENU_CUSTOM_EVENT:String = 'custom';
		public static const MENU_BUILD_CHILD:String = 'buildChild';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new CascadingMenuEvent instance.
		 *
		 */
		public function CascadingMenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
			super(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		// override clone so the event can be redispatched
        public override function clone():Event {
            return new CascadingMenuEvent(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
	}
	
}