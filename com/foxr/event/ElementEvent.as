package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides Element specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class ElementEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const ELEMENT_ADDED:String = 'elementAdded';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ElementEvent instance.
		 *
		 */
		public function ElementEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
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
            return new ElementEvent(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		
		
	}
	
}