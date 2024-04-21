package states.editors;

import psychlua.FunkinLua;
import openfl.net.FileFilter;
import flixel.addons.display.FlxBackdrop;
import flash.geom.Rectangle;
import haxe.Json;
import haxe.format.JsonParser;
import haxe.io.Bytes;
import flixel.FlxObject;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxSort;
import lime.media.AudioBuffer;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.Assets as OpenFlAssets;
import backend.Song;
import backend.Section;
import backend.StageData;
import objects.Note;
import objects.StrumNote;
import objects.NoteSplash;
import objects.HealthIcon;
import objects.AttachedSprite;
import objects.Character;
import substates.Prompt;
#if sys
import flash.media.Sound;
#end

class NewChartingState extends MusicBeatState
{
	// background shit
	var backgroundColor:FlxColor = 0xff71a876;

	var scrollgridcolor:Dynamic = 0x33FFFFFF;
	var gradient:FlxSprite;
	var scrollgrid:FlxBackdrop;

	// file shit
	var _file:FileReference;

	// ui shit
	var zoom:Int = 1;
	var zoomList:Array<Float> = [0.25, 0.5, 1, 2, 3, 4, 6, 8, 12, 16, 24];
	var curZoom:Int = 2;

	var curSec:Int = 0;
	var sectionBeats:Int = 4;

	public static var GRID_SIZE:Int = 40;

	var sectionLines:FlxTypedGroup<FlxSprite>;
	var gridLayer:FlxTypedGroup<FlxSprite>;

	var curSelectedNote:Array<Dynamic> = null;

	var gridBG:FlxSprite;
	var strumLine:FlxSprite;

	var columns:Int = 9;

	var UI_box:FlxUITabMenu;

	var characters:Array<String> = Mods.mergeAllTextsNamed('data/characterList.txt', Paths.getSharedPath());

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;

	var playbackSpeed:Float = 1;

	// song shit
	var _song:SwagSong;

	var currentSongName:String;

	var playingSong:Bool = false;

	var vocals:FlxSound = null;
	var opponentVocals:FlxSound = null;

	override public function create()
	{
		trace('You are in the Chart Editor!! Woah!');

		FlxG.mouse.visible = true;

		var background:FlxSprite = new FlxSprite(0, 0, Paths.image('menuDesat'));
		background.screenCenter();
		background.color = backgroundColor;
		add(background);

		gradient = new FlxSprite(0, 0).loadGraphic(Paths.image('chartEditor/gradientSprite'));
		// gradient.setPosition(0, ((FlxG.height * 4) * -1));
		gradient.scrollFactor.set(0, 0);
		gradient.updateHitbox();
		gradient.visible = ClientPrefs.data.editorGradVisible;
		// gradient.alpha = 1;
		add(gradient);

		scrollgrid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, scrollgridcolor, 0x0));
		scrollgrid.velocity.set(40, 40);
		scrollgrid.alpha = 0;
		FlxTween.tween(scrollgrid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(scrollgrid);

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		if (_song == null)
		{
			Difficulty.resetList();
			_song = {
				song: 'Test',
				notes: [],
				events: [],
				bpm: 150.0,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				gfVersion: 'gf',
				speed: 1,
				stage: 'stage'
			};
			// addSection();
			PlayState.SONG = _song;
		}

		var tabs = [
			{name: "Visual", label: 'Visual'},
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'},
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(600, 350);
		UI_box.x = FlxG.width - UI_box.width - 16;
		UI_box.y = 25;
		UI_box.scrollFactor.set();

		add(UI_box);

		characterListShit();

		dataUI();
		noteUI();
		sectionUI();
		songUI();
		visualUI();

		gridBG = FlxGridOverlay.create(1, 1, columns, (sectionBeats * 4 * zoom)); /*columns, Std.int(getSectionBeats() * 4 * zoomList[curZoom])*/
		gridBG.antialiasing = false;
		gridBG.scale.set(GRID_SIZE, GRID_SIZE);
		gridBG.updateHitbox();
		gridBG.setPosition(UI_box.x - (gridBG.width * 1.5) - 8, 0);
		gridBG.screenCenter(Y);
		add(gridBG);

		gridLayer = new FlxTypedGroup<FlxSprite>();
		add(gridLayer);
		sectionLines = new FlxTypedGroup<FlxSprite>();
		add(sectionLines);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(GRID_SIZE * 9), 4, FlxColor.RED);
		strumLine.setPosition(gridBG.x, gridBG.y);
		add(strumLine);

		updateSectionLines();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (sectionBeats != stepperBeats.value)
		{
			sectionBeats = Std.int(stepperBeats.value);
			trace('sus');
			updateSectionLines();
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			if (vocals != null)
				vocals.play();
			if (opponentVocals != null)
				opponentVocals.play();
			pauseAndSetVocalsTime();
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.music.play();
				if (vocals != null)
					vocals.play();
				if (opponentVocals != null)
					opponentVocals.play();
			}
			else
				FlxG.sound.music.pause();
		}

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) / zoomList[curZoom] % (Conductor.stepCrochet * 16)) / (getSectionBeats() / 4);

		super.update(elapsed);
	}

	function pauseAndSetVocalsTime()
	{
		if (vocals != null)
		{
			vocals.pause();
			vocals.time = FlxG.sound.music.time;
		}

		if (opponentVocals != null)
		{
			opponentVocals.pause();
			opponentVocals.time = FlxG.sound.music.time;
		}
	}

	function loadSong():Void
	{

		var characterData:Dynamic = {
			iconP1: null,
			iconP2: null,
			vocalsP1: null,
			vocalsP2: null
		};
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (vocals != null)
		{
			vocals.stop();
			vocals.destroy();
		}
		if (opponentVocals != null)
		{
			opponentVocals.stop();
			opponentVocals.destroy();
		}

		vocals = new FlxSound();
		opponentVocals = new FlxSound();
		try
		{
			var playerVocals = Paths.voices(currentSongName,
				(characterData.vocalsP1 == null || characterData.vocalsP1.length < 1) ? 'Player' : characterData.vocalsP1);
			vocals.loadEmbedded(playerVocals != null ? playerVocals : Paths.voices(currentSongName));
		}
		vocals.autoDestroy = false;
		FlxG.sound.list.add(vocals);

		opponentVocals = new FlxSound();
		try
		{
			var oppVocals = Paths.voices(currentSongName,
				(characterData.vocalsP2 == null || characterData.vocalsP2.length < 1) ? 'Opponent' : characterData.vocalsP2);
			if (oppVocals != null)
				opponentVocals.loadEmbedded(oppVocals);
		}
		opponentVocals.autoDestroy = false;
		FlxG.sound.list.add(opponentVocals);

		// generateSong();
		FlxG.sound.music.pause();
		Conductor.songPosition = sectionStartTime();
		FlxG.sound.music.time = Conductor.songPosition;

		var curTime:Float = 0;
		// trace(_song.notes.length);
		if (_song.notes.length <= 1) // First load ever
		{
			trace('first load ever!!');
			while (curTime < FlxG.sound.music.length)
			{
				// addSection();
				curTime += (60 / _song.bpm) * 4000;
			}
		}
	}

	function getYfromStrum(strumTime:Float, doZoomCalc:Bool = true):Float
	{
		var leZoom:Float = zoomList[curZoom];
		if (!doZoomCalc)
			leZoom = 1;
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height * leZoom);
	}

	public function dataUI()
	{
		var tab_grp = new FlxUI(null, UI_box);
		tab_grp.name = "Data";

		UI_box.addGroup(tab_grp);
	}

	public function noteUI()
	{
		var tab_grp = new FlxUI(null, UI_box);
		tab_grp.name = "Note";

		UI_box.addGroup(tab_grp);
	}

	var stepperBeats:FlxUINumericStepper;

	public function sectionUI()
	{
		var tab_grp = new FlxUI(null, UI_box);
		tab_grp.name = "Section";

		stepperBeats = new FlxUINumericStepper(10, 30, 1, 4, 1, 7, 2);
		stepperBeats.value = sectionBeats;
		stepperBeats.name = 'section_beats';

		tab_grp.add(new FlxText(stepperBeats.x, stepperBeats.y - 15, 0, 'Section Beats:'));
		tab_grp.add(stepperBeats);

		UI_box.addGroup(tab_grp);
	}

	var UI_songTitle:FlxUIInputText;

	public function songUI()
	{
		var tab_grp = new FlxUI(null, UI_box);
		tab_grp.name = "Song";

		UI_songTitle = new FlxUIInputText(10, 30, 100, _song.song, 8);

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(UI_songTitle.x + UI_songTitle.width + 4, UI_songTitle.y, 1, 1, 1, 400, 3);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var player1DropDown = new FlxUIDropDownMenu(10, UI_songTitle.y + 45, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true),
			function(character:String)
			{
				_song.player1 = characters[Std.parseInt(character)];
			});
		player1DropDown.selectedLabel = _song.player1;

		var gfVersionDropDown = new FlxUIDropDownMenu(player1DropDown.x + player1DropDown.width + 10, player1DropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.gfVersion = characters[Std.parseInt(character)];
		});
		gfVersionDropDown.selectedLabel = _song.gfVersion;

		var player2DropDown = new FlxUIDropDownMenu(gfVersionDropDown.x + gfVersionDropDown.width + 10, gfVersionDropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
		});
		player2DropDown.selectedLabel = _song.player2;

		tab_grp.add(new FlxText(UI_songTitle.x, UI_songTitle.y - 15, 0, 'Song Name:'));
		tab_grp.add(UI_songTitle);
		tab_grp.add(new FlxText(stepperBPM.x, stepperBPM.y - 15, 0, 'BPM:'));
		tab_grp.add(stepperBPM);
		tab_grp.add(new FlxText(player1DropDown.x, player1DropDown.y - 15, 0, 'Boyfriend:'));
		tab_grp.add(player1DropDown);
		tab_grp.add(new FlxText(gfVersionDropDown.x, gfVersionDropDown.y - 15, 0, 'Girlfriend:'));
		tab_grp.add(gfVersionDropDown);
		tab_grp.add(new FlxText(player2DropDown.x, player2DropDown.y - 15, 0, 'Opponent:'));
		tab_grp.add(player2DropDown);

		UI_box.addGroup(tab_grp);
	}

	public function visualUI()
	{
		var tab_grp = new FlxUI(null, UI_box);
		tab_grp.name = "Visual";

		UI_box.addGroup(tab_grp);
	}

	public function characterListShit()
	{
		#if MODS_ALLOWED
		var directories:Array<String> = [
			Paths.mods('characters/'),
			Paths.mods(Mods.currentModDirectory + '/characters/'),
			Paths.getSharedPath('characters/')
		];
		for (mod in Mods.getGlobalMods())
			directories.push(Paths.mods(mod + '/characters/'));
		#else
		var directories:Array<String> = [Paths.getSharedPath('characters/')];
		#end

		var tempArray:Array<String> = [];
		for (character in characters)
		{
			if (character.trim().length > 0)
				tempArray.push(character);
		}

		#if MODS_ALLOWED
		for (i in 0...directories.length)
		{
			var directory:String = directories[i];
			if (FileSystem.exists(directory))
			{
				for (file in FileSystem.readDirectory(directory))
				{
					var path = haxe.io.Path.join([directory, file]);
					if (!FileSystem.isDirectory(path) && file.endsWith('.json'))
					{
						var charToCheck:String = file.substr(0, file.length - 5);
						if (charToCheck.trim().length > 0 && !charToCheck.endsWith('-dead') && !tempArray.contains(charToCheck))
						{
							tempArray.push(charToCheck);
							characters.push(charToCheck);
						}
					}
				}
			}
		}
		#end
		tempArray = [];
	}

	public function updateSectionLines()
	{
		sectionLines.clear();

		for (i in 0...5)
		{
			var beatsep:FlxSprite = new FlxSprite(gridBG.x, (GRID_SIZE * (4 * zoom)) * i).makeGraphic(1, 1, 0xFF8D0000);
			beatsep.scale.x = gridBG.width;
			beatsep.updateHitbox();
			sectionLines.add(beatsep);
		}
	}

	function sectionStartTime(add:Int = 0):Float
	{
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSec + add)
		{
			if (_song.notes[i] != null)
			{
				if (_song.notes[i].changeBPM)
				{
					daBPM = _song.notes[i].bpm;
				}
				daPos += getSectionBeats(i) * (1000 * 60 / daBPM);
			}
		}
		return daPos;
	}

	function getSectionBeats(?section:Null<Int> = null)
	{
		if (section == null)
			section = curSec;
		var val:Null<Float> = null;

		if (_song.notes[section] != null)
			val = _song.notes[section].sectionBeats;
		return val != null ? val : 4;
	}
}
