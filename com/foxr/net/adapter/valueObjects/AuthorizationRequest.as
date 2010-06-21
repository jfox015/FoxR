package com.foxr.net.adapter.valueObjects 
{
	
	import com.foxr.net.IValueObject;
	import com.foxr.net.adapter.valueObjects.BaseRequest;

	public class AuthorizationRequest extends BaseRequest {
		
		private var userName:String = '';
		private var password:String = '';
		private var securityLevel:String = '';
	
		public function AuthorizationRequest() { }
		
		public function getUserName():String { return userName; }
		public function setUserName(u:String):void { userName = u; }
		
		public function getPassword():String { return password; }
		public function setPassword(p:String):void { password = p; }
		
		public function getSecurityLevel():String { return securityLevel; }
		public function setSecurityLevel(s:String):void { securityLevel = s; }
		
	}
	
}