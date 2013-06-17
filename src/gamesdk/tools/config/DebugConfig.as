package gamesdk.tools.config
{
	
	/**
	 * ...
	 * @author hanxianming
	 */
	public class DebugConfig
	{
		/** 是否启用debug*/
		public var isDebug:Boolean = true;
		/** 是否启用Flash-trace*/
		public var isTrace:Boolean = true;
		/** 日志log输出最大缓存长度*/
		public var logInfoLength:int = 1000;
		/** FPS显示和关闭*/
		public var fps:String = "@fps";
		/** 是否永久显示*/
		public var isForeverLog:Boolean = false;
		
		public function DebugConfig()
		{
		
		}
	
	}

}