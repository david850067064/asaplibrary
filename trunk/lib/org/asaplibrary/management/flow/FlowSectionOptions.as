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
	
	public class FlowSectionOptions {

		public static const NONE:uint =      (1<<0);		
		public static const EQUAL:uint =     (1<<1);
		public static const UNRELATED:uint = (1<<2);		
		public static const ROOT:uint =      (1<<3);
		public static const DISTANT:uint =  (1<<4);
		public static const SIBLING:uint =   (1<<5);
		public static const CHILD:uint =     (1<<6);
		public static const PARENT:uint =    (1<<7);
		
		public static const ANY:uint =       UNRELATED|ROOT|DISTANT|SIBLING|CHILD|PARENT;
		
		public static const SHOW:uint =      (1<<8);
		public static const SHOW_END:uint =  (1<<9);
		public static const HIDE:uint =      (1<<10);
		public static const HIDE_END:uint =  (1<<11);
		public static const LOAD:uint =      (1<<12);
	}
}
