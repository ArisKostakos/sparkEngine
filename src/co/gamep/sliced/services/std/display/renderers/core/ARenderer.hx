/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	public var logicalViewSet( default, null ):Array<ILogicalView>;
	public var uses3DEngine( default, null ):Bool;
	
	private function new() 
	{
		_aRendererInit();
	}

	inline private function _aRendererInit():Void
	{
		logicalViewSet = new Array<ILogicalView>();
	}
	
	public function update ():Void
	{
		//update 'dirty' views
		for (logicalView in logicalViewSet)
		{
			_updateView(logicalView);
		}
	}
	
	private function _updateView(p_logicalView:ILogicalView):Void
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
		if (_hasView(p_logicalView) == false)
		{
			_createView(p_logicalView);
		}
		
		//VALIDATE IT
		_validateView(p_logicalView);
	}
	
	private function _updateScene(p_logicalScene:ILogicalScene):Void
	{
		//CREATE IT
		if (_hasScene(p_logicalScene) == false)
		{
			_createScene(p_logicalScene);
		}
		
		//VALIDATE IT
		_validateScene(p_logicalScene);
		
		
		//UPDATE CHILDREN
		for (f_logicalEntity in p_logicalScene.logicalEntitySet)
		{
			_updateEntity(f_logicalEntity, p_logicalScene);
		}
		
	}
	
	private function _updateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		//CREATE IT
		if (_hasCamera(p_logicalCamera) == false)
		{
			_createCamera(p_logicalCamera);
		}
		
		
		//VALIDATE IT
		_validateCamera(p_logicalCamera);
		
		
		//UPDATE CHILDREN
		//???????
	}
	
	//@todo: parent may be an entity too not just a scene. Also, update children, like u do in scene
	private function _updateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		//CREATE IT
		if (_hasEntity(p_logicalEntity) == false)
		{
			_createEntity(p_logicalEntity, p_logicalScene);
		}
		
		//VALIDATE IT
		_validateEntity(p_logicalEntity, p_logicalScene);
		

	}
	
	//override functions
	public function render ( p_logicalView:ILogicalView):Void { }
	
	private function _hasView(p_logicalView:ILogicalView):Bool { return false; }
	private function _createView(p_logicalView:ILogicalView):Void { }
	private function _validateView(p_logicalView:ILogicalView):Void { }
	
	private function _hasScene(p_logicalScene:ILogicalScene):Bool { return false; }
	private function _createScene(p_logicalScene:ILogicalScene):Void { }
	private function _validateScene(p_logicalScene:ILogicalScene):Void { }
	
	private function _hasCamera(p_logicalCamera:ILogicalCamera):Bool { return false; }
	private function _createCamera(p_logicalCamera:ILogicalCamera):Void { }
	private function _validateCamera(p_logicalCamera:ILogicalCamera):Void { }
	
	private function _hasEntity(p_logicalEntity:ILogicalEntity):Bool { return false; }
	private function _createEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void { }
	private function _validateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void { }
}