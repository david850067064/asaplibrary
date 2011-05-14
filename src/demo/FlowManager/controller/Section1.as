package demo.FlowManager.controller {
	import demo.FlowManager.data.AppSettings;
	import demo.FlowManager.ui.GenericButton;

	import org.asaplibrary.management.flow.*;

	import flash.display.MovieClip;

	public class Section1 extends FlowSection {
		public var tNumber : MovieClip;
		public var Show_Intro : GenericButton;
		public var Show_Section2 : GenericButton;
		public var Show_Section3 : GenericButton;
		public var Show_Section1_1 : GenericButton;

		function Section1() {
			super(AppSettings.SECTION1);
			tNumber.tText.text = "1";
			Show_Intro.setData("Show Intro", AppSettings.SECTION_INTRO);
			Show_Section2.setData("Show 2", AppSettings.SECTION2);
			Show_Section3.setData("Show 3", AppSettings.SECTION3);
			Show_Section1_1.setData("Register!", AppSettings.SECTION1_1);
		}
	}
}
