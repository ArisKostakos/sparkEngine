/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework.assets;

/**
 * ...
 * @author Aris Kostakos
 */
enum EModuleState 
{
	NOT_LOADED;
	LOADING;
	LOADED;
	RUNNING;
	PAUSED;
}