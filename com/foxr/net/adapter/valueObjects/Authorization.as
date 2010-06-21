package com.foxr.net.adapter.valueObjects 
{
	
	import com.foxr.net.IValueObject;
	
	public class Authorization extends BaseResponse {
		
		private var userName:String = '';
		private var userType:String = '';
		private var firstName:String = '';
		private var lastName:String = '';
		private var userStatus:String = '';
		private var sessionId:String = '';
		
		public function Authorization() { }
		
		public function getUserName():String { return userName; }
		public function setUserName(u:String):void { userName = u; }
		
		public function getUserType():String { return userType; }
		public function setUserType(u:String):void { userType = u; }
		
		public function getFirstName():String { return firstName; }
		public function setFirstName(f:String):void { firstName = f; }
		
		public function getLastName():String { return lastName; }
		public function setLastName(l:String):void { lastName = l; }
		
		public function getUserStatus():String { return userStatus; }
		public function setUserStatus(u:String):void { userStatus = u; }
		
		public function getSessionId():String { return sessionId; }
		public function setSessionId(s:String):void { sessionId = s; }
	}
}