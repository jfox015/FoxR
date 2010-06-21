package com.foxr.model 
{
	import com.foxr.data.GlobalConstants;
	import com.foxr.model.GlobalProxyManager;
	import com.foxr.factory.AnalyticsFactory;
	import com.foxr.util.Utils;
	import com.foxr.util.StringUtils;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	/**
	 * This proxy extension provides an interface to working with external analytics 
	 * applications for perfiorming click tracking analysis of the application.
	 * <p />
	 * @author			Jeff Fox
	 * @version			1.1
	 * 
	 */
	public class AnalyticsProxy extends BaseProxy {
		
		/*--------------------------------
		/	VARIABLES
		/-------------------------------*/
		public static var NAME:String = 'AnalyticsProxy';
		/**
		 * Tracking Application
		 * @var	tracker:*
		 */
		private var tracker:* = null;
		/*---------------------------------
		/	C'TOR
		/--------------------------------*/
		/**
		 * Creates a new AnalyticsProxy instance.
		 */
		public function AnalyticsProxy() { 
			super(NAME, new Object());
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Applies tracking data to the proxy.
		 * @param	configData	Data object.
		 * @since	1.0
		 * @see		com.foxr.data.GlobalConfig
		 */
		public override function setData(configData:Object):void { 
			if (tracker != null) {
				try {
					for (var cfgItem:String in configData) {
						tracker[cfgItem] = configData[cfgItem];
					} // END for
				} catch (e:Error) {
					trace("Error occured in tracker property applications. Error: " + e);
				} //END try/catch
			} else {
				data = configData; 
			} // END if
		}
		/**
		 * Applies a tracking application inatance to the proxy.
		 * @param	trackApp	Tracking Application Class.
		 * @since	1.0
		 */
		public function set trackingApplication(trackApp:Class):void { 
			tracker = AnalyticsFactory.getTrackingApplication(tracker);
		}
		/*---------------------------------
		/	PUBLIC FUNCTIONS
		/--------------------------------*/
		/**
		 * Tracks a click event
		 * @param	page	A page name identifier
		 * @since	1.0
		 */
		public function trackClick(page:String):void {
			var gpm:GlobalProxyManager = facade.retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			var analyticsPage:String = data.trackingURL != null ? data.trackingURL : GlobalConstants.DEFAULT_TRACKING_STRING;
			if (analyticsPage != "") {
				if (tracker == null) {
					// ASSUME EXTERNAL TRACKING SCRIPT
					var trackStr:String = "javascript:"+StringUtils.replace(analyticsPage, '[TRACK_ID]', data.pathIds[page])+";"
					if (Utils.checkOnlineStatus() && ExternalInterface.available) {
						try {
							ExternalInterface.call(trackStr);
						} catch (e:Error) {
							gpm.log.error("Error occured sending external tracking string, error = " + e);
						} // END try/catch
					} else {
						gpm.log.debug("Analytics Event: " + trackStr);
					} // END if
				} else {
					// TODO: Add support for tracking app classes
					// These will most likely require driver classes to be set-up
					// per application supported.
				} // END if
			} // END if
		}
	}
}