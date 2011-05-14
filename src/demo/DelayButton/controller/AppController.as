package demo.DelayButton.controller {
	import demo.DelayButton.ui.MyButton;

	import fl.controls.NumericStepper;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class AppController extends MovieClip {
		public var tInDelayNS : NumericStepper;
		public var tOutDelayNS : NumericStepper;
		public var tAfterDelayNS : NumericStepper;
		public var tButton : MyButton;

		public function AppController() {
			super();
			tInDelayNS.addEventListener(Event.CHANGE, handleInDelaySetting);
			tOutDelayNS.addEventListener(Event.CHANGE, handleOutDelaySetting);
			tAfterDelayNS.addEventListener(Event.CHANGE, handleAfterDelaySetting);
		}

		private function handleInDelaySetting(e : Event) : void {
			var nsTarget:NumericStepper = e.target as NumericStepper;
			tButton.indelay = nsTarget.value;
		}

		private function handleOutDelaySetting(e : Event) : void {
			var nsTarget:NumericStepper = e.target as NumericStepper;
			tButton.outdelay = nsTarget.value;
		}

		private function handleAfterDelaySetting(e : Event) : void {
			var nsTarget:NumericStepper = e.target as NumericStepper;
			tButton.afterdelay = nsTarget.value;
		}
	}
}
