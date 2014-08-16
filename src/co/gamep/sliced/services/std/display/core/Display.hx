/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.core;

import co.gamep.framework.Framework;
import co.gamep.sliced.interfaces.IDisplay;
import co.gamep.sliced.core.AService;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameSpace;

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
	//do i need to itterate anything now that I ditched the logicalSpace?

	public var space( default, null ):IGameEntity;
	
	private var _invalidated:Bool;
	
	public function setSpace(p_gameEntity:IGameEntity):IGameEntity
	{
		//cast the gameEntity, and complain if space already set.
		if (space != null)
		{
			//@note if another space already exists, maybe you can warn better the user, or take
				//other action. may need rerendering, changing renderers, etc, etc, etc
			Console.warn("A space object is already bound to the Display service! Rebounding...");
		}

		space = p_gameEntity;
		invalidate();

		return (space);
	}
	
	//This array will be modified from Subgraphic modules, depending on which renderers are available on the platform
	public var rendererSet( default, null ):Array<IRenderer>;
	
	//views data stored here for optimization (saving the platform.subgraphics from looking which renderer is responsible for which view
		//and in what order the views must be renderer
	public var activeViewsOrder (default, null ):Array<IGameEntity>;
	public var viewToRenderer (default, null ):Map<IGameEntity,IRenderer>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Display std Service...");
		rendererSet = new Array<IRenderer>();
		
		_invalidated = false;
	}
	
	
	public function update():Void 
	{
		//Assert logicalSpace
		if (space == null)
			return;

		//Validate Display Service
			//If Display is invalidated, it means validation is required up to the Views level
		if (isValidated()==false)
		{
			validate();
		}
		
		//Validate active views (validation of views always happens IN CONTEXT of its assigned renderer)
		for (viewEntity in activeViewsOrder)
		{
			//Validate Display Service That's why views HAVE to be assigned to renderers as well
			if (viewToRenderer[viewEntity].isViewValidated(viewEntity) == false)
			{
				viewToRenderer[viewEntity].validateView(viewEntity);
			}
		}
		  
	}
	
	
	public function validate():Void
	{
		Console.warn("DISPLAY UPDATE: VALIDDATING...!");
		
		if (space.getState('invalidated') == true) _validateSpace(space);
		
		_invalidated = false;
	}
	
	inline private function _validateSpace(spaceEntity:IGameEntity):Void
	{
		Console.warn("DISPLAY UPDATE: space invalidated.");
		if (spaceEntity.getState('stage') != null)
		{
			Console.warn("DISPLAY UPDATE: stage found.");
			if (spaceEntity.getState('stage').getState('invalidated') == true) _validateStage(space.getState('stage'));
		}
		else
		{
			Console.warn("DISPLAY UPDATE: stage NOT found.");
		}
		
		spaceEntity.setState('invalidated', false);
	}
	
	inline private function _validateStage(stageEntity:IGameEntity):Void
	{
		Console.warn("DISPLAY UPDATE: stage invalidated.");
		
		//Validate Stage
		
		//Here, it's important before reseting this area, to let the renderers know if a view they have been assigned to is being discarded.
			//this is important since some renderers will keep data of their own that cache a specific view (for example, 2_5 space, flambe's or away3d's internal data)
		for (currentGameEntityView in viewToRenderer.keys())
		{
			viewToRenderer[currentGameEntityView].removeView(currentGameEntityView);
		}
			
		viewToRenderer = new Map<IGameEntity,IRenderer>();
		activeViewsOrder = new Array<IGameEntity>();
		
		//add all views
		for (gameEntityView in stageEntity.children)
		{	
			//test if view is active (meaning, it has a valid camera and scene assigned to it, otherwise ignore the view until it becomes active again (will cause invalidation so it will be checked if this happens)
			if (gameEntityView.getState('active') == true)
			{
				_addViewToStage(gameEntityView);
			}
		}
		
		//Reorder views
		activeViewsOrder.sort(_orderViews);
		
		//Print all views (in order)
		for (viewEntity in activeViewsOrder)
		{
			Console.debug("View: " + viewEntity.getState('name') );
		}
		
		//reset invalidate flag
		space.getState('stage').setState('invalidated', false);
	}
	
	private function _addViewToStage(view:IGameEntity):Void
	{
		viewToRenderer.set(view, rendererSet[0]);  //@FIX NOW: When renderer selection is done, fix this so it picks the appropriate renderer. Now it will always assign every view to the first one found!
		activeViewsOrder.push(view);
		rendererSet[0].addView(view);
	}
	
	private function _orderViews(view1:IGameEntity, view2:IGameEntity):Int
	{
		if (view1.getState('zIndex')>view2.getState('zIndex')) return 1;
		else if (view1.getState('zIndex') < view2.getState('zIndex')) return -1;
		else return 0;
	}
	
	inline public function invalidate():Void
	{
		Console.warn("Display invalidated!");
		_invalidated = true;
	}
	
	inline public function isValidated():Bool
	{
		return !_invalidated;
	}
	
	inline public function isCurrentSpace(p_gameEntity:IGameEntity):Bool
	{
		return p_gameEntity == space;
	}
	
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




	//temp
	//private var _renderer3dcapable:IRenderer;
	//private var _renderer2dcapable:IRenderer;

	/*
		for (viewEntity in space.children) //for (logicalView in logicalSpace.logicalStage.logicalViewSet)
		{
			if (viewToRenderer.exists(viewEntity) == false)
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
				
				Console.info("Found a (spaceChild)viewEntity to add to display! whooray!");
				viewToRenderer.set(viewEntity, _renderer2dcapable); //temp define for 2d rendering
			}
			
		}
		
		
		//after updating the 'dirty' space, always re-order the Views correctly
		if (l_temp_spaceInvalidated)
		{
			//logicalViewsOrder.sort(_orderViews);
			
			for (viewEntity in space.children) //for (logicalView in logicalSpace.logicalStage.logicalViewSet)
			{
				Console.debug("(spaceChild)View: " + viewEntity.getState('name') );
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
		*/
		
	
	//TEMP POLLING EXAMPLE
	/*
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
	*/