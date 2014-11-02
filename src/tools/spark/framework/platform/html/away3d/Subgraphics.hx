/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.html.away3d;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import tools.spark.sliced.services.std.display.renderers.core.platform.html.Away3DHtmlRenderer;
import tools.spark.sliced.services.std.display.renderers.core.platform.html.Flambe2_5DHtmlRenderer;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.platform.html.WebGLBatcher;
import flambe.platform.html.WebGLRenderer;
import flambe.platform.Renderer;
import flambe.platform.html.HtmlPlatform;
import away3d.utils.RequestAnimationFrame;
import away3d.events.Stage3DEvent;
import js.html.webgl.RenderingContext;

/**
 * ...
 * @author Aris Kostakos
 */
class Subgraphics
{	
	private static var _flambeDisplaySystem:Renderer;
	private static var _stage3DManager : Stage3DManager;
	private static var _stage3DProxy : Stage3DProxy;
	
	public static function createDisplayRenderers():Void
	{
		//Create Flambe Renderer
		Sliced.display.platformRendererSet.push(new Flambe2_5DHtmlRenderer());
		
		//Create Away3D Renderer
		Sliced.display.platformRendererSet.push(new Away3DHtmlRenderer());
	}
	
	public static function init():Void
	{
		//If Away3d code is inside, it will be responsible for
		//drawing things, instead of flambe's loop
		
		//Flambe Init
		_flambeDisplaySystem = HtmlPlatform.instance.getRenderer();
		
		//Away3d Init
		_initProxies();
	}
	
	//Called from flambe's HtmlPltform to get the Context3D created by Away3D
	public static function initAway3DStage3DgetContext3D():RenderingContext
	{
		//fix the haxe/js bug before running any js code
		//untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});'); //I put that in the framework since it's not just for away3d ts but anything external javascript
		
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
						
						
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		
		//Create a temp View3D which in away-ts will kind of 'initialize' the engine and the Stage
		var l_view3D:View3D = new View3D();
		l_view3D.shareContext = true;
		l_view3D.layeredView = true;
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		// Define a new Stage3DManager for the Stage3D objects
		_stage3DManager = Stage3DManager.getInstance(l_view3D.stage);
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		// Create a new Stage3D proxy to contain the separate views
		_stage3DProxy = _stage3DManager.getStage3DProxy(0);
		
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		l_view3D.dispose();
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		return _stage3DProxy.stage3D.context3D.gl();
	}
	
	/**
	 * Initialise the Stage3D proxies
	 */
	private static function _initProxies():Void
	{
		_stage3DProxy.antiAlias = 8;
		_stage3DProxy.color = 0xf00f00;
		
		//event listener
		var reqAnimFrame:Dynamic = new RequestAnimationFrame(_onAwayEnterFrame, Subgraphics);
		reqAnimFrame.start();
	}
	
	private static var _counterMax:Int = 1;
	private static var _counterCount:Int = 0;
	
	private static function _onAwayEnterFrame(?p1 : Dynamic):Void
	{
		if (Sliced.display == null) return;
		//@todo WTF, two more ifs here, JUST to check if there are active Views available???? DO SOMETHING ABOUT THAT, THIS THING RUNS EVERY - SINGLE - FRAME
		if (Sliced.display.projectActiveSpaceReference == null) return;
		if (Sliced.display.projectActiveSpaceReference.activeStageReference == null) return;
		
		//if (_counterCount >= _counterMax) return;
		
		var htmlrenderer:WebGLRenderer = cast(_flambeDisplaySystem, WebGLRenderer);
		var batcher:WebGLBatcher = htmlrenderer.batcher;
		
		
		
		//Console.info("away html rendering away: " + _stage3DManager.numProxySlotsUsed);
		
		// Clear the Context3D object
		//if (_counterCount < _counterMax) 
		//_stage3DProxy.clear();
		
		//Flambe Prepare Render
		_flambeDisplaySystem.willRender(); //DOES NOT DO AANYTHING. ITS EMPTY
		
		
		
		//query display for views in order (far away first)
		//for each Active View Reference (there are in z-order)
		for (activeViewReference in Sliced.display.projectActiveSpaceReference.activeStageReference.activeViewReferences)
		{
			_flambeDisplaySystem.didRender();
			
			//Render viewEntity
			activeViewReference.renderer.renderView(activeViewReference.viewEntity);
			
			_flambeDisplaySystem.didRender();
		}
		
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();
		
		// Present the Context3D object to Stage3D
		//_stage3DProxy.present();
		
		//_counterCount++;
	}
}