/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import flambe.sound.Playback;
import flambe.sound.Sound;

/**
 * ...
 * @author Aris Kostakos
 */
interface ISound extends IService
{
	function playSound(p_soundName:String, ?volume :Float):Playback;
	function loopSound(p_soundName:String, ?volume :Float):Playback;
}