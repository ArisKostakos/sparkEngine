/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import away3d.containers.Scene3D;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.primitives.SphereGeometry;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DSceneManager implements IDisplayObjectManager
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
		
		var l_scene3D:Scene3D = new Scene3D();
		
		
		update(l_scene3D,p_gameEntity);
		
		return l_scene3D;
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
		//typecast?
		
		p_objectParent.addChild(p_objectChild);
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void 
	{
		//typecast?
		
	}
}