package com.foxr.view.containers
{
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.Element;
	import com.foxr.display.graphics.Box;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * The Message class serves as a top level modal object and messaging container object. It 
	 * provides methods via the MessageMediator object to open global top level dialogs above 
	 * all the other content in the movie either as a directly placed child (by way of getInstance) 
	 * or through the Global Application.SHOW_MESSAGE notification. Opened Dialogs also have 
	 * the option to be opened as modal windows meaning that all other content within the movie 
	 * is disabled while the modal window is open.
	 * <p />
	 * This class sits is the top most class, sitting above the the Messaging Container class, 
	 * in the FoxR Visual Architecture.
	 * <p />
	 * This class is mediated by the MessageMediator class. This class is not available 
	 * to be overridden by a custom class.
	 * 
	 * @author		Jeff Fox
	 * @version		1.0
	 * @see 		com.foxr.view.mediators.MessageMediator MessageMediator
	 * @see 		com.foxr.controller.Application Application
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Message extends Element 
	{
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/		
		/**
		 * Static name property
		 */
		public static const NAME:String = "Message";
		/**
		 * BLOCKER
		 * @var		blocker:Box 
		 */
		private var blocker:Box = null;		
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Message instance.
		 *
		 */
		public function Message() { 
			blocker = Box(addElement('blocker', Box ));
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Fired when the object is added to the stage. Place all your objects to be rendered to the 
		 *  stage within this method, NOT the constructor.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			setStyle();
			super.objReady(e);
		}
		/**
		 * 	Applies a predefined set of style proeprties to the included modal layer.
		 *  @since	1.0
		 */
		public function setStyle():void {
			var styleProps:Object = { width:gpm.visualConfig.width, 
			height:gpm.visualConfig.height, color:0xFFFFFF, alpha:0.10, visible:false, 
			useHandCursor:false, mouseChildren:false, buttonMode:true }
			blocker.applyProperties(styleProps);
			
		}
		/**
		 * 	Turns the click blocker off by making it visible and removing an MOUSE_UP event handler.
		 *  @since	1.0
		 */
		public function hideBlockingLayer():void {
			blocker.visible = false;
			blocker.removeEventListener(MouseEvent.MOUSE_UP, onBlockerClick);
		}
		/**
		 * 	Turns the click blocker on by making it visible and adding an MOUSE_UP event handler.
		 *  @since	1.0
		 */
		public function showBlockingLayer():void {
			blocker.visible = true;
			blocker.addEventListener(MouseEvent.MOUSE_UP, onBlockerClick);
		}
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Handles the blocker clip click action which does nothing.
		 *  @since	1.0
		 */
		private function onBlockerClick(e:Event):void { }
	}
	
}