package seafight.communication.protocol
{
	import flash.utils.ByteArray;

	public interface IPacket
	{
		function get Length():int;
		
		function get PacketID():int;
		
		function get Data():ByteArray;
		
		function set Data(data:ByteArray):void;
		
		function get Bytes():ByteArray;
	}
}