package example18_mouseinteraction 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import net.morocoshi.common.graphics.Palette;
	import net.morocoshi.moja3d.events.MouseEvent3D;
	import net.morocoshi.moja3d.loader.M3DParser;
	import net.morocoshi.moja3d.materials.preset.FillMaterial;
	import net.morocoshi.moja3d.objects.Line3D;
	import net.morocoshi.moja3d.objects.Mesh;
	import net.morocoshi.moja3d.objects.Object3D;
	import net.morocoshi.moja3d.primitives.Cube;
	import net.morocoshi.moja3d.primitives.Plane;
	import net.morocoshi.moja3d.primitives.Sphere;
	import net.morocoshi.moja3d.resources.LineSegment;
	import net.morocoshi.moja3d.shaders.ShaderList;
	import net.morocoshi.moja3d.shaders.render.FillShader;
	import net.morocoshi.moja3d.shaders.render.VertexColorShader;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * マウスイベントのサンプル
	 * 
	 * @author tencho
	 */
	public class ExampleMain extends ExampleBase 
	{
		[Embed(source = "asset/teapot.m3d", mimeType = "application/octet-stream")] private var Model:Class;
		
		private var faceLine:Line3D;
		private var normalLine:Object3D;
		
		public function ExampleMain() 
		{
			super(30, 300);
		}
		
		override public function init():void 
		{
			scene.view.backgroundColor = 0x111111;
			
			//各種プリミティブの生成（ティーポットは頂点アルファを無効にすることでdrawCallを減らしてます）
			var teapot:Mesh = new M3DParser().parse(new Model).objects[0] as Mesh;
			var teapotShader:ShaderList = teapot.surfaces[0].material.shaderList;
			FillShader(teapotShader.getShaderAs(FillShader)).color = 0x333333;
			VertexColorShader(teapotShader.getShaderAs(VertexColorShader)).alphaBlend = "";
			var cube:Cube = new Cube(50, 50, 50, 1, 1, 1, new FillMaterial(0x333333, 1, true));
			var ball:Sphere = new Sphere(35, 16, 12, new FillMaterial(0x333333, 1, true));
			var plane:Plane = new Plane(350, 150, 1, 1, 0.5, 0.5, false, new FillMaterial(0x252525, 1, true), null);
			
			//三角ポリゴン用ライン
			faceLine = new Line3D();
			faceLine.zbias = 0.01;
			faceLine.visible = false;
			var seg:LineSegment = faceLine.lineGeometry.addSegment(1);
			seg.addPoint(0, 0, 0);
			seg.addPoint(0, 0, 0);
			seg.addPoint(0, 0, 0);
			seg.close();
			
			//法線用ライン
			normalLine = new Object3D();
			normalLine.mouseEnabled = normalLine.mouseChildren = false;
			normalLine.addChild(new Sphere(2, 4, 4, new FillMaterial(0xff0000, 1, false)));
			var line:Line3D = new Line3D();
			seg = line.lineGeometry.addSegment(2);
			seg.addPoint(0, 0, 0, 0xff0000);
			seg.addPoint(0, -20, 0, 0xffff00);
			normalLine.addChild(line);
			
			scene.root.addChild(ball);
			scene.root.addChild(teapot);
			scene.root.addChild(cube);
			scene.root.addChild(plane);
			scene.root.addChild(faceLine);
			scene.root.addChild(normalLine);
			
			var count:int = -1;
			for each(var mesh:Mesh in [ball, teapot, cube]) 
			{
				mesh.x = count++ * 100;
				mesh.z = -mesh.boundingBox.minZ;
				mesh.rotationZ = 45 / 180 * Math.PI;
				mesh.addEventListener(MouseEvent3D.CLICK, click);
				mesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverOut);
				mesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOverOut);
			}
			scene.addEventListener(MouseEvent3D.MOUSE_MOVE, mouseMove);
			
			scene.root.upload(scene.context3D, true);
			
			//マウスイベントを有効にする
			scene.startMouseInteraction(stage, true, true, 33);
		}
		
		private function mouseMove(e:MouseEvent3D):void 
		{
			//マウス位置に何も無い場合collision=nullになる
			if (e.collision == null)
			{
				//ラインを非表示にする
				faceLine.visible = false;
				normalLine.visible = false;
				return;
			}
			
			//マウス位置にメッシュがあれば三角ポリゴンを表示する
			var matrix:Matrix3D = e.collision.target.worldMatrix;
			var a:Vector3D = matrix.transformVector(e.collision.face.a);
			var b:Vector3D = matrix.transformVector(e.collision.face.b);
			var c:Vector3D = matrix.transformVector(e.collision.face.c);
			var n:Vector3D = matrix.deltaTransformVector(e.collision.face.normal);
			
			var seg:LineSegment = faceLine.lineGeometry.segments[0];
			seg.points[0].setVector3D(a);
			seg.points[1].setVector3D(b);
			seg.points[2].setVector3D(c);
			
			faceLine.lineGeometry.upload(scene.context3D);
			faceLine.visible = true;
			
			normalLine.setPosition3D(e.collision.worldPosition);
			normalLine.lookAt3D(e.collision.worldPosition.add(n));
			normalLine.setScale(scene.camera.getDistance3D(normalLine.getWorldPosition()) / 200);
			normalLine.visible = true;
		}
		
		private function mouseOverOut(e:MouseEvent3D):void 
		{
			var over:Boolean = (e.type == MouseEvent3D.MOUSE_OVER);
			var mesh:Mesh = e.currentTarget as Mesh;
			mesh.colorTransform = Palette.getFillColor(0xffffff, over? 0.2 : 0, mesh.alpha);
		}
		
		private function click(e:MouseEvent3D):void 
		{
			var mesh:Mesh = e.currentTarget as Mesh;
			var shaders:ShaderList = mesh.surfaces[0].material.shaderList;
			FillShader(shaders.getShaderAs(FillShader)).color = 0xffffff * Math.random();
		}
		
	}

}