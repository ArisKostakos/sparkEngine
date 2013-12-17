/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform;

import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.core.base.Geometry;
import away3d.entities.Mesh;

#if flash
	import flash.geom.Vector3D;
#else
	import away3d.core.geom.Vector3D;
#end

import away3d.lights.DirectionalLight;
import away3d.materials.ColorMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.MaterialBase;
import away3d.primitives.SphereGeometry;
import away3d.entities.Entity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalMesh;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.core.A3DRenderer;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene; 
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class AAway3DRenderer extends A3DRenderer
{
	private var _viewPointerSet:Map<ILogicalView,View3D>;
	private var _scenePointerSet:Map<ILogicalScene,Scene3D>;
	private var _entityPointerSet:Map<ILogicalEntity,Entity>;
	private var _cameraPointerSet:Map<ILogicalCamera,Camera3D>;
	
	private function new()
	{
		//Abstract class, private constructor
		super();
		
		_aAway3dRendererInit();
	}

	inline private function _aAway3dRendererInit():Void
	{
		_viewPointerSet = new Map<ILogicalView,View3D>();
		_scenePointerSet = new Map<ILogicalScene,Scene3D>();
		_entityPointerSet = new Map<ILogicalEntity,Entity>();
		_cameraPointerSet = new Map<ILogicalCamera,Camera3D>();
	}
	
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		_viewPointerSet[p_logicalView].render();
		
		//Console.info("away3d render request");
	}
	
	
	override private function _createView(p_logicalView:ILogicalView):Void
	{
		_viewPointerSet.set(p_logicalView, new View3D());
		_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.logicalScene];
		_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.logicalCamera];
		
		//away3d ts bug?
		_viewPointerSet[p_logicalView].x = 0;// p_logicalView.x;
		_viewPointerSet[p_logicalView].y = 0;// p_logicalView.y;
		_viewPointerSet[p_logicalView].width = 640;// p_logicalView.width;
		_viewPointerSet[p_logicalView].height = 480;// p_logicalView.height;
	}
	
	override private function _validateView(p_logicalView:ILogicalView):Void
	{
		//WHAT ABOUT X AND Y??????????
	}
	
	
	override private function _createScene(p_logicalScene:ILogicalScene):Void
	{
		_scenePointerSet.set(p_logicalScene, new Scene3D());
	}
	
	override private function _validateScene(p_logicalScene:ILogicalScene):Void
	{
		
	}
	
	override private function _createCamera(p_logicalCamera:ILogicalCamera):Void
	{
		_cameraPointerSet.set(p_logicalCamera, new Camera3D());
	}
	
	override private function _validateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		_cameraPointerSet.get(p_logicalCamera).x = p_logicalCamera.x;
		_cameraPointerSet.get(p_logicalCamera).y = p_logicalCamera.y;
		_cameraPointerSet.get(p_logicalCamera).z = p_logicalCamera.z;
		_cameraPointerSet.get(p_logicalCamera).lookAt(new Vector3D(0, 0, 0));
		//_cameraPointerSet.get(p_logicalCamera).yaw(p_logicalCamera.pitch);
		//_cameraPointerSet.get(p_logicalCamera).pitch( p_logicalCamera.pitch);
		//_cameraPointerSet.get(p_logicalCamera).roll(p_logicalCamera.roll);
	}
	
	private var _deleteMeMainLight:DirectionalLight;
	private var _deleteMeMainLightpicker:StaticLightPicker;
	
	private function _deletemeCreateLight(p_logicalScene:ILogicalScene):Void
	{
		var directionalLight:DirectionalLight = new DirectionalLight();
		directionalLight.ambientColor = 0xFFFFFF;
		directionalLight.color = 0xFFFFFF;
		directionalLight.ambient = 0.39;
		directionalLight.castsShadows = false;
		//directionalLight.shaderPickingDetails = false;
		directionalLight.specular = 0.8;
		directionalLight.diffuse = 0.6;
		directionalLight.name = "MainLight";
		directionalLight.direction = new Vector3D(-0.7376268918178536, -0.4171149406714452, -0.5309629881034924);
		_scenePointerSet[p_logicalScene].addChild(directionalLight);
		
		_deleteMeMainLight = directionalLight;
		
		_deleteMeMainLightpicker = new StaticLightPicker([_deleteMeMainLight]);
	}
	
	
	//@todo: parent may be an entity too not just a scene
	override private function _createEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		if (_deleteMeMainLight == null) _deletemeCreateLight(p_logicalScene);
		
		var l_logicalMesh:ILogicalMesh = cast(p_logicalEntity, ILogicalMesh);
		Console.warn("meshType_3d: " + l_logicalMesh.meshType_3d);
		Console.warn("mesh_3d: " + l_logicalMesh.mesh_3d);
		
		Console.warn("materialType_3d: " + l_logicalMesh.materialType_3d);
		Console.warn("material_3d: " + l_logicalMesh.material_3d);
		
		var l_mesh:Mesh;
		var l_geometry:Geometry=null;
		var l_material:MaterialBase=null;
		
		if (l_logicalMesh.meshType_3d == "Primitive")
		{
			if (l_logicalMesh.mesh_3d == "Sphere")
			{
				l_geometry = new SphereGeometry();
			}
		}
		
		if (l_logicalMesh.materialType_3d == "Color")
		{
			l_material = new ColorMaterial(Std.parseInt(l_logicalMesh.material_3d));
			l_material.lightPicker = _deleteMeMainLightpicker;
		}
		l_mesh = new Mesh(l_geometry, l_material);
		//l_mesh.visible = false;
		_entityPointerSet.set(p_logicalEntity, l_mesh);
		_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		_entityPointerSet.get(p_logicalEntity).x = p_logicalEntity.x;
		_entityPointerSet.get(p_logicalEntity).y = p_logicalEntity.y;
		_entityPointerSet.get(p_logicalEntity).z = p_logicalEntity.z;
		//_entityPointerSet.get(p_logicalEntity).yaw(p_logicalEntity.yaw);
		//_entityPointerSet.get(p_logicalEntity).pitch(p_logicalEntity.pitch);
		//_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
		
		_entityPointerSet.get(p_logicalEntity).rotationZ=p_logicalEntity.yaw;
		_entityPointerSet.get(p_logicalEntity).rotationX=p_logicalEntity.pitch;
		_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
	}
	
	override private function _hasView(p_logicalView:ILogicalView):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:ILogicalScene):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:ILogicalCamera):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalEntity:ILogicalEntity):Bool { return _entityPointerSet.exists(p_logicalEntity); }
}