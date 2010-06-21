/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package com.foxr.view.mediators
{
	import com.foxr.model.GlobalProxyManager;
    import flash.events.Event;
    import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    import com.foxr.controller.Application;
    import com.foxr.display.components.Dialog;
    import com.foxr.event.LoginEvent;
    import com.foxr.event.DialogEvent;
    import com.foxr.view.containers.Message;
    import com.foxr.view.components.LoginView;
    /**
	 * A Mediator for managing message dialogs displayed in the Message view class.
	 * <p />
	 * The message mediator registers interested in the following application level notifications:
	 * <ul>
	 * 	<li>Application.SHOW_MESSAGE</li>
	 * 	<li>Application.HIDE_MESSAGE</li>
	 * 	<li>Application.SHOW_LOGIN</li>
	 * 	<li>Application.MESSAGE_RENDERED</li>
	 * 	<li>LoginEvent.LOGIN_COMPLETE</li>
	 * 	<li>LoginEvent.LOGIN_SUCCESS</li>
	 * </ul>
	 * <p />
	 * 
	 * <p />
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see			com.foxr.display.components.Dialog
	 * @see			com.foxr.view.containers.Message
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class MessageMediator extends BaseMediator {
        /*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property
		 * @var		NAME:String
		 */
		public static var NAME:String = 'MessageMediator';
		/**
		 * List of open messages
		 * @var		_messageList:Array
		 */
		private var _messageList:Array = null;
		/**
		 * MsgBox Message handler
		 * @var		_messageList:Array
		 */
		private var login:LoginView = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new MessageMediator instance.
		 * @param	viewComponent	The related view class object
		 */
		public function MessageMediator( viewComponent:Object ) {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
			_messageList = new Array();
        }
        /*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        public override function listNotificationInterests():Array {
            return [ Application.SHOW_MESSAGE, 
			Application.HIDE_MESSAGE, 
			Application.SHOW_LOGIN, 
			Application.MESSAGE_RENDERED, 
			LoginEvent.LOGIN_COMPLETE, 
			LoginEvent.LOGIN_SUCCESS ];
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
        public override function handleNotification( note:INotification ):void {
            var params:Object = note.getBody();
			var dlgName:String = (params != null && params.name != null) ? params.name as String : '';
			var dlgClass:Class = (params != null && params.className != null) ? params.className as Class : null;
			var dlgProps:Object = (params != null && params.props != null) ? params.props as Object : null;
			var dlgCss:Object = (params != null && params.css != null) ? params.css as Object : null;
					
			switch ( note.getName() ) {
                // Create the movies visual hirearchy of view containers
                case Application.SHOW_MESSAGE:
					showMessage(dlgName,dlgClass,dlgProps,dlgCss);
                    break;
				case Application.HIDE_MESSAGE:
				case LoginEvent.LOGIN_COMPLETE:
					closeMessage(dlgName);;
                    break;
				case Application.SHOW_LOGIN:
					showLogin();
					break
				case Application.MESSAGE_RENDERED:
					onDialogRendered(dlgName);
					break
				default:
					break;
            }
        }                    
        /**
		 *  Closes the specified message and removes it from the Message object. This method will drop
		 *  the blocker movie clip underneath the next highest message in the _messageList array 
		 *  or turn it off if no more messages are present.
		 *  @param	ref	Message object
		 *  @since	1.0
		 */
		public function closeMessage(dialogName:String = ''):Boolean {
			var mc:Message = viewComponent as Message;
			try {
				var tmpMessage:* = null;
				if (dialogName != '')
					tmpMessage = mc.getChildByName(dialogName);
				else
					tmpMessage = mc.getChildAt(mc.numChildren - 1); // END if
					
				if (_messageList.length > 0) {
					for (var i:Number = 0; i < _messageList.length; i++) {
						if (_messageList[i] == tmpMessage) {
							_messageList.splice(i,1);
							break;
						} // End if
					} // End for
				} // END if
				if (_messageList.length <= 0){
					mc.hideBlockingLayer();
					mc.setChildIndex(mc.getChildByName('blocker'),0);
				} else {
					mc.setChildIndex(mc.getChildByName('blocker'),_messageList.length-1);
				} // END if
				mc.removeChild(tmpMessage);
				return true;
			} catch (e:Error) {
				gpm.log.error(this.name + ", error occured closing message " + dialogName + ". Error = " + e);
				return false;
			} // END try/catch
			return true;
		}
		/**
		 * 	Shortcut method for invoking the built in authentication dialog process.
		 *  <p />
		 * 	Creates the Login View object and registers the Login mediator object.
		 *  @since	1.0
		 *  @see			com.foxr.model.LoginProxy LoginProxy
		 *  @see			com.foxr.event.LoginEvent LoginEvent
		 *  @see			com.foxr.view.components.LoginView LoginView
		 *  @see			com.foxr.view.mediators.LoginMediator LoginMediator
		 */
		public function showLogin():void { 
			var mc:Message = viewComponent as Message;
			login = LoginView(showMessage('login', LoginView));
			facade.registerMediator(new LoginMediator(login));
		}
		/**
		 * 	Opens a message by creating a movieclip and attaching the requested message into it
		 *  @param	dialogName	Linkage name of the message to be opened
		 *  @since	1.0
		 */
		public function showMessage(dialogName:String = '',dialogClass:Class = null,props:Object=null,cssStyle:Object=null):*{
			var mc:Message = viewComponent as Message;
			if (dialogName == '') dialogName = 'dlgMessage';
			if (!dialogClass) dialogClass = Dialog;
			var newMessage:* = dialogClass(mc.addElement(dialogName, dialogClass, props, cssStyle));
			_messageList.push(newMessage);
			if (_messageList.length > 0 && newMessage.showAsModal) {
				mc.setChildIndex(mc.getChildByName('blocker'), mc.numChildren - 2);
				//var index:Number = 0;
				for (var i:Number = 0; i < mc.numChildren; i++) {
					var child:* = mc.getChildAt(i);
					if (child.name != 'blocker') {
						mc.setChildIndex(child,i);
					} // END if
				} // END for
				mc.showBlockingLayer();
			} // END if
			newMessage.show();
			return newMessage;
		}
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Fired once the dialog has completed rendering itself. It centers the opened dialog 
		 *  acording to the height and width of the message view object.
		 *  @param	id	The name of the dialog that has been rendered
		 *  @since	1.0
		 */
		protected function onDialogRendered(id:String):void {
			var mc:Message = message;
			var dlg:Dialog = mc.getChildByName(id) as Dialog;
			dlg.x = (mc.width / 2) - (dlg.width / 2);
			dlg.y = (mc.height / 2) - (dlg.height / 2);
		}
		/**
         * Cast the viewComponent to its actual type.
         * 
         * @return message 	the viewComponent cast to com.foxr.view.containers.Message
		 * @see				com.foxr.view.containers.Message
         */
        protected function get message():Message{
            return viewComponent as Message;
        }
    }
}