/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class Console
{
#if (debug || flambe_keep_logs)
	inline public static function log(p_message:String):Void
	{
		SparkLog.info(p_message);
	}
	
	inline public static function info(p_message:String):Void
	{
		SparkLog.info(p_message);
	}
	
	inline public static function debug(p_message:String):Void
	{
		SparkLog.info(p_message);
	}
	
	inline public static function warn(p_message:String):Void
	{
		SparkLog.warn(p_message);
	}
	
	inline public static function error(p_message:String):Void
	{
		SparkLog.error(p_message);
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