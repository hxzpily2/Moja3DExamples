package 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * ...
	 * @author tencho
	 */
	public class ExampleBase extends Sprite 
	{
		public var scene:Scene3D;
		private var centerZ:Number;
		private var distance:Number;
		private var background:uint;
		public var buttons:LabelButtonList;
		
		public function ExampleBase(height:Number = 0, distance:Number = 150, frameRate:Number = 30, background:uint = 0x444444, profile:String = Context3DProfile.BASELINE) 
		{
			centerZ = height;
			this.distance = distance;
			this.background = background;
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = frameRate;
			stage.color = background;
			
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, profile);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			scene.startRendering();
			scene.view.backgroundColor = background;
			scene.view.startAutoResize(stage);
			scene.setTPVController(stage, -90, 35, distance, 0, 0, centerZ);
			
			scene.root.addChild(new AmbientLight(0xffffff, 0.7));
			scene.root.addChild(new DirectionalLight(0xffffff, 0.8)).lookAtXYZ(10, 10, -10);
			
			buttons = new LabelButtonList(true, 10, 80);
			buttons.setPosition(10, 170);
			addChild(buttons);
			
			init();
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			tick();
		}
		
		public function tick():void
		{
			
		}
		
		public function init():void
		{
			
		}
		
	}

}