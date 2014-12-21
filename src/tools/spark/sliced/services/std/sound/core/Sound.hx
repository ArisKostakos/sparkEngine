/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.sound.core;

import flambe.sound.Playback;
import tools.spark.framework.Assets;
import tools.spark.sliced.interfaces.ISound;
import tools.spark.sliced.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Sound extends AService implements ISound
{
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Sound std Service...");
	}
	
	public function playSound(p_soundName:String, ?volume :Float):Playback
	{
		return Assets.getSound(p_soundName).play(volume);
	}
	
	public function loopSound(p_soundName:String, ?volume :Float):Playback
	{
		return Assets.getSound(p_soundName).loop(volume);
	}
}