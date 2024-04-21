package states;

import backend.WeekData;
import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;

class Retry extends MusicBeatState
{
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	var charX:Float = 0;
	var charY:Float = 0;
	var retry:Alphabet = null;

	override function create()
	{

		Conductor.songPosition = 0;

		var text:Array<Array<String>> = [
			['This approach', 'excites me', 'Shall we go again?'],
			['A new game to play', 'with an older face', 'to greet'],
			['Nothing like the', 'first round', 'Or am I mistaken?']

		];

		retry = new Alphabet(0, 0, 'I better not see you again', true);
		retry.text += (FlxG.save.data.pussyName) ? '\nPussy' : '\n'+Main.usrName;
		retry.color = FlxColor.RED;
		retry.screenCenter();
		//retry.setAlignmentFromString('CENTER');
		add(retry);

		retry.visible = true;
		// new FlxTimer().start(5, Void-> {retry.visible = true;});

		// FlxG.sound.play(Paths.sound(deathSoundName));
		// FlxG.camera.scroll.set();
		// FlxG.camera.target = null;

		camFollow = new FlxObject(0, 0, 1, 1);
		// camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		// camFollow.setPosition(death.getGraphicMidpoint().x, death.getGraphicMidpoint().y);
		// FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x, FlxG.camera.scroll.y));
		add(camFollow);

		FlxG.camera.target = null;

		//PlayState.instance.setOnScripts('inGameOver', true);
		//PlayState.instance.callOnScripts('onGameOverStart', []);

		new FlxTimer().start(1, Void ->
		{
			cio();
		});

		super.create();
	}

	function cio()
	{
		isEnding = true;
		//boyfriend.playAnim('deathConfirm', true);
		FlxG.sound.music.stop();
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.4, false, function()
			{
				MusicBeatState.switchState(new PlayState());
			});
		});
		//PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
	}

	public var startedDeath:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		//PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}

		//PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			FlxG.sound.music.stop();
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			//PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	override function destroy()
	{
		//instance = null;
		super.destroy();
	}
}
