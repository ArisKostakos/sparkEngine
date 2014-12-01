/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;

/**
 * @author Aris Kostakos
 */

interface IScene2_5D
{
	var name( default, default ):String;
	var children( default, null ):Array<IEntity2_5D>;
	function addChild( p_entity2_5D:IEntity2_5D):Void;
}