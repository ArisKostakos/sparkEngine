/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.sliced.services.std.display.renderers.core.library;

import tools.spark.sliced.services.std.display.renderers.core.dimension.A2_5DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class ANativeControls2_5DRenderer extends A2_5DRenderer implements ILibrarySpecificRenderer
{

	private function new() 
	{
		super();
		
	}
	
	public function renderView(p_viewEntity:IGameEntity):Void 
	{
		
	}
	
	public function createView(p_viewEntity:IGameEntity):Dynamic 
	{
		return null;
	}
	
	public function destroyView ( p_viewEntity:IGameEntity):Void
	{
		
	}
	
	public function createScene(p_sceneEntity:IGameEntity):Dynamic 
	{
		return null;
	}
	
	public function createCamera(p_cameraEntity:IGameEntity):Dynamic 
	{
		return null;
	}
	
	public function createObject(p_objectEntity:IGameEntity):Dynamic 
	{
		return null;
	}
	
	public function addChild(p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void 
	{
		
	}
	
	public function insertChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity, p_index:Int):Void
	{
		
	}
	
	public function removeChild(p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void 
	{
		
	}
	
	public function updateState(p_objectEntity:IGameEntity, p_state:String):Void 
	{
		
	}
	
	public function updateFormState(p_objectEntity:IGameEntity, p_state:String):Void 
	{
		
	}
	
}