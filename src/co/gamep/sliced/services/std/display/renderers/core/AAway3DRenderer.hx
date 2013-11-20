/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.primitives.SphereGeometry;
import away3d.entities.Entity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene; 
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;

#if flash
	import flash.Lib;
	import away3d.core.managers.Stage3DManager;
	import away3d.debug.AwayStats;
#end

/**
 * ...
 * @author Aris Kostakos
 */
class AAway3DRenderer extends ARenderer
{
	private var _viewPointerSet:Map<ILogicalView,View3D>;
	private var _scenePointerSet:Map<ILogicalScene,Scene3D>;
	private var _entityPointerSet:Map<ILogicalEntity,Entity>;
	private var _cameraPointerSet:Map<ILogicalCamera,Camera3D>;
	
	private function new()
	{
		//Abstract class, private constructor
		super();
		
		_aAway3dRendererinit();
	}

	inline private function _aAway3dRendererinit():Void
	{
		uses3DEngine = true;
		
		_viewPointerSet = new Map<ILogicalView,View3D>();
		_scenePointerSet = new Map<ILogicalScene,Scene3D>();
		_entityPointerSet = new Map<ILogicalEntity,Entity>();
		_cameraPointerSet = new Map<ILogicalCamera,Camera3D>();
	}
	
	override public function update ():Void
	{
		super.update();
	}
	
	override private function _updateView(p_logicalView:ILogicalView):Void
	{
		//UPDATE SCENE
		
		//assert scene
		if (p_logicalView.logicalScene == null) {
			Console.error("nothing to render...");
			return; }
			
		_updateScene(p_logicalView.logicalScene);
		
		//UPDATE CAMERA
		
		//assert camera
		if (p_logicalView.logicalCamera == null) {
			Console.error("no way to render...");
			return; }
		
		_updateCamera(p_logicalView.logicalCamera);
		
		
		//UPDATE VIEW
		
		//CREATE IT
		if (_viewPointerSet.exists(p_logicalView) == false)
		{
			_viewPointerSet.set(p_logicalView, new View3D());
			_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.logicalScene];
			_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.logicalCamera];
			_viewPointerSet[p_logicalView].width = p_logicalView.width;
			_viewPointerSet[p_logicalView].height = p_logicalView.height;

			#if flash
				//standard settings
				var stage3Dmanager:Stage3DManager = Stage3DManager.getInstance(Lib.current.stage);
				
				_viewPointerSet[p_logicalView].stage3DProxy = stage3Dmanager.getStage3DProxy(0);
				_viewPointerSet[p_logicalView].shareContext = true;
				
				//temp add childs
				Lib.current.stage.addChild(_viewPointerSet[p_logicalView]);
			
				//debug
				Lib.current.stage.addChild(new AwayStats(_viewPointerSet[p_logicalView]));
			#end
		}
			
		//UPDATE IT
		
	}
	
	override private function _updateScene(p_logicalScene:ILogicalScene):Void
	{
		//CREATE IT
		if (_scenePointerSet.exists(p_logicalScene) == false)
		{
			_scenePointerSet.set(p_logicalScene, new Scene3D());
			//_scenePointerSet[p_logicalScene]
		}
		
		//UPDATE IT
		for (f_logicalEntity in p_logicalScene.logicalEntitySet)
		{
			_updateEntity(f_logicalEntity, p_logicalScene);
		}
		
	}
	
	override private function _updateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		//CREATE IT
		if (_cameraPointerSet.exists(p_logicalCamera) == false)
		{
			_cameraPointerSet.set(p_logicalCamera, new Camera3D());
		}
		
		
		//UPDATE IT
		_cameraPointerSet.get(p_logicalCamera).x = p_logicalCamera.x;
		_cameraPointerSet.get(p_logicalCamera).y = p_logicalCamera.y;
		_cameraPointerSet.get(p_logicalCamera).z = p_logicalCamera.z;
		_cameraPointerSet.get(p_logicalCamera).yaw(p_logicalCamera.yaw);
		_cameraPointerSet.get(p_logicalCamera).pitch( p_logicalCamera.pitch);
		_cameraPointerSet.get(p_logicalCamera).roll(p_logicalCamera.roll);
	}
	
	override private function _updateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		//CREATE IT
		if (_entityPointerSet.exists(p_logicalEntity) == false)
		{
			_entityPointerSet.set(p_logicalEntity, new Mesh(new SphereGeometry()));
			_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
		}
		

		//UPDATE IT
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
	
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		_viewPointerSet[p_logicalView].render();
		
		//Console.info("away3d render request");
	}
}