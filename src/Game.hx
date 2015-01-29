import flash.utils.Timer;
import flash.events.TimerEvent;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.core.Starling;
import starling.display.Sprite;

class Game
{
	private var score : UInt;
	private var total : UInt;
	private var timer : Timer;
	private var delay : UInt;
	private var repeat : UInt;
	private var timeLeft : String;
	private var currentText : Image;
	private var answerTimer : Timer;
	private var answer : Image;
	
	public function new(r:Root)
	{
		score = total = 0;
		delay = 1000; repeat = 30;
		timer = new Timer(delay,repeat);
		timeLeft = "Time Left: " + ((delay*repeat)/1000);
		timer.addEventListener(TimerEvent.TIMER, timeUpdate);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
		function(e:Dynamic)
		{	r.gameDone();});
		timer.start();
		answerTimer = new Timer(1000,1);
		answerTimer.addEventListener(TimerEvent.TIMER_COMPLETE,
		function(e:Dynamic)
		{	Starling.current.stage.removeChild(answer);});
		addText();		
	}
	
	public function getTimeLeft() : String {return timeLeft;}
	private function timeUpdate(e:Dynamic)
	{	timeLeft = "Time Left: " + ((delay*--repeat)/1000);}
	
	public function getScore() : String
	{	return "You got " + score + " out of " + total;}
	
	private static function randomText() : String
	{
		return switch(Std.random(4))
		{
			case 0: "redBlank";
			case 1: "greenBlank";
			case 2: "blueBlank";
			default:
			case 3: "yellowBlank";
			//default: "MAGENTA";
		}
	}
	
	private static function randomColor() : Int
	{
		return switch(Std.random(4))
		{
			case 0: 0xff0000;//Red
			case 1: 0x00ff00;//Green
			case 2: 0x0000ff;//Blue
			default:
			case 3: 0xffff00;//Yellow
			//default: 0xff00ff;//Magenta
		}
	}
	
	private function addText()
	{
		var lastColor : UInt = currentText == null ? 0: currentText.color;
		Starling.current.stage.removeChild(currentText);
		currentText = new Image(Root.assets.getTexture(randomText()));
		do
		{
			currentText.color = randomColor();
		}while(lastColor == currentText.color);
		currentText.scaleX = currentText.scaleY = 3;
		currentText.width = 300;
		currentText.x = 350; currentText.y = 100;
		Starling.current.stage.addChild(currentText);
	}
	
	public function checkMatch(c:UInt)
	{
		Starling.current.stage.removeChild(answer);
		++total;
		if(currentText.color == c)
		{
			++score;
			answer = new Image(Root.assets.getTexture("checkMark"));
			Root.assets.playSound("RightSound");
		}
		else 
		{
			answer = new Image(Root.assets.getTexture("redX"));
			Root.assets.playSound("WrongSound");
		}
		answerTimer.reset();
		answerTimer.start();
		Starling.current.stage.addChild(answer);
		answer.x = 200; answer.y = 250;
		answer.scaleX = answer.scaleY = 3;
		addText();
	}
}