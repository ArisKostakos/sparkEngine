/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.framework.layout.containers.Group;

/**
 * @author Aris Kostakos
 */

interface IActiveStageAreaReference 
{
  var stageAreaEntity( default, null ):IGameEntity;
  var layoutElement( default, null ):Group;
}