/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.renderers.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
interface ILibrarySpecificRenderer extends IDimensionSpecificRenderer
{
	function renderView ( p_viewEntity:IGameEntity):Void;
	
	function createView ( p_viewEntity:IGameEntity):Dynamic;
	function createScene ( p_sceneEntity:IGameEntity):Dynamic;
	function createCamera ( p_cameraEntity:IGameEntity):Dynamic;
	function createObject ( p_objectEntity:IGameEntity):Dynamic;
	
	//delete me
	function addChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void;
	function insertChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity, p_index:Int):Void;
	function removeChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void;
	function updateState ( p_objectEntity:IGameEntity, p_state:String):Void;
	function updateFormState ( p_objectEntity:IGameEntity, p_state:String):Void;
	
	//function destroyView ( p_viewEntity:IGameEntity):Void;
}