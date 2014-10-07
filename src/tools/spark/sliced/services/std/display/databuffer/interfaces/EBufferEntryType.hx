/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.databuffer.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
enum EBufferEntryType 
{
	ADDED;
	REMOVED;
	ASSIGNED;
	UPDATED_STATE;
	UPDATED_FORM_STATE;
	UPDATED_COMPONENT_STATES;
	UPDATED_FORM_COMPONENT_STATES;
}