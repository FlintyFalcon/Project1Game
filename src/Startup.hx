import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.Lib;
import flash.events.Event;
import starling.core.Starling;
import flash.display.BitmapData;

@:bitmap("assets/load.png")
class LoadingImage extends BitmapData { }

class Startup extends Sprite
{
	public var loadingImage:Bitmap;
	
	public function new ()
	{
		super();
		loadingImage = new Bitmap(new LoadingImage(0, 0));
		loadingImage.x = loadingImage.y = 0;
		loadingImage.width = Lib.current.stage.stageWidth;
		loadingImage.height	= Lib.current.stage.stageHeight;
		loadingImage.smoothing = true;
		addChild(loadingImage);
		Lib.current.stage.addEventListener(Event.RESIZE, 
			function(e:Event)
			{
				Starling.current.viewPort = new Rectangle(0, 0, 
				Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
				if (loadingImage != null)
				{
					loadingImage.width = Lib.current.stage.stageWidth;
					loadingImage.height = Lib.current.stage.stageHeight;
				}
			});
		var nStar = new Starling(Root, Lib.current.stage);
		nStar.antiAliasing = 0;
		function onRootCreated(event:Dynamic, root:Root)
		{
			nStar.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			root.start(this);
			nStar.start();
		}
		nStar.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
	}
	
	static function main()
	{
		var stage = Lib.current.stage;
		stage.addChild(new Startup());
	}
}