package com.foxr.view.containers
{
	import com.foxr.display.Page;
	/**
	 * The Background view is the bottom most view containter in the FoxR Visual Architecture. 
	 * It is at the bottom of the visual hirearchy and sits on level above the the Stage 
	 * Container.
	 * <p />
	 * The Background class can be directly styled via css by assigning a <b>background</b> 
	 * class in any loaded CSS file. 
	 * <p />
	 * This class can also be completely replaced by a custom background class within the 
	 * GlobalConfig.as file located in any local project's /flash/com/foxr/data folder.
	 * <p />
	 * This class does not have a dedicated Mediator class attached to it. It is manipulated and 
	 * mediated by the StageMediator class.
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see 		com.foxr.view.mediators.StageMediator StageMediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Background extends Page 
	{
		/**
		 * Static name property
		 */
		public static const NAME:String = "Background";
		/**
		 * Creates a new instance of Background
		 */
		public function Background() { }
		
	}
	
}