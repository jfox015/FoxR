package com.foxr.model 
{
	import com.foxr.event.AudioEvent;
	import com.foxr.model.BaseProxy;
	import com.foxr.util.Utils;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * A proxy that loads, stores and plays back external sound files.
	 * 
	 * @author			Jeff Fox
	 * @version			1.0
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * 
	 */
	public class AudioProxy extends BaseProxy {
		
		/*--------------------------------
		/	VARIABLES
		/-------------------------------*/
		public static const NAME:String = 'AudioProxy';

		public static const SOUND_MP3:String = 'mp3';
		public static const SOUND_WAV:String = 'wav';
		public static const SOUND_RAW:String = 'raw';
		public static const SOUND_AIF:String = 'aif';
		public static const SOUND_AU:String = 'au';
		public static const SOUND_MID:String = 'mid';
		
		private var gpm:GlobalProxyManager = null;
		
		private var sounds:Object = null;
		private var _soundList:Array = null;
		private var _playChannel:SoundChannel = null;
		private var _currSound:String = '';
		private var _customPath:String = '';
		private var _soundPlaying:Boolean = false;
		private var _starPos:Number = 0;
		/*---------------------------------
		/	C'TOR
		/--------------------------------*/
		/**
		 * Creates a new LoginModel instance.
		 * @param	application		Tracking Application identifier
		 */
		public function AudioProxy() { 
			super(NAME, new Object());
			gpm = facade.retrieveProxy(GlobalProxyManager.NAME) as GlobalProxyManager;
			sounds = new Array();
			_playChannel = new SoundChannel();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 * Used to ammend the default media path with sub directories
		 * @param	cp	Custom path ammendment
		 * @return		Custom Path Value
		 * @since	1.0
		 * 
		 */
		public function get customPath():String { return _customPath; }
		public function set customPath(cp:String):void { _customPath = cp; }
		/**
		 * Used to adjust the volume of sound playback
		 * @param	v	Volume amount (0 - 1.0)
		 * @since	1.0
		 * 
		 */
		public function set volume(v:Number):void {
			var tmpSndTrandform:SoundTransform = new SoundTransform();
			tmpSndTrandform.volume = v;
			_playChannel.soundTransform = tmpSndTrandform;
		}
		/*---------------------------------
		/	PUBLIC FUNCTIONS
		/--------------------------------*/		
		/**
		 * Tests if a specific sound file has been loaded.
		 * @param 	id	The sound file id
		 * @return 		TRUE if loaded, FALSE if not
		 * @since	1.0
		 * 
		 */
		public function isSoundLoaded(id:String):Boolean {
			return (sounds[id] != null);
		}
		/**
		 * Tests if a specific sound file is currently being played.
		 * @param 	id	The sound file id
		 * @return 		TRUE if loaded, FALSE if not
		 * @since	1.0
		 * 
		 */
		public function isSoundPlaying(id:String):Boolean {
			return (_currSound == id && _soundPlaying);
		}
		/**
		 * Loads an array of sound files.
		 * @param 	soundList	Array of sound file paths
		 * @since	1.0
		 * 
		 */
		public function loadSounds(soundList:Array):void {
			if (soundList != null) {
				_soundList = soundList;
				loadSound();
			} // END if
		}
		/**
		 * Being splayback of a specific sound file.
		 * @param 	id			The id of the sound file to be played.
		 * @param	startTime	(OPTIONAL) Specificy a point in the sound file to being playback at if other than 0:00
		 * @param	loops		(OPTIONAL) How many times to loop the playback
		 * @since	1.0
		 * 
		 */
		public function playSound(id:String,startTime:Number = 0,loops:Number = 0):void {
			if (gpm.config.soundEnabled) {
				if (sounds[id] != null) {
					if (_soundPlaying) {
						_playChannel.stop();
					} // END if
					if (!_playChannel.hasEventListener(Event.SOUND_COMPLETE)) {
						_playChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					} // END if
					_playChannel = Sound(sounds[id]).play(startTime,loops);
					_currSound = id;
					_soundPlaying = true;
					sendNotification(AudioEvent.AUDIO_START);
				} // END if
			} // END if
		}
		/**
		 * Resets the internal playback volume to 100% (1.0).
		 * @since	1.0
		 * 
		 */
		public function pause():void {
			if (_soundPlaying) {
				_starPos = _playChannel.position;
				_playChannel.stop();			
			}
		}
		/**
		 * Resets the internal playback volume to 100% (1.0).
		 * @since	1.0
		 * 
		 */
		public function play():void {
			if (!_soundPlaying && _currSound != '') {
				playSound(_currSound,_starPos);
			}
		}
		/**
		 * Resets the internal playback volume to 100% (1.0).
		 * @since	1.0
		 * 
		 */
		public function resetVolume():void {
			volume = 1.0;
		}
		/**
		 * Instructs the proxy to stop playing a specific sound file (if it is currently playing).
		 * @param 	id			The id of the sound file to be stopped.
		 * @since	1.0
		 * 
		 */
		public function stopSound(id:String):void {
			if (_currSound == id) {
				_playChannel.stop();
				_soundPlaying = false;
				_currSound = '';
				sendNotification(AudioEvent.AUDIO_STOP);
			} // END if
		}
		/*---------------------------------
		/	PRIVATE FUNCTIONS
		/--------------------------------*/
		/**
		 * Called when a sound has finsihed playing.
		 * @param	e	Event response object
		 * @since	1.0
		 */
		private function loadSound():void {
			var tmpSound:Sound = new Sound();
			tmpSound.addEventListener(Event.COMPLETE, onSoundLoaded);
			tmpSound.load(new URLRequest(gpm.config.mediaPath + _customPath + _soundList[0]));
		}
		/**
		 * Called when a sound has finsihed playing.
		 * @param	e	Event response object
		 * @since	1.0
		 */
		private function onSoundComplete(e:Event):void {
			_playChannel.stop();
			_soundPlaying = false;
			sendNotification(AudioEvent.AUDIO_STOP);
		}
		/**
		 * Called when a sound has finsihed loading.
		 * @param	e	Event response object
		 * @since	1.0
		 */
		private function onSoundLoaded(e:Event):void {
			var tmpSound:Sound = Sound(e.currentTarget);
			tmpSound.removeEventListener(Event.COMPLETE, onSoundLoaded);
			var tmpTransform:SoundTransform = new SoundTransform();
			tmpTransform.volume = 0;
			_playChannel = new SoundChannel();
			var pathDelim:String = (Utils.checkOnlineStatus()) ? "/" : "\\";
			var id:String = tmpSound.url.substring(tmpSound.url.lastIndexOf(pathDelim) + 1).split(".")[0];
			sounds[id] = tmpSound;
			_playChannel = tmpSound.play();
			_playChannel.soundTransform = tmpTransform;
			_playChannel.stop();
			_playChannel.soundTransform = new SoundTransform(1);
			_soundList.shift()
			if (_soundList.length > 0)
				loadSound();
			else
				sendNotification(AudioEvent.AUDIO_LOADED);  // END if
		}
	}
}