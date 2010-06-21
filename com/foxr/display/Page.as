package com.foxr.display 
{
	//import external classes
	import com.foxr.display.CompoundElement;
	import caurina.transitions.*;
	
	import flash.events.*;
	
	/**
	 * Abstract parent class for all child Page objects.
	 * <p />
	 * A page is essentially a container that collects visial display
	 * objects much the same way that an HTML page display content on Web sites. 
	 * It has prebuilt functions to allow for simple transitions between 
	 * pages to be defined and for direct targeting of pages in the application 
	 * via deep linking.
	 * <p />
	 * Pages can be styled like any other CompoundElement child.
	 * 
	 * @author	Jeff Fox
	 * @version	1.9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 * 
	 * @see 	com.foxr.display.CompoundElement CompoundElement
	 * @see 	com.foxr.view.mediators.PageMediator PageMediator
	 *
	 */
	public class Page extends CompoundElement {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Fade Time
		 * @var	_fadeTime	Number
		 */
		public static var _fadeTime:Number = 0;
		/*-------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Page instance.
		 *
		 */
		public function Page() {
			super();
        } // END function
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Sets the time (in seconds) to fade this object in or out. Set to 
		 * 0 for instant switching.
		 * @since	1.0
		 * @param	ft	Time (in seconds) to fade the object
		 * @return		Time (in seconds) to fade the object
		 *
		 */
		public function get fadeTime():Number { return _fadeTime; }	
		public function set fadeTime(ft:Number):void { _fadeTime = ft; }		
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/	
		/**
		 * Page startup function. Override in child pages for custom startup functionality.
		 * @since	1.0
		 *
		 */
		public function init():void { }
		/**
		 * Turns the current items visibility on. Overrides default show from Element.
		 * @since	1.0
		 * @see 	com.foxr.display.Element Element
		 *
		 */
		public override function show():void {
			this.setOverflow();
			this.visible = true;
			Tweener.addTween(this, { alpha:1 , time:_fadeTime , delay:0 , onComplete:function():void { onChangeState('show'); } } );
		} // END function
		/**
		 * Turns the current items visibility off. Overrides default hide from Element.
		 * @since	1.0
		 * @see 	com.foxr.display.Element Element
		 *
		 */
		public override function hide():void {
			Tweener.addTween(this, { alpha:0 , time:_fadeTime , delay:0 , onComplete:function():void { onChangeState('hide'); } } );
		} // END function		
		/**
		 * Subset of the <b>PageMediator.changePage()</b> method that allows 
		 * Page objects to directly load child pages.
		 * <p />
		 * The list of pages available to be switched is defined in the GlobalConfig file
		 * under pageList.
		 * @since	1.0
		 * @param	type	show or hide
		 * @see 	com.foxr.view.mediators.PageMediator#changePage() PageMediator.changePage()
		 *
		 */
		public function showChildPage(p:String,target:String=''):void {
			var c:Class = gpm.visualConfig.pageList[p];
			if (c != null) {
				var page:Page = null;
				if (this.getChildByName(p) == null)
					page = Page (addElement(p,c,{alpha:0,visible:false,fadeTime:gpm.visualConfig.pageFadeTime}));
				else
					page = Page(getChildByName(p)); // END if
				
				for (var pname:String in  gpm.visualConfig.pageList) {
					if (pname != p && getChildByName(pname) != null) {
						var tmpPage:Page = Page(getChildByName(pname));
						if (tmpPage.visible) tmpPage.hide(); // END if
					}  // END if
				} // END for
				if (target != '') page.showChildPage(target); // END if
				page.show();
				// SEND CHANGE PAGE EVENT TO ANALYTICS IF ENAABLED
				if (gpm.config.analytics) 
					gpm.analytics.trackClick(p);
			} else {
				// Backstage object passed so throw an error
				gpm.log.error(this.name + ', showChildPage -- Class ' + c.toString() + ' could not be loaded.'); // END if
			} // END if
		}
		/**
		 * Handler for completion of show method
		 * @since	1.0
		 * @param	type	show or hide
		 *
		 */
		public function onChangeState(type:String):void {
			if (type == 'hide') this.visible = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * Executed once they have been added to the movie stage.
		 * @since	1.0
		 * @param	e	Event response object
		 *
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
		}
	} // END class
} // END package