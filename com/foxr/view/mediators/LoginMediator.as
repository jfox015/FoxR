package com.foxr.view.mediators
{
	import flash.events.Event;

    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    import com.foxr.controller.Application;
    import com.foxr.event.LoginEvent;
    import com.foxr.model.LoginProxy;
    import com.foxr.util.StringUtils;
    import com.foxr.view.components.LoginView;
    /**
	 * A Mediator for interacting with the login UI module.
	 * <p />
	 * This class provides functionality to connect to the LoginProxy object which in 
	 * turn gives this mediator access to the FoxR Adapter workflow to send login 
	 * credentials and validate their authenticity.
	 * <p />
	 * As of Foxr 0.2, the steps to both prepare the data received by this classes associated view 
	 * object as well as those to parse the results and process them have been moved from 
	 * the associated proxy to custom response commands that should be set up in the specific 
	 * projects architecture.
	 * <p />
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see			com.foxr.model.LoginProxy LoginProxy
	 * @see			com.foxr.event.LoginEvent LoginEvent
	 * @see			com.foxr.view.components.LoginView LoginView
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class LoginMediator extends BaseMediator {
        /*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property 
		 * @var 	NAME:String 
		 */
		public static var NAME:String = 'LoginMediator';
		/**
		 * Login Proxy Object reference 
		 * @var 	lp:LoginProxy
		 */
		private var lp:LoginProxy = null;
        /*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Creates a new LoginMediator instance.
		 * @param	viewComponent		View component instance
		 */
		public function LoginMediator( viewComponent:Object ) {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
			var login:LoginView = viewComponent as LoginView;
			facade.registerProxy(new LoginProxy());
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
            return [ LoginEvent.LOGIN_SUBMIT,
					 LoginEvent.LOGIN_FAILURE,
					 LoginEvent.LOGIN_RESPONSE,
					 LoginEvent.LOGIN_SUCCESS];
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
            switch ( note.getName() ) {
				case LoginEvent.LOGIN_SUBMIT:
					if (gpm.config.authorizeRequestHandler != '') 
						sendNotification(gpm.config.authorizeRequestHandler, note.getBody());
					break;
				case LoginEvent.LOGIN_RESPONSE:
					if (gpm.config.authorizeResponseHandler != '') 
						sendNotification(gpm.config.authorizeResponseHandler, note.getBody());
					break;
				case LoginEvent.LOGIN_SUCCESS:
					sendNotification(LoginEvent.LOGIN_COMPLETE);
					break;
				case LoginEvent.LOGIN_FAILURE:
					var loginFail:Object = note.getBody();
					var failStr:String = gpm.copy.getCopyString('global.login.bodyError');
					failStr = failStr.replace('{ErrorMess}', loginFail.errorStr);
					sendNotification(Application.SHOW_MESSAGE, { name:'loginErr',  props:{titleBarString:'global.login.titleError', 
					text:failStr }} )
					break;
				default:
					break;
            } // END switch
        }                    
        /*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/		
		/**
         * Cast the viewComponent to its actual type.
         * 
         * @return login the viewComponent cast to com.foxr.view.components.LoginView
         */
        protected function get login():LoginView{
            return viewComponent as LoginView;
        }
    }
}