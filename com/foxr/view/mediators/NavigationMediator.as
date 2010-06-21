package com.foxr.view.mediators
{
	import com.foxr.view.containers.GlobalNav;
    import flash.events.Event;
    import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    import com.foxr.controller.Application;
    import com.foxr.view.containers.Message;
     /**
	 * A Mediator for managing  GlobalNav view class.
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see			com.foxr.view.containers.GlobalNav GlobalNav
	 * @see			org.puremvc.as3.patterns.mediator.Mediator Mediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class NavigationMediator extends BaseMediator {
       /**
		 * Static name property
		 * @var		NAME:String
		 */
		public static var NAME:String = 'NavigationMediator';
        /*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new NavigationMediator instance.
		 * @param	viewComponent	The related view class object
		 */
		public function NavigationMediator( viewComponent:Object ) {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
        }
        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array {
            return [  ];
        }
        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) {
				default:
					break;
            }
        }                    
        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return GlobalNav the viewComponent cast to flash.display.GlobalNav
         */
        protected function get globalNav():GlobalNav{
            return viewComponent as GlobalNav;
        }
    }
}