/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.sliced.services.std.comms.filetransfer.core.platform.html5.websocket.binaryjs.externs;

/**
 * ...
 * @author Aris Kostakos
 */
@:native("BinaryClient")
extern class IBinaryJs
{
	public function new(address:String):Void;
	public function on(eventName:String, callback:Dynamic):Void;
	public function close():Void;
	public function send(data:Dynamic, meta:Dynamic):Dynamic;
}