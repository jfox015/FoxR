package com.foxr.view.mediators
{
	import com.foxr.model.GlobalProxyManager;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * Abstract base class for all visual mediators used to mediate view content within 
	 * the FoxR Visual Architecture.
	 * <p />
	 * This class provides a reference to the GlobalProxyManager for all child classes 
	 * as well as passed up registration of children via the PureMVC Mediator constructor.
	 * <p />
	 * 
	 * @author 		Jeff Fox
	 * @version		2.01
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class BaseMediator extends Mediator implements IMediator	{
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static name property 
		 * @var 	NAME:String 
		 */
		public static var NAME:String = 'BaseMediator';
		/**
		 * Reference to the GlobalProxyManager object. 
		 * @var 	gpm:GlobalProxyManager
		 */
		protected var gpm:GlobalProxyManager = null;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new instance of BaseMediator by chacking for a passed name argument 
		 * and then registering itself with the Global View class by means of the super()
		 * constructor inherited from Mediator.
		 * 
		 * @since	1.0
		 * @param	mediatorName	The name of the mediator to be registered
		 * @param	viewComponent	The associated view object
		 * @see 	org.puremvc.as3.patterns.mediator.Mediator
		 * @see 	com.foxr.model.GlobalProxyManager
		 */
		public function BaseMediator(mediatorName:String,viewComponent:Object) {
			var thisName:String = mediatorName != null ? mediatorName : NAME;
			super(thisName, viewComponent);
			gpm = Facade.getInstance().retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
		}
	}
	
}