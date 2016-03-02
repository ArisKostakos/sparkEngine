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
	CHANGED;
	NETWORK_CONNECTED;
	NETWORK_REQUEST;
	NETWORK_SERVER_EVENT;
	FILETRANSFER_CONNECTED;
	FILETRANSFER_SENDREQUEST;
	MOUSE_LEFT_CLICK;
	MOUSE_RIGHT_CLICK;
	MOUSE_LEFT_DOWN;
	MOUSE_RIGHT_DOWN;
	MOUSE_SCROLL;
	MOUSE_ENTERED;
	MOUSE_MOVED;
	MOUSE_LEFT;
	MOUSE_DOWN;
	MOUSE_UP;
	PHYSICS_COLLISION_START;
	PHYSICS_COLLISION_END;
	PHYSICS_SENSOR_START;
	PHYSICS_SENSOR_START_BIPED_FEET;
	PHYSICS_SENSOR_END;
	PHYSICS_SENSOR_END_BIPED_FEET;
	ON_DRAG_START;	//fires when the user starts to drag an element
	ON_DRAG;	//fires when an element is being dragged
	ON_DRAG_END;	//fires when the user has finished dragging the element
	ON_DRAG_ENTER;	//fires when the dragged element enters the drop target
	ON_DRAG_OVER;	//fires when the dragged element is over the drop target
	ON_DRAG_LEAVE;	//fires when the dragged element leaves the drop target
	ON_DROP;	//fires when the dragged element is dropped on the drop target
	
	KEY_PRESSED_LOCAL;
	KEY_DOWN_LOCAL;
	KEY_RELEASED_LOCAL;
	
	KEY_PRESSED;
	KEY_DOWN;
	KEY_RELEASED;
	
	STATE_CHANGED;
	
	CUSTOM_TRIGGER;
	
	SCENE_CREATED;
	
	PROJECT_PAUSED;
	PROJECT_RESUMED;
	
	SOUND_COMPLETED;
	
	LAYOUT_INVALIDATED;
}