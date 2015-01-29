import starling.display.Sprite;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Button;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
/*import starling.events.TouchEvent;
import starling.events.TouchPhase;
import flash.ui.Keyboard;*/


/**
* ...
* @author ... Temitope Alaga
* @author ... David Terry 
*/
enum GameState
{
	Menu;
	Play;
	Results;
}
	
class Root extends Sprite
{
	inline static var titleText = "Project 1\n" +
	"By\nTemitope Alaga\n(Enter other team members' names here)";
		
	public static var assets = new AssetManager();
	private var state : GameState = GameState.Menu;
	private var button : Image;
	private var game : Game;
	
	public function new() 
	{	super();}
	
	public function setStageForGame()
	{
		//removes all children from stage
		while(Starling.current.stage.numChildren > 0)
		{Starling.current.stage.removeChildAt(0);}	
		
		
		switch(state)
		{
			case GameState.Menu://main menu
				haxe.Log.clear();
				var title = new TextField(500,200,titleText);
				title.x = 400; title.y = 0; title.fontSize = 20;
				title.color = 0xffffff;
				Starling.current.stage.addChild(title);
				
				var PlayBox = new MenuButton("Play",button);
				PlayBox.x = 600; PlayBox.y = 300;
				PlayBox.addEventListener(Event.TRIGGERED, 
				function (e:Event)
				{
					state = Play;
					setStageForGame();
				});
				
			case GameState.Play://game
				game = new Game(this);
				/*var list : Array<UInt> = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff];
				for(i in 0...5)
				{	
					var but = new GameButton(list[i],button,game);
					but.x = 100+(i*100); but.y = 300;
				}*/
				Starling.current.stage.addEventListener(Event.ENTER_FRAME, gameUpdate);
				Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, checkInput);
				var Arrow = new Image(assets.getTexture("arrows"));
				Starling.current.stage.addChild(Arrow);
				Arrow.x = 500; Arrow.y = 300;
				Arrow.scaleX = Arrow.scaleY = 5;
			case GameState.Results://results
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, gameUpdate);
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkInput);
				haxe.Log.clear();
				trace("Time's Up!");
				trace(game.getScore());
				trace("Do you want to play again?");
				
				var RestartBox = new MenuButton("Restart",button);
				RestartBox.x = 600; RestartBox.y = 300;
				RestartBox.fontSize = 25;
				RestartBox.scaleX = RestartBox.scaleY = 3;
				RestartBox.addEventListener(Event.TRIGGERED, 
				function (e:Event)
				{
					state = Menu;
					setStageForGame();
				});
		}
	}
	
	public function start(startup:Startup)
	{
		assets.enqueue("assets/play.png");
		assets.enqueue("assets/arrows.png");
		assets.enqueue("assets/checkMark.png");
		assets.enqueue("assets/redX.png");
		assets.loadQueue(function (r:Float)
		{
			if(r == 1)
			{
			Starling.juggler.tween(startup.loadingImage, 0.5, 
			{
				transition: Transitions.EASE_OUT,
				delay: 1.0,
				alpha: 0,
				onComplete: function() 
				{
					startup.removeChild(startup.loadingImage);
					button = new Image(assets.getTexture("play"));
					setStageForGame();
				}
			});
			}
		});
	}
	
	private function gameUpdate()
	{
		haxe.Log.clear();
		trace(game.getTimeLeft());
	}
	
	public function gameDone()
	{	
		state = Results;
		setStageForGame();
	}
	
	private function checkInput(e:KeyboardEvent)
	{
		trace("Input checked: " + e.keyCode);
		switch(e.keyCode)
		{
			case Keyboard.UP:
				game.checkMatch(0xffff00);
			case Keyboard.DOWN:
				game.checkMatch(0x00ff00);
			case Keyboard.LEFT:
				game.checkMatch(0x0000ff);
			case Keyboard.RIGHT:
				game.checkMatch(0xff0000);
		}
	}
}

class MenuButton extends Button
{
	public function new(t:String,tex:Image)
	{	
		super(tex.texture,t);
		color = 0x333333;//grey
		fontColor = 0xffffff;//white
		fontSize = 50;
		Starling.current.stage.addChild(this);
	}
}

class GameButton extends Button
{
	private var game : Game;
	public function new(c:UInt,i:Image,g:Game)
	{
		super(i.texture);
		color = c;
		game = g;
		this.addEventListener(Event.TRIGGERED, 
		function(e:Event){game.checkMatch(c);});
		Starling.current.stage.addChild(this);
	}
}