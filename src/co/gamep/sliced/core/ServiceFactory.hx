/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.core;
import co.gamep.sliced.interfaces.IServiceFactory;
import co.gamep.sliced.interfaces.ISound;
import co.gamep.sliced.interfaces.ILogic;
import co.gamep.sliced.interfaces.IInput;
import co.gamep.sliced.interfaces.IComms;
import co.gamep.sliced.interfaces.IEvent;
import co.gamep.sliced.interfaces.IDisplay;


/**
 * Every Available Service must be included below.
 * So that it is packaged to the application, in case
 * it needs to be reflected.
 */
//Dummy
import co.gamep.sliced.services.dummy.Sound;
import co.gamep.sliced.services.dummy.Comms;


//Std
import co.gamep.sliced.services.std.logic.core.Logic;
import co.gamep.sliced.services.std.input.core.Input;
import co.gamep.sliced.services.std.event.core.Event;
import co.gamep.sliced.services.std.display.core.Display;

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