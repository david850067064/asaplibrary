﻿package controller {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import org.asaplibrary.management.flow.*;

	import data.AppSettings;
	import ui.CloseButton;
	
	public class Section4_1 extends Section1_1 {
		
		function Section4_1 () {
			super();
			tNumber.tText.text = "4.1";
		}
		
		protected override function handleClose (e:MouseEvent) : void {
			FlowManager.getInstance().goto(AppSettings.SECTION4);
		}
		
		public override function getName () : String {
			return AppSettings.SECTION4_1;
		}
		
	}

}