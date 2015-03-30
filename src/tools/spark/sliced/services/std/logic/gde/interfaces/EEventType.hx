/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
enum EEventType
{
	CREATED;
	UPDATE;
	NETWORK_CONNECTED;
	NETWORK_REQUEST;
	NETWORK_SERVER_EVENT;
	FILETRANSFER_CONNECTED;
	FILETRANSFER_SENDREQUEST;
	MOUSE_LEFT_CLICK;
	MOUSE_RIGHT_CLICK;
	MOUSE_ENTERED;
	MOUSE_MOVED;
	MOUSE_LEFT;
	KEY_PRESSED;
	KEY_RELEASED;
}