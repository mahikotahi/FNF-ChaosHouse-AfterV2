package states.stages;

import states.stages.objects.*;
import objects.Character;

class Tube extends BaseStage
{
	override function create()
	{
		var bg:BGSprite = new BGSprite('Tube', 0, 0);
		bg.scale.set(2, 2);

		bg.screenCenter();
		add(bg);
	}
}