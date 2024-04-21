package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

class SystemName extends MusicBeatState
{
	public static var leftState:Bool = true;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"I'm Going to read your system name in this.\n\nDo you want me to?\n(Enter to be a pussy, Escape to be a man)\n\n",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		if (FlxG.save.data.censorSysName == null) FlxG.save.data.censorSysName = false;

		new FlxTimer().start(3.0, function(tmr:FlxTimer){ trace('ieksijf'); leftState = true; });
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.save.data.censorSysName = true;
					FlxG.save.data.pussyName = FlxG.save.data.censorSysName;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					warnText.text = "Pussy";
					warnText.screenCenter(Y);
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {FlxG.save.data.censorSysName = false;
					FlxG.save.data.pussyName = FlxG.save.data.censorSysName;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					warnText.text = "That's what i'm talking about "+ Main.usrName;
					warnText.screenCenter(Y);
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
