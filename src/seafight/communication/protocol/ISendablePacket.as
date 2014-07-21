package seafight.communication.protocol
{
	public interface ISendablePacket extends IPacket
	{
		function writeImpl():void;
	}
}