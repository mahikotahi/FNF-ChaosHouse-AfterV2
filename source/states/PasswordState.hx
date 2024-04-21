package;

import backend.Song;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;
import haxe.Json;
import sys.io.File;

using StringTools;

typedef Passwords = {

    password:String,
    song:String
}


/* Made and Programmed by HeroEyad, Credit me if this is used
 Otherwise I will get Saul Goodman to sue you!
 that's how you do it and you can setup a background or whatever lol!
*/ 

/* EXPLANATION!!
Go to assets/preload/data and make a file named passwords.json
in this file you have to add this kind of template
[
    {
        "password": "anypassword",
        "song": "anysong"
    }
]

if you want to add more then here's another template
[
    {
        "password": "anypassword",
        "song": "anysong"
    },  // you have to add the comma or else it'll crash
    {
        "password": "anypassword2",
        "song": "anysong2"
    }
]

THATS IT. BYE!

*/


class PasswordState extends MusicBeatState
{
    
    var source:Array<Passwords>;

    var inputKey:FlxUIInputText;

    override function create()
    {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        

        // Comment out the line if you don't want the music to change. If not the menu might be silent.
        // FlxG.sound.playMusic(Paths.music("any"));

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
        bg.screenCenter();
        add(bg);

        source = cast Json.parse(File.getContent(Paths.json('passwords')));
        trace(source);

		var check:FlxBackdrop = new FlxBackdrop(Paths.image('checkered'), XY, FlxG.random.int(0, 0), FlxG.random.int(0, 0));
		check.scrollFactor.set(0.3, 0.3);
		check.velocity.set(-10, 0);
		add(check);

        var bar = new FlxSprite(800, 0).makeGraphic(1280, 720, 0xFF000000);
        bar.alpha = 0.5;
        bar.x += 1280;
        bar.screenCenter(XY);
        add(bar);

        var background:FlxSprite = new FlxSprite(10, 50).loadGraphic(Paths.image("bars"));
        background.setGraphicSize(Std.int(background.width * 1));
        background.screenCenter();
        add(background);
    
        // Create an input field for the password
        inputKey = new FlxUIInputText(850, 30, 400, "Enter Password", 24, 0xFF000000, 0xFF1A6AC5);
        inputKey.screenCenter(XY);
        inputKey.visible = true;
        add(inputKey);

        var buttonKey = new FlxButton(850, 450, "Enter", onButtonKey);
        buttonKey.screenCenter(X);
        buttonKey.scale.set(3, 3);
        add(buttonKey);


        FlxG.mouse.visible = true;
    
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
            // FlxG.sound.playMusic(Paths.music("freakyMenu")); // if you used music for this menu
        }
    }

    function onButtonKey()
    {
        // Get the entered password
        var enteredPassword:String = inputKey.text;
            
        for (Passwords in source) {
            if (enteredPassword == Passwords.password) {
                loadSong(Passwords.song);
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                trace('Password correct (' + enteredPassword + ')');
                FlxG.camera.flash(FlxColor.WHITE, 0.5);
                FlxG.mouse.visible = false;
                return; // Exit the loop once a match is found
            }
            
            FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
            trace('Wrong password');
         }
    }

    function loadSong(song:String)
    {
        var songLowercase:String = Paths.formatToSongPath(song);
        PlayState.SONG = Song.loadFromJson(songLowercase + "-null", songLowercase);

        PlayState.isStoryMode = false;
        PlayState.seenCutscene = false;
        LoadingState.loadAndSwitchState(new PlayState());
    }
}