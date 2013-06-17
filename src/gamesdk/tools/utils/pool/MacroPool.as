package gamesdk.tools.utils.pool
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 多类型对象池管理
	 * @author hanxianming
	 */
	public class MacroPool
	{
//		private static var pool:Dictionary = new Dictionary();
//		private static var buf:*;
//		
//		public static function getObj(cla:Class, args:Array, maxSize:int = 50, growthValue:uint = 10):*
//		{
//			buf = pool[cla];
//			if (buf == null)
//			{
//				buf = new SimplePool(cla, maxSize, growthValue);
//				pool[cla] = buf;
//			}
//			return buf.getObj();
//		}
//		
//		public static function dispose(obj:*):void
//		{
//			buf = pool[getDefinitionByName(getQualifiedClassName(obj))];
//			if (buf != null)
//				buf.dispose(obj);
//			else
//			{
//				buf = new SimplePool(Class(getDefinitionByName(getQualifiedClassName(obj))), 50, 10);
//				pool[getDefinitionByName(getQualifiedClassName(obj))] = buf;
//				buf.dispose(obj);
//			}
//			obj = null;
//		}
	}
}