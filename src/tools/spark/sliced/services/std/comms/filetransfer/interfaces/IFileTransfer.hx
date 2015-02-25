/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.sliced.services.std.comms.filetransfer.interfaces;

/**
 * @author Aris Kostakos
 */

interface IFileTransfer 
{
	function onConnected(p_callback:Void->Void):Void;
	function disconnect():Void;
	function sendFile(p_fileReference:Dynamic, p_fileMeta:Dynamic, ?p_callBack:Dynamic->Void):Void;
}