package states.stages;

import states.stages.objects.*;
import objects.Character;

class Desktop extends BaseStage
{
	override function create()
	{
		var bg:BGSprite = new BGSprite('desktop', 0, 0,);
		bg.scale.set(4, 4);

		bg.screenCenter();
		add(bg);
	}
}