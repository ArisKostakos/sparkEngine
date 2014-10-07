/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.interfaces;

import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * @author Aris Kostakos
 */

interface IBufferEntry 
{
	var type( default, null ):EBufferEntryType;
	var source( default, null ):IGameEntity;
	var target( default, null ):IGameEntity;
	var field( default, null ):String;
}