/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.html5.websocket ;

import tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.html5.websocket.externs.IPomeloClientWebSocketJs;
import tools.spark.sliced.services.std.comms.sockets.interfaces.ISocket;

/**
 * ...
 * @author Aris Kostakos
 */
class Socket implements ISocket
{
	public function new() 
	{
		
	}

	public function init(p_hostName:String, p_port:String, p_log:Bool=false, ?p_callBack:Void->Void):Void
	{
		IPomeloClientWebSocketJs.init({host:p_hostName, port:p_port, log: p_log}, p_callBack);
	}
	
	public function request(p_route:String, p_msg:Dynamic, ?p_callBack:Dynamic->Void):Void
	{
		IPomeloClientWebSocketJs.request(p_route, p_msg, p_callBack);
	}
	
	public function notify(p_route:Dynamic, p_msg:Dynamic):Void
	{
		IPomeloClientWebSocketJs.notify(p_route, p_msg);
	}
	
	public function on(p_route:String, ?p_callback:Dynamic->Void):Void
	{
		IPomeloClientWebSocketJs.on(p_route, p_callback);
	}
	
	public function disconnect():Void
	{
		IPomeloClientWebSocketJs.disconnect();
	}
}