/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.dom2_5D;

import js.html.DivElement;
import js.html.Element;
import js.Browser;
import tools.spark.framework.space2_5D.core.AScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class DomScene2_5D extends AScene2_5D
{
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initDomScene2_5D();
	}
	
	private function _initDomScene2_5D()
	{
		
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		_instances[p_view2_5D] = Browser.document.createDivElement();
		_instances[p_view2_5D].style.position = "absolute";

		return super.createInstance(p_view2_5D);
	}
	
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//_updateState('2DmeshType', p_view2_5D);
		//_updateState('spaceX',p_view2_5D);
		//_updateState('spaceY',p_view2_5D);
		//_updateState('spaceZ', p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' addChild... a flambe addChild..
		_instances[p_view2_5D].appendChild(cast(p_childEntity.createInstance(p_view2_5D), Element));
		
		super._createChildOfInstance(p_childEntity, p_view2_5D);
	}
}