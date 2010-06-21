package com.foxr.display.components.media
{
	//import external classes
	import flash.events.Event;
	/**
	 * Interface for object that will act as children of Media Control.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public interface IMediaControl {
		
		/*--------------------------------------
		/	FUNCTIONS
		/-------------------------------------*/
		/**
		 * Decides which type of player to draw and executes it.
		 * @param	e
		 */
		function draw():void
		/**
		 * Fired once the media playback completes.
		 * @param	e
		 */
		function onAnimationComplete(e:Event):void
	}
	
}