package example06_starling 
{
	import example06_starling.starling.StarlingBackLayer;
	import example06_starling.starling.StarlingFrontLayer;
	import net.morocoshi.moja3d.events.Event3D;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import starling.core.Starling;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * Starling+Moja3Dの表示サンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		private var parser:M3DParser;
		
		private var starlingBack:Starling;
		private var starlingFront:Starling;
		
		[Embed(source = "asset/teapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		public function ExampleMain() 
		{
			super(20, 150, 30, 0x666666);
		}
		
		override public function init():void 
		{
			//-----------------------------------------------------------------------------
			//	ここからStarlingの設定
			//-----------------------------------------------------------------------------
			
			//最背面描画用Starling
			starlingBack = new Starling(StarlingBackLayer, stage, null, scene.stage3D);
			starlingBack.enableErrorChecking = true;
			starlingBack.shareContext = true;
            starlingBack.start();
			
			//最前面描画用Starling
			starlingFront = new Starling(StarlingFrontLayer, stage, null, scene.stage3D);
			starlingFront.enableErrorChecking = true;
			starlingFront.shareContext = true;
            starlingFront.start();
			
			//最背面の描画タイミング
			scene.addEventListener(Event3D.CONTEXT_POST_CLEAR, scene_contextPostClearHandler);
			//最前面の描画タイミング
			scene.addEventListener(Event3D.CONTEXT_PRE_PRESENT, scene_contextPrePresentHandler);
			
			//-----------------------------------------------------------------------------
			//	ここまで
			//-----------------------------------------------------------------------------
			
			
			//ティーポット
			new M3DParser().parse(new Model, scene.root).materials[0].shaderList.addShader(new SpecularShader(100, 2, false));
			
			//まとめてアップロード
			scene.root.upload(scene.context3D, true, false);
		}
		
		private function scene_contextPostClearHandler(e:Event3D):void 
		{
			//最背面を描画
			starlingBack.nextFrame();
		}
		
		private function scene_contextPrePresentHandler(e:Event3D):void 
		{
			//最前面を描画
			starlingFront.nextFrame();
		}
		
	}

}