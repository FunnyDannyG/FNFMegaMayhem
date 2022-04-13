package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
#if sys
import sys.FileSystem;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'awards', 'options'];

	var newGaming:FlxText;
	var newGaming2:FlxText;

	var MayhemLogo:FlxSprite;

	public static var firstStart:Bool = true;

	public static var isVideoPlaying:Bool = true;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}

		Conductor.changeBPM(102);
		persistentUpdate = true;
		persistentUpdate = persistentDraw = true;
		
		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('MAYHEM_MENU'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.0));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var overlay:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('TitleOverlay'));
		overlay.scrollFactor.x = 0;
		overlay.scrollFactor.y = 0.10;
		overlay.setGraphicSize(Std.int(overlay.width * 1.0));
		overlay.updateHitbox();
		overlay.screenCenter();
		overlay.antialiasing = true;
		add(overlay);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.0));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);

		MayhemLogo = new FlxSprite(-150, -100);
		MayhemLogo.frames = Paths.getSparrowAtlas('logoBumpin');
		MayhemLogo.antialiasing = true;
		MayhemLogo.animation.addByPrefix('bump', 'logo bumpin', 24);
		MayhemLogo.animation.play('bump');
		MayhemLogo.screenCenter();
		MayhemLogo.y -= 105;
		MayhemLogo.updateHitbox();
		add(MayhemLogo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
            var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
            menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
            menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
            menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
            menuItem.animation.play('idle');
            menuItem.ID = i;
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
            var scr:Float = (optionShit.length - 4) * 0.135;
            if(optionShit.length < 6) scr = 0;
            menuItem.scrollFactor.set(0, scr);
            menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.setGraphicSize(Std.int(FlxG.height * 0.32));
			//ok whAT THE FUCK
			FlxTween.tween(menuItem,{x: 30 + (i * 325)},0.1 ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
					finishedFunnyMove = true; 
					changeItem();
				}});
			menuItem.y = 570;
			menuItems.add(menuItem);
            menuItem.updateHitbox();
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));
		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}

		if (FlxG.keys.pressed.L)
			{
				//lime.app.Application.current.window.alert('You are making a terrible mistake.');
				MusicBeatState.switchState(new AchievementsMenuState());
			}

		if (FlxG.keys.justPressed.B)
			{
				FlxG.sound.play(Paths.sound('bruh'));
			}
		if (FlxG.keys.justPressed.C)
			{
				FlxG.switchState(new CreditsState());
			}


		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.RIGHT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			
			if (FlxG.keys.justPressed.ENTER)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
					
				if (FlxG.save.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						if (FlxG.save.data.flashing)
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								goToState();
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
						}
					}
				});
			}
		}
	}
	override function beatHit()

		{

			super.beatHit();

			MayhemLogo.animation.play('bump');
		
		}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story_mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
			case 'awards':
				MusicBeatState.switchState(new OutdatedState());
			case 'options':
				MusicBeatState.switchState(new options.OptionsState());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}


		
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.color = 0xDD19BA;
			}
			else 
				spr.color = 0xFFFFFF;

			spr.updateHitbox();
		});
	}
}