/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.core;

import co.gamep.framework.Framework;
import co.gamep.sliced.interfaces.IDisplay;
import co.gamep.sliced.core.AService;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalLight;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalMesh;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.core.LogicalView;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalLight;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalMesh;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class Display extends AService implements IDisplay
{
	//todo: somewhere here, add a filtering mechanism for choosing the appropriate renderer
	//do this by enumerating all the available renderers added for the current platform
	//and start disqualifing renderers due to platform requirements and restrictions
	//order by gRenderer request, then chose the top one
	//@todo: Reflection needed here!!! See above todo
	
	//@think: this is a nice way to check if a new view/scene/entity/etc has been created, 
	//instead of itterating the virtual world. The Renderer may find this useful.

	public var logicalSpace( default, default ):ILogicalSpace;
	public var rendererSet( default, null ):Array<IRenderer>;
	
	//views data stored here for optimization (saving the platform.subgraphics from looking which renderer is responsible for which view
		//and in what order the views must be renderer
	public var logicalViewsOrder (default, null ):Array<ILogicalView>;
	public var logicalViewRendererAssignments (default, null ):Map<ILogicalView,IRenderer>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Display std Service...");
		rendererSet = new Array<IRenderer>();
		logicalViewsOrder = new Array<ILogicalView>();
		logicalViewRendererAssignments = new Map<ILogicalView,IRenderer>();
	}
	
	
	//temp
	private var _renderer3dcapable:IRenderer;
	private var _renderer2dcapable:IRenderer;
	
	public function update():Void 
	{
		//Assert logicalSpace
		if (logicalSpace == null)
			return;
		
		//We will be polling the logicalSpace here and taking action when a change is found
		
		//Display is responsible for polling up to the Views level
		
		//Then, it will update all active renderers to poll their assigned view
		
		//TEMP POLLING EXAMPLE
		
		//Find 3d capable renderer
		if (_renderer3dcapable == null)
		{
			for (renderer in rendererSet)
			{
				if (renderer.uses3DEngine == true)
				{
					_renderer3dcapable = renderer;
					break;
				}
			}
		}
		
		//Find 2dcapable renderer
		if (_renderer2dcapable == null)
		{
			for (renderer in rendererSet)
			{
				if (renderer.uses3DEngine == false)
				{
					_renderer2dcapable = renderer;
					break;
				}
			}
		}
			
		//poll for 'dirty' views. actually you poll for 'dirty' stages here... and 'dirty' space of course
		var l_temp_spaceInvalidated:Bool = false;	//temp value until i do proper invalidation
		
		for (logicalView in logicalSpace.logicalStage.logicalViewSet)
		{
			if (logicalViewRendererAssignments.exists(logicalView) == false)
			{
				if (logicalView.requests3DEngine == true)
				{
					if (_renderer3dcapable != null)
					{
						//assign view to renderer
						_renderer3dcapable.logicalViewSet.push(logicalView);
						logicalViewRendererAssignments.set(logicalView, _renderer3dcapable);
						logicalViewsOrder.push(logicalView);
						l_temp_spaceInvalidated = true;	//temp value until i do proper invalidation 
					}
				}
				else
				{
					if (_renderer2dcapable != null)
					{
						//assign view to renderer
						_renderer2dcapable.logicalViewSet.push(logicalView);
						logicalViewRendererAssignments.set(logicalView, _renderer2dcapable);
						logicalViewsOrder.push(logicalView);
						l_temp_spaceInvalidated = true;	//temp value until i do proper invalidation 
					}
				}
			}
		}
		
		//after updating the 'dirty' space, always re-order the Views correctly
		if (l_temp_spaceInvalidated)
		{
			logicalViewsOrder.sort(_orderViews);
			
			for (logicalView in logicalViewsOrder)
			{
				Console.debug("View: " + logicalView.name);
			}
		}
		

		
		//after the Display.update, the platform.subgraphics system will request a render() for each view from their assigned renderer, in the order 
		
		//RENDERER UPDATE TEMP EXAMPLE
		//poll 'dirty' views here, and if one is found, assign the responsible renderer as 'dirty'
		
		//update all 'dirty' renderers
		for (renderer in rendererSet)
		{
			renderer.update();
		}
	}
	
	
	/**
		Sorts [this] Array according to the comparison function [f], where
		[f(x,y)] returns 0 if x == y, a positive Int if x > y and a
		negative Int if x < y.
		
		This operation modifies [this] Array in place.
		
		The sort operation is not guaranteed to be stable, which means that the
		order of equal elements may not be retained. For a stable Array sorting
		algorithm, haxe.ds.sort.MergeSort.sort() can be used instead.
		
		If [f] is null, the result is unspecified.
	**/
	private function _orderViews(view1:ILogicalView, view2:ILogicalView):Int
	{
		if (view1.zIndex>view2.zIndex) return 1;
		else if (view1.zIndex < view2.zIndex) return -1;
		else return 0;
	}
	
	public function setSpace( p_space:ILogicalSpace ):Void
	{
		//@note if another space already exists, maybe you can warn the user, or take
			//other action. may need rerendering, changing renderers, etc, etc, etc
			
		logicalSpace = p_space;
	}
	
	public function createSpace():ILogicalSpace { return new LogicalSpace(); }
	public function createStage():ILogicalStage { return new LogicalStage(); }
	public function createScene():ILogicalScene { return new LogicalScene(); }
	public function createCamera():ILogicalCamera { return new LogicalCamera(); }
	public function createView():ILogicalView { return new LogicalView(); }
	public function createEntity():ILogicalEntity { return new LogicalEntity(); }
	public function createMesh():ILogicalMesh { return new LogicalMesh(); }
	public function createLight():ILogicalLight { return new LogicalLight(); }
	
	
	//@todo: The display service should DISPLAY the console messages ON SCREEN
	//platform independant..
	//merge mconsole's view with flambe's renderer to make this possible
	//probably in a separate view created by the Display service
	//for this purpose alone.
	public function log(message:String):Void 
	{
		Console.log(message);
	}
	
	public function info(message:String):Void 
	{
		Console.info(message);
	}
	
	public function debug(message:String):Void 
	{
		Console.debug(message);
	}
	
	public function warn(message:String):Void 
	{
		Console.warn(message);
	}
	
	public function error(message:String):Void 
	{
		Console.error(message);
	}
	
}