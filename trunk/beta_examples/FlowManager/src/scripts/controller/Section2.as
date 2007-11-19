package controller {
	import flash.display.MovieClip;
	
	import org.asaplibrary.management.flow.*;
	
	import data.AppSettings;
	
	import ui.GenericButton;	

	public class Section2 extends FlowSection {
		
		public var tNumber:MovieClip;
		public var Show_Section1:GenericButton;
		public var Show_Section3:GenericButton;
		public var Show_Section4:GenericButton;

		function Section2 () {
			super( AppSettings.SECTION2 );
			tNumber.tText.text = "2";
			Show_Section1.setData("Show 1", AppSettings.SECTION1);
			Show_Section3.setData("Show 3", AppSettings.SECTION3);
			Show_Section4.setData("Show 4", AppSettings.SECTION4);
		}

	}

}
