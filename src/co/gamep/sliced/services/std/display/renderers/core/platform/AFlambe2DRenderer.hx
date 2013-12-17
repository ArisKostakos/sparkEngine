/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform;

import co.gamep.framework.pseudo3d.flambe.FlambeView;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.renderers.core.A2DRenderer;
import flambe.Entity;
import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import flambe.platform.Renderer;
import flambe.System;


/**
 * ...
 * @author Aris Kostakos
 */
class AFlambe2DRenderer extends A2DRenderer
{
	private var _platform:Platform;
	private var _internalGraphics:InternalGraphics;
	
	private function new() 
	{
		super();
		
		_flambeRendererInit();
	}
	
	inline private function _flambeRendererInit():Void
	{
        _internalGraphics = _platform.getRenderer().graphics;
		
		if (_internalGraphics == null)
		{
			Console.error("Flambe renderer does NOT have internal graphics!");
		}
	}
	
	override private function _createView(p_logicalView:ILogicalView):Void
	{
		_viewPointerSet.set(p_logicalView, new FlambeView(_internalGraphics));
	}
	
	
	
	
	override private function _hasView(p_logicalView:ILogicalView):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:ILogicalScene):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:ILogicalCamera):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalEntity:ILogicalEntity):Bool { return _entityPointerSet.exists(p_logicalEntity); }
}