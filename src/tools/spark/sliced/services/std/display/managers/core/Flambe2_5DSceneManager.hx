/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

package tools.spark.sliced.services.std.display.managers.core;

import tools.spark.framework.flambe2_5D.FlambeScene2_5D;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Flambe2_5DSceneManager implements IDisplayObjectManager
{
	private var _renderer:ILibrarySpecificRenderer;
	
	public function new(p_renderer:ILibrarySpecificRenderer) 
	{
		_renderer = p_renderer;
	}
	
	/* INTERFACE tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager */
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_scene2_5D:FlambeScene2_5D = new FlambeScene2_5D();
		l_scene2_5D.name = p_gameEntity.getState('name');
		
		update(l_scene2_5D,p_gameEntity);
		
		return l_scene2_5D;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//typecast?
		
		//Update is usually responsible for two things.. update all entity states and form states, and update all children
		
		//Before doing this, shouldn't we remove all children from this entity?
		//p_object.removeChildren(); ??
		
		//FOR EACH ENTITY CHILD INSIDE SCENE
		for (f_childEntity in p_gameEntity.children)
		{
			addTo(_renderer.createObject(f_childEntity), p_object);
		}
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast?
		
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//typecast?
		
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void 
	{
		//typecast
		var l_scene2_5D:FlambeScene2_5D = cast(p_objectParent, FlambeScene2_5D);
		
		l_scene2_5D.addChild(p_objectChild);
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void 
	{
		//typecast?
		
	}
}