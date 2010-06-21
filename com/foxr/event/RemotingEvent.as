package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides Remoting specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class RemotingEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const REMOTING_CONNECTION_FAILURE:String = 'remotingFailure';
		public static const REMOTING_CONNECTION_SUCCESS:String = 'remotingSuccess';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new RemotingEvent instance.
		 *
		 */
		public function RemotingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
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
            return new RemotingEvent(type, bubbles, cancelable);
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		
		
	}
	
}