/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveViewReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

/**
 * ...
 * @author Aris Kostakos
 */
class ViewReferenceManager implements IDisplayObjectManager
{	
	private var _activeReferenceMediator:IActiveReferenceMediator;
	
	public function new(p_activeReferenceMediator:IActiveReferenceMediator) 
	{
		_activeReferenceMediator = p_activeReferenceMediator;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_viewReference:IActiveViewReference = new ActiveViewReference(p_gameEntity);
		
		return l_viewReference;
	}
	
	//This right now weakly removes the view from the renderer.. Doesn't destroy ANYTHING
	//Later, add an optional flag parameter to this function, that determines if we just remove, or hard destroy EVERYTHING (references, and renderer objects)
	public function destroy(p_object:Dynamic):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast
		var l_viewReference:IActiveViewReference = cast(p_object, IActiveViewReference);
		
		if (l_viewReference.renderer != null)
		{
			//This is huge... starting to talk to renderers here!! right place to do that??? Sure why not...
			l_viewReference.renderer.destroyView(l_viewReference.viewEntity); //flag goes here too..
		}
		else
		{
			Console.error("Tried to remove View from renderer, but view wasn't assigned to one. Ignoring...");
		}
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast
		var l_viewReference:IActiveViewReference = cast(p_object, IActiveViewReference);
		
		updateState(l_viewReference, p_gameEntity, 'scene');
		updateState(l_viewReference, p_gameEntity, 'camera');
		
		//Update my layoutObject
		l_viewReference.layoutElement.update();
		
		_updateRenderer(l_viewReference);
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
		switch (p_state)
		{
			//@TODO: Here, do the following.. if you set its scene or camera to null or something, the View immediately becomes invalid and needs to be removed
			//from the active Stage. Then think how to make it valid again since now it's removed and won't listen to UpdateState anymore... hmmmm HEY! what if it's not active
			//at the beginning and we need to activate it later then? SHIT....hmmmmm
			//maybe still add it to the active stage but set it as inactive so the renderers know to ignore the request from the Graphics Platform
			case 'scene':
				//Update again, in case renderer needs to be modified, with the new 'scene' value
				_updateRenderer(cast(p_object, ActiveViewReference));
			case 'camera':
				//Update again, in case renderer needs to be modified, with the new 'camera' value
				_updateRenderer(cast(p_object, ActiveViewReference));
		}
	}
	
	//@TODO: After the updates, a view becomes invalidated, in which case it needs to be REMOVED from a renderer instead...and stuff like that...
	//SO, although in order to be ADDED, camera and scene are set, you should ALWAYS check again for them both to be valid here and act accordingly
	private function _updateRenderer(p_viewReference:IActiveViewReference):Void
	{
		//@FIXME: Do tests like these again, and act accordingly...
		//if (p_viewEntity.getState('scene') == null || p_viewEntity.getState('camera') == null)....
		
		//Add to Renderer, if you haven't already
		if (p_viewReference.renderer == null)
		{
			//@FIX NOW: Only explicit renderer selection has been implemented.. work on the auto one later
			if (p_viewReference.viewEntity.getState('renderer') != "Implicit")
			{
				p_viewReference.renderer = _activeReferenceMediator.display.platformRendererSet[p_viewReference.viewEntity.getState('renderer')];
			}
			else
			{
				Console.error("Implicit Renderer selection has not been implemented yet. View " + p_viewReference.viewEntity.getState('name') + " cannot be rendered!");
			}
			
			if (p_viewReference.renderer != null)
			{
				//This is huge... starting to talk to renderers here!! right place to do that??? Sure why not...
				p_viewReference.renderer.createView(p_viewReference.viewEntity);
			}
			else
			{
				Console.error("Could not create renderer: " + p_viewReference.viewEntity.getState('renderer') + ".");
			}
		}
		//else
		//{
		//	Console.warn("This view object [" + p_viewReference.viewEntity.getState('name') + "] already has a renderer assigned. So whatever changes you made to it, didn't make it assign to a new one or whatever, it just ignored it.");
		//}
	}
	
		
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
	}
	
	public function insertTo(p_objectChild:Dynamic, p_objectParent:Dynamic, p_index:Int):Void
	{
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
	}
}