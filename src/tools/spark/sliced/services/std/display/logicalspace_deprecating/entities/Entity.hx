package tools.spark.sliced.services.std.display.logicalspace.entities;

@:keep class Entity extends tools.spark.sliced.services.std.display.logicalspace.containers.ObjectContainer3D {
	public var _pickingCollider : tools.spark.sliced.services.std.display.logicalspace.core.pick.IPickingCollider;
	public var _pickingCollisionVO : tools.spark.sliced.services.std.display.logicalspace.core.pick.PickingCollisionVO;
	public var _staticNode : Bool;
	public var bounds : tools.spark.sliced.services.std.display.logicalspace.bounds.BoundingVolumeBase;
	public var pickingCollider : tools.spark.sliced.services.std.display.logicalspace.core.pick.IPickingCollider;
	public var pickingCollisionVO(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.pick.PickingCollisionVO;
	public var shaderPickingDetails : Bool;
	public var showBounds : Bool;
	public var staticNode : Bool;
	public var worldBounds(default, never) : tools.spark.sliced.services.std.display.logicalspace.bounds.BoundingVolumeBase;
	public function new():Void {super();}}
