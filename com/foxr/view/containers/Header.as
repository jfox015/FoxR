package com.foxr.view.containers
{
	import com.foxr.display.Page;
	import flash.events.Event;
	/**
	 * A view placed at the top section of the movie that displays the title of the movie.
	 * <p />
	 * The Header class can be directly styled via css by assigning a <b>header</b> 
	 * class in any loaded CSS file. 
	 * <p />
	 * This class can also be completely replaced by a custom header class within the 
	 * GlobalConfig.as file located in any local project's /flash/com/foxr/data folder.
	 * <p />
	 * This class does not have a dedicated Mediator class attached to it. It is manipulated and 
	 * mediated by the StageMediator class.
	 * 
	 * 
	 * @author		Jeff Fox
	 * @version		1.0
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Header extends Page 
	{
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/		
		/**
		 * Static name property
		 */
		public static const NAME:String = "Header";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Header instance.
		 */
		public function Header() { }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/		
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			height = 35;
			bkgd.applyProperties( { width:gpm.visualConfig.width, height:height, visible:true } );
			var title:String = gpm.copy.getCopyString('global.general.title');
			if (title != '') {
				txt.text = title;
				txt.visible = true;
				if (gpm.css.getTextFormat('header_text') != null) {
					txt.style = gpm.css.getTextFormat('header_text');
				}
				refresh();
			}
		} // END function
		
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Refreshes the objects layout based in the current height.
		 *	@since	1.0
		 */
		private function refresh():void {
			txt.x = _padding;
			txt.y = (bkgd.height / 2) - (txt.textHeight / 2);
		}
	}
	
}