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
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameSpace;

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
	public var platformRendererSet( default, null ):Array<IRenderer>;
	public var projectActiveSpaceReference( default, null ):IActiveSpaceReference;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		//Log
		Console.log("Init Display std Service...");
		
		//Renderer Set
		platformRendererSet = new Array<IRenderer>();
		
		//Data Buffer
		_dataBuffer = new DataBuffer();
	}
	
	private function _setActiveSpace(p_spaceEntity:IGameEntity):Void
	{
		if (projectActiveSpaceReference != null)
		{
			//@note if another space already exists, maybe you can warn better the user, or take
				//other action. may need rerendering, changing renderers, etc, etc, etc
			Console.warn("A space object was already bound to this Project! Rebounding...");
		}
		
		projectActiveSpaceReference = new ActiveSpaceReference(p_spaceEntity);
	}
	
	public function update():Void 
	{
		//Console.warn("DISPLAY UPDATE: UPDATING...!");
		
		
		//Buffer
		for (f_bufferEntry in _dataBuffer.dataBuffer)
		{
			if (f_bufferEntry.type == ASSIGNED)
			{
				if (f_bufferEntry.source.getState('displayType') == "Space")
				{
					_setActiveSpace(f_bufferEntry.source);
				}
				
			}
		}
		_dataBuffer.clearBuffer();
		
		
		//all renderers are up to date in this point, so...
		
		//after the Display.update, the platform.subgraphics system will request a render() for each view from their assigned renderer
	}
	
	public function assignSpaceToProject(p_spaceEntity:IGameEntity):Bool
	{
		//This is always relevant, meaning, it has direct effect to the ACTIVE space, so always post it to the buffer
		
		
		//cast the p_spaceEntity
		if (p_spaceEntity.getState('displayType') == "Space")
		{
			_dataBuffer.addEntry(ASSIGNED, p_spaceEntity);
			
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public function assignStageToSpace(p_stageEntity:IGameEntity, p_spaceEntity:IGameEntity):Bool
	{
		//cast the gameEntities
		if (p_stageEntity.getState('displayType') == "Stage" && p_spaceEntity.getState('displayType') == "Space")
		{
			//@todo: ONLY add this to the buffer, IF the Space that the stage is being added to, is an ACTIVE SPACE, meaning, it's ADDED TO THE PROJECT
			_dataBuffer.addEntry(ASSIGNED, p_stageEntity, p_spaceEntity);
			
			return true;
		}
		else
		{
			return false;
		}
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