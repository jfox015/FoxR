package com.foxr.controller.commands
{
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import flash.system.Security;
	
    /**
	 * Applies extended security settings specified in the global config class 
	 * and passed in via the Notificztion object.
	 * <p />
	 * 
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class SecurityCommand extends SimpleCommand implements ICommand {
        /**
         * Initalizes global application security.
		 * @param	note 	INotification objerct
		 * 
         */
        override public function execute( note:INotification ) : void {
			var level:String = note.getBody().level as String;
			var settings:Array = note.getBody().settings as Array;
			try {
				switch (level) {
					case 'custom':
						if (settings != null && settings.length > 0) {
							for (var i:int = 0; i < settings.length; i++) {
								Security.allowDomain(settings[i]);
							} // END for
						} // END if
						break;
					case 'minimal':
					default:
						Security.allowDomain('localhost');
						Security.allowInsecureDomain('localhost');
						break;
				} // END switch
			} catch (e:Error) {
				trace('SecurityCommand::setSecurity -- Error occured during security setup. Error: ' + e);
			}// END try/catch
        }
    }
}