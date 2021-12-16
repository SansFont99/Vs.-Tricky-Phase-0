package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var coolswag:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var easterEggEnabled:Bool = true; //Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.O, FlxKey.L, FlxKey.D];
	var lastKeysPressed:Array<FlxKey> = [];

	override public function create():Void
	{
		#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}

		//Gonna finish this later, probably
		#end
		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
			#end
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
		#end
	}

	var logoBl:FlxSprite;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var trickyDance:FlxSprite;
	var bg:FlxSprite;
	var sky:FlxSprite;
	var ground:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
				var chosenSong:Int = FlxG.random.int(0, 4);

				switch(chosenSong) {
				case 0: // unlaugh
					FlxG.sound.playMusic(Paths.music('funnySong2'), 0);
					Conductor.changeBPM(184);
				case 1: // calliope 2
					FlxG.sound.playMusic(Paths.music('funnySong3'), 0);
					Conductor.changeBPM(150);
				case 2: // the last party
					FlxG.sound.playMusic(Paths.music('funnySong4'), 0);
					Conductor.changeBPM(200);
				case 3: // engaged
					FlxG.sound.playMusic(Paths.music('funnySong5'), 0);
					Conductor.changeBPM(160);
				default: // calliope
					FlxG.sound.playMusic(Paths.music('funnySong'), 0);
					Conductor.changeBPM(100);
				}

				FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		persistentUpdate = true;

		if(!FlxG.save.data.psykaEasterEgg || !easterEggEnabled) {
			bg = new FlxSprite(-2300, -1010).loadGraphic(Paths.image('phase0/nevadatitlebg', 'shared'));
			bg.setGraphicSize(Std.int(bg.width * 1.4));
			bg.updateHitbox();
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			add(bg);
		}
		else
		{
			sky = new FlxSprite(-1350, -850).loadGraphic(Paths.image('phase0/nevadasky', 'shared'));
			sky.updateHitbox();
			sky.antialiasing = ClientPrefs.globalAntialiasing;
			add(sky);

			ground = new FlxSprite(-2100, -1010).loadGraphic(Paths.image('phase0/old/nevadagroundold', 'shared'));
			ground.setGraphicSize(Std.int(ground.width * 1.4));
			ground.updateHitbox();
			ground.antialiasing = ClientPrefs.globalAntialiasing;
			add(ground);
		}
		
		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		add(logoBl);

		if(!FlxG.save.data.psykaEasterEgg || !easterEggEnabled) {
			trickyDance = new FlxSprite(500, 100);
			trickyDance.frames = Paths.getSparrowAtlas('characters/TrickyPhase0', 'shared');
			trickyDance.animation.addByPrefix('dance', 'Right', 24);
			trickyDance.flipX = true;
		}
		else
		{
			trickyDance = new FlxSprite(500, 100);
			trickyDance.frames = Paths.getSparrowAtlas('characters/old/TrickyPhase0', 'shared');
			trickyDance.animation.addByPrefix('dance', 'Sing Right', 24);
			trickyDance.flipX = true;
		}
		trickyDance.antialiasing = ClientPrefs.globalAntialiasing;
		trickyDance.shader = swagShader.shader;
		add(trickyDance);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		credTextShit.visible = false;

		coolswag = new FlxSprite(0, FlxG.height * 0.4).loadGraphic(Paths.image('coolswag'));
		add(coolswag);
		coolswag.visible = false;
		coolswag.setGraphicSize(Std.int(coolswag.width * 1));
		coolswag.updateHitbox();
		coolswag.screenCenter(X);
		coolswag.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (!transitioning && skippedIntro)
		{
			if(pressedEnter)
			{
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
			else if(easterEggEnabled)
			{
				var finalKey:FlxKey = FlxG.keys.firstJustPressed();
				if(finalKey != FlxKey.NONE) {
					lastKeysPressed.push(finalKey); //Convert int to FlxKey
					if(lastKeysPressed.length > easterEggKeyCombination.length)
					{
						lastKeysPressed.shift();
					}
					
					if(lastKeysPressed.length == easterEggKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != easterEggKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						if(!isDifferent) {
							trace('Easter egg triggered!');
							FlxG.save.data.psykaEasterEgg = !FlxG.save.data.psykaEasterEgg;
							FlxG.sound.play(Paths.sound('secretSound'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
								function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							lastKeysPressed = [];
							closedState = true;
							transitioning = true;
						}
					}
				}
			}
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null) 
			logoBl.animation.play('bump');
		
		if(trickyDance != null) 
			trickyDance.animation.play('dance');

		if(!closedState) {
			switch (curBeat)
			{
				case 1:
					createCoolText(['SansFont99'], 45);
				case 2:
					addMoreText('presents', 45);
				case 3:
					deleteCoolText();
				case 5:
					createCoolText(['YOOO NEW TRICKY ASSETS!!!'], -60);
				case 7:
					addMoreText('coolswag!!!', -60);
					coolswag.visible = true;
				case 8:
					deleteCoolText();
					coolswag.visible = false;
				case 9:
					createCoolText([curWacky[0]]);
				case 11:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				case 13:
					addMoreText('Vs.');
				case 14:
					addMoreText('Tricky');
				case 15:
					addMoreText('Phase 0');
				case 16:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(coolswag);
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
