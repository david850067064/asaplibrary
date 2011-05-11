/*
Copyright 2009 by the authors of asaplibrary, http://asaplibrary.org

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
package org.asaplibrary.ui.video {
	public class VideoDeblocking {
		/** Lets the video compressor apply the deblocking filter as needed. */
		public static const AUTO : uint = 0;
		/** Does not use a deblocking filter. */
		public static const DISABLE : uint = 1;
		/** Uses the Sorenson deblocking filter. */
		public static const SORENSON : uint = 2;
		/** For On2 video only, uses the On2 deblocking filter but no deringing filter. */
		public static const ON2_NO_DERINGING : uint = 3;
		/** For On2 video only, uses the On2 deblocking and deringing filter. */
		public static const ON2_DERINGING_LOW : uint = 4;
		/** For On2 video only, uses the On2 deblocking and a higher-performance On2 deringing filter. */
		public static const ON2_DERINGING_HIGH : uint = 5;
	}
}