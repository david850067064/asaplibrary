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
	
	/**
	
	*/
	public class FlowRule {
	
		public var name:String;
		public var mode:uint;
		public var type:uint;
		public var callback:Function;
		
		/**
		@param inName: name of FlowSection
		@param inMode: the mode, either {@link FlowSectionOptions#SHOW}, {@link FlowSectionOptions#SHOW_END}, {@link FlowSectionOptions#HIDE} or {@link FlowSectionOptions#HIDE_END}
		@param inType: one of the type options in {@link FlowSectionOptions}
		@param inCallbackFunction: the function to call
		*/
		function FlowRule (inName:String, inMode:uint, inType:uint, inCallback:Function) {
			name = inName;
			mode = inMode;
			type = inType;
			callback = inCallback;
		}
		
		/**
		Creates a copy of an existing rule.
		*/
		public function copy () : FlowRule {
			return new FlowRule(name, mode, type, callback);
		}
		
		public function toString () : String {
			return "Rule: name=" + name + "; mode=" + mode + "; type=" + type + "; callback=" + callback;
		}
	}

}

