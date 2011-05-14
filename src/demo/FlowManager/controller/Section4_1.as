package demo.FlowManager.controller {
	import demo.FlowManager.data.AppSettings;

	import org.asaplibrary.management.flow.*;

	import flash.events.MouseEvent;

	public class Section4_1 extends Section1_1 {
		function Section4_1() {
			super();
			tNumber.tText.text = "4.1";
		}

		protected override function handleClose(e : MouseEvent) : void {
			FlowManager.defaultFlowManager.goto(AppSettings.SECTION4);
		}

		public override function getName() : String {
			return AppSettings.SECTION4_1;
		}
	}
}
