package com.foxr.display.content 
{
	// import external classes
	import flash.events.Event;
	/**
	 * Interface for objects that will provide animation capabilities.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Jeff Fox
	 *
	 * 
	 */
	public interface IAnimator  {
		
		function isAnimating():Boolean
		
		function itemsLoaded():Number
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		/**
		 * 	Executes the animation.
		 *	@since	1.0
		 */
		function animate(idx1:Object,idx2:Object):void
		/**
		 * 	Method to go to the first item.
		 *	@since	1.0
		 */
		function first():void
		/**
		 * 	Method to go to the last item.
		 *	@since	1.0
		 */
		function last():void
		/**
		 * 	Method to pause the animation.
		 *	@since	1.0
		 */
		function pause():void
		/**
		 * 	Method to start the animation.
		 *	@since	1.0
		 */
		function play():void
		/**
		 * 	Method to play a specific item in the collection.
		 *	@since	1.0
		 */
		function playItem(itemIndex:Number):void
		/**
		 * 	Method to go to the next item.
		 *	@since	1.0
		 */
		function next():void
		/**
		 * 	Method to go back to a previous item.
		 *	@since	1.0
		 */
		function previous():void
		/**
		 * 	Method to reset the animation.
		 *	@since	1.0
		 */
		function reset():void 
		/**
		 * 	Method to stop the animation.
		 *	@since	1.0
		 */
		function stop():void 
		
	}
	
}