/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import away3d.containers.ObjectContainer3D;
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
class Away3DObjectManager implements IDisplayObjectManager
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
		
		var l_object3D:ObjectContainer3D = new ObjectContainer3D();
		
		
		
		var l_geometry:SphereGeometry = new SphereGeometry();
		var l_material:ColorMaterial = new ColorMaterial(0xFF0000);
		var l_mesh:Mesh = new Mesh(l_geometry, l_material);
		
		//l_object3D.x = Math.random() * 500;
		//l_object3D.y = Math.random() * 500;
		//l_object3D.z = Math.random() * 500;
		
		l_object3D.addChild(l_mesh);
		
		update(l_object3D, p_gameEntity);
		
		return l_object3D;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//typecast?
		
		updateState(p_object, p_gameEntity, 'posX');
		updateState(p_object, p_gameEntity, 'posY');
		updateState(p_object, p_gameEntity, 'posZ');
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast?
		
		switch (p_state)
		{
			case 'posX':
				p_object.x = p_gameEntity.getState(p_state);
			case 'posY':
				p_object.y = p_gameEntity.getState(p_state);
			case 'posZ':
				p_object.z = p_gameEntity.getState(p_state);
		}
		
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//typecast?
		
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