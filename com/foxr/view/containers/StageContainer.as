package com.foxr.view.containers
{
	import com.foxr.display.Element;
	/**
	 * The StageContainer is a top level container for the individual container "views" of 
	 * the FoxR Visual Architecutre. This class sits directly on the stage and stores the 
	 * individual visual containers as it's direct children.
	 * <p />
	 * This class is mediated by the StageMediator class. 
	 * <p />
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 * @see 		com.foxr.view.mediators.PageMediator StageMediator
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class StageContainer extends Element 
	{
		/**
		 * Static name property
		 */
		public static const NAME:String = "StageContainer";
		/**
		 * Creates a new instance of StageContainer
		 */
		public function StageContainer() { }
	}
	
}