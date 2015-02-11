/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.space2_5D.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */

interface IBase2_5D
{
	var gameEntity( default, null ):IGameEntity;
	function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void;
}