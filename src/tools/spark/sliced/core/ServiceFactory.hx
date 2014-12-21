/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.core;
import tools.spark.framework.config.ENodeType;
import tools.spark.sliced.interfaces.IServiceFactory;
import tools.spark.sliced.interfaces.ISound;
import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.interfaces.IInput;
import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.interfaces.IEvent;
import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.framework.Project;

/**
 * Every Available Service must be included below.
 * So that it is packaged to the application, in case
 * it needs to be reflected.
 */
import tools.spark.sliced.services.dummy.Comms;


//Std
import tools.spark.sliced.services.std.logic.core.Logic;
import tools.spark.sliced.services.std.input.core.Input;
import tools.spark.sliced.services.std.event.core.Event;
import tools.spark.sliced.services.std.display.core.Display;
import tools.spark.sliced.services.std.sound.core.Sound;

/**
 * ...
 * @author Aris Kostakos
 */
class ServiceFactory implements IServiceFactory
{	
	public function new()
	{
		_init();
	}
	
	private function _init():Void
	{
		//Create Services (S.L.I.C.E.D.)
		_createServices();
	}
	
	private function _createServices():Void
	{
		var l_soundService:ISound = _reflectService(ENodeType.SOUND_SERVICE);
		var l_logicService:ILogic = _reflectService(ENodeType.LOGIC_SERVICE);
		var l_inputService:IInput = _reflectService(ENodeType.INPUT_SERVICE);
		var l_commsService:IComms = _reflectService(ENodeType.COMMUNICATIONS_SERVICE);
		var l_eventService:IEvent = _reflectService(ENodeType.EVENT_SERVICE);
		var l_displayService:IDisplay = _reflectService(ENodeType.DISPLAY_SERVICE);
		
		Sliced.assignServices(l_soundService, l_logicService, l_inputService, l_commsService, l_eventService, l_displayService);
	}
	
	inline private function _reflectService(p_slicedService:ENodeType):Dynamic
	{
		//@todo: create throw/catch for an exception when the url cannot be resolved or cannot be created.
		var l_classPath:String = Project.sliced[p_slicedService];
		return Type.createInstance(Type.resolveClass(l_classPath), []);
	}
}