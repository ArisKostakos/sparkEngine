package co.gamep.sliced.services.std.display.logicalspace.core.partition;

class EntityNode extends NodeBase {
	public var _updateQueueNext : EntityNode;
	public var entity(default,never) : co.gamep.sliced.services.std.display.logicalspace.entities.Entity;
	public function new():Void {super();}}