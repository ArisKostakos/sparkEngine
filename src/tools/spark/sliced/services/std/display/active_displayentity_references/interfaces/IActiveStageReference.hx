/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.interfaces;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.layout.managers.LayoutManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */

interface IActiveStageReference 
{
  var activeViewReferences (default, null ):Array<IActiveViewReference>;
  var activeStageAreaReferences (default, null ):Array<IActiveStageAreaReference>;
  var stageEntity( default, null ):IGameEntity;
  var layoutRoot( default, null ):Group;
  var layoutManager( default, null ):LayoutManager;
  
  function addView(p_viewReference:IActiveViewReference):Void;
  function addStageArea(p_stageAreaReference:IActiveStageAreaReference):Void;
  function removeView(p_viewReference:IActiveViewReference):Void;
  function removeStageArea(p_stageAreaReference:IActiveStageAreaReference):Void;
}