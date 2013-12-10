/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.framework.pseudo3d.interfaces.IPseudoCamera;
import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;
import co.gamep.framework.pseudo3d.interfaces.IPseudoView;
import co.gamep.framework.pseudo3d.core.PseudoCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;

/**
 * ...
 * @author Aris Kostakos
 */
class A2DRenderer extends ARenderer
{
	private var _viewPointerSet:Map<ILogicalView,IPseudoView>;
	private var _scenePointerSet:Map<ILogicalScene,IPseudoScene>;
	private var _entityPointerSet:Map<ILogicalEntity,IPseudoEntity>;
	private var _cameraPointerSet:Map<ILogicalCamera,IPseudoCamera>;
	
	private function new() 
	{
		super();
		
		_a2DRendererInit();
	}
	
	
	inline private function _a2DRendererInit():Void
	{
		uses3DEngine = false;
		
		_viewPointerSet = new Map<ILogicalView,IPseudoView>();
		_scenePointerSet = new Map<ILogicalScene,IPseudoScene>();
		_entityPointerSet = new Map<ILogicalEntity,IPseudoEntity>();
		_cameraPointerSet = new Map<ILogicalCamera,IPseudoCamera>();
	}	
	
	override private function _createCamera(p_logicalCamera:ILogicalCamera):Void
	{
		_cameraPointerSet.set(p_logicalCamera, new PseudoCamera());
	}
	
	override private function _validateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		_cameraPointerSet[p_logicalCamera].x = p_logicalCamera.x;
		_cameraPointerSet[p_logicalCamera].y = p_logicalCamera.y;
		_cameraPointerSet[p_logicalCamera].z = p_logicalCamera.z;
		_cameraPointerSet[p_logicalCamera].yaw = p_logicalCamera.yaw;
		_cameraPointerSet[p_logicalCamera].pitch = p_logicalCamera.pitch;
		_cameraPointerSet[p_logicalCamera].roll = p_logicalCamera.roll;
		_cameraPointerSet[p_logicalCamera].fieldOfView = p_logicalCamera.fieldOfView;
	}
	
	override private function _validateView(p_logicalView:ILogicalView):Void
	{
		_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.logicalCamera];
		_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.logicalScene];
		_viewPointerSet[p_logicalView].width = p_logicalView.width;
		_viewPointerSet[p_logicalView].height = p_logicalView.height;
		_viewPointerSet[p_logicalView].x = p_logicalView.x;
		_viewPointerSet[p_logicalView].y = p_logicalView.y;

		_viewPointerSet[p_logicalView].validate();
		//temp add childs
		//_viewPointerSet[p_logicalView].addChild(_scenePointerSet[p_logicalView.logicalScene]);
	}
	
	override private function _validateScene(p_logicalScene:ILogicalScene):Void
	{
		
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		_entityPointerSet[p_logicalEntity].x = p_logicalEntity.x;
		_entityPointerSet[p_logicalEntity].y = p_logicalEntity.y;
		_entityPointerSet[p_logicalEntity].z = p_logicalEntity.z;
		_entityPointerSet[p_logicalEntity].yaw = p_logicalEntity.yaw;
		_entityPointerSet[p_logicalEntity].pitch = p_logicalEntity.pitch;
		_entityPointerSet[p_logicalEntity].roll = p_logicalEntity.roll;
		
		_entityPointerSet[p_logicalEntity].validate();
	}
}