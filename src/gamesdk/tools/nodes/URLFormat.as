package gamesdk.tools.nodes
{
	import gamesdk.tools.managers.ResType;
	
	/**
	 * ...
	 * @author hanxianming
	 */
	public class URLFormat
	{
		public var url:String = "";
		public var type:int;
		public var size:int;
		
		/**
		 * 资源url的格式
		 * @param	url url地址
		 * @param	type 资源的类型，具体请参见ResType.as
		 * @param	size 资源的体积大小
		 */
		public function URLFormat(url:String, type:int = 4, size:int = 1)
		{
			this.url = url;
			this.type = type;
			this.size = size;
		}
	
	}

}