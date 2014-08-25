/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2013
 */

package tools.spark.framework.pseudo3d.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IPseudoScene
{
	var pseudoEntitySet:Array<IPseudoEntity>;
	function addChild(p_pseudoEntity:IPseudoEntity):Void;
}