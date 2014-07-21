package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class SystemMessagePacket extends ReceivablePacket
	{
		private var messageId:int;
		
		public function get MessageId():int { return this.messageId; }
		
		public override function get PacketID():int { return 0x7D; }		
							
		public override function readImpl():void {
			this.messageId = this.readByte();
		}
	}
}