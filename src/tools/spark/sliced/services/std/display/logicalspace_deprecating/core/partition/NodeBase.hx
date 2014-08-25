package tools.spark.sliced.services.std.display.logicalspace.core.partition;

class NodeBase {
	public var _collectionMark : Int;
	public var _numEntities : Int;
	public var _parent : NodeBase;
	public var numEntities(default,never) : Int;
	public var parent(default,never) : NodeBase;
	public var showDebugBounds : Bool;
	public function new():Void {super();}}
