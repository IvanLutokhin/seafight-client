package seafight.communication.protocol.recvpackets
{
	import seafight.communication.protocol.ReceivablePacket;

	public class ClientStatePacket extends ReceivablePacket
	{
		private var stateCode:int;
		
		public function get StateCode():int { return this.stateCode; }
		
		public override function get PacketID():int { return 0x7E; }		
		
		public override function readImpl():void {
			this.stateCode = this.readByte();
		}
	}
}