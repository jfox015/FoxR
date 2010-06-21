package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides Login specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class LoginEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const LOGIN_COMPLETE:String = 'completed';
		public static const LOGIN_FAILURE:String = 'failure';
		public static const LOGIN_SUCCESS:String = 'success';
		public static const LOGIN_SUBMIT:String = 'submit';
		public static const LOGIN_RESPONSE:String = 'response';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new LoginEvent instance.
		 *
		 */
		public function LoginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
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
            return new LoginEvent(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
	}
	
}