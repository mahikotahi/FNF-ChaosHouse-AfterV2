package states;

import flixel.FlxSprite;
import flixel.FlxG;
import objects.CoolMouse;

class AchievementDesk extends MusicBeatState
{
	var base:FlxSprite;

	var stick:FlxSprite;
	var buckshot:FlxSprite;

	var coolwindow:FlxSprite;

	var folder:String = 'desktopshit/achievements/';

	var achievementNames:Array<String> = ['stick', 'buckshot']; // for reference
	public static var achievementToggles:Array<Bool> = [false, false];
	var mouse:FlxSprite;

	// LockedAchievement

    public static function unlockAdvancement(identity:Int) 
    {
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.5);
        FlxG.save.data.achieves[identity] = true;
		FlxG.save.flush();

		cool();
    }

	public static function cool()
	{
		achievementToggles = FlxG.save.data.achieves;
		trace(FlxG.save.data.achieves);
		trace(achievementToggles);
	}

	function updateIcons()
	{
		achievementIcon(base, 'BaseAchievement', -1);
		base.setPosition(160, 20);

		achievementIcon(stick, 'StickAchievement', 0);
        stick.setPosition(base.x,base.y);

		achievementIcon(buckshot, 'BuckshotAchievement', 1);
        buckshot.setPosition(stick.x + stick.width + 16,stick.y);

		FlxG.save.data.achieves = achievementToggles;
	}

	public function new()
	{
		if (FlxG.save.data.achieves != null)
		{
			achievementToggles = FlxG.save.data.achieves;
			cool();
		}
		else
		{
			// FlxG.save.data.achieves = achievementToggles;
		}

		super();
	}

	override public function create()
	{
		coolwindow = new FlxSprite(0, 0);
		coolwindow.loadGraphic(Paths.image('mainmenu/dawindow'));
		coolwindow.screenCenter(XY);
		coolwindow.alpha = 0;
		add(coolwindow);

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Achievementa'));
		bg.screenCenter();
		bg.scale.set(0.8, 0.8);
		add(bg);

		base = new FlxSprite(160, 0);
		// add(base);

		stick = new FlxSprite(160, 0);
        add(stick);

		buckshot = new FlxSprite(160, 0);
        add(buckshot);

		updateIcons();

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

		super.create();
	}

	function achievementIcon(obj:FlxSprite, name:String = 'BaseAchievement', achievementID:Int = 0)
	{
		obj.scale.set(0.6, 0.6);

		if (achievementToggles[achievementID])
		{
			obj.frames = Paths.getSparrowAtlas('${folder}${name}');
			obj.animation.addByPrefix('icon', name, 24);
		}
		else
		{
			obj.frames = Paths.getSparrowAtlas('${folder}LockedAchievement');
			obj.animation.addByPrefix('icon', 'LockedAchievement', 24);
		}

		obj.animation.play('icon');
	}

	override public function update(elapsed:Float)
	{
		var realMouse:Dynamic = FlxG.mouse;

		mouse.setPosition(realMouse.x, realMouse.y);

		if (FlxG.keys.justReleased.SEVEN)
		{
			//achievementToggles[0] = !achievementToggles[0];
			updateIcons();
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));

			MusicBeatState.switchState(new MainMenuState());

			FlxTween.tween(coolwindow, {alpha: 0}, 1, {
				onUpdate: function(twn:FlxTween)
				{
					coolwindow.scale.x = coolwindow.alpha * 2;
					coolwindow.scale.y = coolwindow.alpha * 2;
				}
			});
		}

		super.update(elapsed);
	}
}
