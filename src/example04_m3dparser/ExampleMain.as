package example04_m3dparser 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.ParserMaterial;
	import net.morocoshi.moja3d.materials.TriangleFace;
	import net.morocoshi.moja3d.shaders.render.DistanceColorFogShader;
	import net.morocoshi.moja3d.shaders.render.HalfLambertShader;
	import net.morocoshi.moja3d.shaders.render.ReflectionShader;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * M3Dモデルをパースするサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var parser:M3DParser;
		
		[Embed(source = "asset/primitives.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		public function ExampleMain() 
		{
			super(20, 300);
		}
		
		override public function init():void 
		{
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
			}
			
			//この時点ではテクスチャシェーダーが持つExternalTextureResouceは空っぽなので、
			//M3DParserが持つリソースパック内の画像データを各種リソースに渡す必要があります。
			//これはM3Dデータ内に画像を含めた際に有効になります。
			parser.resourcePack.attachTo(scene.root.getResources(true), false);
			
			//まとめてアップロード
			scene.root.upload(scene.context3D, true);
			
			//アニメーションで、キーフレーム間の補完はしない設定にする
			parser.animationPlayer.interpolationEnabled = false;
		}
		
		override public function tick():void 
		{
			//時間指定でアニメーションを更新させる
			parser.animationPlayer.setTime(getTimer() / 1000);
		}
		
	}

}