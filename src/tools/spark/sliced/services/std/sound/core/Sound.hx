/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.sound.core;

import flambe.sound.Playback;
import tools.spark.framework.Assets;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.interfaces.ISound;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

/**
 * ...
 * @author Aris Kostakos
 */
class Sound extends AService implements ISound
{
	private var _playBacks:Map<String,Playback>;
	public var iOSPlayedBlankSound( default, null ):Bool;
	
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Sound std Service...");
		_playBacks = new Map<String,Playback>();
		iOSPlayedBlankSound = false;
	}
	
	public function playSound(p_soundName:String, ?volume :Float):Playback
	{
		if (Assets.getSound(p_soundName)!=null)
		{
			var l_playback:Playback = Assets.getSound(p_soundName).play(volume);
			_playBacks[p_soundName] = l_playback;
			
			l_playback.complete.changed.connect(function (to:Bool, from:Bool)
			{
			   Sliced.event.raiseEvent(EEventType.SOUND_COMPLETED, null, p_soundName);
			});
			
			return l_playback;
		}
		else
		{
			Console.warn("Could not play sound: " + p_soundName);
			return null;
		}
	}
	

	
	public function loopSound(p_soundName:String, ?volume :Float):Playback
	{
		if (Assets.getSound(p_soundName) != null)
		{
			var l_playback:Playback = Assets.getSound(p_soundName).loop(volume);
			_playBacks[p_soundName] = l_playback;
			return l_playback;
		}
		else
		{
			Console.warn("Could not loop sound: " + p_soundName);
			return null;
		}
	}
	
	public function stopSound(p_soundName:String, ?p_fadeOut:Float):Void
	{
		//Get playback
		var l_playback:Playback = _playBacks[p_soundName];
		
		//If playback is still playing
		if (l_playback!=null)
		{
			if (l_playback.complete._ == false)
			{
				if (p_fadeOut == null)
				{
					l_playback.dispose();
				}
				else
				{
					l_playback.volume.animateTo(0, p_fadeOut);
					//Warning.. this will never actually dispose the playback!!!!
				}
			}
		}
	}
	
	public function isPlaying(p_soundName:String):Bool
	{
		//Get playback
		var l_playback:Playback = _playBacks[p_soundName];
		
		if (l_playback == null)
			return false;
		else
			return !l_playback.complete._;
	}
	
	public function iOSPlayBlankSound():Void
	{
		playSound("_blankSound", 0);
		iOSPlayedBlankSound = true;
	}
	
	public function stopAllSounds(?p_fadeOut:Float):Void
	{
		//For all registered playbacks
		for (f_playback in _playBacks)
		{
			//If playback is still playing
			if (f_playback.complete._ == false)
			{
				if (p_fadeOut == null)
				{
					f_playback.dispose();
				}
				else
				{
					f_playback.volume.animateTo(0, p_fadeOut);
					//Warning.. this will never actually dispose the playback!!!!
				}
			}
		}
	}
}