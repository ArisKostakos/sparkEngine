/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */

interface IActiveStageReference 
{
  var activeViewReferences (default, null ):Array<IActiveViewReference>;
  var stageEntity( default, null ):IGameEntity;
  
  function addView(p_viewReference:IActiveViewReference):Void;
}