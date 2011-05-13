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
package org.asaplibrary.util.validation.rules {
	import org.asaplibrary.util.validation.IValidatable;
	import org.asaplibrary.util.validation.IValidationRule;

	/**
	 * Validation rule to check for a valid Dutch type postcode. This validation rule will return <code>false</code> for <code>isValid()</code> if the return value of <code>inTarget.getValue()</code> is an invalid postal code.
	 */
	public class DutchPostcodeValidationRule extends RegExpValidationRule implements IValidationRule {
		public function DutchPostcodeValidationRule(inTarget : IValidatable) {
			super(inTarget);

			mRegExp = /[1-9][0-9]{3} {0,1}[a-zA-Z]{2}/;
		}
	}
}
