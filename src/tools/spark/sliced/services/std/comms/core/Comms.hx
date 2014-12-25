/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.core;

import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.comms.sockets.interfaces.ISocket;

//@think: loading sources for both socket io and native websocket will make the runtime file bigger unnessecerily
//however, adding more ifdefs here (if io, if websocket, if none) etc, will create way, waaay too many runtimes
//for all combinations, for example: html5->2d->withPhysics->with socketIo, etc... so we want that? only if it's easy to
//create all those runtimes easily with one click... (me the developer, the end-user will have no idea, or care of course)
//benefit of course is, thin runtimes..
#if flash
	import tools.spark.sliced.services.std.comms.sockets.core.platform.flash.PomeloSocketIO;
	import tools.spark.sliced.services.std.comms.sockets.core.platform.flash.PomeloWebsocket;
#else
	import tools.spark.sliced.services.std.comms.sockets.core.platform.html5.PomeloSocketIO;
	import tools.spark.sliced.services.std.comms.sockets.core.platform.html5.PomeloWebsocket;
#end

/**
 * ...
 * @author Aris Kostakos
 */
class Comms extends AService implements IComms
{
	private var _socket:ISocket;
	
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Comms std Service...");
		//Temporarily create the native websocket by default
		_socket = new PomeloWebsocket();
	}
	
}