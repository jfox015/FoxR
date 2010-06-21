package com.foxr.view.containers
{
	import com.foxr.display.Page;
	/**
	 * The Pages view is a container for all of the child <b>Page</b> objects that are 
	 * created and stored for display. Child Page objects are stacked in the order in which
	 * they are called and simple have their visibility turned on and off by default 
	 * when changing pages. 
	 * <p />
	 * The Pages class is mediated by the PageMediator class.
	 * <p />
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see 		com.foxr.view.mediators.PageMediator PageMediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class Pages extends Page 
	{
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/		
		/**
		 * Static name property
		 */
		public static const NAME:String = "Pages";
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Creates a new instance of Pages
		 */
		public function Pages() { }
		
	}
	
}