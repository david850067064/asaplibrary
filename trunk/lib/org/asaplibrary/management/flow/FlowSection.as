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
	
	/**
	Building block of navigatable site sections.
	
	<div style="background:#ffc; padding:1em; margin:0 0 1em 0; text-align:center">
	WARNING: provided "AS IS" -- this code has not been tested on production sites!
	</div>
	
	Subclasses will most likely override {@link #startAction} and {@link #stopAction}, see example below.
	It is also possible to override {@link #start} and {@link #stop} for non-timebased actions.
	
	Each FlowSection needs to have a name to be addressable by {@link FlowManager}. Simply pass the name with the super constructor call:
	<code>
	public class Gallery extends FlowSection {
		
		function Gallery () {
			super( "Gallery" );
			...
		}
	
	}
	</code>
	or better:
	<code>
	function Gallery () {
		super( APPSETTINGS.SECTION_GALLERY );
		...
	}
	</code>
	@example
	Overriding the default stop action with a scaling animation:
	<code>
	public override function get stopAction () : IAction {
		var queue:ActionQueue = new ActionQueue("Section1_1 stop");
		const CURRENT:Number = Number.NaN;
		var effect:Function = Quadratic.easeOut;
		queue.addAction(new AQScale().scale(this, .3, CURRENT, CURRENT, 0, 0, effect));
		queue.addAction(new AQSet().setVisible(this, false));
		return queue;
	}
	</code> 
	*/
	public class FlowSection extends LocalController implements IFlowSection {
		
		protected var mFlowManager:FlowManager;
		
		/**
		Creates a new FlowSection.
		@param inName: (optional) unique identifier for this section; you may also override {@link #getName} in a subclass
		@param inFlowManager: (optional, but if you are using a custom FlowManager you must pass the FlowManager here)
		*/
		function FlowSection (inName:String = null, inFlowManager:FlowManager = null) {
			super(inName);
			setFlowManager(inFlowManager)	
			register();
			visible = false;
		}
		
		/**
		Sets the FlowManager. You must call {@link #register} after setting the FlowManager.
		@param inFlowManager: FlowManager to set
		*/
		public function setFlowManager (inFlowManager:FlowManager) : void {
			mFlowManager = inFlowManager;
		}
		
		/**
		@return The FlowManager, if set with {@link #setFlowManager} or the constructor; otherwise {@link FlowManager#defaultFlowManager}.
		*/
		public function getFlowManager () : FlowManager {
			if (mFlowManager != null) {
				return mFlowManager;
			}
			return FlowManager.defaultFlowManager;
		}
		
		/**
		Registers this FlowSection with the FlowManager. Only call this function if you have set a non-default FlowManager in {@link #setFlowManager}.
		*/
		public function register () : void {
			getFlowManager().registerFlowSection(this, getName());
		}
		
		/**
		Returns the name that is used to register this class to the FlowManager.
		Override this function to set the name of a FlowSection subclass.
		@example
		<code>
		public override function getName () : String {
			return "Gallery";
		}
		</code>
		*/
		public override function getName () : String {
			return super.getName();
		}
		
		/**
		The Action to be run when the section is shown. Actions are run by {@link ActionRunner}.
		*/
		public function get startAction () : IAction {
			return new Action(this, start);
		}
		
		/**
		The Action to be run when the section is hidden. Actions are run by {@link ActionRunner}.
		*/
		public function get stopAction () : IAction {
			return new Action(this, stop);
		}
		
		/**
		Default start function.
		*/
		public override function start () : void {
			visible = true;
		}
		
		/**
		Default stop function.
		*/
		public override function stop () : void {
			visible = false;
		}
		
		/**
		Runs {@link #startAction} stand-alone, for testing purposes. 
		*/
		protected function startStandalone () : void {
			var runner:ActionRunner = new ActionRunner();
			runner.addAction(startAction);
			runner.run();
		}
		
		/**
		Runs {@link #stopAction} stand-alone, for testing purposes. 
		*/
		protected function stopStandalone () : void {
			var runner:ActionRunner = new ActionRunner();
			runner.addAction(stopAction);
			runner.run();
		}
		
		/**
		@exclude
		*/
		public override function toString () : String {
			return ";org.asaplibrary.management.flow.FlowSection: " + getName();
		}
		
	}

}
