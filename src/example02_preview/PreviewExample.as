package example02_preview 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * とりあえずモデルを表示して、確認したい人向けの簡易設定
	 * 
	 * @author tencho
	 */
	[SWF(width="640", height="480")]
	public class PreviewExample extends Sprite 
	{
		private var scene:Scene3D;
		
		public function PreviewExample() 
		{
			//シーンの初期化
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.STANDARD);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			
			//毎フレームレンダリングさせる
			scene.startRendering();
			
			//ステージのリサイズに合わせてビューポートを自動リサイズ
			scene.view.startAutoResize(stage);
			
			//カメラをマウスドラッグでくるくるさせる
			scene.setTPVController(stage, -90, 45, 150);
			
			//もしくるくるではなく空間内をキー操作で飛行したい場合はこっち
			//scene.setFPVController(stage, false, 5);
			
			//適当にメッシュ生成
			for (var i:int = 0; i < 30; i++) 
			{
				//とりあえず色を貼りたいだけならFillMaterial
				var rgb:uint = int(Math.random() * 0xffffff);
				var mesh:Sphere = new Sphere(10, 6, 4, new FillMaterial(rgb, 1, false));
				mesh.setPositionXYZ(Math.random() * 100 - 50, Math.random() * 100 - 50, Math.random() * 100 - 50);
				scene.root.addChild(mesh);
			}
			
			//シーン内にある全てのリソースをまとめてアップロード
			scene.root.upload(scene.context3D, true, false);
		}
		
	}

}