/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.html5.websocket.externs;

/**
 * ...
 * @author Aris Kostakos
 */
@:native("window.pomelo")
extern class IPomeloClientWebSocketJs
{
	public static function init(params:Dynamic, callback:Void->Void):Void;
	public static function request(route:String, msg:Dynamic, callback:Dynamic->Void):Void;
	public static function notify(route:Dynamic, params:Dynamic):Void;
	public static function on(route:String, callback:Dynamic->Void):Void;
	public static function disconnect():Void;
}