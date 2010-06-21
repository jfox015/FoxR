package com.foxr.model
{
	//import external classes
	import com.foxr.net.IDataRequester;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	//import com.foxr.data.GlobalDataManager
	import com.foxr.controller.Application;
	import com.foxr.data.GlobalConstants;
	import com.foxr.net.adapter.Adapter;
	import com.foxr.model.BaseProxy;
	import com.foxr.util.Locale;
	import com.foxr.util.Utils;
	import com.foxr.util.XMLObjectOutput;
	import com.foxr.net.XMLLoader;
	
	import flash.events.Event;
	import flash.system.Capabilities;
	/**
	 * This proxy is responsible for collecting and providing access to the basic 
	 * application level configuration propertties and thei associated values. These 
	 * values can be set either in the global level (GlobalConfig), 
	 * the run time file level (xml/localConfig.xml) or client side run time via 
	 * FlashVars.
	 * <p />
	 * Each successive step overides the previous level meaning that values set in 
	 * localConfig.xml override values set in GlobalConfig.as and values set via 
	 * FlashVars override both localConfig.xml and GlobalConfig.as.
	 * 
	 * @author			Jeff Fox
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @version			1.0.6
	 * 
	 */
	public class ConfigProxy extends BaseProxy {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static var NAME:String = 'ConfigProxy';
		
		private var _movieName:String = '';
		private var _movieCodeName:String = '';
		private var _movieUrl:String = '';
		private var _publisher:String = '';
		private var _copyright:String = '';
		private var _authors:Array = null;
		private var _playerVersion:Number = 0;
		private var _majorVersion:Number = 0;
		private var _minorVersion:Number = 0;
		private var _buildVersion:Number = 0;
		private var _locale:Locale = null;
		private var _eclipseDev:Boolean = false;
		private var _analytics:Boolean = false;
		private var _analyticsApplication:Class = null;
		private var _analyticsConfig:Object = null;
		private var _externalLogging:Boolean = false;
		private var _loggerType:String = '';
		private var _customDashboard:Class = null;
		private var _securityLevel:String = '';
		private var _securityAllowances:Array = null;
		private var _debugLevel:String = '';
		private var _multilingual:Boolean = false;
		private var _mediaPath:String = '';
		private var _localeMediaPath:String = '';
		private var _xmlPath:String = '';
		private var _localeXmlPath:String = '';
		private var _cssPath:String = '';
		private var _localeCssPath:String = '';
		private var _stylesheets:Array = null;
		private var _fonts:Array = null;
		private var _defaultFont:String = '';
		private var _copyXML:Array = null;
		private var _serverPath:String = '';
		private var _baseURL:String = '';
		private var _gatewayURL:String = '';
		private var _adapterType:String = '';
		private var _authorizeUsers:Boolean = false;
		private var _authorizeAction:String = '';
		private var _authorizeRequestHandler:String = '';
		private var _authorizeResponseHandler:String = '';
		private var _flashVars:Object = null;
		private var _soundEnabled:Boolean = true;
		private var _activeCSS:Boolean = true;
		private var _recursiveRendering:Boolean = false;
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ConfigProxy instance.
		 *
		 */
		public function ConfigProxy() { 
			super(NAME);
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public function get movieName():String { return _movieName; }
		public function set movieName(m:String):void { _movieName = m; }
		
		public function get movieCodeName():String { return _movieCodeName; }
		public function set movieCodeName(n:String):void { _movieCodeName = n; }
		
		public function get movieUrl():String { return _movieUrl; }
		public function set movieUrl(u:String):void { _movieUrl = u; }
		
		public function get publisher():String { return _publisher; }
		public function set publisher(p:String):void { _publisher = p; }
		
		public function get copyright():String { return _copyright; }
		public function set copyright(c:String):void { _copyright = c; }
		
		public function get authors():Array { return _authors; }
		public function set authors(a:Array):void { _authors = a; }

		public function get playerVersion():Number { return _playerVersion; }
		public function set playerVersion(v:Number):void { _playerVersion = v; }

		public function get majorVersion():Number { return _majorVersion; }
		public function set majorVersion(v:Number):void { _majorVersion = v; }

		public function get minorVersion():Number { return _minorVersion; }
		public function set minorVersion(v:Number):void { _minorVersion = v; }

		public function get buildVersion():Number { return _buildVersion; }
		public function set buildVersion(v:Number):void { _buildVersion = v; }

		public function get locale():Locale { return _locale; }
		public function set locale(l:Locale):void { _locale = l; }

		public function get eclipseDev():Boolean { return _eclipseDev; }
		public function set eclipseDev(d:Boolean):void { _eclipseDev = d; }

		public function get analytics():Boolean { return _analytics; }
		public function set analytics(a:Boolean):void { _analytics = a; }

		public function get analyticsApplication():Class { return _analyticsApplication; }
		public function set analyticsApplication(a:Class):void { _analyticsApplication = a; }

		public function get analyticsConfig():Object { return _analyticsConfig; }
		public function set analyticsConfig(c:Object):void { _analyticsConfig = c; }
		
		public function get externalLogging():Boolean { return _externalLogging; }
		public function set externalLogging(l:Boolean):void { _externalLogging = l; }

		public function get loggerType():String { return _loggerType; }
		public function set loggerType(t:String):void { _loggerType = t; }

		public function get customDashboard():Class { return _customDashboard; }
		public function set customDashboard(d:Class):void { _customDashboard = d; }

		public function get securityLevel():String { return _securityLevel; }
		public function set securityLevel(l:String):void { _securityLevel = l; }
		
		public function get securityAllowances():Array { return _securityAllowances; }
		public function set securityAllowances(a:Array):void { _securityAllowances = a; }

		public function get debugLevel():String { return _debugLevel; }
		public function set debugLevel(l:String):void { _debugLevel = l; }

		public function get multilingual():Boolean { return _multilingual; }
		public function set multilingual(t:Boolean):void { _multilingual = t; }

		public function get mediaPath():String { return _mediaPath; }
		public function set mediaPath(p:String):void { _mediaPath = p; }

		public function get localeMediaPath():String { return _localeMediaPath; }
		public function set localeMediaPath(p:String):void { _localeMediaPath = p; }
		
		public function get xmlPath():String { return  _xmlPath; }
		public function set xmlPath(p:String):void { _xmlPath = p; }
		
		public function get localeXmlPath():String { return  _localeXmlPath; }
		public function set localeXmlPath(p:String):void { _localeXmlPath = p; }
		
		public function get cssPath():String { return  _cssPath; }
		public function set cssPath(p:String):void { _cssPath = p; }
		
		public function get localeCssPath():String { return  _localeCssPath; }
		public function set localeCssPath(p:String):void { _localeCssPath = p; }
		
		public function get stylesheets():Array { return _stylesheets; }
		public function set stylesheets(s:Array):void { _stylesheets = s; }

		public function get fonts():Array { return _fonts; }
		public function set fonts(f:Array):void { _fonts = f; }
		
		public function get defaultFont():String { return _defaultFont; }
		public function set defaultFont(f:String):void { _defaultFont = f; }

		public function get copyXML():Array { return _copyXML; }
		public function set copyXML(x:Array):void { _copyXML = x; }		

		public function get serverPath():String { return _serverPath; }
		public function set serverPath(p:String):void { _serverPath = p; }
		
		public function get adapterType():String { return _adapterType; }
		public function set adapterType(t:String):void { _adapterType = t; }

		public function get baseURL():String { return _baseURL; }
		public function set baseURL(u:String):void { _baseURL = u; }
		
		public function get gatewayURL():String { return _gatewayURL; }
		public function set gatewayURL(u:String):void { _gatewayURL = u; }
		
		public function get authorizeUsers():Boolean { return _authorizeUsers; }
		public function set authorizeUsers(a:Boolean):void { _authorizeUsers = a; }
		
		public function get authorizeAction():String { return _authorizeAction; }
		public function set authorizeAction(a:String):void { _authorizeAction = a; }
		
		public function get authorizeRequestHandler():String { return _authorizeRequestHandler; }
		public function set authorizeRequestHandler(h:String):void { _authorizeRequestHandler = h; }
		
		public function get authorizeResponseHandler():String { return _authorizeResponseHandler; }
		public function set authorizeResponseHandler(h:String):void { _authorizeResponseHandler = h; }
		/**
		 * Defines whether Element sub classes should automatically search for CSS classes matching 
		 * the instance name of the object.
		 * @param	e	TRUE OR FALSE
		 * @return	TRUE OR FALSE
		 */
		public function get activeCSS():Boolean { return _activeCSS; }
		public function set activeCSS(a:Boolean):void { _activeCSS = a; }
		/**
		 * Defines whether Element sub classes should call render() in this child classes when
		 * it is called in the parent.
		 * @param	e	TRUE OR FALSE
		 * @return	TRUE OR FALSE
		 */
		public function get recursiveRendering():Boolean { return _recursiveRendering; }
		public function set recursiveRendering(r:Boolean):void { _recursiveRendering = r; }
		
		/**
		 * The FlashVars property is a catch-all object that stores any properties 
		 * assigned to the config proxy that are not an explicit existing property. 
		 * The properties assigned to this object can be determined at any time via 
		 * the listFlashVars() command.
		 * 
		 * @param	v	Data Object
		 * @return	FlashVars object with associated properties.
		 */
		public function get flashVars():Object { return _flashVars; }
		public function set flashVars(v:Object):void { _flashVars = v; }
		/**
		 * Defines whether the sound is enabled within the application.
		 * 
		 * @param	e	TRUE OR FALSE
		 * @return	TRUE OR FALSE
		 */
		public function get soundEnabled():Boolean { return _soundEnabled; }
		public function set soundEnabled(e:Boolean):void { _soundEnabled = e; }
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Return the major, minor and build version of the program from the movie_cfg file.
		 * @since	1.9
		 */
		public function get applicationVersion():String {
			return majorVersion + "." + minorVersion + "." + buildVersion;
		}
		/**
		 * 	Returns an array of environment based values for child objects to use. 
		 * 	Values retuened and their keys are:
		 *	<ul>
		 *		<li><b>protocol</b> - the URL protocol (http://, file:|///, or other</li>
		 *		<li><b>domain</b> - the fully qualified domain (www.aeoliandhotels.com, localhost, other)</li>
		 *		<li><b>locale</b> - </li>
		 *	</ul>
		 * 	@since	1.0
		 *	@param	g	Array of Global properties
		 *
		 */
		public function get enviromentValues():Array {
			var protocol:String = (movieUrl.substring(0, 4) == 'http') ? movieUrl.split('/')[0] + '//' : 'http://';
			var domain:String = (movieUrl.substring(0, 4) == 'http') ? movieUrl.split('/')[2] : 'localhost'; 
			var env:Array = [{protocol:protocol,domain:domain,locale:locale}];
			return env;
		} // END function
		/**
		 * Applies a set of key/value pairs to the built in properties of the class.
		 * <p />
		 * Any values that do not match preexisting properties of this class are consequently 
		 * dumped into the FlashVars catchall property.
		 * <p />
		 * @param	data	Key/Value pair object of properties.
		 * @since	1.0
		 */
		public override function setData(data:Object):void {
			if (_flashVars == null) _flashVars = new Object();
			for (var item:String in data) {
				var theItem:* = data[item] != null ? data[item] : null;
				if (item == 'stylesheets' || item == 'copyXML' || item == 'fonts') {
					this[item] = Utils.toArray(theItem['file']);
				} else {
					if (item != 'defaultLocale') {
						if (theItem != null) {
							try {
								if (typeof(theItem) == "object" && theItem.value)
									this[item] = theItem.value; 
								else 
									this[item] = theItem // END if
							} catch (e:Error) {
								// NOT A RECOGNIZED VALUE, SO CAPTURE IT TO FLASH VARS
								if (typeof(theItem) == "object" && theItem.value)
									_flashVars[item] = theItem.value; 
								else 
									_flashVars[item] = theItem // END if
							} // END try/catach
						} else {
							try {
								this[item] = null;
							} catch (e:Error) {
								_flashVars[item] = null;
							}
						} // END if
					} // END if
				} // END if
				/*  
				/	EDIT 1.0.5
				/	Added ability to define zttributes for nodes and assign them either to 
				/	existing Config atrtributes of FlashVars catch-all
				*/
				if (!theItem is String && theItem.attributes) {
					for (var attr:String in theItem.attributes) {
						try {
							this[attr] = theItem.attributes[attr];
						} catch (e:Error) {
							_flashVars[attr] = theItem.attributes[attr];
						} // END try/catch
					} // END if
				} // END for
			} // END for
			
			// Set-up Locale
			var language:String = (data.language != undefined) ? data.language : data.defaultLocale.language;
			var country:String = (data.country != undefined) ? data.country : data.defaultLocale.country;
			locale = new Locale(language, country);
			
			// Set locale specific path support
			if (_multilingual) {
				localeMediaPath = mediaPath + locale.toString() + "/";
				localeXmlPath = xmlPath + locale.toString() + "/";
				localeCssPath = mediaPath + locale.toString() + "/" + cssPath;
			} else {
				localeMediaPath = mediaPath;
				localeXmlPath = xmlPath;
				localeCssPath = mediaPath + cssPath;
			} // END if
			
			// Determine of the player is in a browser (Plugin) or IDE (External)
			var localPlayer:Boolean = (Capabilities.playerType == 'Plugin' || Capabilities.playerType == 'External');
			
			// Eclipse Development Override
			// This is because Eclipse launches the app in a browser, although the movie should act as 
			// though it is playing back in the IDE
			if (data.eclipseDev != undefined) localPlayer = eclipseDev; // END if
		}
	}
}