/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package org.asaplibrary.management.flow {

	import flash.display.MovieClip;
	
	import org.asaplibrary.management.movie.*;
	import org.asaplibrary.management.flow.*;
	import org.asaplibrary.util.actionqueue.*;
	
	public class FlowSection extends LocalController implements IFlowSection {
		
		function FlowSection (inName:String = null) {
			super(inName);
			visible = false;
			FlowManager.getInstance().registerFlowSection(this);
		}
		
		/**
		
		*/
		public function get showAction () : IAction {
			return new Action(this, show);
		}
		
		/**
		
		*/
		public function get hideAction () : IAction {
			return new Action(this, hide);
		}
		
		/**
		Default show function.
		*/
		public function show () : void {
			visible = true;
		}
		
		/**
		Default hide function.
		*/
		public function hide () : void {
			visible = false;
		}
		
		/**
		
		*/
		protected function showStandalone () : void {
			var runner:ActionRunner = new ActionRunner();
			runner.addAction(showAction);
			runner.run();
		}
		
		/**
		
		*/
		protected function hideStandalone () : void {
			var runner:ActionRunner = new ActionRunner();
			runner.addAction(hideAction);
			runner.run();
		}
		
		/**
		@exclude
		*/
		public override function toString () : String {
			return "FlowSection: " + getName();
		}
		
	}

}
