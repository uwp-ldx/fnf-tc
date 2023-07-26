package;

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
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainDIARY extends MusicBeatState
{
	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;
	private var camAchievement:FlxCamera;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		var bg:FlxSprite = new FlxSprite(-100, 0).loadGraphic(Paths.image('diary/diaryCover'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scale.x = 0.75;
		bg.scale.y = 0.75;
		add(bg);

		var black:FlxSprite = new FlxSprite(50, 550).makeGraphic(1180, 100, FlxColor.BLACK);
		black.scrollFactor.set();
		black.cameras = [camHUD];
		add(black);

		var NewText:FlxText = new FlxText(0, 580, 0, 'The pages of this diary are lost... For now...', 12);
		NewText.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER);
		NewText.scrollFactor.set();
		NewText.alpha = 0.3;
		NewText.screenCenter(X);
		NewText.cameras = [camHUD];
		add(NewText);

		FlxTween.tween(NewText, {alpha: 1}, 2, {ease: FlxEase.linear, type: ONESHOT});
		FlxG.camera.follow(camFollowPos, null, 1);

		#if android
		addVirtualPad(NONE, B);
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainExtrase());
			}
		}
		super.update(elapsed);
	}
}