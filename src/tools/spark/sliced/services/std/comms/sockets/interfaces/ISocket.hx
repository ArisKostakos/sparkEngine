/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.sockets.interfaces;

/**
 * @author Aris Kostakos
 */

interface ISocket 
{
	function init(p_hostName:String, p_port:String, p_log:Bool = false, ?p_callBack:Void->Void):Void;
	function request(p_route:String, p_msg:Dynamic, ?p_callBack:Dynamic->Void):Void;
	function notify(p_route:String, p_msg:Dynamic):Void;
	function on(p_route:String, ?p_callback:Dynamic->Void):Void;
	function disconnect():Void;
}