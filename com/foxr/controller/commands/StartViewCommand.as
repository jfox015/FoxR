package com.foxr.controller.commands
{
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import com.foxr.controller.Application;
	
    /**
	 * Tells the StageMediator to display the stage.
	 * <p />
	 * 
	 * @see 			com.foxr.view.mediators.StageMediator StageMediator
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class StartViewCommand extends SimpleCommand implements ICommand {
        /**
         * Initialize Stage Mediator via the Application.STAGE_ADD_SPRITE
		 * notification.
		 * @param	note 	INotification objerct
		 * 
         */
        override public function execute( note:INotification ) : void {
			sendNotification( Application.STAGE_ADD_SPRITE );
        }
    }
}