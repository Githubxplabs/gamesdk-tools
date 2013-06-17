package gamesdk.tools.managers {
	import flash.display.BitmapData;
	import gamesdk.tools.atf.ATFTool;
	import gamesdk.tools.ToolsMain;
	import gamesdk.tools.utils.ObjectUtils;
	import gamesdk.tools.handlers.Handler;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**资源加载器*/
	public class ResLoader {
		private static var _loadedMap:Object = {};
		private var _loader:Loader = new Loader();
		private var _urlLoader:URLLoader = new URLLoader();
		private var _urlRequest:URLRequest = new URLRequest();
		private var _loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		private var _url:String;
		private var _type:int;
		private var _complete:Handler;
		private var _progress:Handler;
		private var _isLoading:Boolean;
		private var _loaded:Number;
		private var _lastLoaded:Number;
		
		public function ResLoader() {
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function tryCloseLoad():void {
			try {
				_loader.unloadAndStop();
				_urlLoader.close();
			} catch (e:Error) {
			}
		}
		
		private function doLoad():void {
			if (_isLoading) {
				tryCloseLoad();
			}
			_isLoading = true;
			_urlRequest.url = _url;
			if (_type == ResType.SWF) {
				_loader.load(_urlRequest, _loaderContext);
				return;
			}
			if (_type == ResType.BMD || _type == ResType.AMF || _type == ResType.BYTE || _type == ResType.ATF || _type == ResType.ATF_ATLAS) {
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.load(_urlRequest);
				return;
			}
			if (_type == ResType.TXT) {
				_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				_urlLoader.load(_urlRequest);
				return;
			}
		}
		
		private function onStatus(e:HTTPStatusEvent):void {
		
		}
		
		private function onError(e:Event):void {
			ToolsMain.log.error("Load Error:", e.toString());
			endLoad(null);
		}
		
		private function onProgress(e:ProgressEvent):void {
			if (_progress != null) {
				var value:Number = e.bytesLoaded / e.bytesTotal;
				_progress.executeWith([value]);
			}
			_loaded = e.bytesLoaded;
		}
		
		private function onComplete(e:Event):void {
			if (_type == ResType.SWF) {
				endLoad(_loadedMap[_url] = _loader.content);
				return;
			}
			if (_type == ResType.BMD) {
				if (_urlLoader.data != null) {
					_loader.loadBytes(_urlLoader.data);
					_urlLoader.data = null;
					return;
				}
				endLoad(_loadedMap[_url] = Bitmap(_loader.content).bitmapData);
				return;
			}
			if (_type == ResType.AMF) {
				var bytes:ByteArray = _urlLoader.data as ByteArray;
				endLoad(_loadedMap[_url] = bytes.readObject());
				return;
			}
			if (_type == ResType.BYTE) {
				var byte:ByteArray = _urlLoader.data as ByteArray;
				//byte.uncompress();
				endLoad(_loadedMap[_url] = byte);
				return;
			}
			if (_type == ResType.ATF) {
				byte = _urlLoader.data as ByteArray;
				//byte.uncompress();
				endLoad(_loadedMap[_url] = byte);
				return;
			}
			if (_type == ResType.ATF_ATLAS) {
				byte = _urlLoader.data as ByteArray;
				//byte.uncompress();
				//endLoad(_loadedMap[_url] = byte);
				endLoad(_loadedMap[_url] = ATFTool.analysis(byte));
				return;
			}
			if (_type == ResType.TXT) {
				endLoad(_loadedMap[_url] = _urlLoader.data);
				return;
			}
		}
		
		private function endLoad(content:*):void {
			ToolsMain.timer.clearTimer(checkLoad);
			_isLoading = false;
			_progress = null;
			if (_complete != null) {
				var handler:Handler = _complete;
				_complete = null;
				handler.executeWith([content]);
			}
		}
		
		/**
		 * 资源加载入口
		 * @param	url 资源的路径
		 * @param	type 资源加载的类型，具体类型请参考ResType.as。
		 * @param	complete 加载完成处理器
		 * @param	progress 加载进度处理器
		 */
		public function load(url:String, type:int, complete:Handler, progress:Handler):void {
			_url = url;
			_type = type;
			_complete = complete;
			_progress = progress;
			
			var content:* = getResByUrl(url);
			if (content != null) {
				return endLoad(content);
			}
			_loaded = _lastLoaded = 0;
			ToolsMain.timer.doLoop(5000, checkLoad);
			doLoad();
		}
		
		/**如果5秒钟下载小于1k，则停止下载*/
		private function checkLoad():void {
			if (_loaded - _lastLoaded < 1024) {
				ToolsMain.log.warn("load time out:" + _url);
				tryCloseLoad();
				endLoad(null);
			} else {
				_lastLoaded = _loaded;
			}
		}
		
		/**
		 * 获取已经加载的资源。
		 * @param	url
		 * @return
		 */
		public static function getResByUrl(url:String):* {
			return _loadedMap[url];
		}
		
		/**
		 * 根据key获取资源名称
		 * @param	key
		 * @return
		 */
		public static function getResByKey(key:String):* {
			for (var name:String in _loadedMap) {
				if (name.indexOf(key) != -1) {
					return _loadedMap[name]
				}
			}
			return null;
		}
		
		/**
		 * 施放已经加载的资源
		 * @param	url
		 */
		public static function disposeRes(url:String):void {
			var tempData:* = _loadedMap[url];
			if (tempData != null && tempData is BitmapData) {
				tempData.dispose();
			}
			_loadedMap[url] = null;
		}
	}
}