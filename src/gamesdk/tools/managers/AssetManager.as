package gamesdk.tools.managers {
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import gamesdk.tools.ToolsMain;
	import gamesdk.tools.utils.BitmapUtils;
	import gamesdk.tools.utils.StringUtils;
	
	/**资源管理器*/
	public class AssetManager {
		private var _bmdMap:Object = {};
		private var _clipsMap:Object = {};
		private var _imageMap:Object = {};
		private var _dataMap:Object = {};
		
		public function AssetManager() {
		
		}
		
		/**判断是否有类的定义*/
		public function hasClass(name:String):Boolean {
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
		
		/**获取类*/
		public function getClass(name:String):Class {
			if (hasClass(name)) {
				return ApplicationDomain.currentDomain.getDefinition(name) as Class;
			}
			ToolsMain.log.error("Miss Asset:", name);
			return null;
		}
		
		/**获取资源*/
		public function getAsset(name:String):* {
			var assetClass:Class = getClass(name);
			if (assetClass != null) {
				return new assetClass();
			}
			return null;
		}
		
		/**
		 * 获取资源
		 * @param	name 获取的资源名称
		 * @param	cache 是否缓存
		 * @return
		 */
		public function getBitmapDataBySwf(name:String, cache:Boolean = true):BitmapData {
			var bmd:BitmapData = _bmdMap[name];
			if (bmd == null) {
				var bmdClass:Class = getClass(name);
				if (bmdClass == null) {
					return null;
				}
				bmd = new bmdClass(1, 1);
				if (cache) {
					_bmdMap[name] = bmd;
				}
			}
			return bmd;
		}
		
		/**获取切片资源*/
		public function getClips(name:String, xNum:int, yNum:int, cache:Boolean = true):Vector.<BitmapData> {
			var clips:Vector.<BitmapData> = _clipsMap[name];
			if (clips == null) {
				var bmd:BitmapData = getBitmapDataBySwf(name, false);
				if (bmd == null) {
					return null;
				}
				clips = BitmapUtils.createClips(bmd, xNum, yNum);
				if (cache) {
					_clipsMap[name] = clips;
				}
			}
			return clips;
		}
		
		/**缓存切片资源*/
		public function cacheClips(name:String, clips:Vector.<BitmapData>):void {
			if (clips) {
				_clipsMap[name] = clips;
			}
		}
		
		/**
		 * 获取已经加载的资源，如果为swf资源，请用getBitmapDataBySwf或getAssets或getClass。
		 * @param	url url为加载资源的全路径
		 * @return
		 */
		public function getResLoaded(url:String):* {
			if (StringUtils.isUrl(url)) {
				return ResLoader.getResByUrl(url);
			}
			return ResLoader.getResByKey(url);
		
		}
		
		/**
		 * 施放已经加载的资源
		 * @param	url
		 */
		public static function disposeRes(url:String):void {
			ResLoader.disposeRes(url);
		}
	}
}