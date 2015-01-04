/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.core;

import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.comms.sockets.interfaces.ISocket;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

//@think: loading sources for both socket io and native websocket will make the runtime file bigger unnessecerily
//however, adding more ifdefs here (if io, if websocket, if none) etc, will create way, waaay too many runtimes
//for all combinations, for example: html5->2d->withPhysics->with socketIo, etc... so we want that? only if it's easy to
//create all those runtimes easily with one click... (me the developer, the end-user will have no idea, or care of course)
//benefit of course is, thin runtimes..
#if flash
	#if socketIO
		import tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.flash.socketio.Socket;
	#else
		import tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.flash.websocket.Socket;
	#end
#else
	#if socketIO
		import tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.html5.socketio.Socket;
	#else
		import tools.spark.sliced.services.std.comms.sockets.core.pomelo.platform.html5.websocket.Socket;
	#end
#end

/**
 * ...
 * @author Aris Kostakos
 */
class Comms extends AService implements IComms
{
	private var _socket:ISocket;
	private var _requestsData:Map<String, Dynamic>;
	private var _serverEventsData:Map<String, Dynamic>;
	
	public var isConnected( default, null ):Bool;
	public var connectedServerName( default, null ):String;
	
	//have some info here for polling... connected or not... connected to where, etc... logging maybe..
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Comms std Service...");
		
		//if you remove ifdefs for socket io, include full path of Socket class here.. otherwise, it's ok
		_socket = new Socket();
		
		_requestsData = new Map<String, Dynamic>();
		_serverEventsData = new Map<String, Dynamic>();
		
		isConnected = false;
	}
	
	public function update():Void
	{
		_requestsData = new Map<String, Dynamic>();
		_serverEventsData = new Map<String, Dynamic>();
	}
	
	public function getRequestData(p_requestName:String):Dynamic
	{
		return _requestsData[p_requestName];
	}
	
	public function getServerEventData(p_serverEventName:String):Dynamic
	{
		return _serverEventsData[p_serverEventName];
	}
	
	public function connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String):Void
	{
		if (p_serverIdentifier == null)
			p_serverIdentifier = p_hostname+":"+p_port;
			
		//Using Closures to preserve server id
		var l_connectToCallback:Void->Void = function () 
		{
			isConnected = true;
			connectedServerName = p_serverIdentifier;
			Sliced.event.raiseEvent(NETWORK_CONNECTED);
		}
		
		_socket.init(p_hostname, p_port, l_connectToCallback);
	}
	
	public function request(p_remoteRoute:String, p_message:Dynamic, ?p_requestIdentifier:String):Void
	{
		if (p_requestIdentifier == null)
			p_requestIdentifier = p_remoteRoute;
			
		//Using Closures to preserve request id
		var l_requestCallback:Dynamic->Void = function (p_data:Dynamic) 
		{
			_requestsData[p_requestIdentifier] = p_data;
			Sliced.event.raiseEvent(NETWORK_REQUEST);
		}
		
		_socket.request(p_remoteRoute, p_message, l_requestCallback);
	}
	
	
	public function disconnect():Void
	{
		_socket.disconnect();
		isConnected = false;
		connectedServerName = null;
	}
	
	
	//public function notify
	//...
	
	
	public function addServerEvent(p_serverEventName:String, ?p_serverEventIdentifier:String):Void
	{
		if (p_serverEventIdentifier == null)
			p_serverEventIdentifier = p_serverEventName;
			
		//Using Closures to preserve request id
		var l_serverEventCallback:Dynamic->Void = function (p_data:Dynamic) 
		{
			_serverEventsData[p_serverEventIdentifier] = p_data;
			Sliced.event.raiseEvent(NETWORK_SERVER_EVENT);
		}
		
		_socket.on(p_serverEventName, l_serverEventCallback);
	}
}