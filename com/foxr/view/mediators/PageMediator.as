package com.foxr.view.mediators
{
	import flash.events.Event;
    import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    import com.foxr.controller.Application;
    import com.foxr.display.Page;
    import com.foxr.view.containers.Pages;
	import com.foxr.view.containers.StageContainer;

    /**
     * A Mediator for interacting with child page views.
     */
    public class PageMediator extends BaseMediator {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property 
		 * @var 	NAME:String 
		 */
		public static var NAME:String = 'PageMediator';
        /*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Creates a new LoginMediator instance.
		 * @param	viewComponent		View component instance
		 */
		public function PageMediator( viewComponent:Object ) {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent as Pages );
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
        override public function listNotificationInterests():Array {
            return [ Application.CHANGE_PAGE ];
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
                // Create the movies visual hirearchy of view containers
                case Application.CHANGE_PAGE:
					changePage(note.getBody() as String);
                    break;
				default:
					break;
            }
        }                    
        /*--------------------------------------
		/	PRIVATE/PROTECTED FUNCTIONS
		/-------------------------------------*/
		/**
         * Cast the viewComponent to its actual type.
         * 
         * @return Pages the viewComponent cast to flash.display.Pages
         */
        protected function get pages():Pages{
            return viewComponent as Pages;
        }
		/**
		 *  Switches the application from an active view to one passed as an argument.
		 *  <p />
		 *  The list of pages available to be switched is defined in the GlobalConstants file
		 *  under pageList.
		 * 	@since	1.0
		 *  @param	p		Page name argument
		 *  @see 	com.foxr.data.GlobalConstants GlobalConstants
		 *  @see 	com.foxr.display.Page Page
		 */
		protected function changePage(p:String):Boolean {
			var success:Boolean = false;
			// Test to assure the page requested is not specified as the Backstage object
			try {
				if (p != 'backstage') {
					var c:Class = gpm.visualConfig.pageList[p].view;
					if (c != null) {
						var page:Page = null;
						var pc:Pages = viewComponent as Pages;
						if (pc.getChildByName(p) == null) {
							page = Page (pc.addElement(p, c, { alpha:0, visible:false, fadeTime:gpm.visualConfig.pageFadeTime } ));
							var style:Object = gpm.css.getStyle(p);
							if (style != null) page.applyProperties(style);
						} else {
							page = Page(pc.getChildByName(p));
							page.init();
						} // END if
						for (var pname:String in gpm.visualConfig.pageList) {
							if (pname != p && pc.getChildByName(pname) != null) {
								var tmpPage:Page = Page(pc.getChildByName(pname));
								if (tmpPage.visible) tmpPage.hide(); // END if
							}  // END if
						} // END for
						page.show();
						var medClass:Class = gpm.visualConfig.pageList[p].mediator;
						facade.registerMediator(new medClass(page));
						
						// SEND CHANGE PAGE EVENT TO CLICK TRACKING APPLICATION IF ENAABLED
						if (gpm.config.analytics) 
							gpm.analytics.trackClick(p);
						success = true;
					} else {
						// Backstage object passed so throw an error
						trace(NAME+'::changePage -- Class ' + c + ' could not be loaded.');
					} // END if
				} else {
					trace(NAME+'::changePage -- Backstage object name passed as showPage parameter. This operation is not allowed.');
				} // END if
			} catch (e:Error) {
				trace(NAME+'::changePage -- An error occured adding the requested page ' + p + ', error = ' + e);
			} finally {
				return success;
			} // END try/catch/finally
		}
    }
}