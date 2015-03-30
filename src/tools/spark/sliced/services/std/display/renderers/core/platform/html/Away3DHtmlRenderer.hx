/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.renderers.core.platform.html;


import tools.spark.sliced.services.std.display.renderers.core.library.AAway3DRenderer;
import away3d.core.managers.Stage3DManager;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DHtmlRenderer extends AAway3DRenderer implements IPlatformSpecificRenderer
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
	/*
	override public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		//@FIX: HUGE BUG. Every time I create a View3D in away-ts it will create a new Stage3DProxy!!! disable that!!!!!!!
			//or at least make sures u're only left with one Stage3DProxy not 2 or more
		super.createView(p_viewEntity);
		
		//Add to html's Stage3D
		
		//standard settings
		//
		var stage3Dmanager:Stage3DManager = Stage3DManager.getInstance(_views[p_viewEntity].stage);
		_views[p_viewEntity].stage3DProxy = stage3Dmanager.getStage3DProxy(0);
		_views[p_viewEntity].shareContext = true;// false;
		_views[p_viewEntity].layeredView =  true;// false;
		
		Console.error("CREATED VIEW 3D WITHOUT A GROUP ON HTML RENDERER!!");
		Console.info("away html new view created. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);
		stage3Dmanager.iRemoveStage3DProxy(stage3Dmanager.getStage3DProxy(1));
		Console.info("away html view removed. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);
		
		
		//temp add childs
		//Lib.current.stage.addChild(_viewPointerSet[p_logicalView]);
	
		//debug
		//Lib.current.stage.addChild(new AwayStats(_viewPointerSet[p_logicalView]));
		
		return _views[p_viewEntity];
	}
	*/
}