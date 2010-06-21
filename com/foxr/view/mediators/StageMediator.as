package com.foxr.view.mediators
{
	import com.foxr.display.Element;
    import flash.events.Event;
    import flash.display.Stage;
    import flash.display.*;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

    import org.puremvc.as3.interfaces.*;

    import com.foxr.controller.Application;
    import com.foxr.model.GlobalProxyManager;
    import com.foxr.event.LoginEvent;
    import com.foxr.view.containers.*;
    import com.foxr.view.mediators.*;
    
    /**
     * A Mediator for interacting with the containers of the FoxR visual architecture 
	 * which are created and live on the movies Stage.
	 * 
	 * While the Message, Pages and GlobalNav objects have their own mediators, this class 
	 * directly mediates for the Background, Header and Footer view containers.
	 * 
	 * @author 		Jeff Fox
	 * @version		1.15
	 * @see 		com.foxr.view.mediators.PageMediator PageMediator
	 * @see 		com.foxr.view.mediators.PageMediator MessageMediator
	 * @see 		com.foxr.view.mediators.PageMediator NavigationMediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
     */
    public class StageMediator extends BaseMediator {
        /*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property 
		 * @var 	NAME:String 
		 */
		public static var NAME:String = 'StageMediator';
        /**
		 * Notification to make changes to a direct child of StageContainer
		 * @var 	MODIFY_GLOBAL_OBJECT:String 
		 */
		public static const MODIFY_GLOBAL_OBJECT:String = 'stgMed_modObject';
		/**
		 * Number of items required to initalize for the stage to be shown
		 * @var 	ITEMS_REQUIED:Number
		 */
		public static const ITEMS_REQUIED:Number = 4;
		/**
		 * StageContainer Object Reference
		 * @var 	 stageContainer:StageContainer
		 */
		private var stageContainer:StageContainer = null;
		/**
		 * Background Object Reference
		 * @var 	 background:*
		 */
		private var background:* = null;
		/**
		 * Header Object Reference
		 * @var 	 header:*
		 */
		private var header:* = null;
		/**
		 * Footer Object Reference
		 * @var 	 footer:*
		 */
		private var footer:* = null;
		/**
		 * Number of items loaded
		 * @var 	 footer:*
		 */
		private var _itemsLoaded:Number = 0;
		/**
		 * Reference to the page displayed once Login Authentication successfully completes.
		 * @since	 FoxR 0.2
		 * @var 	 footer:*
		 */
		private var _rsltPage:String = '';
        /*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Creates a new StageMediator instance.
		 * @param	viewComponent		View component instance
		 */
		public function StageMediator( viewComponent:Object ) {
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
        public override function listNotificationInterests():Array {
            return [ Application.STAGE_ADD_SPRITE,
			Application.CSS_LOADED,
			Application.COPY_LOADED,
			Application.FONTS_LOADED,
			LoginEvent.LOGIN_COMPLETE,
			StageMediator.MODIFY_GLOBAL_OBJECT];
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
            var initTest:Boolean = true;
			switch ( note.getName() ) {
                // Create the movies visual hirearchy of view containers
                case Application.STAGE_ADD_SPRITE:
                case Application.CSS_LOADED:
                case Application.COPY_LOADED:
                case Application.FONTS_LOADED:
					_itemsLoaded++;
                    break;
				case LoginEvent.LOGIN_COMPLETE:
					onLoginComplete();
					break;
				case StageMediator.MODIFY_GLOBAL_OBJECT:
					var modObj:Object = note.getBody();
					modifyGlobalObject(modObj.name, modObj.params);
					initTest = false;
					break;
            } // END switch
			if (initTest &&_itemsLoaded == ITEMS_REQUIED)
				init();
        }
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		// LOGIN SPECIFIC WORKFLOW METHODS
		/**
		 * Handles a successful login attempt.
		 */
		private function onLoginComplete():void {
			_rsltPage = gpm.visualConfig.authorizeResultPage;
		}
		/**
		 * This method allows a custom set of properties to be applied to one of the 
		 * global child objects, such as the Background, view. Without this method,
		 * these objects could only be manipulated via a single CSS class definition 
		 * when the movie is initalized.
		 * @param	objName 	The name of the global object to be modified
		 * @param	objParams	Key/Value pair object if properties to be applied.
		 */
		private function modifyGlobalObject(objName:String,objParams:Object):void {
			var tmpObj:Element = Element(stageContainer.getChildByName(objName));
			if (tmpObj != null && objParams != null)
				tmpObj.applyProperties(objParams);
		}
        /**
         * Cast the viewComponent to its actual type.
         * 
         * @return stage the viewComponent cast to flash.display.Stage
         */
        protected function get stage():Stage{
            return viewComponent as Stage;
        }
		/**
		 * Mediator initialization function.
		 * <p />
		 * The Stage Mediator works in two init modes:
		 * <ul>
		 * 		<li>Normal</li>
		 * 		<li>Login</li>
		 * </ul>
		 * If the <b>authorizeUsers</b> property in <b>com.foxr.data.GlobalConfig</b> of the 
		 * local project is set to <b>false</b>, the StageMediator executes init() in <i>Normal</i>
		 * mode, where it instantiates all of the global FoxR View container classes and starts 
		 * the movie.
		 * <p />
		 * As of FoxR 0.2, the Stage Mediator also support <i>Login</i> mode where it will only 
		 * initialize the StageContainer and Message view objects, the require the user to 
		 * login. Once the login process completes and the users authorization is confirmed, init() 
		 * is called a second time whereby it executes as if in Normal mode.
		 * 
		 * @since	1.0
		 */
		private function init():void {
			if (stageContainer == null) {
				var stg:Stage = viewComponent as Stage; 
				stg.align = StageAlign.TOP_LEFT;
				stg.scaleMode = StageScaleMode.NO_SCALE;
				stageContainer = new StageContainer();
				stg.addChild(stageContainer);
			} // END if
			// Login or call default page
			if ((!gpm.config.authorizeUsers || (gpm.config.authorizeUsers && gpm.config.flashVars['authorized'])) && stageContainer.numChildren < 2) {
				while (stageContainer.numChildren > 0) {
					stageContainer.removeChildAt(0);
				}
				// Add background object
				var backgroundClass:* = gpm.visualConfig.background as Class;
				if (backgroundClass != null && backgroundClass.toString() != '') {
					background = backgroundClass(stageContainer.addElement('background', backgroundClass));
				} else {
					background = Background(stageContainer.addElement('background', Background));
				} // END if
				try {
					background.applyProperties({ width:gpm.visualConfig.width, height:gpm.visualConfig.height } );
				}catch (e:Error) { }
				if (gpm.css.getStyle('background') != null)
					background.applyProperties(gpm.css.getStyle('background'));
				
				// Add pages object
				var pages:Pages = Pages(stageContainer.addElement('pages', Pages, { width:gpm.visualConfig.width,
					height:gpm.visualConfig.height } ));
				facade.registerMediator(new PageMediator(pages));	
				
				// Add header object
				var headerClass:* = gpm.visualConfig.header as Class;
				if (headerClass != null && headerClass.toString() != '') {
					header = headerClass(stageContainer.addElement('header', headerClass));
				} else {
					header = Header(stageContainer.addElement('header', Header));
				} // END if
				try {
					header.applyProperties({ width:gpm.visualConfig.width } );
				} catch (e:Error) { }
				if (gpm.css.getStyle('header') != null)
					header.applyProperties(gpm.css.getStyle('header'));
					
				// Add footer object
				var footerClass:* = gpm.visualConfig.footer as Class;
				if (footerClass != null && footerClass.toString() != '') {
					footer = footerClass(stageContainer.addElement('footer', footerClass));
				} else {
					footer = Footer(stageContainer.addElement('footer', Footer));
				} // END if
				try {
					footer.applyProperties({ width:gpm.visualConfig.width});
				}catch (e:Error) { }
				if (gpm.css.getStyle('footer') != null)
					footer.applyProperties(gpm.css.getStyle('footer'));	
				footer.y = gpm.visualConfig.height - footer.height;
				
				// Add global nav object
				var gNav:GlobalNav = GlobalNav(stageContainer.addElement('gNav', GlobalNav, { width:gpm.visualConfig.width,
					height:gpm.visualConfig.height } ));
				facade.registerMediator(new NavigationMediator(gNav));
			}
			// Add message object
			var message:Message = Message(stageContainer.addElement('message', Message, { width:gpm.visualConfig.width,
				height:gpm.visualConfig.height } ));
			facade.registerMediator(new MessageMediator(message));
			
			// Login or call default page
			if (gpm.config.authorizeUsers && !gpm.config.flashVars['authorized']) {
				sendNotification(Application.SHOW_LOGIN);
			} else {
				if (_rsltPage == '') _rsltPage = gpm.visualConfig.startPage;
				sendNotification(Application.CHANGE_PAGE,_rsltPage);
			}
		}
    }
}