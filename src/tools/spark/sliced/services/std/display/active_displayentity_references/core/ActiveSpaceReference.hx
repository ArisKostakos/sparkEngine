/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveSpaceReference implements IActiveSpaceReference
{
	public var activeStageReference( default, null ):IActiveStageReference;
	
	public function new() 
	{
		
	}
}