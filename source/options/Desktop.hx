package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;
import flixel.FlxSprite;

class Desktop extends BaseOptionsMenu
{
	var cursor:FlxTypedGroup<FlxSprite>;

	public function new()
	{
		title = 'Window';
		rpcTitle = 'Desktop Menu'; // for Discord Rich Presence

		// desktopbg

		var option:Option = new Option('Cursor Color', "Set your Cursor Color!", 'cursorColor', 'string', [
			'red', 'orange', 'yellow', 'green', 'lime', 'cyan', 'blue', 'purple', 'pink', 'brown', 'gray', 'white', 'black'
		]);
		addOption(option);

		var option:Option = new Option('Desktop Background', "Set your Desktop Background", 'desktopbg', 'string', ['hill', 'the table']);
		//addOption(option);

		var option:Option = new Option('Cursor Size', "Set your Cursor Size", 'cursorsize', 'float');
		option.minValue = 0.5;
		option.maxValue = 2;
		option.changeValue = 0.1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end
		
		var option:Option = new Option('Check for Updates',
			'Turn this on to check for update previews! when you start the game.',
			'checkForUpdates',
			'bool');
		addOption(option);

		cursor = new FlxTypedGroup<FlxSprite>();

		//FlxG.mouse.visible = true;

		super();
	}

	override function create()
	{
		add(cursor);
		super.create();
	}

	override function update(elapsed:Float)
	{
		var realMouse:Dynamic = FlxG.mouse;

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();

		super.update(elapsed);
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic && !OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}
