/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform.html;

import away3d.containers.View3D;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.core.platform.AAway3DRenderer;
import away3d.core.managers.Stage3DManager;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DHtmlRenderer extends AAway3DRenderer
{
	public function new() 
	{
		super();
		
		_away3DHtmlRendererInit();
	}
	
	inline private function _away3DHtmlRendererInit():Void
	{
		Console.info("Creating Away3D Html Renderer...");
	}
	
	override private function _createView(p_logicalView:ILogicalView):Void
	{
		//@FIX: HUGE BUG. Every time I create a View3D in away-ts it will create a new Stage3DProxy!!! disable that!!!!!!!
			//or at least make sures u're only left with one Stage3DProxy not 2 or more
		super._createView(p_logicalView);
		
		//Add to html's Stage3D
		
		//standard settings
		//
		var stage3Dmanager:Stage3DManager = Stage3DManager.getInstance(_viewPointerSet[p_logicalView].stage);
		_viewPointerSet[p_logicalView].stage3DProxy = stage3Dmanager.getStage3DProxy(0);
		_viewPointerSet[p_logicalView].shareContext = true;// false;
		_viewPointerSet[p_logicalView].layeredView = true;// false;
		
		
		Console.info("away html new view created. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);
		stage3Dmanager.iRemoveStage3DProxy(stage3Dmanager.getStage3DProxy(1));
		Console.info("away html view removed. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);
		
		
		//temp add childs
		//Lib.current.stage.addChild(_viewPointerSet[p_logicalView]);
	
		//debug
		//Lib.current.stage.addChild(new AwayStats(_viewPointerSet[p_logicalView]));
	}
}