package gamesdk.tools.atf
{
	import flash.utils.ByteArray;

	public class ATFNode
	{
		public var xml:XML;
		public var byte:ByteArray;
		public function ATFNode(xml:XML,byte:ByteArray)
		{
			this.xml = xml;
			this.byte = byte;
		}
	}
}