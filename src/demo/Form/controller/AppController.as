package demo.Form.controller {
	import demo.Form.data.URLManager;
	import demo.Form.ui.UserForm;

	import org.asaplibrary.data.xml.ServiceEvent;
	import org.asaplibrary.management.movie.LocalController;
	import org.asaplibrary.util.FrameDelay;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author stephan.bezoen
	 */
	public class AppController extends LocalController {
		
		private const XML_DIR:String = "xml/urls.xml"; 
		private const FORM_URL:String = "Form.swf";
		
		public function AppController() {
			super();

			URLManager.getInstance().addEventListener(ServiceEvent._EVENT, handleServiceEvent);
			URLManager.getInstance().loadURLs(XML_DIR);
		}

		private function handleServiceEvent(e : ServiceEvent) : void {
			if (e.subtype != ServiceEvent.COMPLETE) return;

			AssetManager.getInstance().addEventListener(AssetEvent._EVENT, handleAssetEvent);
			AssetManager.getInstance().loadSWF(FORM_URL);
		}

		private function handleAssetEvent(e : AssetEvent) : void {
			if (e.subtype != AssetEvent.COMPLETE) return;

			new FrameDelay(createUI);
		}

		private function createUI() : void {
			var dob : DisplayObject = AssetManager.getInstance().instantiate("Form");
			dob.x = (stage.stageWidth - dob.width) / 2;
			dob.y = (stage.stageHeight - dob.height) / 2;
			addChild(dob);

			new UserForm(dob as MovieClip);
		}
	}
}
