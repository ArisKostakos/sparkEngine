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
	
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_scene3D:Scene3D = new Scene3D();
		
		//Temp Lighting
		_deletemeCreateLight(l_scene3D);
		
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
	
	private var _deleteMeMainLight:away3d.lights.DirectionalLight;
	public static var _deleteMeMainLightpicker:away3d.materials.lightpickers.StaticLightPicker;
	
	private function _deletemeCreateLight(p_scene:Scene3D):Void
	{
		var directionalLight:away3d.lights.DirectionalLight = new away3d.lights.DirectionalLight();
		directionalLight.ambientColor = 0xFFFFFF;
		directionalLight.color = 0xFFFFFF;
		directionalLight.ambient = 0.39;
		directionalLight.castsShadows = false;
		directionalLight.specular = 0.8;
		directionalLight.diffuse = 0.6;
		directionalLight.name = "MainLight";
		//directionalLight.direction = new Vector3D(-0.7376268918178536, -0.4171149406714452, -0.5309629881034924);
		p_scene.addChild(directionalLight);
		
		_deleteMeMainLight = directionalLight;
		
		_deleteMeMainLightpicker = new away3d.materials.lightpickers.StaticLightPicker([_deleteMeMainLight]);
	}
}