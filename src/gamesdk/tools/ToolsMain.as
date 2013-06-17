package gamesdk.tools {
	import flash.display.Stage;
	import flash.events.Event;
	import gamesdk.tools.managers.AssetManager;
	import gamesdk.tools.managers.GCManager;
	import gamesdk.tools.managers.LoaderManager;
	import gamesdk.tools.managers.LogManager;
	import gamesdk.tools.managers.StatsFps;
	import gamesdk.tools.managers.TimerManager;
	import gamesdk.tools.utils.GTester;
	
	/**全局引用入口*/
	public class ToolsMain {
		/**全局stage引用*/
		public static var stage:Stage;
		/**资源管理器*/
		public static var asset:AssetManager = new AssetManager();
		/**加载管理器*/
		public static var loader:LoaderManager = new LoaderManager();
		/**时钟管理器*/
		public static var timer:TimerManager = new TimerManager();
		/**日志管理器,快捷键 [CTRL + L] 打开和关闭*/
		public static var log:LogManager = new LogManager();
		/** FPS显示，快捷键 [CTRL + T] 打开和关闭*/
		public static var fps:StatsFps = new StatsFps();
		/** 垃圾回收*/
		public static var gc:GCManager = new GCManager();
		
		public static function init(_stage:Stage):void {
			stage = _stage;
			stage.stageFocusRect = false;
			
			stage.addChild(log);
			stage.addChild(fps);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			updatePosition();
			
			if (ToolsConfig.debugConfig.isForeverLog)
				log.toggle();
			
			GTester.init(stage);
		}
		
		private static function stageResizeHandler(e:Event):void {
			updatePosition();
		}
		
		/**
		 * 更新log日志面板的坐标位置，默认只有左上角。
		 */
		public static function updatePosition(layout:int = 0):void {
			log.x = stage.stageWidth - log.width;
		}
		
		/**
		 * 代码块性能测试
		 * @param	executeCount 执行的有效次数
		 * @param	forCount for循环执行testFunc的次数
		 * @param	testFunc 需要被测试的代码块函数
		 */
		public static function gTester(executeCount:int, forCount:int, testFunc:Function):void {
			timer.doOnce(200, func);
			function func():void {
				for (var j:int = 0; j < executeCount; j++) {
					GTester.start();
					for (var i:int = 0; i < forCount; i++) {
						testFunc();
					}
					GTester.end(true);
				}
				GTester.output(GTester.ANALYSIS);
			}
		}
	}
}