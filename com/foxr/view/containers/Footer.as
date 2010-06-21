package com.foxr.view.containers
{
	import com.foxr.display.Page;
	import flash.events.Event;
	/**
	 * A view placed at the bottom of the movie that displays copyright information.
	 * <p />
	 * The Footer class can be directly styled via css by assigning a <b>footer</b> 
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
	public class Footer extends Page {
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property
		 */
		public static const NAME:String = "Footer";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new Footer instance.
		 */
		public function Footer() { }
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * 	Modified the height of the object and aligns the child text field.
		 *	@since	1.0
		 */
		public override function set height(h:Number):void {
			super.height = h;
			txt.y = (bkgd.height / 2) - (txt.textHeight / 2);
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/		
		/**
		 * 	Fires when the object is added to the stage.
		 *	@since	1.0
		 */
		public override function objReady(e:Event):void {
			bkgd.applyProperties( { width:width, height: height, visible:true } );
			var today:Date = new Date();
			var footerText:String = '';
			try {
				footerText = gpm.copy.getDynamicCopyString('global.general.legal.footer', { '{YEAR}':today.getFullYear(), '{PUBLISHER}':gpm.config.publisher } );
			} catch (e:Error) {
				gpm.log.error("An error occured when trying to retirve the footer copy string. Error: " + e);
			}
			if (footerText != '') {
				txt.text = footerText;
				if (gpm.css.getTextFormat('footer_text') != null) 
					txt.style = gpm.css.getTextFormat('footer_text');
				if (_alignment != ALIGN_LEFT) textAlign = _alignment;
				txt.y = (bkgd.height / 2) - (txt.textHeight / 2);
				txt.visible = true;
			}
		}
	}
	
}