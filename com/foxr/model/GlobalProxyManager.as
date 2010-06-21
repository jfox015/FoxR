package com.foxr.model
{
	import com.foxr.controller.Application;
	import com.foxr.data.GlobalConstants;
	import com.foxr.factory.LogFactory;
	import com.foxr.model.*;
	import com.foxr.util.log.ILog;
	import com.foxr.util.Utils;
	
	import flash.events.Event;
	/**
	 * The GlobalProxyManager is a "Super Proxy" class that loads and stores static 
	 * references to the major proxy amd utility objects loaded and used within the framework. 
	 * <P />
	 * These proxy (and utility) objects include:
	 * <ul>
	 * 	<li>AnalyticsProxy</li>
	 * 	<li>ConfigProxy</li>
	 * 	<li>CopyProxy</li>
	 * 	<li>Log</li>
	 * 	<li>CSSProxy</li>
	 * 	<li>VisualConfigProxy</li>
	 * </ul>
	 * <p />
	 * @author 		Jeff Fox
	 * @version		1.8
	 * @see			com.foxr.controller.commands.GPMInitCommand GPMInitCommand
	 * @see			com.foxr.controller.commands.GMPLoadedCommand GMPLoadedCommand
	 * @see			com.foxr.model.AnalyticsProxy AnalyticsProxy
	 * @see			com.foxr.model.ConfigProxy ConfigProxy
	 * @see			com.foxr.model.CopyProxy CopyProxy
	 * @see			com.foxr.model.com.foxr.util.log Log
	 * @see			com.foxr.model.CSSProxy CSSProxy
	 * @see			com.foxr.model.VisualConfigProxy VisualConfigProxy
	 * @see			org.puremvc.as3.core.Model Model
	 */
	public class GlobalProxyManager extends BaseProxy {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		/**
		 * Static Name property
		 */
		public static var NAME:String = 'GlobalProxyManager';
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new GlobalProxyManager instance.
		 *
		 */
		public function GlobalProxyManager(tmpName:String=null,data:Object=null) { 
			super(NAME, data);
			data['initData'] = data;
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Returns an instance of the AnalyticsProxy.
		 * @param	a	AnalyticsProxy Object
		 * @return		AnalyticsProxy Instance
		 */
		public function get analytics():AnalyticsProxy { 
			return data[AnalyticsProxy.NAME] as AnalyticsProxy;
		}
		/**
		 * Returns an instance of the ConfigProxy.
		 * @param	cfg	ConfigProxy Object
		 * @return		ConfigProxy Instance
		 */
		public function get config():ConfigProxy { 
			return data[ConfigProxy.NAME] as ConfigProxy;
		}
		/**
		 * Returns an instance of the CopyProxy.
		 * @param	x	CopyProxy Object
		 * @return		CopyProxy Instance
		 */
		public function get copy():CopyProxy { 
			return data[CopyProxy.NAME] as CopyProxy;
		}
		/**
		 * External logging application instance. Flash trace used as output if no external 
		 * logging application is specified.
		 * @param	l	Log object
		 * @return		Log object intance
		 */
		public function get log():ILog { return data['log'] as ILog; }
		/**
		 * Returns an instance of the CSSProxy.
		 * @param	css	CSSProxy Object
		 * @return		CSSProxy Instance
		 */
		public function get css():CSSProxy { 
			return data[CSSProxy.NAME] as CSSProxy;
		}
		/**
		 * Returns an instance of the VisualConfigProxy.
		 * @param	vc	VisualConfigProxy Object
		 * @return		VisualConfigProxy Instance
		 */
		public function get visualConfig():VisualConfigProxy { 
			return data[VisualConfigProxy.NAME] as VisualConfigProxy; 
		}
		/*---------------------------------------
		/	PUBLIC FUNCTIONS
		/--------------------------------------*/
		/**
		 * Fired once the class hae been registered by the global Model class.
		 * @param	responseObj	Data Response Object
		 * @since	2.0
		 * @see 	org.puremvc.as3.core.Model#registerProxy() Model.registerProxy()
		 */
		public override function onRegister():void {
			init();
		}
		/**
		 * Fired when the external localCngig.xml file has been loaded. This method then performs 
		 * the initaliation routines for all the enabled child proxies.
		 * @param	responseObj	Data Response Object
		 * @since	2.0
		 */
		public override function handleDataResponse(responseObj:Object):void {
		
			// ---------------------------
			//	CONFIG XML
			// ----------------------------
			// MERGE LOCAL CONFIG XML DATA WITH GLOBAL DATA
			// THIS EFFECTIVELY OVERRITES THE SETTINGS IN THE GLOBAL 
			// CONFIG WITH MORE LOCAL VALUES
			var cfgData:Object = responseObj.localcfg.config;
			for (var cprop:String in cfgData) {
				data['initData'].config[cprop] = cfgData[cprop];
			} // END for
			var vcfgData:Object = responseObj.localcfg.visualConfig;
			for (var vprop:String in vcfgData) {
				data['initData'].visConfig[cprop] = vcfgData[cprop];
			} // END for
			// ---------------------------
			//	FLASH VARS
			// ----------------------------
			// MERGE FLASH VARS CONFIG DATA WITH GLOBAL DATA
			// THIS EFFECTIVELY OVERRITES THE SETTINGS IN THE GLOBAL 
			// CONFIG AND THE LOCAL LOCAL XML WITH THE RUN TIME FlashVars VALUES.
			
			// EDIT 1/15/10 -- JF
			// Added support for config and visual congif objects in Flash vars. All
			// non specified flash vars now default to config.
			var lfi:Object = data['initData'].loaderInfo;
			if (lfi != null) {
				if (lfi['config'] != null)
					parseFlashVars(lfi['config'], 'config', log);
				else if (lfi['visConfig'] != null)
					parseFlashVars(lfi['visConfig'], 'visConfig', log);
				else
					parseFlashVars(lfi, 'config', log); // END if
			} // END if
			
			// -------------------------------------
			//	CONFIG AND VISCONFIG PROXIES
			// -------------------------------------
			// SET UP THE CONFIG PROXY AND APPLY THE DATA
			var cfg:ConfigProxy = new ConfigProxy();
			cfg.setData(data['initData'].config);
			data[cfg.getProxyName()] = cfg;
			
			// SET UP THE VISUAL CONFIG PROXY AND APPLY THE DATA
			var vcfg:VisualConfigProxy = new VisualConfigProxy();
			vcfg.setData(data['initData'].visConfig);
			data[vcfg.getProxyName()] = vcfg;
			
			// -------------------------------------
			//	Logging
			// -------------------------------------
			// Create logger support
			var logger:String = GlobalConstants.LOG_DEFAULT;
			if (cfg.externalLogging) { logger = cfg.loggerType; }
			data['log'] = LogFactory.getInstance().getLoggerbyName(logger);
			
			// -------------------------------------
			//	COPY AND CSS PROXIES
			// -------------------------------------
			// SET UP THE CSSPROXY AND LOAD THE CSS DATA
			var css:CSSProxy = new CSSProxy();
			var cssPath:String = '';
			if (cfg.multilingual)
				cssPath = cfg.localeCssPath;
			else
				cssPath = cfg.mediaPath + cfg.cssPath;
			css.cssLoadPath = cssPath;
			css.getExternalCSS(cfg.stylesheets);
			data[css.getProxyName()] = css;
			
			// SET UP THE COPYROXY AND LOAD THE COPY DATA
			var copy:CopyProxy = new CopyProxy();
			if (cfg.copyXML.length > 0) {
				var copyPath:String = cfg.xmlPath;
				var fontsPath:String = cfg.mediaPath;
				if (cfg.multilingual) {
					copyPath = cfg.localeXmlPath;
					fontsPath = cfg.localeMediaPath;
				}
				copy.init(cfg.copyXML, copyPath, cfg.fonts, fontsPath);	
			} // END if
			data[copy.getProxyName()] = copy;
			
			// -------------------------------------
			//	ANALYTICS
			// -------------------------------------
			// IF ANALYTICS IS ENABLEDm, SET UP THE ANALYTICS PROXY \
			// AND INITALIZE IT
			if (cfg.analytics) {
				var analytics:AnalyticsProxy = new AnalyticsProxy();
				if (cfg.analyticsApplication != null)
					analytics.trackingApplication = cfg.analyticsApplication;
				analytics.setData(cfg.analyticsConfig);
				data[analytics.getProxyName()] = analytics;
			} // END if
			
			// -------------------------------------
			//	LOADING COMPLETE
			// -------------------------------------
			// Broadbast notifications that gpm setup is complete
			sendNotification(Application.SECURITY_INIT, {level:cfg.securityLevel,settings:cfg.securityAllowances});
			sendNotification(Application.PROXY_LOADED);
			// Clean the initdata property to free up some memory
			data['initData'] = null;
		}
		/*---------------------------------------
		/	PRIVATE FUNCTIONS
		/--------------------------------------*/
		private function parseFlashVars(o:Object, dest:String,log:ILog = null):void {
			for (var vfvProp:String in o) {
				var strVal:String = String(o[vfvProp]);
				if (dest == "config" && vfvProp == 'url')
					vfvProp = 'movieUrl';
				data['initData'][dest][vfvProp] = strVal;
			}
		}
		private function init():void {
			requestData(data['initData'].config['xmlPath'] + 'localcfg.xml', 'config', GlobalConstants.ADAPTER_XML, this);
		}
	}
}