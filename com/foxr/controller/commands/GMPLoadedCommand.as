package com.foxr.controller.commands
{
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.foxr.controller.Application;
	/**
	 * Executed when the GPM completes loading it's child proxy objects. This 
	 * command sends a notification for the main view to begin rendering.
	 * <p />
	 * 
	 * @see 			com.foxr.model.GlobalProxyManager GlobalProxyManager
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class GMPLoadedCommand extends SimpleCommand implements ICommand {
        /**
         * Calls the Application startView function to kick off the 
		 * setup of the visual architecture.
		 * @param	note 	INotification objerct
		 * 
         */
        override public function execute( note:INotification ) : void {
	    	sendNotification(Application.START_VIEW);
        }
    }
}