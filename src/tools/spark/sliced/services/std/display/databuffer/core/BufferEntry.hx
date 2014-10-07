/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.core;

import tools.spark.sliced.services.std.display.databuffer.interfaces.EBufferEntryType;
import tools.spark.sliced.services.std.display.databuffer.interfaces.IBufferEntry;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class BufferEntry implements IBufferEntry
{
	public var type( default, null ):EBufferEntryType;
	public var source( default, null ):IGameEntity;
	public var target( default, null ):IGameEntity;
	public var field( default, null ):String;
	
	public function new(p_type:EBufferEntryType, p_source:IGameEntity, ?p_target:IGameEntity, ?p_field:String) 
	{
		type = p_type;
		source = p_source;
		target = p_target;
		field = p_field;
	}
	
}