/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.core;

import tools.spark.sliced.services.std.display.databuffer.interfaces.IBufferEntry;
import tools.spark.sliced.services.std.display.databuffer.interfaces.IDataBuffer;

/**
 * ...
 * @author Aris Kostakos
 */
class DataBuffer implements IDataBuffer
{
	public var dataBuffer( default, null ):Array<IBufferEntry>;

	public function new() 
	{
		
	}
	
}