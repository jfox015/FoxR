package com.foxr.controller.commands
{
	import com.foxr.model.GlobalProxyManager;

    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    /**
	 * Instantiates and initalizes the GlobalProxyManager. The command passes
	 * FlashVars information via the Note object.
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
	public class GPMInitCommand extends SimpleCommand implements ICommand {
        /**
         * Registers the GlobalProxyManager.
		 * @param	note 	INotification objerct
		 * 
         */
        override public function execute( note:INotification ) : void {
			facade.registerProxy(new GlobalProxyManager(null, note.getBody()));
        }
    }
}