/*Copyright 2009 by the authors of asaplibrary, http://asaplibrary.orgLicensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at   	http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/package org.asaplibrary.util.media {		public class MediaStatus {		public static const STOPPED : String = "stopped";
		public static const PLAYING : String = "playing";	
		public static const PAUSED : String = "paused";
		// added for streaming video
		public static const BUFFERING : String = "buffering";
	}}