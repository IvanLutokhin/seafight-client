package seafight.communication.protocol
{
	import flash.utils.ByteArray;
	
	public class SendablePacket extends AbstractPacket implements ISendablePacket
	{
		protected var data:ByteArray = new ByteArray();
		
		public function get Length():int {
			return PACKET_LENGTH_SIZE + PACKET_ID_SIZE + data.length;
		}
		
		public function get PacketID():int {
			return -1;
		}
		
		public function get Data():ByteArray {
			return this.data;
		}
		
		public function set Data(data:ByteArray):void {
			this.data = data;
		}
		
		public function get Bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeShort(this.Length);
			bytes.writeByte(this.PacketID);
			bytes.writeBytes(this.data, 0, this.data.length);
			
			return bytes;
		}
		
		public function write():Boolean {
			try { this.writeImpl(); }
			catch (e:Error) { trace(e); return false; }
			
			return true;
		}
		
		protected function writeByte(value:int):void {
			this.data.writeByte(value);
		}
		
		protected function writeBytes(bytes:ByteArray, offset:int, length:int):void {
			this.data.writeBytes(bytes, offset, length);
		}
		
		protected function writeShort(value:int):void {
			this.data.writeShort(value);
		}
		
		protected function writeInt(value:int):void {
			this.data.writeInt(value);
		}
		
		protected function writeDouble(value:Number):void {
			this.data.writeDouble(value);
		}
		
		protected function writeString(value:String):void {
			var temp:ByteArray = new ByteArray();
			temp.writeUTFBytes(value);
			this.data.writeShort(temp.length);
			this.data.writeBytes(temp, 0, temp.length);
		}
		
		protected function writeBoolean(value:Boolean):void {
			var b:int = (value) ? 1 : 0;
			this.writeByte(b);
		}
		
		public function writeImpl():void { }		
	}
}