/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import tools.spark.framework.space2_5D.core.ACamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeCamera2_5D extends ACamera2_5D
{
	private var _addedToViews:Map<IView2_5D,IView2_5D>;
	
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeCamera2_5D();
	}
	
	private function _initFlambeCamera2_5D()
	{
		_addedToViews = new Map<IView2_5D,IView2_5D>();
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		_addedToViews[p_view2_5D] = p_view2_5D;
		
		return null;
	}
}