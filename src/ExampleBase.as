package 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.config.LightSetting;
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
		public var buttons:LabelButtonList;
		private var centerZ:Number;
		private var distance:Number;
		
		public function ExampleBase(centerZ:Number = 0, distance:Number = 150, addDefaultLight:Boolean = true) 
		{
			this.centerZ = centerZ;
			this.distance = distance;
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
			stage.color = 0x0;
			
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			
			if (addDefaultLight)
			{
				scene.root.addChild(new AmbientLight(0xffffff, 0.7));
				scene.root.addChild(new DirectionalLight(0xffffff, 0.8)).lookAtXYZ(10, 10, -10);
			}
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			scene.startRendering();
			scene.view.backgroundColor = 0x333333;
			scene.view.startAutoResize(stage);
			scene.setTPVController(stage, -90, 35, distance, 0, 0, centerZ);
			
			LightSetting.numDirectionalLights = 2;
			LightSetting.numOmniLights = 0;
			
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