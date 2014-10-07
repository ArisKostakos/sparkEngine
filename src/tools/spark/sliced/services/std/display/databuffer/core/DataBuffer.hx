/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.core;

import tools.spark.sliced.services.std.display.databuffer.interfaces.EBufferEntryType;
import tools.spark.sliced.services.std.display.databuffer.interfaces.IBufferEntry;
import tools.spark.sliced.services.std.display.databuffer.interfaces.IDataBuffer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class DataBuffer implements IDataBuffer
{
	public var dataBuffer( default, null ):Array<IBufferEntry>;

	public function new() 
	{
		_init();
	}
	
	inline private function _init():Void
	{
		dataBuffer = new Array<IBufferEntry>();
	}
	
	public function addEntry(p_type:EBufferEntryType, p_source:IGameEntity, ?p_target:IGameEntity, ?p_field:String):Void
	{
		dataBuffer.push(new BufferEntry(p_type, p_source, p_target, p_field));
	}
	
	public function clearBuffer():Void
	{
		dataBuffer = new Array<IBufferEntry>();
	}
	
}