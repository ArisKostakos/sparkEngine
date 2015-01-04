/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

package tools.spark.sliced.services.std.display.managers.core;

import tools.spark.framework.flambe2_5D.FlambeEntity2_5D;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Flambe2_5DObjectManager implements IDisplayObjectManager
{
	private var _renderer:ILibrarySpecificRenderer;
	
	public function new(p_renderer:ILibrarySpecificRenderer) 
	{
		_renderer = p_renderer;
	}
	
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_object2_5D:FlambeEntity2_5D = new FlambeEntity2_5D();
		l_object2_5D.name = p_gameEntity.getState('name');
		l_object2_5D.gameEntity = p_gameEntity;
		
		update(l_object2_5D, p_gameEntity);
		
		return l_object2_5D;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_object, FlambeEntity2_5D);
		
		l_entity2_5D.update();
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_object, FlambeEntity2_5D);
		
		switch (p_state)
		{
			case 'spaceX':
				l_entity2_5D.x = p_gameEntity.getState(p_state);
			case 'spaceY':
				l_entity2_5D.y = p_gameEntity.getState(p_state);
			case 'spaceZ':
				l_entity2_5D.z = p_gameEntity.getState(p_state);
		}
		
		//Not really sure about this... THIS IS SOO BAD!!! it will update everything on the real flambe instances
		//not just the state currently being revalidated... and ALSO, it happens like 3 billion times (if you do update();)
		l_entity2_5D.updateInstances();
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_object, FlambeEntity2_5D);
		
		switch (p_state)
		{
			case 'SpriteUrl':
				l_entity2_5D.spriteUrl = p_gameForm.getState(p_state);
				l_entity2_5D.updateInstances(p_state);
				//Console.error("updating sprite url of: " + l_entity2_5D.name + "to: " + p_gameForm.getState(p_state));
			case 'ModelUrl':
				l_entity2_5D.modelUrl = p_gameForm.getState(p_state);
		}
		
		//Not really sure about this... THIS IS SOO BAD!!! it will update everything on the real flambe instances
		//not just the state currently being revalidated... and ALSO, it happens like 3 billion times (if you do update();)
		//l_entity2_5D.updateInstances();
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
}