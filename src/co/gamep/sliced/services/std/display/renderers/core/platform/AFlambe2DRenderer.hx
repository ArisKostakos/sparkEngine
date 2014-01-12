/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform;

import co.gamep.framework.pseudo3d.flambe.FlambeView;
import co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.Scene3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.View3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.ObjectContainer3D;
import co.gamep.sliced.services.std.display.renderers.core.A2DRenderer;
import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import flambe.platform.Renderer;


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
	
	override private function _createView(p_logicalView:View3D):Void
	{
		_viewPointerSet.set(p_logicalView, new FlambeView(_internalGraphics));
	}
	
	
	
	
	override private function _hasView(p_logicalView:View3D):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:Scene3D):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:Camera3D):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalObjectContainer:ObjectContainer3D):Bool { return _entityPointerSet.exists(p_logicalObjectContainer); }
}