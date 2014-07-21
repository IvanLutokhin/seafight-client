package seafight
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="24")]
	public class Main extends Sprite
	{
		public function Main()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			ApplicationFacade.getInstance().init(this);			
		}
	}
}