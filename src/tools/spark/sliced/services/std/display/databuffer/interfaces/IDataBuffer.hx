/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.interfaces;

import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */

interface IDataBuffer 
{
	var dataBuffer( default, null ):Array<IBufferEntry>;
	
	function addEntry(p_type:EBufferEntryType, p_source:IGameEntity, ?p_target:IGameEntity, ?p_field:String):Void;
	function clearBuffer():Void;
}