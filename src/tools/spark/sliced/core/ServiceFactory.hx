/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.core;
import tools.spark.framework.Config;
import tools.spark.sliced.interfaces.IServiceFactory;
import tools.spark.sliced.interfaces.ISound;
import tools.spark.sliced.interfaces.ILogic;
import tools.spark.sliced.interfaces.IInput;
import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.interfaces.IEvent;
import tools.spark.sliced.interfaces.IDisplay;


/**
 * Every Available Service must be included below.
 * So that it is packaged to the application, in case
 * it needs to be reflected.
 */
//Dummy
import tools.spark.sliced.services.dummy.Sound;
import tools.spark.sliced.services.dummy.Comms;


//Std
import tools.spark.sliced.services.std.logic.core.Logic;
import tools.spark.sliced.services.std.input.core.Input;
import tools.spark.sliced.services.std.event.core.Event;
import tools.spark.sliced.services.std.display.core.Display;

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
		var l_soundService:ISound = _reflectService("sliced.sound");
		var l_logicService:ILogic = _reflectService("sliced.logic");
		var l_inputService:IInput = _reflectService("sliced.input");
		var l_commsService:IComms = _reflectService("sliced.comms");
		var l_eventService:IEvent = _reflectService("sliced.event");
		var l_displayService:IDisplay = _reflectService("sliced.display");
		
		Sliced.assignServices(l_soundService, l_logicService, l_inputService, l_commsService, l_eventService, l_displayService);
	}
	
	inline private function _reflectService(p_configUrl:String):Dynamic
	{
		//@todo: create throw/catch for an exception when the url cannot be resolved or cannot be created.
		var l_classPath:String = Config.getConfig( p_configUrl );
		return Type.createInstance(Type.resolveClass(l_classPath), []);
	}
}