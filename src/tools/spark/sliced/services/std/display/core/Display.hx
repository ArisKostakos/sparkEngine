/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.core;

import tools.spark.framework.Framework;
import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.sliced.core.AService;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveSpaceReference;
import tools.spark.sliced.services.std.display.databuffer.core.DataBuffer;
import tools.spark.sliced.services.std.display.databuffer.interfaces.EBufferEntryType;
import tools.spark.sliced.services.std.display.databuffer.interfaces.IDataBuffer;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.managers.core.ActiveReferenceMediator;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;
import tools.spark.framework.layout.managers.LayoutManager;

/**
 * ...
 * @author Aris Kostakos
 */
class Display extends AService implements IDisplay
{
	//@TODO: When you create the std .egc, .fgc, etc templates, DO ONE THING. You have an .egc (extension) called "Positionable". That's excellent, but 
	//it should create an extra Boolean state called "Positionable" with value to true. So, now we practically have COMPONENT BASED LOGIC in LionML. Just like that!
	//So we is this here at Display? Well, after you do this, go to the renderers, and when you update things (put the data to the actual renderer), check against States
	//like "Positionable", or "3DForm" or "2DForm" or "Physicsable" or AAANYTHING else, and only update if it is a component like that... This can decide if the whole
	//game can be run on both 3d and 2d... it can decide everything.. it links the component system with Display and all its renderers in a neat and clean way. Do it!!!
	
	
	//@todo: somewhere here, add a filtering mechanism for choosing the appropriate renderer
	//do this by enumerating all the available renderers added for the current platform
	//and start disqualifing renderers due to platform requirements and restrictions
	//order by gRenderer request, then chose the top one
	//@todo: Reflection needed here!!! See above todo
	
	//@think: this is a nice way to check if a new view/scene/entity/etc has been created, 
	//instead of itterating the virtual world. The Renderer may find this useful.
	//do i need to itterate anything now that I ditched the logicalSpace?
	
	
	private var _dataBuffer:IDataBuffer;
	
	//This array will be modified from Subgraphic modules, depending on which renderers are available on the platform
	public var platformRendererSet( default, null ):Map<String, IPlatformSpecificRenderer>;
	public var projectActiveSpaceReference( default, null ):IActiveSpaceReference;
	
	private var _activeReferenceMediator:IActiveReferenceMediator;
	
	private var _renderStateNames:Map<String,Bool>;
	private var _renderFormStateNames:Map<String,Bool>;
	
	private function _initRenderStateNames():Void
	{
		_renderStateNames['2DmeshType'] = true;
		_renderStateNames['3DmeshType'] = true;
		_renderStateNames['touchable'] = true;
		_renderStateNames['2DMeshImageForm'] = true;
		_renderStateNames['2DMeshTextForm'] = true;
		_renderStateNames['2DMeshSpriterForm'] = true;
		_renderStateNames['2DMeshFillRectForm'] = true;
		_renderStateNames['2DMeshSpriteForm'] = true;
		
		_renderStateNames['2DMeshSpriterAnimForm'] = true;
		
		_renderStateNames['visibility'] = true;
		_renderStateNames['visible'] = true;
		_renderStateNames['width'] = true;
		_renderStateNames['height'] = true;
		_renderStateNames['top'] = true;
		_renderStateNames['left'] = true;
		_renderStateNames['opacity'] = true;
		_renderStateNames['display'] = true;
		_renderStateNames['text'] = true;
		_renderStateNames['fontSize'] = true;
		_renderStateNames['fontWeight'] = true;
		_renderStateNames['fontColor'] = true;
		_renderStateNames['src'] = true;
		_renderStateNames['overflow'] = true;
		_renderStateNames['backgroundColor'] = true;
		_renderStateNames['border'] = true;
		_renderStateNames['borderColor'] = true;
		_renderStateNames['command_zOrder'] = true;
		
		_renderStateNames['font'] = true;
		_renderStateNames['align'] = true;
		_renderStateNames['wrapWidth'] = true;
		_renderStateNames['letterSpacing'] = true;
		_renderStateNames['lineSpacing'] = true;
		
		_renderStateNames['spaceX'] = true;
		_renderStateNames['spaceY'] = true;
		_renderStateNames['spaceZ'] = true;
		
		_renderStateNames['scaleX'] = true;
		_renderStateNames['scaleY'] = true;
		_renderStateNames['scaleZ'] = true;
		
		_renderStateNames['rotation'] = true;
		
		_renderStateNames['velocityX'] = true; //physics
		_renderStateNames['velocityY'] = true; //physics
		_renderStateNames['applyImpulseX'] = true; //physics
		_renderStateNames['applyImpulseY'] = true; //physics
		
		_renderStateNames['captureAreaX'] = true; //camera
		_renderStateNames['captureAreaY'] = true; //camera
		_renderStateNames['captureAreaWidth'] = true; //camera
		_renderStateNames['captureAreaHeight'] = true; //camera
		
		
		_renderStateNames['spaceWidth'] = true;	//just for fillsprites
		_renderStateNames['spaceHeight'] = true;	//just for fillsprites
		
		_renderStateNames['stage'] = true;
		_renderStateNames['view'] = true;
		_renderStateNames['camera'] = true;
		_renderStateNames['scene'] = true;
		_renderStateNames['space'] = true;
		
		_renderStateNames['active'] = true;
	}
	
/*  ****************************FORM STATE UPDATE DEPRECATED*************************
	private function _initRenderFormStateNames():Void
	{
		_renderFormStateNames['SpriteUrl'] = true;
		_renderFormStateNames['ModelUrl'] = true;
	}
*/	
	
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		//Log
		Console.log("Init Display std Service...");
		
		//Init Render StateNames
		_renderStateNames = new Map<String,Bool>();
		_initRenderStateNames();
		
		//Init Render Form StateNames
		_renderFormStateNames = new Map<String,Bool>();
		//_initRenderFormStateNames();
		
		//Active Reference Mediator
		_activeReferenceMediator = new ActiveReferenceMediator(this);
		
		//Renderer Set
		platformRendererSet = new Map<String, IPlatformSpecificRenderer>();
		
		//Data Buffer
		_dataBuffer = new DataBuffer();
	}
	
	//@TODO: Quite a lot of public functions here, all dealing with the activeXReferences.. 
	//Maybe create a mediator to handle all that, and lighten the Display Service a bit
	
	
	public function setActiveSpace(p_spaceEntity:IGameEntity):Bool
	{
		//weakcast the p_spaceEntity
		if (p_spaceEntity.getState('displayType') == "Space")
		{
			_dataBuffer.addEntry(SET_SPACE, p_spaceEntity);
			
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private function _setActiveSpace(p_spaceEntity:IGameEntity):Void
	{
		if (_activeReferenceMediator.getActiveSpaceReference(p_spaceEntity) != null)
		{
			Console.warn("This space object is already bound to the Project. Ignoring...");
		}
		else
		{
			if (projectActiveSpaceReference != null)
			{
				//@note if another space already exists, maybe you can warn better the user, or take
					//other action. may need rerendering, changing renderers, etc, etc, etc
				Console.warn("Another space object was already set to this Project! Resetting...");
			}
			
			projectActiveSpaceReference = _activeReferenceMediator.createSpaceReference(p_spaceEntity);
			_activeReferenceMediator.spaceReferenceManager.update(projectActiveSpaceReference, p_spaceEntity);
		}
	}
	
	//Invalidates the active layout manager for the active space/stage..
	public function invalidateLayout():Void
	{
		projectActiveSpaceReference.activeStageReference.layoutManager.validated = false;
	}
	
	public function getSpace2_5Object(p_gameEntity:IGameEntity, p_bAllRenderers:Bool = false):Dynamic //hash for all renderers, space object otherwise
	{
		if (p_bAllRenderers)
		{
			//Create Hash, do the for, return it
			//Not yet implemented
			return null;
		}
		else
		{
			var l_realObject:Dynamic;
			
			for (renderer in platformRendererSet)
			{
				l_realObject = renderer.getRealObject(p_gameEntity);
				if (l_realObject != null) break;
			}
			
			return l_realObject;
		}
		
	}
	
	public function update():Void 
	{
		//Buffer
		for (f_bufferEntry in _dataBuffer.dataBuffer)
		{
			//Console.warn("DISPLAY UPDATE: Updating Type: [" + f_bufferEntry.type + "], Name: [" +f_bufferEntry.source.getState('name') + "], State [" + f_bufferEntry.field+"]");
			
			switch (f_bufferEntry.type)
			{
				case SET_SPACE:
					_setActiveSpace(f_bufferEntry.source);
				case ADDED, INSERTED:
					switch (f_bufferEntry.source.getState('displayType'))
					{
						case "Space":
							Console.warn("adding something to a space");//...
						case "Stage":
							Console.warn("adding something to a stage");//...
						case "StageArea":
							Console.warn("adding something to a stageArea");//...
						case "View":
							Console.warn("adding something to a view");//...
							for (renderer in platformRendererSet)
								Console.warn("adding something to a view, renderer logic");//...
						default:
							//HUGE PROBLEM HERE
							//An object is created even for renderers that don't really render it's parent view
							for (renderer in platformRendererSet)
							{
								if (f_bufferEntry.type==ADDED)
									renderer.addChild(f_bufferEntry.source, f_bufferEntry.target);
								else if (f_bufferEntry.type == INSERTED)
									renderer.insertChild(f_bufferEntry.source, f_bufferEntry.target, Std.parseInt(f_bufferEntry.field));
							}
					}
				case REMOVED:
					switch (f_bufferEntry.source.getState('displayType'))
					{
						case "Space":
							Console.warn("removing something from a space");//...
						case "Stage":
							Console.warn("removing something from a stage");//...
						case "StageArea":
							Console.warn("removing something from a stageArea");//...
						case "View":
							Console.warn("removing something from a view");//...
							for (renderer in platformRendererSet)
								Console.warn("removing something from a view, renderer logic");//...
						default:
							for (renderer in platformRendererSet)
								renderer.removeChild(f_bufferEntry.source, f_bufferEntry.target);
					}
				case UPDATED_STATE:
					switch (f_bufferEntry.source.getState('displayType'))
					{
						case "Space":
							_activeReferenceMediator.spaceReferenceManager.updateState(_activeReferenceMediator.getActiveSpaceReference(f_bufferEntry.source), f_bufferEntry.source, f_bufferEntry.field);
						case "Stage":
							_activeReferenceMediator.stageReferenceManager.updateState(_activeReferenceMediator.getActiveStageReference(f_bufferEntry.source), f_bufferEntry.source, f_bufferEntry.field);
						case "StageArea":
							_activeReferenceMediator.stageAreaReferenceManager.updateState(_activeReferenceMediator.getActiveStageAreaReference(f_bufferEntry.source), f_bufferEntry.source, f_bufferEntry.field);
						case "View":
							_activeReferenceMediator.viewReferenceManager.updateState(_activeReferenceMediator.getActiveViewReference(f_bufferEntry.source), f_bufferEntry.source, f_bufferEntry.field);
							for (renderer in platformRendererSet)
								renderer.updateState(f_bufferEntry.source, f_bufferEntry.field);
						default:
							for (renderer in platformRendererSet)
								renderer.updateState(f_bufferEntry.source, f_bufferEntry.field);
					}
				/*  ****************************FORM STATE UPDATE DEPRECATED*************************
				case UPDATED_FORM_STATE:
					for (renderer in platformRendererSet)
						renderer.updateFormState(f_bufferEntry.source, f_bufferEntry.field);
				*/
				default:
					Console.warn("DISPLAY: Unhandled request: " + f_bufferEntry.type);
			}
		}
		
		//Clear buffer
		_dataBuffer.clearBuffer();
		
		//Layout
		//@think: should this be before the buffer, or after the buffer? should this be here at all? prob, not..
		//put me in a buffer event, so i don't check for this every single FUCKING frame.. this is so WRONG
		if (projectActiveSpaceReference!=null)
			projectActiveSpaceReference.activeStageReference.layoutManager.validate();
		
		
		//all renderers are up to date in this point, so...
		//after the Display.update, the platform.subgraphics system will request a render() for each view from their assigned renderer
	}
	
	inline public function addDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void
	{
		if (p_gameEntityParent.getState('displayType')!=null && p_gameEntityChild.getState('displayType')!=null)
			_addChild(p_gameEntityParent, p_gameEntityChild);
	}
	
	inline public function insertDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity, p_index:Int):Void
	{
		if (p_gameEntityParent.getState('displayType')!=null && p_gameEntityChild.getState('displayType')!=null)
			_insertChild(p_gameEntityParent, p_gameEntityChild, p_index);
	}
	
	inline public function removeDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void
	{
		if (p_gameEntityParent.getState('displayType')!=null && p_gameEntityChild.getState('displayType')!=null)
			_removeChild(p_gameEntityParent, p_gameEntityChild);
	}
	
	inline public function updateDisplayObjectState(p_gameEntity:IGameEntity, p_state:String):Void
	{
		if (p_gameEntity.getState('displayType')!=null && _renderStateNames[p_state]==true)
			_updateState(p_gameEntity, p_state);
	}
	
	inline public function updateDisplayObjectFormState(p_gameEntity:IGameEntity, p_state:String):Void
	{
		if (p_gameEntity.getState('displayType')!=null && _renderFormStateNames[p_state]==true)
			_updateFormState(p_gameEntity, p_state);
	}
	
	inline private function _addChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void
	{
		_dataBuffer.addEntry(ADDED, p_gameEntityParent, p_gameEntityChild);
	}
	
	inline private function _insertChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity, p_index:Int):Void
	{
		_dataBuffer.addEntry(INSERTED, p_gameEntityParent, p_gameEntityChild, Std.string(p_index));
	}
	
	inline private function _removeChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void
	{
		_dataBuffer.addEntry(REMOVED, p_gameEntityParent, p_gameEntityChild);
	}
	
	inline private function _updateState(p_gameEntity:IGameEntity, p_state:String):Void
	{
		_dataBuffer.addEntry(UPDATED_STATE, p_gameEntity, p_state);
	}
	
	inline private function _updateFormState(p_gameEntity:IGameEntity, p_state:String):Void
	{
		_dataBuffer.addEntry(UPDATED_FORM_STATE, p_gameEntity, p_state);
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