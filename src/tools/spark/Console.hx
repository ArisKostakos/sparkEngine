/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark;

#if (debug || flambe_keep_logs)
import flambe.System;
import flambe.util.Logger;
#end

/**
 * ...
 * @author Aris Kostakos
 */
class Console
{
#if (debug || flambe_keep_logs)
	private static var _engineLogger:Logger;
	
	inline public static function init():Void 
	{
		_engineLogger = System.createLogger("engine");
	}

	inline public static function log(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.info(message, args);
	}
	
	inline public static function warn(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.warn(message, args);
	}
	
	inline public static function error(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.error(message, args);
	}
	
	inline public static function dl(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.info('DEBUG->' + message, args);
	}
	
	inline public static function dw(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.warn('DEBUG->' + message, args);
	}
	
	inline public static function de(message:String, ?args:Array<Dynamic>):Void 
	{
		_engineLogger.error('DEBUG->' + message, args);
	}
#else
    // In release builds, console calls are stripped out
	inline public static function init() {}
	inline public static function log (message:String, ?args:Array<Dynamic>) {}	
    inline public static function warn (message:String, ?args:Array<Dynamic>) {}
    inline public static function error (message:String, ?args:Array<Dynamic>) {}
    inline public static function dl (message:String, ?args:Array<Dynamic>) {}
	inline public static function dw (message:String, ?args:Array<Dynamic>) {}
	inline public static function de (message:String, ?args:Array<Dynamic>) {}	
#end
}
