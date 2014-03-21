package co.gamep.sliced.services.std.display.logicalspace.entities;

@:keep class Entity extends co.gamep.sliced.services.std.display.logicalspace.containers.ObjectContainer3D {
	public var _pickingCollider : co.gamep.sliced.services.std.display.logicalspace.core.pick.IPickingCollider;
	public var _pickingCollisionVO : co.gamep.sliced.services.std.display.logicalspace.core.pick.PickingCollisionVO;
	public var _staticNode : Bool;
	public var bounds : co.gamep.sliced.services.std.display.logicalspace.bounds.BoundingVolumeBase;
	public var pickingCollider : co.gamep.sliced.services.std.display.logicalspace.core.pick.IPickingCollider;
	public var pickingCollisionVO(default,never) : co.gamep.sliced.services.std.display.logicalspace.core.pick.PickingCollisionVO;
	public var shaderPickingDetails : Bool;
	public var showBounds : Bool;
	public var staticNode : Bool;
	public var worldBounds(default, never) : co.gamep.sliced.services.std.display.logicalspace.bounds.BoundingVolumeBase;
	public function new():Void {super();}}
