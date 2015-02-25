/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.sliced.services.std.comms.filetransfer.core.platform.html5.websocket.binaryjs;

import tools.spark.sliced.services.std.comms.filetransfer.core.platform.html5.websocket.binaryjs.externs.IBinaryJs;
import tools.spark.sliced.services.std.comms.filetransfer.interfaces.IFileTransfer;

/**
 * ...
 * @author Aris Kostakos
 */
class FileTransfer implements IFileTransfer
{
	private var _binaryJs:IBinaryJs;
	
	public function new(p_address:String) 
	{
		_binaryJs = new IBinaryJs(p_address);
	}
	
	public function onConnected(p_callback:Void->Void):Void
	{
		_binaryJs.on("open", p_callback);
	}
	
	public function disconnect():Void
	{
		_binaryJs.close();
		_binaryJs = null;
	}
	
	public function sendFile(p_fileReference:Dynamic, p_fileMeta:Dynamic, ?p_callBack:Dynamic->Void):Void
	{
		var l_stream:Dynamic = _binaryJs.send(p_fileReference, p_fileMeta);
		
		l_stream.on('data', p_callBack);
	}
}