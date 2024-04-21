package states;

import objects.CoolMouse;
import flixel.FlxState;
import objects.AttachedSprite;

class CreditsState extends FlxState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var game:PlayState = PlayState.instance;
	var coolwindow:FlxSprite;

	var mouseClickAmount:Int = 0;

	public static var currentSelection:String = '';

	var port:FlxSprite;
	var portText:FlxText = new FlxText(0, 0, 0, "Portilizen\n", 16);

	var jtsf:FlxSprite;
	var jtsfText:FlxText = new FlxText(0,0,0,"jtsf\n",16);

	var djotta:FlxSprite;
	var djottaTXT:FlxText = new FlxText(0,0,0,"Djotta\n",16);

	var haroeyad:FlxSprite;
	var haroeyadT:FlxText = new FlxText(0,0,0,"HeroEyad\n",16);

	var desktop:FlxSprite;
	var terminal:FlxSprite;
	var notepad:FlxSprite;
	var tubeyou:FlxSprite;

	public var controls(get, never):Controls;

	var mouse:FlxSprite;

	private function get_controls()
	{
		return Controls.instance;
	}

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Notepad++", null);
		#end

		persistentUpdate = true;

		var magenta:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('mainmenu/background'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = true;
		// magenta.color = 0xff21d9ee;
		// add(magenta);
		var deskBG:FlxSprite = new FlxSprite(DeskBGShit.x, DeskBGShit.y);
		deskBG.loadGraphic(DeskBGShit.imageLocation);
		deskBG.scale.x = 1.1;
		add(deskBG);

		createCoolIcons();

		coolwindow = new FlxSprite(0, 0);
		coolwindow.loadGraphic(Paths.image('mainmenu/dawindow'));
		coolwindow.screenCenter(XY);
		coolwindow.alpha = 1;
		coolwindow.scale.x = coolwindow.alpha * 2;
		coolwindow.scale.y = coolwindow.alpha * 2;
		add(coolwindow);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		port = new FlxSprite(0, 0).loadGraphic(Paths.image('coolcreds/Portilizen'));
		port.screenCenter();
		port.x -= 120;
		add(port);

		portText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(portText);

		jtsf = new FlxSprite(0, 0).loadGraphic(Paths.image('coolcreds/jtsf'));
		jtsf.screenCenter();
		jtsf.x += 120;
		add(jtsf);

		jtsfText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(jtsfText);

		djotta = new FlxSprite(0, 0).loadGraphic(Paths.image('coolcreds/djotta'));
		djotta.screenCenter();
		djotta.y += 120;
		add(djotta);

		djottaTXT.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(djottaTXT);

		haroeyad = new FlxSprite(0, 0).loadGraphic(Paths.image('coolcreds/haro'));
		haroeyad.screenCenter();
		haroeyad.y += 120;
		add(haroeyad);

		haroeyadT.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(haroeyadT);

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		// add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		// descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		// add(descText);

		// bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		// intendedColor = bg.color;

		

		mouse = new FlxSprite(0, 0);
		mouse.frames = Paths.getSparrowAtlas('mainmenu/cursor');
		mouse.animation.addByPrefix('white', "white", 24);
		mouse.animation.addByPrefix('gray', "gray", 24);
		mouse.animation.addByPrefix('black', "black", 24);
		mouse.animation.addByPrefix('red', "red", 24);
		mouse.animation.addByPrefix('orange', "orange", 24);
		mouse.animation.addByPrefix('yellow', "yellow", 24);
		mouse.animation.addByPrefix('green', "green", 24);
		mouse.animation.addByPrefix('lime', "lime", 24);
		mouse.animation.addByPrefix('cyan', "cyan", 24);
		mouse.animation.addByPrefix('blue', "blue", 24);
		mouse.animation.addByPrefix('purple', "purple", 24);
		mouse.animation.addByPrefix('pink', "pink", 24);
		mouse.animation.addByPrefix('brown', "brown", 24);
		mouse.scale.set(ClientPrefs.data.cursorsize, ClientPrefs.data.cursorsize);
		mouse.animation.play(ClientPrefs.data.cursorColor);
		add(mouse);

		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		portText.setPosition(port.x + 16, port.y + port.height + 16);
		jtsfText.setPosition(jtsf.x + 16, jtsf.y + jtsf.height + 16);
		djottaTXT.setPosition(djotta.x + 16, djotta.y + djotta.height + 16);
		var realMouse:Dynamic = FlxG.mouse;

		mouse.setPosition(realMouse.x, realMouse.y);

		var prevCurSel:String = currentSelection;

		currentSelection = '';

		if (mouse.overlaps(port))
		{
			currentSelection = 'port';
		}
		else if (mouse.overlaps(jtsf))
		{
			currentSelection = 'jtsf';
		}
		else if (mouse.overlaps(djotta))
		{
			currentSelection = 'djotta';
		}
		else if (mouse.overlaps(haroeyad))
		{
			currentSelection = 'HeroEyad';
		}
		/*if (prevCurSel != currentSelection)
				mouseClickAmount = 0;

			if (FlxG.mouse.justReleased && mouseClickAmount != 3)
				mouseClickAmount++; */

		if (FlxG.keys.pressed.SHIFT && FlxG.mouse.pressed)
		{
			switch (currentSelection)
			{
				case 'port':
					port.setPosition(mouse.x - (port.width / 2), mouse.y - (port.height / 2));
					case 'jtsf':
						jtsf.setPosition(mouse.x - (jtsf.width / 2), mouse.y - (jtsf.height / 2));
						case 'djotta':
							djotta.setPosition(mouse.x - (djotta.width / 2), mouse.y - (djotta.height / 2));
							case 'HeroEyad':
								haroeyad.setPosition(mouse.x - (haroeyad.width / 2), mouse.y - (haroeyad.height / 2));
			}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();

		if (!quitting)
		{
			if (creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
			{
				// CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}

			if (controls.BACK)
			{
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
				FlxTween.tween(coolwindow, {alpha: 0}, 1, {
					onUpdate: function(twn:FlxTween)
					{
						coolwindow.scale.x = coolwindow.alpha * 2;
						coolwindow.scale.y = coolwindow.alpha * 2;
						
						port.scale.x = coolwindow.alpha * 2;
						port.scale.y = coolwindow.alpha * 2;
						portText.scale.x = coolwindow.alpha * 2;
						portText.scale.y = coolwindow.alpha * 2;

						jtsf.scale.x = coolwindow.alpha * 2;
						jtsf.scale.y = coolwindow.alpha * 2;
						jtsfText.scale.x = coolwindow.alpha * 2;
						jtsfText.scale.y = coolwindow.alpha * 2;
					}
				});
			}
		}

		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		if (change > 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		curSelected += change;
		if (curSelected < 0)
			curSelected = creditsStuff.length - 1;
		if (curSelected >= creditsStuff.length)
			curSelected = 0;

		var bullShit:Int = 0;

		// descText.text = creditsStuff[curSelected][2];
		// descText.y = FlxG.height - descText.height + offsetThing - 60;

		if (moveTween != null)
			moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	function createCoolIcons()
	{
		terminal = new FlxSprite(20, 70);
		terminal.antialiasing = ClientPrefs.data.antialiasing;
		terminal.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		terminal.animation.addByPrefix('termina', "Terminal", 24);
		terminal.animation.play('termina');
		// add(terminal);

		notepad = new FlxSprite(20, 70 + terminal.height + 20);
		notepad.antialiasing = ClientPrefs.data.antialiasing;
		notepad.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		notepad.animation.addByPrefix('nopa', "Notepad", 24);
		notepad.animation.play('nopa');
		// add(notepad);

		desktop = new FlxSprite(terminal.x + terminal.width + 48, 60);
		desktop.antialiasing = ClientPrefs.data.antialiasing;
		desktop.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		desktop.animation.addByPrefix('desktop', "Animate", 24);
		desktop.animation.play('desktop');
		// add(desktop);

		tubeyou = new FlxSprite(desktop.x + desktop.width + 48, 80);
		tubeyou.antialiasing = ClientPrefs.data.antialiasing;
		tubeyou.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		tubeyou.animation.addByPrefix('yout', "Youtube", 24);
		tubeyou.animation.play('yout');
		// add(tubeyou);
	}
}
