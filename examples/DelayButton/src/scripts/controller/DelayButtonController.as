package controller {
	import flash.events.Event;
	
	import org.asaplibrary.management.movie.LocalController;
	
	import fl.controls.NumericStepper;
	
	import ui.MyButton;	

	public class DelayButtonController extends LocalController {
		
		public var tInDelayNS:NumericStepper;
		public var tOutDelayNS:NumericStepper;
		public var tAfterDelayNS:NumericStepper;
		public var tButton:MyButton;
		
		public function DelayButtonController () {
			tInDelayNS.addEventListener(Event.CHANGE, handleInDelaySetting);
			tOutDelayNS.addEventListener(Event.CHANGE, handleOutDelaySetting);
			tAfterDelayNS.addEventListener(Event.CHANGE, handleAfterDelaySetting);
		}
		
		private function handleInDelaySetting (e:Event) : void {
			tButton.indelay = e.currentTarget.value;
		}
		
		private function handleOutDelaySetting (e:Event) : void {
			tButton.outdelay = e.currentTarget.value;
		}
		
		private function handleAfterDelaySetting (e:Event) : void {
			tButton.afterdelay = e.currentTarget.value;
		}
	}

}
