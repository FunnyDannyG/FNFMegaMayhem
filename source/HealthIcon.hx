package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bft', [0, 1], 0, false, isPlayer);
		animation.add('gf', [2, 2], 0, false, isPlayer);
		animation.add('gft', [2, 2], 0, false, isPlayer);
		animation.add('dummy', [3, 3], 0, false, isPlayer);
		animation.add('mb', [4, 5], 0, false, isPlayer);
		animation.add('danny', [6, 7], 0, false, isPlayer);
		animation.add('dannyTOFH', [9, 8], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
