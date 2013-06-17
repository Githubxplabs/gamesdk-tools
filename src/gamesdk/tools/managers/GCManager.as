package gamesdk.tools.managers {
	import flash.net.LocalConnection;
	
	/**
	 * 垃圾回收管理器
	 * @author hanxianming
	 */
	public class GCManager {
		
		public function GCManager() {
		
		}
		
		/**
		 * 强制执行垃圾回收
		 */
		public function gc():void {
			try {
				new LocalConnection().connect("gc");
				new LocalConnection().connect("gc");
			} catch (e:Error) {
			}
		}
	}
}