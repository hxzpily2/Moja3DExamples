package example05_animation 
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import net.morocoshi.common.math.random.Random;
	import net.morocoshi.moja3d.animation.MotionController;
	import net.morocoshi.moja3d.animation.MotionData;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.objects.AmbientLight;
	import net.morocoshi.moja3d.objects.DirectionalLight;
	import net.morocoshi.moja3d.objects.Skin;
	import net.morocoshi.moja3d.view.Scene3D;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * アニメーションのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends Sprite 
	{
		private var scene:Scene3D;
		private var parser:M3DParser;
		private var motionController:MotionController;
		private var label:TextField;
		
		[Embed(source = "asset/chara_model.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		[Embed(source = "asset/chara_run.m3d", mimeType = "application/octet-stream")] private var Run:Class;
		[Embed(source = "asset/chara_walk.m3d", mimeType = "application/octet-stream")] private var Walk:Class;
		[Embed(source = "asset/chara_stay.m3d", mimeType = "application/octet-stream")] private var Stay:Class;
		
		public function ExampleMain() 
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.frameRate = 30;
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
			scene.setTPVController(stage, -90, 15, 150, 0, 0, 50);
			
			//ライト
			scene.root.addChild(new AmbientLight(0xffffff, 0.7));
			scene.root.addChild(new DirectionalLight(0xffffff, 0.8)).lookAtXYZ( -10, 10, -10);
			
			parser = new M3DParser();
			parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			
			//専用ツールで書き出しておいたM3DファイルのByteArrayをパースする
			//第二引数にObject3Dを渡しておくと、パースされたオブジェクトがその中にaddChildされます
			parser.parse(new Model, scene.root);
		}
		
		private function parser_completeHandler(e:Event):void 
		{
			parser.removeEventListener(Event.COMPLETE, parser_completeHandler);
			
			//まとめてアップロード
			scene.root.upload(scene.context3D, true, false);
			
			//モーションを適用するスキンを特定しておきます
			var skinObject:Skin = parser.hierarchy[2] as Skin;
			
			//各種モーションデータをパースします。
			//第二引数では補完方法がベジェ曲線だった場合に曲線上に打つキーフレームの間隔を秒単位で指定します。
			var bezierCurveInterval:Number = 1.0 / 30;
			var runMotion:MotionData = M3DParser.parseMotion(new Run, bezierCurveInterval);
			var walkMotion:MotionData = M3DParser.parseMotion(new Walk, bezierCurveInterval);
			var stayMotion:MotionData = M3DParser.parseMotion(new Stay, bezierCurveInterval);
			
			motionController = new MotionController();
			//アニメーションする対象を含んだオブジェクトを指定します。今回はSkinオブジェクトを渡します。
			motionController.setObject(skinObject);
			
			//各種モーションデータを登録します。再生する時はここで設定したIDを使います。
			motionController.addMotion("run", runMotion, 0.3, 1.33);
			motionController.addMotion("walk", walkMotion);
			motionController.addMotion("stay", stayMotion);
			
			//とりあえず適当なモーションを再生しておきます。
			//初回モーション再生時はモーションブレンドができないので第二引数は反映されません。
			motionController.changeMotion("stay", 0, 0);
			
			createButtons();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			enterFrameHandler(null);
		}
		
		private function createButtons():void 
		{
			label = new TextField();
			label.x = 95;
			label.defaultTextFormat = new TextFormat(null, 12, 0xffffff);
			label.autoSize = TextFieldAutoSize.LEFT;
			
			stage.addChild(label);
			var list:LabelButtonList = new LabelButtonList(true, 10, 80);
			list.setPosition(10, 170);
			list.addButton("STAY", changeMotion_clickHandler, ["stay"]);
			list.addButton("WALK", changeMotion_clickHandler, ["walk"]);
			list.addButton("RUN", changeMotion_clickHandler, ["run"]);
			list.addButton("PLAY", play_clickHandler, []);
			list.addButton("STOP", stop_clickHandler, []);
			list.addButton("RANDOM", random_clickHandler, []);
			addChild(list);
		}
		
		private function random_clickHandler():void 
		{
			motionController.setTime(Random.number(0, motionController.current.timeLength));
		}
		
		private function play_clickHandler():void 
		{
			motionController.play();
		}
		
		private function stop_clickHandler():void 
		{
			motionController.stop();
		}
		
		private function changeMotion_clickHandler(motionID:String):void 
		{
			//モーション切り替え
			motionController.changeMotion(motionID, 0.5, 0, 0.1);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			//時間指定でアニメーションを更新させる
			motionController.update();
			label.text = String(motionController.getFrame());
		}
		
	}

}