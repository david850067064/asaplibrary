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
	/**
	FlowSection relation types and display mode types. The options use bitwise operators, see {@link ButtonStates} for an example.
	 */
	public class FlowOptions {
		public static const NONE : uint = (1 << 0);
		/**< Relation type. */
		public static const EQUAL : uint = (1 << 1);
		/**< Relation type. */
		public static const UNRELATED : uint = (1 << 2);
		/**< Relation type. */
		public static const ROOT : uint = (1 << 3);
		/**< Relation type. */
		public static const DISTANT : uint = (1 << 4);
		/**< Relation type. */
		public static const SIBLING : uint = (1 << 5);
		/**< Relation type. */
		public static const CHILD : uint = (1 << 6);
		/**< Relation type. */
		public static const PARENT : uint = (1 << 7);
		/**< Relation type. */
		public static const ANY : uint = UNRELATED | ROOT | DISTANT | SIBLING | CHILD | PARENT;
		/**< Relation type. */
		public static const START : uint = (1 << 8);
		/**< Display mode type. */
		public static const START_END : uint = (1 << 9);
		/**< Display mode type. */
		public static const STOP : uint = (1 << 10);
		/**< Display mode type. */
		public static const STOP_END : uint = (1 << 11);
		/**< Display mode type. */
	}
}
