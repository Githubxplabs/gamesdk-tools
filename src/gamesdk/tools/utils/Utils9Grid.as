package gamesdk.tools.utils
{
	import gamesdk.tools.ToolsConfig;
	
	/**
	 * 9宫范围处理工具
	 * @author hanxianming
	 */
	public class Utils9Grid
	{
		/** 显示的区域宽度*/
		public var screenW:int = 480;
		/** 显示的区域高度*/
		public var screenH:int = 762;
		/** 地图的总宽度*/
		public var mapW:int = 768;
		/** 地图的总高度*/
		public var mapH:int = 5806;
		/** 地图区块的宽度*/
		public var cellW:int = 256;
		/** 地图区块的高度*/
		public var cellH:int = 256;
		/** 地图区块的很想布局最大块数*/
		public var rowNum:int;
		
		private var _cellX:int;
		private var _cellY:int;
		private var _maxCellX:int;
		private var _maxCellY:int;
		
		private var _gridIndexList:Vector.<int> = new Vector.<int>();
		private var _prevGridIndexs:Object = {};
		
		public function Utils9Grid()
		{
		
		}
		
		/**
		 * 初始化使用九宫范围区域的数据
		 * @param	screenW 显示的区域宽度
		 * @param	screenH 显示的区域高度
		 * @param	mapW 地图的总宽度
		 * @param	mapH 地图的总高度
		 * @param	cellW 地图区块的宽度
		 * @param	cellH 地图区块的高度
		 * @param	 rowNum 地图区块的很想布局最大块数
		 */
		public function init(screenW:int, screenH:int, mapW:int, mapH:int, cellW:int, cellH:int, rowNum:int = 3):void
		{
			this.screenW = screenW;
			this.screenH = screenH;
			this.mapW = mapW;
			this.mapH = mapH;
			this.cellW = cellW;
			this.cellH = cellH;
			this.rowNum = rowNum;
			
			_cellX = Math.ceil(screenW / cellW) + 2;
			_cellY = Math.ceil(screenH / cellH) + 2;
			
			_maxCellX = Math.ceil(mapW / cellW) - _cellX;
			_maxCellY = Math.ceil(mapH / cellH) - _cellY;
		}
		
		/**
		 * 检测九宫范围的区域对象。
		 * 使用的公式。
		 * 被除数=除数×商+余数；
		 * 除数=（被除数-余数）÷商；
		 * 商=（被除数-余数）÷除数；
		 * 余数=被除数-除数×商。
		 * @param	listlegnth 检测的对象范围列表的长度。
		 * @param	px 对象的x坐标。
		 * @param	py 对象的y坐标。
		 * @return 返回区域对象列表的索引值。
		 */
		public function check9Grid(listlegnth:int, px:Number, py:Number):Result9Grid
		{
			var tempCellX:int = Math.min(_maxCellX, Math.abs(int(px / cellW)));
			var tempCellY:int = Math.min(_maxCellY, Math.abs(int(py / cellH)));
			_gridIndexList.length = 0;
			for (var i:int = 0; i < listlegnth; i++)
			{
				var tempX:int = i % (rowNum);
				var tempY:int = int(i / (rowNum));
				if ((tempX >= tempCellX && tempX < tempCellX + _cellX) && (tempY >= tempCellY && tempY < tempCellY + _cellY))
				{
					_gridIndexList[_gridIndexList.length] = i;
					continue;
				}
			}
			var isChange:Boolean = false;
			var len:int = _gridIndexList.length;
			for (var j:int = 0; j < len; j++)
			{
				if (!_prevGridIndexs[_gridIndexList[j]])
				{
					isChange = true;
					break;
				}
			}
			_prevGridIndexs = {};
			for (j = 0; j < len; j++)
			{
				_prevGridIndexs[_gridIndexList[j]] = true;
			}
			return new Result9Grid(_gridIndexList, isChange);
		}
	
	}

}