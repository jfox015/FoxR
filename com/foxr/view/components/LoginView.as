package com.foxr.view.components
{
	import com.foxr.controller.Application;
	import com.foxr.data.GlobalConstants;
	import com.foxr.display.components.Dialog;
	import com.foxr.display.components.Form;
	import com.foxr.display.components.TextInput;
	import com.foxr.display.TextElement;
	import com.foxr.event.LoginEvent;
	import com.foxr.event.DialogEvent;
	
	import com.foxr.view.mediators.LoginMediator;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * Login View.
	 * Draws a login dialog box to accept user authentication submissions.
	 * 
	 * @author		Jeff Fox
	 * @version		0.1
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class LoginView extends Dialog {
		/*-----------------------------------
		/	VARIABLES
		/----------------------------------*/
		/**
		 * Static name property 
		 * @var 	NAME:String 
		 */
		public static var NAME:String = 'LoginView';
		/**
		 * Login Form object 
		 * @var 	frmLogin:Form
		 */
		private var frmLogin:Form = null;
		/**
		 * Username Field Label
		 * @var 	lblUsername:TextElement
		 */
		private var lblUsername:TextElement = null;
		/**
		 * Username text Field
		 * @var 	txtUsername:TextInput
		 */
		private var txtUsername:TextInput = null;
		/**
		 * Password Field Label
		 * @var 	lblPassword:TextElement 
		 */
		private var lblPassword:TextElement = null;
		/**
		 * Password text Field
		 * @var 	txtPassword:TextInput
		 */
		private var txtPassword:TextInput = null;
		/**
		 * Authorization reuqest values object
		 * @var 	authRequest:Object
		 */
		private var authRequest:Object = null;
        /*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new LoginView instance.
		 */
		public function LoginView() {
			
			frmLogin = Form(addElement('frmLogin', Form, {validateOnSubmit:true,action:'asfunction:submitAuth',verbose:true} ));
			
			txtUsername = TextInput(frmLogin.addElement('txtUsername', TextInput, gpm.css.getStyle('forminput'), { textStyle:gpm.css.getTextFormat('forminput_text'),
			displayName:'Username', variable:'username', enabled:true, required:true,format:Form.VALIDATE_ALPHANUMERIC} ));
			txtPassword = TextInput(frmLogin.addElement('txtPassword', TextInput,gpm.css.getStyle('forminput'), { textStyle:gpm.css.getTextFormat('forminput_text'),displayAsPassword:true,
			displayName:'Password', variable:'password', enabled:true, required:true } ));
			
			lblUsername = TextElement(frmLogin.addElement('lblUsername', TextElement,{cssTextClass:'formlabels'}, null ));
			lblPassword = TextElement(frmLogin.addElement('lblPassword', TextElement,{cssTextClass:'formlabels'}, null ));
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Called once the object has been added to the stage.
		 * @param	e Event Response Object
		 * @since	1.0
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			bkgd.visible = true;
			txt.visible = false;
			btnClose.visible = btnCloseCross.visible = false;
			btnClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
			setCopy();
			setStyle();
			updateLayout();
		}
		/**
		 * Connection Failure handler.
		 * @param	e Event Response Object
		 * @since	1.0
		 */
		public function onConnectionFailure(e:Event):void { 
			//trace("LoginView, onConnectionFailure");
			sendNotification(Application.SHOW_MESSAGE,{ text:"An error occured during login. The server failed to connect.", titleBarText:'Login Error' } );
		}
		/**
		 * Submit Authorization handler.
		 * @param	e Event Response Object
		 * @since	1.0
		 */
		public function submitAuth(e:Event):void {
			sendNotification(LoginEvent.LOGIN_SUBMIT, {username:frmLogin.values.username,
			password:frmLogin.values.password });
		}
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
		 * Handler fo the OK button click event
		 * @param	e Event Response Object
		 * @since	1.0
		 */
		protected override function onBtnOKClick(e:MouseEvent):void {
			//gpm.log.debug(this.name + ".onBtnOKClick");
			frmLogin.submit(e);
		}
		/**
		 * Handler fo the closebutton click event
		 * @param	e Event Response Object
		 * @since	1.0
		 */
		protected override function onCloseClick(e:MouseEvent):void { }
		/**
		 * Applies predefined copy strings to the object
		 * @since	1.0
		 */
		protected override function setCopy():void {
			super.setCopy();
			titleBarTxt.string = 'global.login.title';
			txt.string = 'global.login.loginInstruction';
			lblUsername.string = 'global.login.labelUsername';
			lblPassword.string = 'global.login.labelPassword';
			btnOK.string = 'global.login.btnSubmit';
			updateLayout();
		}
		/**
		 * Applies predefined css styles to the object.
		 * <p/>
		 * Css Styles are defined in the Global Constants file.
		 * 
		 * @since 	1.0
		 * @see		com.foxr.data.GlobalConstants GlobalConstants
		 */
		protected override function setStyle():void {
			super.setStyle();
			if (gpm.css.getStyle(GlobalConstants.STYLE_LOGIN) != null)
				applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_LOGIN)); // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_LABEL) != null) {
				lblUsername.style = gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_LABEL);
				lblPassword.style = gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_LABEL);
			} // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_INPUT) != null) {
				txtPassword.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_FORM_INPUT));
				txtUsername.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_FORM_INPUT));
			} // END if
			if (gpm.css.getStyle(GlobalConstants.STYLE_FORM_BUTTON) != null)
				btnOK.applyProperties(gpm.css.getStyle(GlobalConstants.STYLE_FORM_BUTTON)); // END if
			if (gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_BUTTON_TEXT) != null)
				btnOK.textStyle = gpm.css.getTextFormat(GlobalConstants.STYLE_FORM_BUTTON_TEXT); // END if
			updateLayout();
		}
		/**
		 * Updates the layout of child objects based on the size of the dialog.
		 * @since	1.0
		 */
		protected override function updateLayout():void {
			titleBar.height = titleBarTxt.textHeight + (_padding * 2);
			
			titleBarTxt.y = (titleBar.height / 2) - (titleBarTxt.textHeight / 2);
			
			btnClose.width = btnClose.height = (titleBar.height - 2);
			btnClose.x = width - (btnClose.width + 1);
			btnClose.y = 1;
			
			btnCloseCross.size = btnClose.width - _padding;
			btnCloseCross.x = (btnClose.x + (_padding / 2));
			btnCloseCross.y = (btnClose.y + (_padding / 2));
			
			var contentStart:Number = titleBar.height + (_padding * 2);
			var contentArea:Number = height - ((buttonBar.height + (_padding * 3)) + contentStart);
			if (txt.visible == true) {
				contentArea -= txt.textHeight + (_padding * 2);
			} // END if
			lblUsername.y = txtUsername.y = (contentArea / 2) - ((txtUsername.height / 2) + _padding * 2);
			lblPassword.y = txtPassword.y = (contentArea / 2) + ((txtUsername.height / 2) + _padding * 2);
			
			lblUsername.x = lblPassword.x = _padding * 2;
			var inputX:Number = (lblUsername.textWidth > lblPassword.textWidth) ? (lblUsername.x + lblUsername.textWidth) + (_padding * 2) : (lblPassword.x + lblPassword.textWidth) + (_padding * 2);
			txtUsername.x = txtPassword.x = inputX;
			txtUsername.width = txtPassword.width = (width - (inputX + (_padding * 2)));
		
			buttonBar.y = ((contentStart + contentArea)  + (_padding * 4));
			btnOK.x = (buttonBar.width / 2) - (btnOK.width / 2);
			buttonBar.height = btnOK.height;
			updateHeight();
		}
	}
}