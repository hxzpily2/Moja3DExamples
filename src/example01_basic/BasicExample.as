package example01_basic 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * 基本
	 * 
	 * @author tencho
	 */
	public class BasicExample extends Sprite 
	{
		private var scene:Scene3D;
		private var sphere:Sphere;
		private var plane:Plane;
		
		[Embed(source = "wood.jpg")] private var Wood:Class;
		
		public function BasicExample() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.color = 0x222222;
			
			
			//最初にビューポート、カメラ、ワールド空間などがセットになったScene3Dを作成する
			scene = new Scene3D();
			
			//初期化に成功すると呼び出される
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			
			//初期化開始。プロファイルにContext3DProfile.STANDARD～を設定するとAGAL2モードになる。
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.STANDARD);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			
			//ビューポートをStageに配置すると3D画面が表示される
			addChild(scene.view);
			//Stats表示
			addChild(scene.stats);
			
			
			//ビューポートの位置とサイズと背景色を設定
			scene.view.x = 5;
			scene.view.y = 5;
			scene.view.setSize(600, 400);
			scene.view.backgroundColor = 0x445544;
			
			
			//レンダリングに使用されるカメラの向きを設定
			scene.camera.setPositionXYZ(0, 100, 75);
			scene.camera.lookAtXYZ(0, 0, 0);
			
			
			//平行光源と環境光をScene3D.rootに追加する
			var sunLight:DirectionalLight = new DirectionalLight(0xffffff, 1.5);
			sunLight.setPositionXYZ(40, 40, 40);
			sunLight.lookAtXYZ(0, 0, 0);
			scene.root.addChild(sunLight);
			scene.root.addChild(new AmbientLight(0xffffff, 0.3));
			
			
			//MaterialクラスのshaderListに各種シェーダーを追加してマテリアルを作成する
			var material1:Material = new Material();
			material1.shaderList.addShader(new FillShader(0x2299aa, 1));//基本色
			material1.shaderList.addShader(new LambertShader());//光源による陰影付け
			material1.shaderList.addShader(new SpecularShader(50, 0.7, false, true, true));//光沢
			
			var material2:Material = new Material();
			var bitmapData:BitmapData = Bitmap(new Wood()).bitmapData;
			var textureResource:ImageTextureResource = new ImageTextureResource(bitmapData);
			material2.shaderList.addShader(new TextureShader(textureResource, null));//画像テクスチャ
			material2.shaderList.addShader(new LambertShader());//光源による陰影付け
			
			//プリミティブを作成し、マテリアルを設定する
			sphere = new Sphere(25, 6, 4, material1);
			sphere.x = -40;
			plane = new Plane(50, 35, 1, 1, 0.5, 0.5, true, material2, material2);
			plane.x = 40;
			
			//モデルをScene3D.rootに追加する
			scene.root.addChild(sphere);
			scene.root.addChild(plane);
			
			//モデルの表示に必要なリソースをアップロードする
			sphere.upload(scene.context3D, false, false);
			plane.upload(scene.context3D, false, false);
			
			
			//毎フレーム処理
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			//モデルの回転
			sphere.rotationZ += 0.02;
			plane.rotationX += 0.03;
			
			//レンダリング
			scene.render();
		}
		
	}

}