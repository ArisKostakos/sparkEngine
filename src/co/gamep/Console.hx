/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep;

/**
 * ...
 * @author Aris Kostakos
 */
class Console
{
#if (debug || flambe_keep_logs)
	inline public static function log(p_message:String):Void
	{
		GamePlusLog.info(p_message);
	}
	
	inline public static function info(p_message:String):Void
	{
		GamePlusLog.info(p_message);
	}
	
	inline public static function debug(p_message:String):Void
	{
		GamePlusLog.info(p_message);
	}
	
	inline public static function warn(p_message:String):Void
	{
		GamePlusLog.warn(p_message);
	}
	
	inline public static function error(p_message:String):Void
	{
		GamePlusLog.error(p_message);
	}
	
#else
    // In release builds, logging calls are stripped out
    inline public static function log(p_message:String):Void {}
    inline public static function info(p_message:String):Void { }
	inline public static function debug(p_message:String):Void { }
	inline public static function warn(p_message:String):Void { }
	inline public static function error(p_message:String):Void {}
#end

}