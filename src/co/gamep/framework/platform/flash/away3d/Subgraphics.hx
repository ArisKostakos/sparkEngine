/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.flash.away3d;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import away3d.debug.AwayStats;
import away3d.entities.Mesh;
import away3d.events.Stage3DEvent;
import away3d.primitives.PlaneGeometry;
import co.gamep.sliced.core.Sliced;
import co.gamep.sliced.services.std.display.renderers.core.Away3DFlashRenderer;
import co.gamep.sliced.services.std.display.renderers.core.FlambeRenderer;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.platform.flash.FlashPlatform;
import flambe.platform.flash.Stage3DRenderer;
import flambe.platform.Renderer;
import flambe.System;
import flash.events.Event;
import flash.geom.Vector3D;
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
	private static var _away3dView:View3D;
	
	public static function createDisplayRenderers():Void
	{
		//Create Flambe Renderer
		Sliced.display.rendererSet.push(new FlambeRenderer());
		
		//Create Away3D Renderer
		Sliced.display.rendererSet.push(new Away3DFlashRenderer());
	}
	
	public static function init():Void
	{
		//If Away3d code is inside, it will be responsible for
		//drawing things, instead of flambe
		
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
		var renderer:Renderer = FlashPlatform.instance.getRenderer();
        var graphics = renderer.graphics;
		
		
		// Clear the Context3D object
		_stage3DProxy.clear();

		
		renderer.willRender();
		
		//query display for views in order (far away first)
			//for each LogicalView
				//query Display what renderer has it
					//renderer.render(logicalView)
					
		if (Sliced.display!=null)
		{
			for (logicalView in Sliced.display.logicalViewsOrder)
			{
				var renderer:IRenderer = Sliced.display.logicalViewRendererAssignments[logicalView];
				renderer.render(logicalView);
			}
		}
		// Render the Flambe layer
		//_flambeRender(false);
		
		// Render the Away3D layer
		//_away3dView.render();

		// Render the Flambe layer
		//_flambeRender(true);
		
		
		renderer.didRender();

		// Present the Context3D object to Stage3D
		_stage3DProxy.present();
	}
	
	/**
	* The main rendering loop
	*/
	private static function _flambeRender(first:Bool) : Void 
	{
		var renderer:Renderer = FlashPlatform.instance.getRenderer();
		
        var graphics = renderer.graphics;
		
		var child:Entity =System.root.firstChild;
		
		if (child != null)
		{
			if (!first) child = child.next;
			
			if (graphics != null) 
			{
				Sprite.render(child, graphics);
			}
		}
		
		/*
		//Console.warn("Iterating children: START");
		var child:Entity = System.root.firstChild;
		while (child != null) 
		{
			var next:Entity = child.next; 
			
			// do something with child here
			if (graphics != null) 
			{
				renderer.willRender();
				Sprite.render(child, graphics);
				renderer.didRender();
			}
			
			//Console.info("hiiiiiiiiiiiiiiiii");
			
			child = next;
		}
		
		//Console.warn("Iterating children: END");
		
		*/
	}
	
	
	
	/**
	 
	 
	private static function _initAway3D() : Void
	{
		// Create the first Away3D view which holds the cube objects.
		_away3dView = new View3D();
		_away3dView.stage3DProxy = _stage3DProxy;
		_away3dView.shareContext = true;
	  
		//hoverController = new HoverController(away3dView.camera, null, 45, 30, 1200, 5, 89.999);

		Lib.current.stage.addChild(_away3dView);
	  
		Lib.current.stage.addChild(new AwayStats(_away3dView));
		
		
		//setup the camera
		_away3dView.camera.z = -600;
		_away3dView.camera.y = 500;
		_away3dView.camera.lookAt(new Vector3D());
		
		//setup the scene
		_plane = new Mesh(new PlaneGeometry(700, 700));
		_away3dView.scene.addChild(_plane);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, _updateAway3dView);
	}
	
	private static var _plane:Mesh;
	
	private static function _updateAway3dView(e:Event):Void
	{
		_plane.rotationY += 1;
	}
	*/
	
	
	
		/*
		Console.warn("Stage 3d free: " + Std.string(Stage3DManager.getInstance(Lib.current.stage).numProxySlotsFree));
		Console.warn("Stage 3d used: " + Std.string(Stage3DManager.getInstance(Lib.current.stage).numProxySlotsUsed));
		
		for (stage3d in Lib.current.stage.stage3Ds)
		{
			Console.warn("Stage3d: " + stage3d.context3D);
		}
		*/
		
		
		/*
		// Use the first available Stage3D
		var poutsa:Int = 0;
        var stage = flash.Lib.current.stage;
        for (stage3D in stage.stage3Ds) 
		{
            if (stage3D.context3D != null) 
			{
               poutsa += 1;
            }
        }
		
		Console.warn("Stage3ds: " + poutsa);
		*/
}