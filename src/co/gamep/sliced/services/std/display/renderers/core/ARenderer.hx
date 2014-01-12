/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.Scene3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.View3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.ObjectContainer3D;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	public var logicalViewSet( default, null ):Array<View3D>;
	public var uses3DEngine( default, null ):Bool;
	
	private function new() 
	{
		_aRendererInit();
	}

	inline private function _aRendererInit():Void
	{
		logicalViewSet = new Array<View3D>();
	}
	
	public function update ():Void
	{
		//update 'dirty' views
		for (logicalView in logicalViewSet)
		{
			_updateView(logicalView);
		}
	}
	
	private function _updateView(p_logicalView:View3D):Void
	{
		//UPDATE SCENE
		
		//assert scene
		if (p_logicalView.scene == null) {
			Console.error("nothing to render...");
			return; }
			
		_updateScene(p_logicalView.scene);
		
		
		//UPDATE CAMERA
		
		//assert camera
		if (p_logicalView.camera == null) {
			Console.error("no way to render...");
			return; }
		
		_updateCamera(p_logicalView.camera);
		
		
		//UPDATE VIEW
		
		//CREATE IT
		if (_hasView(p_logicalView) == false)
		{
			_createView(p_logicalView);
		}
		
		//VALIDATE IT
		_validateView(p_logicalView);
	}
	
	private function _updateScene(p_logicalScene:Scene3D):Void
	{
		//CREATE IT
		if (_hasScene(p_logicalScene) == false)
		{
			_createScene(p_logicalScene);
		}
		
		//VALIDATE IT
		_validateScene(p_logicalScene);
		
		//UPDATE CHILDREN
		for (f_logicalObjectContainer in p_logicalScene._sceneGraphRoot._children)
		{
			_updateEntity(f_logicalObjectContainer, p_logicalScene);
		}
		
	}
	
	private function _updateCamera(p_logicalCamera:Camera3D):Void
	{
		//CREATE IT
		if (_hasCamera(p_logicalCamera) == false)
		{
			_createCamera(p_logicalCamera);
		}
		
		
		//VALIDATE IT
		_validateCamera(p_logicalCamera);
	}
	
	//@todo: parent may be an entity too not just a scene. Also, update children, like u do in scene
	private function _updateEntity(p_logicalObjectContainer:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		//CREATE IT
		if (_hasEntity(p_logicalObjectContainer) == false)
		{
			_createEntity(p_logicalObjectContainer, p_logicalScene);
		}
		
		//VALIDATE IT
		_validateEntity(p_logicalObjectContainer, p_logicalScene);
		
		//UPDATE CHILDREN
		//???????
	}
	
	//override functions
	public function render ( p_logicalView:View3D):Void { }
	
	private function _hasView(p_logicalView:View3D):Bool { return false; }
	private function _createView(p_logicalView:View3D):Void { }
	private function _validateView(p_logicalView:View3D):Void { }
	
	private function _hasScene(p_logicalScene:Scene3D):Bool { return false; }
	private function _createScene(p_logicalScene:Scene3D):Void { }
	private function _validateScene(p_logicalScene:Scene3D):Void { }
	
	private function _hasCamera(p_logicalCamera:Camera3D):Bool { return false; }
	private function _createCamera(p_logicalCamera:Camera3D):Void { }
	private function _validateCamera(p_logicalCamera:Camera3D):Void { }
	
	private function _hasEntity(p_logicalObjectContainer:ObjectContainer3D):Bool { return false; }
	private function _createEntity(p_logicalObjectContainer:ObjectContainer3D, p_logicalScene:Scene3D):Void { }
	private function _validateEntity(p_logicalObjectContainer:ObjectContainer3D, p_logicalScene:Scene3D):Void { }
}