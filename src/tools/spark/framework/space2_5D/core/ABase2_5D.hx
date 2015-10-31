/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.space2_5D.core;
import tools.spark.framework.space2_5D.interfaces.IBase2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class ABase2_5D implements IBase2_5D
{
	public var gameEntity( default, null ):IGameEntity;
  
	private function new(p_gameEntity:IGameEntity) 
	{
		gameEntity = p_gameEntity;
	}
	
	public function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void
	{
		//override me
		//..
		
		//I hope this doesn't cause to much drain
		if (gameEntity.getState('layoutable') == true)
		{	
			if (p_x != null) gameEntity.setState('feedbackX', p_x);
			if (p_y != null) gameEntity.setState('feedbackY', p_y);
			if (p_width != null) gameEntity.setState('feedbackWidth', p_width);
			if (p_height != null) gameEntity.setState('feedbackHeight', p_height);
		}
	}
}