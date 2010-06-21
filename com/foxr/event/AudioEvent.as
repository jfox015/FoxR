package com.foxr.event
{
	//import external classes
	import flash.events.Event;
	
	/**
	 * An extension of Event that provides Audio specific events.
	 * 
	 * @author		Jeff Fox
	 * 
	 */
	public class AudioEvent extends Event {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const AUDIO_START:String = 'audio_start';
		public static const AUDIO_STOP:String = 'audio_stop';
		public static const AUDIO_LOADED:String = 'audio_loaded';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new AudioEvent instance.
		 *
		 */
		public function AudioEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) { 
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