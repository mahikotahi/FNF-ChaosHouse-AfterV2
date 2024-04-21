package objects;

import flixel.FlxSprite;

class CoolMouse extends FlxSprite
{
    public var cursi:Float = ClientPrefs.data.cursorsize / 5;

    public function new(x:Float, y:Float)
    {
        super(x,y);

		loadGraphic(Paths.image('desktopshit/mouse/cursor_${ClientPrefs.data.cursorColor.toLowerCase()}'));
		scale.set(cursi, cursi);
		scrollFactor.set();
    }

	override public function setPosition(x = 0.0, y = 0.0)
	{
		this.x = x;
		this.y = y;
	}
}