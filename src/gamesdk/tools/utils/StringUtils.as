package gamesdk.tools.utils {
	import flash.geom.Rectangle;
	
	/**文本工具集*/
	public class StringUtils {
		/**判断文本为非空*/
		public static function isNotEmpty(str:String):Boolean {
			if (str == null || str == "") {
				return false;
			}
			return true;
		}
		
		/**用字符串填充数组，并返回数组副本*/
		public static function fillArray(arr:Array, str:String, type:Class = null):Array {
			var temp:Array = ObjectUtils.clone(arr);
			if (isNotEmpty(str)) {
				var a:Array = str.split(",");
				for (var i:int = 0, n:int = Math.min(temp.length, a.length); i < n; i++) {
					var value:String = a[i];
					temp[i] = (value == "true" ? true : (value == "false" ? false : value));
					if (type != null) {
						temp[i] = type(value);
					}
				}
			}
			return temp;
		}
		
		/**转换Rectangle为逗号间隔的字符串*/
		public static function rectToString(rect:Rectangle):String {
			if (rect) {
				return rect.x + "," + rect.y + "," + rect.width + "," + rect.height;
			}
			return null;
		}
		
		/**
		 * 转换url地址为取资源的名称
		 * @param	url url地址
		 * @return 转换之后的资源名称
		 */
		public static function convertURLToKey(url:String):String {
			var matches:Array;
			var name:String = url;
			
			name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
			matches = /(.*[\\\/])?([\w\s\-]+)(\.[\w]{1,4})?/.exec(name);
			
			if (matches && matches.length == 4)
				return matches[2];
			else
				throw new ArgumentError("Could not extract name from String '" + url + "'");
			return url;
		}
		
		/**
		 * 是否为url全路径
		 * @param	str 字符串
		 * @return
		 */
		public static function isUrl(str:String):Boolean {
			return str.lastIndexOf("/") != -1;
		}
	
	}
}