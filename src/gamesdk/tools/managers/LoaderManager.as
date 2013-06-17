package gamesdk.tools.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import gamesdk.tools.handlers.Handler;
	import gamesdk.tools.nodes.URLFormat;
	import gamesdk.tools.ToolsMain;
	
	/**加载管理器*/
	public class LoaderManager extends EventDispatcher
	{
		private var _resInfos:Array = [];
		private var _resLoader:ResLoader = new ResLoader();
		private var _isLoading:Boolean;
		private var _failRes:Object = {};
		
		public function LoaderManager()
		{
		
		}
		
		/**
		 * 资源加载入口
		 * @param	url 资源的路径
		 * @param	type 资源加载的类型，具体类型请参考ResType.as。
		 * @param	complete 加载完成处理器
		 * @param	progress 加载进度处理器
		 */
		public function load(url:String, type:uint, complete:Handler = null, progress:Handler = null):void
		{
			var resInfo:ResInfo = new ResInfo();
			resInfo.url = url;
			resInfo.type = type;
			resInfo.complete = complete;
			resInfo.progress = progress;
			
			var content:* = ResLoader.getResByUrl(resInfo.url);
			if (content != null)
			{
				endLoad(resInfo, content);
			}
			else
			{
				_resInfos.push(resInfo);
				checkNext();
			}
		}
		
		private function checkNext():void
		{
			if (_isLoading)
			{
				return;
			}
			while (_resInfos.length > 0)
			{
				var resInfo:ResInfo = _resInfos.shift();
				var content:* = ResLoader.getResByUrl(resInfo.url);
				if (content != null)
				{
					endLoad(resInfo, content);
				}
				else
				{
					doLoad(resInfo);
					return;
				}
			}
			if (hasEventListener(Event.COMPLETE))
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function doLoad(resInfo:ResInfo):void
		{
			_isLoading = true;
			_resLoader.load(resInfo.url, resInfo.type, new Handler(loadComplete, [resInfo]), resInfo.progress);
		}
		
		private function loadComplete(resInfo:ResInfo, content:*):void
		{
			endLoad(resInfo, content);
			_isLoading = false;
			checkNext();
		}
		
		private function endLoad(resInfo:ResInfo, content:*):void
		{
			//如果加载后为空，放入队列末尾重试一次
			if (content == null)
			{
				if (_failRes[resInfo.url] == null)
				{
					_failRes[resInfo.url] = 1;
					_resInfos.push(resInfo);
					return;
				}
				else
				{
					ToolsMain.log.warn("load error:", resInfo.url);
				}
			}
			if (resInfo.complete != null)
			{
				resInfo.complete.executeWith([content]);
			}
		}
		
		/**
		 * 根据数组的url格式列表加载素材
		 * @param	urls url格式的列表
		 * @param	complete 加载完成事件
		 * @param	progress 加载进度事件
		 */
		public function loadAssets(urls:Vector.<URLFormat>, complete:Handler = null, progress:Handler = null):void
		{
			var itemCount:int = urls.length;
			var itemloaded:int = 0;
			var totalSize:int = 0;
			var totalLoaded:int = 0;
			for (var i:int = 0; i < itemCount; i++)
			{
				var item:URLFormat = urls[i];
				totalSize += item.size;
				load(item.url, item.type, new Handler(loadAssetsComplete, [item.size]), new Handler(loadAssetsProgress, [item.size]));
			}
			
			function loadAssetsComplete(size:int, content:*):void
			{
				itemloaded++;
				totalLoaded += size;
				if (itemloaded == itemCount)
				{
					if (complete != null)
					{
						complete.execute();
					}
				}
			}
			
			function loadAssetsProgress(size:int, value:Number):void
			{
				if (progress != null)
				{
					value = (totalLoaded + size * value) / totalSize;
					progress.executeWith([value]);
				}
			}
		}
	}
}
import gamesdk.tools.handlers.Handler;

class ResInfo
{
	public var url:String;
	public var type:int;
	public var complete:Handler;
	public var progress:Handler;
	
	public function ResInfo()
	{
	
	}
}