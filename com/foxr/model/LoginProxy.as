package com.foxr.model 
{
	import com.foxr.controller.Application;
	import com.foxr.data.*;
	import com.foxr.model.BaseProxy;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.util.Utils;
	import com.foxr.event.LoginEvent;
	
	import flash.events.Event;
	
	/**
	 * This proxy serves simply as a conduite to submit the login request and route 
	 * the response to a local command handler.
	 * <p />
	 * @author			Jeff Fox
	 * @version			0.2.1
	 * 
	 * @see 			com.foxr.view.mediators.LoginMediator
	 * 
	 */
	public class LoginProxy extends BaseProxy {
		
		/*--------------------------------
		/	VARIABLES
		/-------------------------------*/
		public static var NAME:String = "LoginProxy";
		/**
		 * Authorization Code.
		 * @var _authCode:Number
		 */
		private var _authCode:Number = -1;
		/**
		 * Error Message.
		 * @var _errorStr:String
		 */
		private var _errorStr:String = "";
		/*---------------------------------
		/	C'TOR
		/--------------------------------*/
		/**
		 * Creates a new LoginModel instance.
		 * @param	application		Tracking Application identifier
		 */
		public function LoginProxy() { 
			super(NAME, new Object());
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Authorization Code.
		 * @return	Authorization Code value
		 * @since	0.2.1
		 */
		public function get authorizationCode():Number { return _authCode; }
		/**
		 * Error Message.
		 * @return	Error Message value
		 * @since	0.1
		 */
		public function get errorMessage():String { return _errorStr; }
		/*---------------------------------
		/	PUBLIC FUNCTIONS
		/--------------------------------*/
		/**
		 * Submits the login credentials to the server using the specified login action via the 
		 * applications selected adapter.
		 * @param	authRequest	Object containing values submitted to the server.
		 * @since	0.1
		 */
		public function performLogin(authRequest:Object):void {
			var gpm:GlobalProxyManager = facade.retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			requestData(authRequest, gpm.config.authorizeAction, gpm.config.adapterType, this);
		}
		/**
		 * Called from onRequestComplete to distribute the data back to the Model for use
		 * @param data:Object - the object returned from the adapter layer call
		 * @since	1.0
		 * 
		 */
		public override function handleDataResponse(responseObj:Object):void { 
			sendNotification(LoginEvent.LOGIN_RESPONSE, responseObj);
		}
	}
}