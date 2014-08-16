/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
//import co.gamep.framework.pseudo3d.core.PseudoEntity;
//import co.gamep.framework.pseudo3d.core.PseudoScene;
//import co.gamep.framework.pseudo3d.interfaces.IPseudoCamera;
//import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
//import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;
//import co.gamep.framework.pseudo3d.interfaces.IPseudoView;
//import co.gamep.framework.pseudo3d.core.PseudoCamera;

/**
 * ...
 * @author Aris Kostakos
 */
class A2_5DRenderer extends ARenderer
{
	//private var _viewPointerSet:Map<View3D,IPseudoView>;
	//private var _scenePointerSet:Map<Scene3D,IPseudoScene>;
	//private var _entityPointerSet:Map<ObjectContainer3D,IPseudoEntity>;
	//private var _cameraPointerSet:Map<Camera3D,IPseudoCamera>;
	
	private function new() 
	{
		super();
		
		_a2DRendererInit();
	}
	
	
	inline private function _a2DRendererInit():Void
	{
		//uses3DEngine = false;
		
		//_viewPointerSet = new Map<View3D,IPseudoView>();
		//_scenePointerSet = new Map<Scene3D,IPseudoScene>();
		//_entityPointerSet = new Map<ObjectContainer3D,IPseudoEntity>(); 
		//_cameraPointerSet = new Map<Camera3D,IPseudoCamera>();
	}	
	
	override public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//render a view
		//_viewPointerSet[p_logicalView].render();
		//Console.warn("2.5 ARenderer rendering View: " + p_viewEntity.getState('name'));
		
		//TODO NEXT!!!!!!!!!!!!!!!!!!!!!
		//this will now render properly. put some entities to test it out and maybe override this for flambe 2.5 html, and make use of space2.5. Take snippets from Flambe View but be careful!
		//The way i link flambe view to the flambe 2.5html renderer right now is in AFlambe2_5renderer. do something similar. Also, mind invalidation this time!
	}
	
	/*
	override private function _createCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet.set(p_logicalCamera, new PseudoCamera());
	}
	
	override private function _validateCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet[p_logicalCamera].x = p_logicalCamera.x;
		_cameraPointerSet[p_logicalCamera].y = p_logicalCamera.y;
		_cameraPointerSet[p_logicalCamera].z = p_logicalCamera.z;
		_cameraPointerSet[p_logicalCamera].rotationX = p_logicalCamera.rotationX;
		_cameraPointerSet[p_logicalCamera].rotationY = p_logicalCamera.rotationY;
		_cameraPointerSet[p_logicalCamera].rotationZ = p_logicalCamera.rotationZ;
		//_cameraPointerSet[p_logicalCamera].fieldOfView = p_logicalCamera.fieldOfView;
	}
	
	override private function _validateView(p_logicalView:View3D):Void
	{
		_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.camera];
		_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.scene];
		_viewPointerSet[p_logicalView].width = p_logicalView.width;
		_viewPointerSet[p_logicalView].height = p_logicalView.height;
		_viewPointerSet[p_logicalView].x = p_logicalView.x;
		_viewPointerSet[p_logicalView].y = p_logicalView.y;

		_viewPointerSet[p_logicalView].validate();
		//temp add childs
		//_viewPointerSet[p_logicalView].addChild(_scenePointerSet[p_logicalView.logicalScene]);
	}
	
	override private function _createScene(p_logicalScene:Scene3D):Void
	{
		_scenePointerSet.set(p_logicalScene, new PseudoScene());
	}
	
	override private function _validateScene(p_logicalScene:Scene3D):Void
	{
		
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _createEntity(p_logicalEntity:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		_entityPointerSet.set(p_logicalEntity, new PseudoEntity());
		_entityPointerSet[p_logicalEntity].spriteUrl = p_logicalEntity.assetType;
		_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalEntity:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		_entityPointerSet[p_logicalEntity].x = p_logicalEntity.x;
		_entityPointerSet[p_logicalEntity].y = p_logicalEntity.y;
		_entityPointerSet[p_logicalEntity].z = p_logicalEntity.z;
		_entityPointerSet[p_logicalEntity].rotationX = p_logicalEntity.rotationX;
		_entityPointerSet[p_logicalEntity].rotationY = p_logicalEntity.rotationY;
		_entityPointerSet[p_logicalEntity].rotationZ = p_logicalEntity.rotationZ;
		_entityPointerSet[p_logicalEntity].velX = p_logicalEntity.velX;
		_entityPointerSet[p_logicalEntity].velY = p_logicalEntity.velY;
		_entityPointerSet[p_logicalEntity].velZ = p_logicalEntity.velZ;
	}
	*/
}