package gamesdk.tools.utils
{
	
	/**
	 * ...
	 * @author hanxianming
	 */
	public class Result9Grid
	{
		/**9宫范围*/
		public var checked9Grid:Vector.<int>;
		/** 是否发生变化了*/
		public var isChange:Boolean;
		
		public function Result9Grid(checked9Grid:Vector.<int>, isChange:Boolean)
		{
			this.checked9Grid = checked9Grid;
			this.isChange = isChange;
		}
	
	}

}