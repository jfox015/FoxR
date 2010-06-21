package com.foxr.data
{
	/**
	 * A static repository for global constant values used throughout 
	 * the framework.
	 * <p />
	 * This class should be used for constants used in the global top level framework 
	 * library. Constansts for individual applications should be placed in a seperate 
	 * LocalConstants file in com.foxr.data.
	 * <p />
	 * @author			Jeff Fox
	 * @version			1.0
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class GlobalConstants {
		
		public static const MIN_VERSION:String = "9";
		
		public static const DEFAULT_TRACKING_STRING:String = '/';
		/*---------------------------------
		/	EXTERNAL CONTENT
		/--------------------------------*/
		public static const IMG_FORMAT_DEFAULT:String = '.swf';
		public static const LOG_ACTIVELOG:String = 'activeLog';
		public static const LOG_FIREBUG:String = 'firebug';
		public static const LOG_LUMINICBOX:String = 'luminicBox';
		public static const LOG_DEFAULT:String = 'default';
		
		/*---------------------------------
		/	KEYBOARD CODES
		/--------------------------------*/
		// WINDOWS
		public static const KEY_WIN_TAB:Number = 9;
		public static const KEY_WIN_ENTER:Number = 13;
		public static const KEY_WIN_BACKSPACE:Number = 8;
		public static const KEY_WIN_SHIFT:Number = 16;
		public static const KEY_WIN_ESC:Number = 27;
		// MAC
		public static const KEY_MAC_TAB:Number = 9;
		public static const KEY_MAC_ENTER:Number = 13;
		
		/*---------------------------------
		/	EXTERNAL ADAPTERS
		/--------------------------------*/
		public static const ADAPTER_AMF:String = 'amf';
		public static const ADAPTER_XML:String = 'xml';
		public static const ADAPTER_HTTP:String = 'http';
		public static const ADAPTER_SOAP:String = 'soap';
	
		// LOGIN EVENTS
		public static const LOGIN_SUCCESS:String = 'loginSuccess';
		public static const LOGIN_FAILURE:String = 'loginFailed';
		public static const LOGIN_COMPLETE:String = 'loginComplete';
		public static const LOGIN_AUTHORIZED:String = 'Authorized';
		public static const LOGIN_NOT_AUTHORIZED:String = 'Not Authorized';
		
		/*---------------------------------
		/	GLOBAL CSS STYLES
		/--------------------------------*/
		public static const STYLE_GENERAL_COPY:String = 'general_copy';
		
		public static const STYLE_DIALOG_TITLEBAR_TEXT:String = 'dialog_title_text';
		public static const STYLE_DIALOG_TEXT:String = 'dialog_text';
		public static const STYLE_DIALOG_CLOSE_BUTTON:String = 'dialog_close_button';
		
		public static const STYLE_MEDIA_PLAYBACK_CTRL:String = 'media_playback_control';
		public static const STYLE_MEDIA_NUMBERED_CTRL:String = 'numbered_media_control';
		public static const STYLE_MEDIA_PLAYBACK_CTRL_TEXT:String = 'media_playback_control_text';
		public static const STYLE_MEDIA_NUMBERED_CTRL_TEXT:String = 'numbered_media_control_text';
		
		
		
		// COMPONENTS
		public static const STYLE_BLOCKER:String = 'blocker';
		public static const STYLE_DIALOG:String = 'dialog';
		public static const STYLE_MSGBOX:String = 'msgbox';
		public static const STYLE_LOGIN:String = 'login';
		public static const STYLE_SCROLLBAR:String = 'scrollbar';
		public static const STYLE_CALENDAR:String = 'calendar';
		public static const STYLE_TOOLTIP:String = 'tooltip';
		
		// FORMS
		public static const STYLE_FORM_BUTTON:String = 'formbutton';
		public static const STYLE_FORM_BUTTON_TEXT:String = 'formbuttontext';
		public static const STYLE_FORM_INPUT:String = 'forminput';
		public static const STYLE_FORM_LABEL:String = 'formlabels';
		
		/*---------------------------------
		/	DEFAULT COPY CONST
		/--------------------------------*/
		public static const COPY_FORM_VALIDATION_MESSAGE:String = 'global.general.forms.validationMessage';
		public static const TEXT_DIALOG_BUTTON_OK:String = 'global.general.buttons.dialogButtonOK';
		
	}
}