package co.gamep.sliced.services.std.display.logicalspace.core.traverse;

class EntityCollector extends PartitionTraverser {
	public var blendedRenderableHead : co.gamep.sliced.services.std.display.logicalspace.core.data.RenderableListItem;
	public var camera : co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var cullPlanes : Dynamic;
	public var directionalLights(default,never) : Dynamic;
	public var entityHead(default,never) : co.gamep.sliced.services.std.display.logicalspace.core.data.EntityListItem;
	public var lightProbes(default,never) : Dynamic;
	public var lights(default,never) : Dynamic;
	public var numMouseEnableds(default,never) : Int;
	public var numTriangles(default,never) : Int;
	public var opaqueRenderableHead : co.gamep.sliced.services.std.display.logicalspace.core.data.RenderableListItem;
	public var pointLights(default,never) : Dynamic;
	public var skyBox(default,never) : co.gamep.sliced.services.std.display.logicalspace.core.base.IRenderable;
	public function new():Void {super();}}
