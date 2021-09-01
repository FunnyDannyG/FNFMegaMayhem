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
		animation.add('bf', [0, 1, 2], 0, false, isPlayer);
		animation.add('bft', [0, 1, 2], 0, false, isPlayer);
		animation.add('gf', [3, 3, 3], 0, false, isPlayer);
		animation.add('gft', [3, 3, 3], 0, false, isPlayer);
		animation.add('dummy', [4, 4, 4], 0, false, isPlayer);
		animation.add('mb', [5, 6, 7], 0, false, isPlayer);
		animation.add('SCmb', [5, 6, 7], 0, false, isPlayer);
		animation.add('OVmb', [8, 9, 9], 0, false, isPlayer);
		animation.add('danny', [10, 11, 12], 0, false, isPlayer);
		animation.add('danny_playable', [10, 11, 12], 0, false, isPlayer);
		animation.add('dannyTOFH', [13, 14, 14], 0, false, isPlayer);
		animation.add('leffrey', [57, 58, 59], 0, false, isPlayer);
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