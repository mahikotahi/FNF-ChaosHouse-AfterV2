package objects;

class MenuApplication extends FlxSprite
{
	public var selection:String = '';

	public function init(myselection:String = '')
	{
		selection = myselection;
	}

	public function setValues(filename:String, aDntialiasing:String, xpos:String, yposition:String)
	{

		// if (!canAnimate){ canAnimate = animated.toLowerCase() == '1';}

		setPosition(Std.parseFloat(xpos), Std.parseFloat(yposition));

		switch (aDntialiasing.toLowerCase())
		{
			case 'true' | '1':
				antialiasing = true;

			case 'false' | '0':
				antialiasing = false;

			case 'client' | 'clientpref' | 'setting' | 'clientprefs':
				antialiasing = ClientPrefs.data.antialiasing;

			default:
				antialiasing = false;
		}

		trace(filename);

		// trace('spritesheet');

		try
		{
			frames = Paths.getSparrowAtlas(filename);
			animation.addByPrefix(filename, filename, 24, true);
		}
		catch (e:Dynamic)
		{
            loadGraphic(Paths.image(filename));
		}

		return;
	}
}
