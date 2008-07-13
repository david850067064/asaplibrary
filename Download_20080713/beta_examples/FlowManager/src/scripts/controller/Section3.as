package controller {
	import flash.display.MovieClip;
	
	import org.asaplibrary.management.flow.*;
	
	import data.AppSettings;
	
	import ui.GenericButton;	

	public class Section3 extends FlowSection {
		
		public var tNumber:MovieClip;
		public var Show_Section2:GenericButton;
		public var Show_Section4:GenericButton;
		public var Show_Register:GenericButton;
		
		function Section3 () {
			super( AppSettings.SECTION3 );
			tNumber.tText.text = "3";
			Show_Section2.setData("Show 2", AppSettings.SECTION2);
			Show_Section4.setData("Show 4", AppSettings.SECTION4);
			Show_Register.setData("Register now", AppSettings.SECTION1_1);
		}
		
	}

}
