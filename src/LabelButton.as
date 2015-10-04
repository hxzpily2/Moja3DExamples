package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.morocoshi.common.graphics.Palette;
	/**
	 * ...
	 * @author tencho
	 */
	public class LabelButton extends Sprite
	{
		private var label:TextField;
		private var frame:Sprite;
		private var clickCallback:Function;
		private var clickArgs:Array;
		
		public function LabelButton(text:String = "", size:Number = 100, click:Function = null, args:Array = null) 
		{
			clickCallback = click;
			clickArgs = args;
			
			var paddingX:Number = 5;
			var paddingY:Number = 2;
			label = new TextField();
			label.defaultTextFormat = new TextFormat("Meiryo", 14, 0x0, false);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = text;
			label.selectable = false;
			label.x = paddingX
			label.y = paddingY;
			
			frame = new Sprite();
			frame.graphics.beginFill(0xeeeeee);
			var w:Number = Math.max(size, label.textWidth + paddingX * 2 + 5);
			var h:Number = label.textHeight + paddingY * 2 + 3;
			frame.graphics.drawRoundRect(0, 0, w, h, 5, 5);
			label.x = (w - label.textWidth - 5) * 0.5;
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			buttonMode = true;
			mouseChildren = false;
			
			addChild(frame);
			addChild(label);
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			frame.transform.colorTransform = new ColorTransform(0.8, 0.8, 0.8);
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			frame.transform.colorTransform = new ColorTransform();
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (clickCallback != null)
			{
				clickCallback.apply(null, clickArgs);
			}
		}
		
	}

}