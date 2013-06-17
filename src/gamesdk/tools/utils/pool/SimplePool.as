package gamesdk.tools.utils.pool
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 单类型对象池管理
	 * @author hanxianming
	 */
	public class SimplePool
	{
		private var MAX_VALUE:int;
		private var GROWTH_VALUE:int;
		private var pool:Array;
		private var cla:Class;
		
		public function SimplePool(pcla:Class, args:Array, maxPoolSize:uint = 50, growthValue:uint = 10)
		{
			MAX_VALUE = maxPoolSize;
			GROWTH_VALUE = growthValue;
			
			var i:int = maxPoolSize;
			cla = pcla;
			
			pool = [];
			while (--i > -1)
				pool[i] = newClass(cla, args);
		}
		
		public function getObj(... args):*
		{
			if (pool.length > 0)
			{
				return pool.shift();
			}
			
			var i:int = GROWTH_VALUE;
			while (--i > -1)
				pool.unshift(newClass(cla, args));
			return getObj(args);
		
		}
		
		public function dispose(obj:*):void
		{
			if (obj == null || getQualifiedClassName(obj) != getQualifiedClassName(cla))
				return;
			pool[pool.length] = obj;
		}
		
		public function removeObj(obj:*):void
		{
		
		}
		
		public function clearAll():void
		{
		
		}
		
		private function newClass(pcla:Class, args:Array = null):*
		{
			if (args == null)
				return new pcla();
			var obj:*;
			switch (args.length)
			{
				case 0: 
					obj = new pcla();
					break;
				case 1: 
					obj = new pcla(args[0]);
					break;
				case 2: 
					obj = new pcla(args[0], args[1]);
					break;
				case 3: 
					obj = new pcla(args[0], args[1], args[2]);
					break;
				case 4: 
					obj = new pcla(args[0], args[1], args[2], args[3]);
					break;
				case 5: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				case 10: 
					obj = new pcla(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					break;
				default: 
					break;
			}
			return obj;
		}
	}

}