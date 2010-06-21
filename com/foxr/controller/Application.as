/*
 * FoxR Application
 *
 * Copyright (c) 2009 Jeff Fox.
 * 
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package com.foxr.controller
{
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import com.foxr.controller.commands.*;
	import com.foxr.data.GlobalConstants;
	/**
	 * This is the base application class for the FoxR Application. It acts as the 
	 * central hub of commincation for the entire movies infastructure.
	 * <p />
	 * This class extends the PureMVC Facade class which sets up the MVC structure 
	 * and facilitates the notifications and command execution structures.
	 * <p />
	 * This class also serves as the central hub for notifications and commands and 
	 * features the definition of numerous notifications used by the global support 
	 * classes in the architecture.
	 * <p />
	 * Example usage:
	 * <listing>
	 * public class FoxRApplication extends Application {
	 *     public function FoxRApplication() { super(); }
	 * 
	 *     public static function getInstance() : FoxRApplication {
	 *         if ( _instance == null ) _instance = new FoxRApplication();
	 *         return _instance as FoxRApplication;
	 *     }
	 *     public function startup(stg:Stage, loaderInfo:Object):void {
	 * 	       sendNotification( STARTUP, {stage:stg, loaderInfo:loaderInfo} );
	 *     }
	 * }
	 * </listing>
	 * 
	 * @author			Jeff Fox
	 * @version			1.0
	 * @see 			org.puremvc.as3.patterns.facade.Facade Facade
	 * @see				org.puremvc.as3.patterns.command.SimpleCommand SimpleCommand
	 * 
	 */
	public class Application extends Facade implements IFacade {
		
		/*--------------------------------
		/	VARIABLES
		/-------------------------------*/
		public static var NAME:String = 'Application';
		protected static var _instance:Application = null;
		
		// Notification name constants
        public static const STARTUP:String  			= "startup";
		public static const PROXY_INIT:String  			= "proxyInit";
        
		// Start up completion notifications
		public static const COPY_LOADED:String  		= "onCopyLoaded";
		public static const FONTS_LOADED:String  		= "onFontsLoaded";
		public static const CSS_LOADED:String  			= "onCSSLoaded";
		public static const PROXY_LOADED:String  		= "proxyLoaded";

		public static const SECURITY_INIT:String  		= "securityInit";
        public static const START_VIEW:String  			= "startView";
        
		public static const STAGE_ADD_SPRITE:String		= "stageAddSprite";
        
		public static const CHANGE_PAGE:String			= "changePage";
        public static const SHOW_MESSAGE:String			= "showMessage";
        public static const HIDE_MESSAGE:String			= "hideMessage";
		public static const MESSAGE_RENDERED:String		= "messageRendered";
		public static const SHOW_LOGIN:String  			= "showLogin";
		
		// Future commands for dynamic copy and css updates
		public static const CSS_UPDATE:String  			= "onCSSUpdated";
		public static const COPY_UPDATE:String  		= "onCopyUpdated";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new Application instance.
		 *
		 */
		public function Application() { super(); }
		/*--------------------------------------
		/	STATIC FUNCTIONS
		/-------------------------------------*/
		/**
         * Singleton ApplicationFacade Factory Method
		 * @since	1.0
         */
        public static function getInstance() : Application {
            if ( _instance == null ) _instance = new Application();
            return _instance as Application;
        }
		/*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
         * Initiallizes the top levelc ontroller object and registera numerous 
		 * startuup commands with the Controller.
		 * @since 	1.0
         */
        protected override function initializeController() : void {
            super.initializeController();            
            registerCommand( PROXY_INIT, GPMInitCommand );
            registerCommand( SECURITY_INIT, SecurityCommand );
			registerCommand( PROXY_LOADED, GMPLoadedCommand );
            registerCommand( START_VIEW, StartViewCommand );
        }
		
	}
}