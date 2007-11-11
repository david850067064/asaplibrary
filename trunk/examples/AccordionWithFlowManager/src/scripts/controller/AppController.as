﻿package controller {

	import flash.display.MovieClip;

	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.StageUtils;
	import org.asaplibrary.util.actionqueue.*;

	import ui.*;
	import ui.accordion.*;
	
	public class AppController extends MovieClip {
		
		protected var mFlowManager:FlowManager;
		protected var mFinishedFadeQueue:ActionQueue;
		
		public var tFinishedNote:MovieClip;
		
		function AppController () {
			
			tFinishedNote.visible = false;
			mFinishedFadeQueue = new ActionQueue();
			
			mFlowManager = new FlowManager("Accordion FlowManager");
			mFlowManager.addEventListener(FlowNavigationEvent._EVENT, handleNavigationEvent);

			var accordion:DemoAccordion = createAccordion(mFlowManager);
			StageUtils.centerOnStage(accordion, Number.NaN, Number.NaN, true);
			
			visible = true;
			accordion.y = 50;
			
			mFlowManager.goto("0.0.1");
		}
		
		private function createAccordion (inFlowManager:FlowManager) : Accordion {
			var accordion:DemoAccordion = new DemoAccordion("", inFlowManager);
			addChild(accordion);
			accordion.setupPanes(4, null);
			
			// create an accordion within an accordion pane
			// set small accordion to pane 0
			var pane:Pane = accordion.getPaneAtIndex(0);
			var paneAccordion:Accordion = createAccordionForPane(pane, inFlowManager);
			// place nested accordion at the right
			paneAccordion.x = accordion.width - paneAccordion.width;
			
			
			// create an accordion within an accordion pane
			// set small accordion to pane 0
			var pane2:Pane = paneAccordion.getPaneAtIndex(0);
			var paneAccordion2:Accordion = createAccordionForPane(pane2, inFlowManager);
			// place nested accordion at the right
			paneAccordion2.x = accordion.width - paneAccordion2.width;
			
			return accordion;
		}
		
		private function createAccordionForPane (inPane:Pane, inFlowManager:FlowManager) : Accordion {
			var name:String = inPane.getName();
			var accordion:DemoAccordion = new DemoAccordion(name, inFlowManager);
			accordion.scaleX = accordion.scaleY = .9;
			accordion.setupPanes(3, inPane);
			inPane.setContent(accordion);
			return accordion;
		}
		
		private function handleNavigationEvent (e:FlowNavigationEvent) : void {
						
			switch (e.subtype) {
				case FlowNavigationEvent.FINISHED:
					showFinishedNote();
					break;
			}
		}
		
		private function showFinishedNote () : void {
			mFinishedFadeQueue.reset();
			mFinishedFadeQueue.addAction(new AQSet().setAlpha(tFinishedNote, 0));
			mFinishedFadeQueue.addAction(new AQSet().setVisible(tFinishedNote, true));
			mFinishedFadeQueue.addAction(new AQFade().fade(tFinishedNote, .05, 0, 1));
			mFinishedFadeQueue.addWait(3);
			mFinishedFadeQueue.addAction(new AQFade().fade(tFinishedNote, 1, 1, 0));
			mFinishedFadeQueue.addAction(new AQSet().setVisible(tFinishedNote, false));
			mFinishedFadeQueue.run();
		}
			
	}
}