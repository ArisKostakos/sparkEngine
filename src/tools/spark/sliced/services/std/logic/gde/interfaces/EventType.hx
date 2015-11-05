package tools.spark.sliced.services.std.logic.gde.interfaces;
import flambe.input.Key;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

/**
 * ...
 * @author Aris
 */
class EventType
{
	static public var eventTypesMap( default, null ):Map<EEventType,String>;
	static public var eventTypesMapReverse( default, null ):Map<String,EEventType>;
	static public var eventTypesStringArray( default, null ):Array<String>;
	static public var keyboardStringToKey( default, null ):Map<String,Key>;
	
	static public inline var TARGET_VAR_ME = "TargetMe";
	static public inline var TARGET_NONE = "TargetNone";
	
	static public function init():Void
	{
		eventTypesMap = new Map<EEventType,String>();
		eventTypesMapReverse = new Map<String,EEventType>();
		eventTypesStringArray = new Array<String>();
		keyboardStringToKey = new Map<String,Key>();
		
		eventTypesMap[CREATED] = "Created";
		eventTypesMap[UPDATE] = "Update";
		eventTypesMap[CHANGED] = "Changed";
		eventTypesMap[NETWORK_CONNECTED] = "NetworkConnected";
		eventTypesMap[NETWORK_REQUEST] = "NetworkRequest";
		eventTypesMap[NETWORK_SERVER_EVENT] = "NetworkServerEvent";
		eventTypesMap[FILETRANSFER_CONNECTED] = "FileTransferConnected";
		eventTypesMap[FILETRANSFER_SENDREQUEST] = "FileTransferRequest";
		eventTypesMap[MOUSE_LEFT_CLICK] = "MouseLeftClick";
		eventTypesMap[MOUSE_RIGHT_CLICK] = "MouseRightClick";
		eventTypesMap[MOUSE_LEFT_DOWN] = "MouseLeftDown";
		eventTypesMap[MOUSE_RIGHT_DOWN] = "MouseRightDown";
		eventTypesMap[MOUSE_SCROLL] = "MouseScroll";
		eventTypesMap[MOUSE_ENTERED] = "MouseEntered";
		eventTypesMap[MOUSE_MOVED] = "MouseMoved";
		eventTypesMap[MOUSE_LEFT] = "MouseLeft";
		eventTypesMap[MOUSE_DOWN] = "MouseDown";
		eventTypesMap[MOUSE_UP] = "MouseUp";
		eventTypesMap[PHYSICS_COLLISION_START] = "PhysicsCollisionStart";
		eventTypesMap[PHYSICS_COLLISION_END] = "PhysicsCollisionEnd";
		eventTypesMap[PHYSICS_SENSOR_START] = "PhysicsSensorStart";
		eventTypesMap[PHYSICS_SENSOR_START_BIPED_FEET] = "PhysicsSensorStartBipedFeet";
		eventTypesMap[PHYSICS_SENSOR_END] = "PhysicsSensorEnd";
		eventTypesMap[PHYSICS_SENSOR_END_BIPED_FEET] = "PhysicsSensorEndBipedFeet";
		eventTypesMap[ON_DRAG_START] = "OnDragStart";	//fires when the user starts to drag an element
		eventTypesMap[ON_DRAG] = "OnDrag";	//fires when an element is being dragged
		eventTypesMap[ON_DRAG_END] = "OnDragEnd";	//fires when the user has finished dragging the element
		eventTypesMap[ON_DRAG_ENTER] = "OnDragEnter";	//fires when the dragged element enters the drop target
		eventTypesMap[ON_DRAG_OVER] = "OnDragOver";	//fires when the dragged element is over the drop target
		eventTypesMap[ON_DRAG_LEAVE] = "OnDragLeave";	//fires when the dragged element leaves the drop target
		eventTypesMap[ON_DROP] = "OnDrop";	//fires when the dragged element is dropped on the drop target
		eventTypesMap[KEY_PRESSED_LOCAL] = "KeyPressedLocal";
		eventTypesMap[KEY_RELEASED_LOCAL] = "KeyReleasedLocal";
		eventTypesMap[KEY_DOWN_LOCAL] = "KeyDownLocal";
		eventTypesMap[KEY_PRESSED] = "KeyPressed";
		eventTypesMap[KEY_RELEASED] = "KeyReleased";
		
		//Reverse Map
		for (eventType in eventTypesMap.keys())
			eventTypesMapReverse[eventTypesMap.get(eventType)] = eventType;
			
		//String Array
		for (eventTypeString in eventTypesMap)
			eventTypesStringArray.push(eventTypeString);
			
		
		//Keyboard Map
		for (key in Key.createAll())
			keyboardStringToKey[key.getName()] = key;
	}
}