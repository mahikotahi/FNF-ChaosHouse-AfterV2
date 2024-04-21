package states.stages;

import states.stages.objects.*;
import objects.Character;

class Table extends BaseStage
{
	var foregroundSprites:FlxTypedGroup<Dynamic>;

	override function create()
	{
		var bg:BGSprite = new BGSprite('buckmock', 0, 0,);
		bg.scale.set(4, 4);

		bg.screenCenter();
		add(bg);

		var bg:BGSprite = new BGSprite('Table', 0, 0,);
		bg.scale.set(4, 4);

		bg.screenCenter();
		foregroundSprites.add(bg);
	}

	override function createPost()
	{
		// add(foregroundSprites);
		add(foregroundSprites);
	}

}