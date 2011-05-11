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
	import flash.utils.getQualifiedClassName;

	/**
	Behavior rule for FlowManager when traversing from one state to the other. See {@link FlowManager} for examples.
	 */
	public class FlowRule {
		public var name : String;
		public var mode : uint;
		public var type : uint;
		public var callback : Function;

		/**
		Creates a new FlowRule.
		@param inName: name of the {@link IFlowSection}
		@param inMode: the display mode, see {@link FlowOptions}
		@param inType: relation type, see {@link FlowOptions}
		@param inCallbackFunction: the function to call
		 */
		function FlowRule(inName : String, inMode : uint, inType : uint, inCallback : Function) {
			name = inName;
			mode = inMode;
			type = inType;
			callback = inCallback;
		}

		/**
		Creates a copy of an existing FlowRule.
		 */
		public function copy() : FlowRule {
			return new FlowRule(name, mode, type, callback);
		}

		public function toString() : String {
			return getQualifiedClassName(this) + ": name=" + name + "; mode=" + mode + "; type=" + type + "; callback=" + callback;
		}
	}
}

