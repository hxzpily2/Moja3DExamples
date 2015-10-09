package example04_m3dparser 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.materials.TriangleFace;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.shaders.render.DistanceColorFogShader;
	import net.morocoshi.moja3d.shaders.render.HalfLambertShader;
	import net.morocoshi.moja3d.shaders.render.ReflectionShader;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import net.morocoshi.moja3d.view.Scene3D;
	
	/**
	 * M3Dモデルをパースするサンプル
	 * 
	 * @author tencho
	 */
	[SWF(width="640", height="480")]
	public class M3DParserExample extends Sprite 
	{
		private var scene:Scene3D;
		private var parser:M3DParser;
		
		[Embed(source = "primitives.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		public function M3DParserExample() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 60;
			stage.color = 0x666666;
			
			scene = new Scene3D();
			scene.addEventListener(Event.COMPLETE, scene_completeHandler);
			scene.init(stage.stage3Ds[0], Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
		}
		
		private function scene_completeHandler(e:Event):void 
		{
			scene.removeEventListener(Event.COMPLETE, scene_completeHandler);
			
			addChild(scene.stats);
			scene.startRendering();
			scene.view.backgroundColor = 0x444444;
			scene.view.startAutoResize(stage);
			scene.setTPVController(stage, -90, 45, 300, 0, 0, 20);
			
			//ライト
			scene.root.addChild(new AmbientLight(0xffffff, 0.3));
			scene.root.addChild(new DirectionalLight(0xffffff, 0.8)).lookAtXYZ( -10, 10, -10);
			
			parser = new M3DParser();
			//パース完了時に呼び出されます
			parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			//専用ツールで書き出しておいたM3DファイルのByteArrayをパースする
			//第二引数にObject3Dを渡しておくと、パースされたオブジェクトがその中にaddChildされます
			parser.parse(new Model, scene.root);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			parser.removeEventListener(Event.COMPLETE, parser_completeHandler);
			
			//パースされた時点では既に各種マテリアルには適当なシェーダーが割り当てられているので表示はできますが、
			//ここではそれをいったんリセットしてシェーダーを1から設定しなおしてみます。
			
			var specularShader:SpecularShader = new SpecularShader(30, 1, false);
			var fogShader:DistanceColorFogShader = new DistanceColorFogShader(0x0, 50, 800, 0, 1);
			var halfLambertShader:HalfLambertShader = new HalfLambertShader();
			
			for each(var material:ParserMaterial in parser.materials)
			{
				material.culling = TriangleFace.BOTH;
				
				//マテリアルに設定された全てのシェーダーを削除
				material.shaderList.removeAllShader();
				//このParserMaterialが持つ基本色もしくは基本テクスチャを貼る
				material.addTextureShader();
				//このParserMaterialがノーマルマップを持っていれば貼る
				material.addNormalMapShader(1);
				
				//床のマテリアルにだけ反射シェーダーを追加します
				if (material.name == "yuka")
				{
					material.shaderList.addShader(new ReflectionShader(0.5, false, 0, 3, 1));
				}
				
				//シェーダーの設定が共通の場合は毎回newする必要はありません。
				material.shaderList.addShader(halfLambertShader);
				material.shaderList.addShader(specularShader);
				material.shaderList.addShader(fogShader);
				
				//この時点ではテクスチャシェーダーが持つExternalTextureResouceは空っぽなので、
				//M3DParserが持つリソースパック内の画像データを各種リソースに渡す必要があります。
				//これはM3Dデータ内に画像を含めた際に有効になります。
				parser.resourcePack.attachTo(material.getResources(), false);
			}
			
			//まとめてアップロード
			scene.root.upload(scene.context3D, true, false);
			
			//アニメーションで、キーフレーム間の補完はしない設定にする
			parser.animationPlayer.interpolationEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			enterFrameHandler(null);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			//時間指定でアニメーションを更新させる
			parser.animationPlayer.setTime(getTimer() / 1000);
		}
		
	}

}