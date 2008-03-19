package data {
	import flash.utils.getQualifiedClassName;
	
	import org.asaplibrary.data.URLData;
	import org.asaplibrary.data.xml.Service;
	import org.asaplibrary.data.xml.ServiceEvent;	

	/**
	 * @author stephan.bezoen
	 */
	public class UserFormService extends Service {
		public function UserFormService() {
			super();
		}
		
		/**
		 *
		 */
		public function postUserForm (inData:Object) : void {
			var ud:URLData = URLManager.getURLDataByName(URLNames.USERFORM);
			if (!ud) return;
			
			load(ud, inData, true, true);
		}
		
		override protected function processData (inData:XML, inName:String) : void {
			var isSuccess:Boolean = (inData.@success == "true");
			if (isSuccess) dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, inName));
			else dispatchEvent(new ServiceEvent(ServiceEvent.LOAD_ERROR, inName, null, null, inData.@message));
		}
		
		override public function toString():String {
			return getQualifiedClassName(this);
		}
	}
}
