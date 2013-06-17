package gamesdk.tools.atf
{
	import flash.utils.ByteArray;
	
	/**
	 * 使用工具导出之后，需要用ATFTool.analysis解析ATF资源。
	 * @author autoCreat
	 */
	public class ATFTool
	{
		/**
		 * 从ATF二进制中获取xml配置信息。
		 * @param	byte
		 * @return
		 */
		public static function analysis(byte:ByteArray):ATFNode
		{
			byte.position = byte.length - 4;
			var position:int = byte.readInt();
			byte.position = position;
			var xml:XML = new XML(byte.readUTFBytes(byte.length - position - 4));
			byte.position = 0;
			var byteArrray:ByteArray = new ByteArray();
			byte.readBytes(byteArrray,0,position);
			return new ATFNode(xml,byteArrray);
		}
	}
}
