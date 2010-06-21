package com.foxr.view.containers
{
	import com.foxr.display.Element;
	/**
	 * The Global Nav class serves as a container to stored an disoplay global navigation
	 * items such as links, menus and more.
	 * <p />
	 * This class sits as the second topmost level, just beneath the Messagin Container class 
	 * in the FoxR Visual Architecture.
	 * <p />
	 * This class is mediated by the NavigationMediator class. This class is not available 
	 * to be overridden by a custom class.
	 * 
	 * @author		Jeff Fox
	 * @version		1.0
	 * @see 		com.foxr.view.mediators.NavigationMediator NavigationMediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class GlobalNav extends Element 
	{
		public static const NAME:String = "GlobalNav";
		
		public function GlobalNav() { }
		
	}
}