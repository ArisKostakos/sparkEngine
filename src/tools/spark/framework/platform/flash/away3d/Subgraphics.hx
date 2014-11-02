/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.flash.away3d;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import away3d.events.Stage3DEvent;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.display.renderers.core.platform.flash.Away3DFlashRenderer;
import tools.spark.sliced.services.std.display.renderers.core.platform.flash.Flambe2_5DFlashRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.platform.flash.FlashPlatform;
import flambe.platform.flash.Stage3DRenderer;
import flambe.platform.Renderer;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author Aris Kostakos
 */
class Subgraphics
{	
	// Stage manager and proxy instances
	private static var _stage3DManager : Stage3DManager;
	private static var _stage3DProxy : Stage3DProxy;
	private static var _flambeDisplaySystem:Renderer;
	
	public static function createDisplayRenderers():Void
	{
		//Create Flambe Renderer
		Sliced.display.platformRendererSet.push(new Flambe2_5DFlashRenderer());
		
		//Create Away3D Renderer
		Sliced.display.platformRendererSet.push(new Away3DFlashRenderer());
	}
	
	public static function init():Void
	{
		//If Away3d code is inside, it will be responsible for
		//drawing things, instead of flambe
		
		//Flambe Init
		_flambeDisplaySystem = FlashPlatform.instance.getRenderer();
		
		//Away3d Init
		_initProxies();
	}
	
	/**
	 * Initialise the Stage3D proxies
	 */
	private static function _initProxies():Void
	{
		// Define a new Stage3DManager for the Stage3D objects
		_stage3DManager = Stage3DManager.getInstance(Lib.current.stage);
	  
		// Create a new Stage3D proxy to contain the separate views
		_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
		_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, _onContextCreated);
		_stage3DProxy.antiAlias = 8;
		_stage3DProxy.color = 0x0;
	}
	
	private static function _onContextCreated(event : Stage3DEvent) : Void 
	{
		//Safe casting since we have already made sure we're on the flash platform
			//so the Renderer interface MUST be implemented by the Stage3DRenderer
		var stage3dRenderer:Stage3DRenderer = cast(FlashPlatform.instance.getRenderer(),Stage3DRenderer);
		
		//pass Context to Flambe
		stage3dRenderer.onContext3DImport(_stage3DProxy.stage3D);
		
		//The Render Call  (Event.ENTER_FRAME, OR Event.RENDER?)
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
	}
	
	/**
	* The main rendering loop
	*/
	private static function _onEnterFrame(event : Event) : Void 
	{
		// Clear the Context3D object
		_stage3DProxy.clear();

		//Flambe Prepare Render
		_flambeDisplaySystem.willRender();
		
		//query display for views in order (far away first)
		if (Sliced.display!=null)
		{
			//for each activeViewReference
			for (activeViewReference in Sliced.display.projectActiveSpaceReference.activeStageReference.activeViewReferences)
			{
				//Render viewEntity
				activeViewReference.renderer.renderView(activeViewReference.viewEntity);
			}
		}
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();

		// Present the Context3D object to Stage3D
		_stage3DProxy.present();
	}
	
	

}