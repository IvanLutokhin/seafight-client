package seafight.events
{
	import flash.events.Event;

	public class JsEvent extends Event
	{
		public static const CONNECT:String		= "connect";
		public static const DISCONNECT:String	= "disconnect";
		public static const SOCKET_ERROR:String = "socketError";
		public static const RECEIVE_DATA:String = "receiveData";
		
		private var obj:Object;
		
		public function JsEvent(type:String, obj:Object = null) {
			super(type, bubbles, cancelable);
			
			this.obj = obj;
		}
		
		public function get DataObject():Object {
			return this.obj;
		}
	}
}