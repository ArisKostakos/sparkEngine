/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.interfaces;

/**
 * @author Aris Kostakos
 */

interface IDataBuffer 
{
  var dataBuffer( default, null ):Array<IBufferEntry>;
}