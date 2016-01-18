/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IComms extends IService
{
	var isConnected( default, null ):Bool;
	var connectedServerName( default, null ):String;
	
	function update():Void;
	
	function getRequestData(p_requestName:String):Dynamic;
	function getServerEventData(p_serverEventName:String):Dynamic;
	function connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String):Void;
	function request(p_remoteRoute:String, p_message:Dynamic, ?p_requestIdentifier:String):Void;
	function disconnect():Void;
	function notify(p_route:String, p_msg:Dynamic):Void;
	function addServerEvent(p_serverEventName:String, ?p_serverEventIdentifier:String):Void;
	
	
	//File Transfer
	var file_isConnected( default, null ):Bool;
	var file_connectedServerName( default, null ):String;
	function file_connectTo(p_hostname:String, p_port:String, ?p_serverIdentifier:String):Void;
	function file_disconnect():Void;
	
	function file_getSendFileRequestData(p_fileRequestName:String):Dynamic;
	function file_sendFileRequest(p_fileReference:Dynamic, p_fileMeta:Dynamic, ?p_fileRequestIdentifier:String):Void;
}