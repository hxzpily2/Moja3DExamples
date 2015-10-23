package example06_starling 
{
	import example06_starling.starling.StarlingBackLayer;
	import example06_starling.starling.StarlingFrontLayer;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import net.morocoshi.moja3d.events.Event3D;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.shaders.render.SpecularShader;
	import net.morocoshi.moja3d.view.Scene3D;
	import starling.core.Starling;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * Starling+Moja3Dの表示サンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		private var scene:Scene3D;
		private var parser:M3DParser;
		
		private var starlingBack:Starling;
		private var starlingFront:Starling;
		
		[Embed(source = "asset/teapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		public function ExampleMain() 
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
			scene.setTPVController(stage, -90, 15, 150, 0, 0, 20);
			
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
			
			
			//ライト
			scene.root.addChild(new AmbientLight(0xffffff, 1));
			scene.root.addChild(new DirectionalLight(0xffffff, 1)).lookAtXYZ( -10, 10, -10);
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