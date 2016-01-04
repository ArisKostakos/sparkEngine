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
		
		var l_object2_5D:FlambeEntity2_5D = new FlambeEntity2_5D(p_gameEntity);
		
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
		
		//No need for this. space 2_5D entities get updated only when added to an active view
		//l_entity2_5D.update();
		
		//Update is usually responsible for two things.. update all entity states and form states, and update all children
		
		//Before doing this, shouldn't we remove all children from this entity?
		//l_entity2_5D.removeChildren(); ??
		
		//FOR EACH ENTITY CHILD INSIDE ENTITY
		for (f_childEntity in p_gameEntity.children)
		{
			addTo(_renderer.createObject(f_childEntity), l_entity2_5D);
		}
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_object, FlambeEntity2_5D);
		
		l_entity2_5D.updateState(p_state);
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		/*  ****************************FORM STATE UPDATE DEPRECATED*************************
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_object, FlambeEntity2_5D);
		
		l_entity2_5D.updateFormState(p_state);
		*/
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_objectParent, FlambeEntity2_5D);
		
		//objetChild may be null if it failed to be typeasted as a display object when being created
		if (p_objectChild!=null)
			l_entity2_5D.addChild(p_objectChild);
	}
	
	public function insertTo(p_objectChild:Dynamic, p_objectParent:Dynamic, p_index:Int):Void
	{
		//typecast
		var l_entity2_5D:FlambeEntity2_5D = cast(p_objectParent, FlambeEntity2_5D);
		
		//objetChild may be null if it failed to be typeasted as a display object when being created
		if (p_objectChild!=null)
			l_entity2_5D.insertChild(p_objectChild, p_index);
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
}