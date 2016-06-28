/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.comms.core;

import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.comms.filetransfer.interfaces.IFileTransfer;
import tools.spark.sliced.services.std.comms.sockets.interfaces.ISocket;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

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

//File Transfer
#if flash

#else
	import tools.spark.sliced.services.std.comms.filetransfer.core.platform.html5.websocket.binaryjs.FileTransfer;
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
	
	
	public var file_isConnected( default, null ):Bool;
	public var file_connectedServerName( default, null ):String;
	
	private var _fileTransfer:IFileTransfer;
	private var _file_requestsData:Map<String, Dynamic>;
	
	
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
		
		_file_requestsData = new Map<String, Dynamic>();
		file_isConnected = false;
	}
	
	public function update():Void
	{
		//I think creating new objects might be costly...
		//it should be faster to do an if it's empty before creating a new Map
		
		_requestsData = new Map<String, Dynamic>();
		_serverEventsData = new Map<String, Dynamic>();
		_file_requestsData = new Map<String, Dynamic>();
	}
	
	public function getRequestData(p_requestName:String):Dynamic
	{
		return _requestsData[p_requestName];
	}
	
	public function getServerEventData(p_serverEventName:String):Dynamic
	{
		return _serverEventsData[p_serverEventName];  //PUT THE .shift(); HERE!!!! AND DO IT FOR EVERYTHING!!!!
	}
	
	public function connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String, ?p_gameEntity:IGameEntity):Void
	{
		if (p_serverIdentifier == null)
			p_serverIdentifier = p_hostname+":"+p_port;
			
		//Using Closures to preserve server id
		var l_connectToCallback:Void->Void = function () 
		{
			isConnected = true;
			connectedServerName = p_serverIdentifier;
			Sliced.event.raiseEvent(NETWORK_CONNECTED, p_gameEntity, p_serverIdentifier);
		}
		
		_socket.init(p_hostname, p_port, l_connectToCallback);
	}
	
	public function request(p_remoteRoute:String, p_message:Dynamic, ?p_requestIdentifier:String, ?p_gameEntity:IGameEntity):Void
	{
		if (p_requestIdentifier == null)
			p_requestIdentifier = p_remoteRoute;
			
		//Using Closures to preserve request id
		var l_requestCallback:Dynamic->Void = function (p_data:Dynamic) 
		{
			_requestsData[p_requestIdentifier] = p_data;
			Sliced.event.raiseEvent(NETWORK_REQUEST,p_gameEntity, p_requestIdentifier);
		}
		
		_socket.request(p_remoteRoute, p_message, l_requestCallback);
	}
	
	
	public function disconnect():Void
	{
		_socket.disconnect();
		isConnected = false;
		connectedServerName = null;
	}
	
	
	public function notify(p_route:String, p_msg:Dynamic):Void
	{
		_socket.notify(p_route, p_msg);
	}
	
	
	public function addServerEvent(p_serverEventName:String, ?p_serverEventIdentifier:String, ?p_gameEntity:IGameEntity):Void
	{
		if (p_serverEventIdentifier == null)
			p_serverEventIdentifier = p_serverEventName;
			
		//Using Closures to preserve request id
		var l_serverEventCallback:Dynamic->Void = function (p_data:Dynamic) 
		{
			//Console.de("Engine data: " + p_data);
			//Allow multiple incoming server events in a single frame hack
			if (!_serverEventsData.exists(p_serverEventIdentifier))
				_serverEventsData[p_serverEventIdentifier] = [];
			
			_serverEventsData[p_serverEventIdentifier].push(p_data);
			Sliced.event.raiseEvent(NETWORK_SERVER_EVENT, p_gameEntity, p_serverEventIdentifier);
		}
		
		_socket.on(p_serverEventName, l_serverEventCallback);
	}
	
	
	
	//FILE TRANSFER FUNCTIONS
	
	public function file_connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String, ?p_gameEntity:IGameEntity):Void
	{
		if (file_isConnected)
		{
			Console.warn("Attempting to connect to file server: File Transfer already connected. Disconnect first.");
		}
		else
		{
			if (p_serverIdentifier == null)
				p_serverIdentifier = p_hostname+":"+p_port;
				
			//Using Closures to preserve server id
			var l_connectToCallback:Void->Void = function () 
			{
				file_isConnected = true;
				file_connectedServerName = p_serverIdentifier;
				Sliced.event.raiseEvent(FILETRANSFER_CONNECTED, p_gameEntity, p_serverIdentifier);
			}
			
			_fileTransfer = new FileTransfer("ws://" + p_hostname+":" + p_port);
			
			_fileTransfer.onConnected(l_connectToCallback);
		}
	}
	
	public function file_getSendFileRequestData(p_fileRequestName:String):Dynamic
	{
		return _file_requestsData[p_fileRequestName];  //PUT THE .shift(); HERE!!!! AND DO IT FOR EVERYTHING!!!! and maybe make 'p_fileRequestName' local to target's name... ehh
	}
	
	public function file_disconnect():Void
	{
		_fileTransfer.disconnect();
		file_isConnected = false;
		_fileTransfer = null;
		file_connectedServerName = null;
	}

	public function file_sendFileRequest(p_fileReference:Dynamic, p_fileMeta:Dynamic, ?p_fileRequestIdentifier:String, ?p_gameEntity:IGameEntity):Void
	{
		if (!file_isConnected)
		{
			Console.warn("Attempting to send a file: File Transfer is not connected.");
		}
		else
		{
			if (p_fileRequestIdentifier == null)
				p_fileRequestIdentifier = p_fileMeta.name;
				
			var clsr_progressBytes:Float = 0;
			
			//Using Closures to preserve request id
			var l_requestCallback:Dynamic->Void = function (p_data:Dynamic) 
			{
				clsr_progressBytes += p_data.length;
				
				p_data.progress = clsr_progressBytes / p_fileMeta.size;
				
				p_data.progressPercent = Math.round((clsr_progressBytes / p_fileMeta.size)* 100);
				
				//Allow multiple incoming server file request events in a single frame hack
				if (!_file_requestsData.exists(p_fileRequestIdentifier))
					_file_requestsData[p_fileRequestIdentifier] = [];
				
				_file_requestsData[p_fileRequestIdentifier].push(p_data);
				Sliced.event.raiseEvent(FILETRANSFER_SENDREQUEST, p_gameEntity, p_fileRequestIdentifier);
			}
			
			_fileTransfer.sendFile(p_fileReference, p_fileMeta, l_requestCallback);
		}
	}
}