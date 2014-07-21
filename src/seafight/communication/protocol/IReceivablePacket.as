package seafight.communication.protocol
{
	public interface IReceivablePacket extends IPacket
	{
		function readImpl():void;
	}
}