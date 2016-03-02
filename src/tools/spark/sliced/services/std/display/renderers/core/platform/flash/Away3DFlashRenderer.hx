/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform.flash;

import tools.spark.sliced.services.std.display.renderers.core.library.AAway3DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flash.Lib;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DFlashRenderer extends AAway3DRenderer implements IPlatformSpecificRenderer
{
	public function new() 
	{
		super();
		
		_away3DFlashRendererInit();
	}
	
	inline private function _away3DFlashRendererInit():Void
	{
		Console.log("Creating Away3D Flash Renderer...");
	}
	
	
	override public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		super.createView(p_viewEntity);
		
		//Add to flash's Stage3D
		
		//standard settings
		var stage3Dmanager:away3d.core.managers.Stage3DManager = away3d.core.managers.Stage3DManager.getInstance(Lib.current.stage);
		
		_views[p_viewEntity].stage3DProxy = stage3Dmanager.getStage3DProxy(0);
		_views[p_viewEntity].shareContext = true;
		
		//@TODO: WHAT DOES THIS DO??????????
		//_viewPointerSet[p_logicalView].layeredView = true; //only enable it if you really tihnk u need it. apparently, if enabled you don't need to clear() or present() the stage3DProxy
		
		//temp add childs
		//Lib.current.stage.addChild(_views[p_viewEntity]);
	
		//debug
		Lib.current.stage.addChild(new away3d.debug.AwayStats(_views[p_viewEntity]));
		
		return _views[p_viewEntity];
	}
}