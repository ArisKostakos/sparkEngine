/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IInstantiable2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.space2_5D.layout.core.GroupSpace2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */
class AInstantiable2_5D extends AObjectContainer2_5D implements IInstantiable2_5D
{
	private var _instances:Map<IView2_5D,Dynamic>;
	private var _updateStateFunctions:Map < String, Dynamic->IView2_5D->Void >;
	
	//For Layout 2D
	public var groupInstances( default, null ):Map<IView2_5D, GroupSpace2_5D>;
	//group instances have a pointer of me, and their view, so they can do stuff
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initInstantiable2_5D();
	}
	
	inline private function _initInstantiable2_5D()
	{
		_instances = new Map<IView2_5D, Dynamic>();
		_updateStateFunctions = new Map < String, Dynamic->IView2_5D->Void > ();
		
		//if (gameEntity.getState('layoutable') == true)
			groupInstances = new Map<IView2_5D, GroupSpace2_5D>();
	}
	
	//For optimization purposes.. to be able to inline the publics
	private function _updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		updateState(p_state,p_view2_5D);
	}
	
	inline public function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in _instances.keys())
				_updateStateOfInstance(p_state, f_view);
		}
		else
		{
			//do for p_View2_5D instance
			_updateStateOfInstance(p_state, p_view2_5D);
		}
	}
	
	//@think: inline here, good idea or not?
	inline private function _updateStateOfInstance(p_state:String, p_view2_5D:IView2_5D):Void
	{
		if (_updateStateFunctions[p_state]!=null)
			_updateStateFunctions[p_state](gameEntity.getState(p_state),p_view2_5D);
		else
			Console.warn("State " + p_state + " does not have a function handler! Ignoring :(");
	}
	
	private function _createChildrenOfInstance(p_view2_5D:IView2_5D):Void
	{
		//Instantiate Children (and add to scene instance)
		for (f_childEntity in children)
			_createChildOfInstance(f_childEntity, p_view2_5D);
	}
	
	public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		//override to create platform specific instance here and store it in _instances[p_view2_5D]
		//also to create the group instance
		
		_createChildrenOfInstance(p_view2_5D);
		
		return _instances[p_view2_5D];
	}
	
	private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//override me!!
	}
	
	public function update(?p_view2_5D:IView2_5D):Void
	{
		//override me!!
	}
}