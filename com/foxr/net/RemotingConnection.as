package com.foxr.net
{
	import com.foxr.event.RemotingEvent;
	
	import flash.events.Event;
	import flash.net.ObjectEncoding;
	import flash.net.NetConnection;
	
	/**
	 * Sets up an AMF connection with a remote server.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class RemotingConnection extends NetConnection {
		
		private var _errors:String = '';
		/*---------------------------------------
		/	CONSTUCTOR
		/--------------------------------------*/
		/**
		 * Constructs a new RemotingConnection instance.
		 * @param	url	The remote connection url
		 * @since	1.0
		 * 
		 */
		public function RemotingConnection(url:String) {
			objectEncoding = ObjectEncoding.AMF3;
			try {
				if (url != '') connect( url ); // END if
			} catch (e:Error) {
				_errors = e.toString();
				dispatchEvent(new RemotingEvent(RemotingEvent.REMOTING_CONNECTION_FAILURE));
			} // END try/catch
		}
		/**
		 * Returns any errors that occur during the remoting session.
		 * @return	List of errors.
		 * @since	1.0
		 * 
		 */
		public function get errors():String { return _errors; }
	}
}