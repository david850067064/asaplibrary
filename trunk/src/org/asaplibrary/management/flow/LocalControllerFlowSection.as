/*
Copyright 2007-2011 by the authors of asaplibrary, http://asaplibrary.org
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
	import org.asaplibrary.management.movie.*;

	/**
	FlowSection that stands in as LocalController, to be used as main controller for external SWFs.
	@use
	<code>
	public class Section1 extends LocalControllerFlowSection {
		
	function Section1 () {
	super( "Section1" );
			
	alpha = 0;
	visible = false;
			
	if (isStandalone()) {
	startStandalone();
	}
	}
		
	}
	</code>
	 */
	public class LocalControllerFlowSection extends FlowSection implements ILocalController {
		protected var mIsStandalone : Boolean;

		/**
		Creates a new LocalControllerFlowSection.
		@param inName: (optional) unique identifier for this section; to pass the section name you may also override {@link FlowSection#getName} in a subclass
		@param inFlowManager: (optional, but if you are using a custom FlowManager you must pass the FlowManager here)
		 */
		function LocalControllerFlowSection(inName : String = null, inFlowManager : FlowManager = null) {
			super(inName, inFlowManager);
			// initialize standalone flag
			mIsStandalone = ((stage != null) && (parent == stage));
		}

		/**
		Dummy implementation of {@link !LocalController#startMovie}.
		 */
		public function startMovie() : void {
		}

		/**
		Dummy implementation of {@link !LocalController#stopMovie}.
		 */
		public function stopMovie() : void {
		}

		/**
		@return True if the Section is the Document class.
		 */
		public function isStandalone() : Boolean {
			return mIsStandalone;
		}
	}
}
