/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.space2_5D.layout.interfaces;
import tools.spark.framework.layout.containers.Group;

/**
 * @author Aris Kostakos
 */

interface ILayoutable 
{
	var group( default, null ):Group;
	var children( default, null ):ILayoutable;
}