/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IInstantiable2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */
class AInstantiable2_5D extends AObjectContainer2_5D implements IInstantiable2_5D
{
	private var _instances:Map<IView2_5D,Dynamic>;
	private var _updateStateFunctions:Map < String, Dynamic->IView2_5D->Void > ;
	private var _queryFunctions:Map < String, Dynamic->IView2_5D->Dynamic >;
	public var groupInstances( default, null ):Map<IView2_5D, Group>;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initInstantiable2_5D();
	}
	
	inline private function _initInstantiable2_5D()
	{
		_instances = new Map<IView2_5D, Dynamic>();
		_updateStateFunctions = new Map < String, Dynamic->IView2_5D->Void > ();
		_queryFunctions = new Map < String, Dynamic->IView2_5D->Dynamic > ();
		
		//if (gameEntity.getState('layoutable') == true)
			groupInstances = new Map<IView2_5D, Group>();
	}
	
	public function getInstance(p_view2_5D:IView2_5D):Dynamic
	{
		return _instances[p_view2_5D];
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
	
	//Look.. in case I want to query a non instanciable object, better do something for supers as well..
	@:keep public function query(p_query:String, ?queryArgument:Dynamic, ?p_view2_5D:IView2_5D, p_bAllViews:Bool=false):Dynamic //hash if all views, just query result if specified view
	{
		if (p_view2_5D == null)
		{
			if (p_bAllViews)
			{
				//Return Hash with query results for all views..
				//Not Yet Imlemented
				return null;
			}
			else
			{
				//Query just the instance on the first view
				if (_instances.keys().hasNext())
				{
					return _queryInstance(p_query, queryArgument, _instances.keys().next());
				}
				else
				{
					return null; //warning here?
				}
			}
		}
		else
		{
			//do for p_View2_5D instance
			return _queryInstance(p_query, queryArgument, p_view2_5D);
		}
	}
	
	inline private function _queryInstance(p_query:String, queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		if (_queryFunctions[p_query]!=null)
			return _queryFunctions[p_query](queryArgument,p_view2_5D);
		else
		{
			Console.warn("Query " + p_query + " does not have a function handler! Returning null :(");
			return null;
		}
	}
	
	private function _updateLayoutGroup( ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in groupInstances.keys())
				groupInstances[f_view].update();
		}
		else
		{
			//do for p_View2_5D instance
			groupInstances[p_view2_5D].update();
		}
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
	
	private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//override me!!
	}
	
	public function update(?p_view2_5D:IView2_5D):Void
	{
		//override me!!
	}
	
	override public function addChild( p_entity2_5D:IEntity2_5D):Bool
	{
		//Console.error("adding child (instanciable here)");
		if (super.addChild(p_entity2_5D))
		{
			//do for all instances (hack?)
			for (f_view in _instances.keys())
			{
				_createChildOfInstance(p_entity2_5D, f_view);
				p_entity2_5D.update(f_view);
			}
		}
		else
		{
			Console.warn("Child Already exists!");
		}
		
		return true;
	}
	
	override public function removeChild( p_entity2_5D:IEntity2_5D):Void
	{
		//Console.error("adding child (instanciable here)");
		super.removeChild(p_entity2_5D);
		
		//do for all instances (hack?)
		for (f_view in _instances.keys())
		{
			_removeChildOfInstance(p_entity2_5D, f_view);
		}
	}
}