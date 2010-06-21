package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides Form specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class FormEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const VALIDATION_SUCCEED:String = 'succeed';
		public static const VALIDATION_FAIL:String = 'fail';
		public static const VALIDATION_SUBMIT_SUCCEED:String = 'submit';
		public static const VALIDATION_SUBMIT_FAIL:String = 'fail';
		public static const ELEMENT_ADDED:String = 'added';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new FormEvent instance.
		 *
		 */
		public function FormEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
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
            return new FormEvent(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		
		
	}
	
}