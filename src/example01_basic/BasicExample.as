package example01_basic 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.materials.Material;
	import net.morocoshi.moja3d.materials.TriangleFace;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.resources.ImageTextureResource;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.LambertShader;
	import net.morocoshi.moja3d.shaders.render.OpacityShader;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import net.morocoshi.moja3d.shaders.render.TextureShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * 基本
	 * 
	 * @author tencho
	 */
	[SWF(width="640", height="480")]
	public class BasicExample extends Sprite 
	{
		private var scene:Scene3D;
		private var sphere:Sphere;
		private var plane:Plane;
		
		[Embed(source = "map.png")] private var Map:Class;
		[Embed(source = "wood.jpg")] private var Wood:Class;
		[Embed(source = "icon.png")] private var Icon:Class;
		
		public function BasicExample() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
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
			
			//Stats表示
			addChild(scene.stats);
			
			//ビューポートの位置とサイズと背景色を設定
			scene.view.x = 10;
			scene.view.y = 10;
			scene.view.setSize(620, 460);
			scene.view.backgroundColor = 0x445544;
			
			//レンダリングに使用されるカメラの向きを設定
			scene.camera.setPositionXYZ(0, 100, 75);
			scene.camera.lookAtXYZ(0, 0, 0);
			
			//平行光源と環境光をScene3D.root（ワールド空間）に追加する
			var sunLight:DirectionalLight = new DirectionalLight(0xffffff, 1.5);
			sunLight.setPositionXYZ(40, 40, 40);
			sunLight.lookAtXYZ(0, 0, 0);
			scene.root.addChild(sunLight);
			scene.root.addChild(new AmbientLight(0xffffff, 0.3));
			
			//テクスチャ用リソースを作成（Bitmap、BitmapData、ATFデータなどから作成）
			var diffuse1:ImageTextureResource = new ImageTextureResource(new Wood);
			var opacity1:ImageTextureResource = new ImageTextureResource(new Icon);
			var opacity2:ImageTextureResource = new ImageTextureResource(new Map);
			
			//MaterialクラスのshaderListに各種シェーダーを追加してマテリアルを作成する
			var material1:Material = new Material();
			material1.shaderList.addShader(new TextureShader(diffuse1, opacity1));//テクスチャ（opacityはnullにできる）
			material1.shaderList.addShader(new LambertShader());//光源による陰影付け
			
			var material2:Material = new Material();
			material2.culling = TriangleFace.BOTH;//両面表示
			material2.shaderList.addShader(new FillShader(0x2299aa, 1));//基本色
			material2.shaderList.addShader(new OpacityShader(opacity2));//不透明度マップ
			material2.shaderList.addShader(new LambertShader());//光源による陰影付け
			material2.shaderList.addShader(new SpecularShader(50, 0.7, false, true, true));//光沢
			
			//プリミティブを作成し、マテリアルを貼る
			sphere = new Sphere(35, 12, 8, material2);
			sphere.x = -20;
			sphere.y = -30;
			plane = new Plane(50, 50, 1, 1, 0.5, 0.5, true, material1, material1);
			plane.x = 20;
			plane.y = 20;
			
			//モデルをワールド空間に追加する
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