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
	/**
	 * Interface to be implemented in order to be used by the Validator class, for validation of IValidatable objects
	 */
	public interface IValidationRule {
		/**
		 * @return true if value of IValidatable target is valid according to the rule
		 */
		function isValid() : Boolean;

		/**
		 * @return the target for validation
		 */
		function getTarget() : IValidatable;
	}
}
