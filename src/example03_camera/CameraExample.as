package example03_camera 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.Camera3D;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.view.FOVMode;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * カメラの切り替え
	 * 
	 * @author tencho
	 */
	[SWF(width="640", height="480")]
	public class CameraExample extends Sprite 
	{
		private var scene:Scene3D;
		private var camera1:Camera3D;
		private var camera2:Camera3D;
		private var camera3:Camera3D;
		
		public function CameraExample() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
			stage.color = 0x666666;
			
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.STANDARD);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			scene.startRendering();
			scene.view.startAutoResize(stage);
			
			//適当にメッシュ生成
			for (var i:int = 0; i < 30; i++) 
			{
				var rgb:uint = int(Math.random() * 0xffffff);
				var mesh:Sphere = new Sphere(10, 6, 4, new FillMaterial(rgb, 1, false));
				mesh.setPositionXYZ(Math.random() * 100 - 50, Math.random() * 100 - 50, Math.random() * 100 - 50);
				scene.root.addChild(mesh);
			}
			scene.root.upload(scene.context3D, true, false);
			
			camera1 = new Camera3D();
			camera1.setPositionXYZ(70, 70, 70);
			camera1.lookAtXYZ(0, 0, 0);
			camera1.fovX = 95 / 180 * Math.PI;
			camera1.fovY = 75 / 180 * Math.PI;
			
			camera2 = new Camera3D();
			camera2.setPositionXYZ(-50, 50, 90);
			camera2.lookAtXYZ(0, 0, 0);
			camera2.fovX = 95 / 180 * Math.PI;
			camera2.fovY = 75 / 180 * Math.PI;
			
			camera3 = new Camera3D();
			camera3.setPositionXYZ(0, 70, 0);
			camera3.lookAtXYZ(0, 0, 0);
			camera3.fovX = 95 / 180 * Math.PI;
			camera3.fovY = 75 / 180 * Math.PI;
			
			scene.camera = camera1;
			changeMode_clickHandler(FOVMode.VERTICAL);
			
			var y:int = 130;
			addChild(new LabelButton(10, y+=40, "CAMERA 1", changeCamera_clickHandler, [camera1]));
			addChild(new LabelButton(10, y+=40, "CAMERA 2", changeCamera_clickHandler, [camera2]));
			addChild(new LabelButton(10, y+=40, "CAMERA 3", changeCamera_clickHandler, [camera3]));
			addChild(new LabelButton(10, y+=70, "VERTICAL", changeMode_clickHandler, [FOVMode.VERTICAL]));
			addChild(new LabelButton(10, y+=40, "HOLIZONTAL", changeMode_clickHandler, [FOVMode.HOLIZONTAL]));
			addChild(new LabelButton(10, y+=40, "INSCRIBED", changeMode_clickHandler, [FOVMode.INSCRIBED]));
			addChild(new LabelButton(10, y+=40, "CIRCUMSCRIBED", changeMode_clickHandler, [FOVMode.CIRCUMSCRIBED]));
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			//ビューポートの縦横サイズを変化させるアニメーション
			var cos:Number = (Math.cos(getTimer() / 1000) + 1) * 0.5;
			scene.view.width = (cos * 530 + 100) | 0;
			scene.view.height = ((1 - cos) * 370 + 100) | 0;
			scene.view.x = (stage.stageWidth - scene.view.width) * 0.5 | 0;
			scene.view.y = (stage.stageHeight - scene.view.height) * 0.5 | 0;
		}
		
		private function changeMode_clickHandler(mode:String):void
		{
			//Camera3D.fovModeを変更する事でFOVの値をスクリーンのアスペクト比に応じて調整させる事ができます。
			//詳しくはFOVModeクラス内のコメントを参照してください。
			camera1.fovMode = mode;
			camera2.fovMode = mode;
			camera3.fovMode = mode;
		}
		
		private function changeCamera_clickHandler(camera:Camera3D):void 
		{
			//Scene3D.cameraにCamera3Dオブジェクトを代入する事でレンダリング時に使うカメラを変更する事ができます。
			scene.camera = camera;
		}
		
	}

}