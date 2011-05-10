package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import org.asaplibrary.data.xml.ServiceEvent;
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.util.FrameDelay;
	
	import assets.AssetEvent;
	import assets.AssetManager;
	
	import data.URLManager;
	
	import ui.UserForm;		

	/**
	 * @author stephan.bezoen
	 */
	public class AppController extends LocalController {

		public function AppController() {
			super();
			
			URLManager.getInstance().addEventListener(ServiceEvent._EVENT, handleServiceEvent);
			URLManager.getInstance().loadURLs("../xml/urls.xml");
		}
		
		private function handleServiceEvent(e : ServiceEvent) : void {
			if (e.subtype != ServiceEvent.COMPLETE) return;
			
			AssetManager.getInstance().addEventListener(AssetEvent._EVENT, handleAssetEvent);
			AssetManager.getInstance().loadSWF("form.swf");
		}

		private function handleAssetEvent(e : AssetEvent) : void {
			if (e.subtype != AssetEvent.COMPLETE) return;
			
			new FrameDelay(createUI);
		}

		private function createUI() : void {
			var dob:DisplayObject = AssetManager.getInstance().instantiate("Form");
			dob.x = (stage.stageWidth - dob.width) / 2;
			dob.y = (stage.stageHeight - dob.height) / 2;
			addChild(dob);
			
			var form:UserForm = new UserForm(dob as MovieClip);
		}
	}
}
