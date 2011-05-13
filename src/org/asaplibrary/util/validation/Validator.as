/*
Copyright 2008-2011 by the authors of asaplibrary, http://asaplibrary.org
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
package org.asaplibrary.util.validation {
	import flash.utils.getQualifiedClassName;

	/**
	 * Class for validation of user input values in UI components.
	 * UI components must implement IValidatable, and be added for validation through implementations of IValidationRule.
	 * 
	 * @example
	 * In a form, suppose two objects of type InputField are defined: tName & tEmail. The class InputField implements Ivalidatable.
	 * Add the following code to allow validation on those objects.
	 * <code>
	mValidator = new Validator();
	mValidator.addValidationRule(new EmptyStringValidationRule(tName));
	mValidator.addValidationRule(new EmailValidationRule(tEmail));
	</code>
	 * 	This code sets a validation rule on tName to check for an empty string, and on tEmail to check for a valid email address.
	 * 	To perform the actual validation, use this:
	 * 	<code>
	var errors:Array = mValidator.validate();
	</code>
	 * If either of the validation rules returns false, it will be added to the list of <code>errors</code>. This list will have a length of 0 if no errors were found.
	 * Run through the list of errors to get the rule(s) that returned false. The UI component itself can then be accessed through the <code>getTarget()</code> function of IValidatable.
	 */
	public class Validator {
		/** Objects of type IValidationRule */
		private var mRules : Array = new Array();

		/**
		 * Add a validation rule
		 */
		public function addValidationRule(inRule : IValidationRule) : void {
			if (inRule) mRules.push(inRule);
		}

		/**
		 * Check validity of all added validation rules
		 * @return a list of all validation rules that did not validate; objects of type IValidationRule
		 */
		public function validate() : Array {
			var errors : Array = new Array();

			var leni : uint = mRules.length;
			for (var i : uint = 0; i < leni; i++) {
				var rule : IValidationRule = mRules[i] as IValidationRule;
				if (!rule.isValid()) errors.push(rule);
			}

			return errors;
		}

		/**
		 * Empty the list of validation rules
		 */
		public function clear() : void {
			mRules = new Array();
		}

		/**
		 * @return all targets for validation, objects of type IValidatable
		 */
		public function getTargets() : Array {
			var a : Array = new Array();
			var leni : uint = mRules.length;
			for (var i : uint = 0; i < leni; i++) {
				a.push((mRules[i] as IValidationRule).getTarget());
			}
			return a;
		}

		public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
