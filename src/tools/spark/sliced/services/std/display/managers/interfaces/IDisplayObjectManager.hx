/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.managers.interfaces;

import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

/**
 * @author Aris Kostakos
 */

interface IDisplayObjectManager
{	
  function create(p_gameEntity:IGameEntity):Dynamic;
  function destroy(p_object:Dynamic):Void;
  function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void;
  function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void;
  function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void;
  function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void;
  function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void;
}