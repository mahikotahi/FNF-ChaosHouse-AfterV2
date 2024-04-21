package states;

import lime.app.Application;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	
	var warnText:FlxText;
	var curVersion:String = Std.string(Application.current.meta.get('version'));

	var debugText:FlxText;

	var coolTXT:FlxText;


	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		debugText = new FlxText(10,24, FlxG.width, '', 8);
		debugText.scrollFactor.set();
		add(debugText);

		var coolname:Dynamic = (FlxG.save.data.pussyName) ? 'Stupid!' : Main.usrName;

		var changes:Dynamic = '';
		
		var http = new haxe.Http("https://raw.githubusercontent.com/mahikotahi/FNF-ChaosHouse/main/gitVersion.txt");
		var size:Float = 24;

		http.onData = function (data:String)
		{
			trace(data);
			http = new haxe.Http("https://raw.githubusercontent.com/mahikotahi/FNF-ChaosHouse/main/gitLog.txt");

			http.onData = function (data:String)
			{
				changes = data;
			}

			http.onError = function (error) {
				trace('error: $error');
				changes = '[NULL]';
			}

			http.request();
		}

		http.onError = function (error) {
			trace('error: $error');
		}

		http.request();

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey "+ coolname +',\n\nYou are on  ${curVersion},\nthe update  version is ${TitleState.updateVersion},\nLooks like havent seen some github commits.\nI will List Them:\n\n'+changes+'\n\n(Disable this Menu in Desktop Settings)',
			32);
		warnText.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER);
		warnText.size = 32;
		warnText.screenCenter();
		add(warnText);

		coolTXT = new FlxText(0,0,0, "PRESS Q or E!", 48);
		coolTXT.screenCenter();
		coolTXT.color = 0xFF0000;
		add(coolTXT);
	}

	var camXchange:Float = 0;
	var camYchange:Float = 0;

	var debug:Bool = false;

	override function update(elapsed:Float)
	{
		debugText.visible = debug;
		debugText.text = 'cam Zoom: ${FlxG.camera.zoom}\ncam X change: $camXchange\ncam Y change: $camYchange\n';

		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/mahikotahi/FNF-ChaosHouse/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
			}

			var change:Float = 0.1;

			if (FlxG.keys.pressed.SHIFT)
			{
				change = 1;
			}
			if (FlxG.keys.justReleased.SEVEN)
			{
				debug = !debug;
			}

			if (FlxG.keys.justReleased.Q)
			{
				coolTXT.visible = false;
				FlxG.camera.zoom += change;
			}

			if (FlxG.keys.justReleased.E)
			{
				coolTXT.visible = false;
				FlxG.camera.zoom -= change;
			}


			FlxG.camera.x += camXchange;
			FlxG.camera.y += camYchange;
		}
		super.update(elapsed);
	}
}
