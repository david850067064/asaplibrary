/*
Copyright 2008 by the authors of asaplibrary, http://asaplibrary.org
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

package com.lostboys.util.validation {
	import yalog.Yalog;	
	
	/**
	 * @author stephan.bezoen
	 */
	public class Validator {
		/** Objects of type IValidationRule */
		private var mRules:Array = new Array();

		/**
		 * Add a validation rule
		 */
		public function addValidationRule (inRule:IValidationRule) : void {
			if (inRule) mRules.push(inRule);
		}
		
		/**
		 * Check validity of all added validation rules
		 * @return a list of all validation rules that did not validate; objects of type IValidationRule
		 */
		public function validate () : Array {
			var errors:Array = new Array();
			
			var leni : uint = mRules.length;
			for (var i:uint = 0; i < leni; i++) {
				var rule : IValidationRule = mRules[i] as IValidationRule;
				if (!rule.isValid()) errors.push(rule);
			}
			
			return errors;
		}
		
		/**
		 *
		 */
		public function clear () : void {
			mRules = new Array();
		}
		
		public function toString():String {
			return "; com.lostboys.util.validation.Validator ";
		}
	}
}
