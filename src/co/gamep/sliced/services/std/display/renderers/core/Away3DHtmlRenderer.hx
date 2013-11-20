/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import away3d.utils.RequestAnimationFrame;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DHtmlRenderer extends AAway3DRenderer
{
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		Console.info("Creating Away3D Html Renderer...");
		
		//fix the haxe/js bug before running any js code
		untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});');
		
		//@todo aris):  1. EASY: don't check by id to get the content: "content-canvas" but do it like flambe does it (using the property in flambe embeder on the html)
		//				2. IMPORTANT: right now, the away3d.next.js will create a stage of default size: 640x480. What happens if flambe's content is NOT the same size as that (currently it's also 640x480)
		//away3d ts Stage hack
		untyped __js__('
						away.display.Stage.prototype.createHTMLCanvasElement = function () {
								return document.getElementById("content-canvas");
							};
							
						away.display.Stage.prototype.addChildHTMLElement = function (canvas) {
								
							};
						
						');
		
		//event listener
		var reqAnimFrame:Dynamic = new RequestAnimationFrame(_onAwayEnterFrame, this);
		reqAnimFrame.start();
	}
	
	override public function update ():Void
	{
		super.update();
	}
	/*
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		
	}
	*/
	
	private function _onAwayEnterFrame(?p1 : Dynamic):Void
	{
		for (logicalView in logicalViewSet)
		{
			//render a view
			_viewPointerSet[logicalView].render();
		}
	}
}