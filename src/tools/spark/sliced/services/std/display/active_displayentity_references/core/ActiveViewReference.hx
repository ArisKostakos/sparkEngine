/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveViewReference implements IActiveViewReference
{
	public var viewEntity( default, null ):IGameEntity;
	public var renderer( default, default ):IPlatformSpecificRenderer;
	
	public function new(p_viewEntity:IGameEntity) 
	{
		viewEntity = p_viewEntity;
	}
}