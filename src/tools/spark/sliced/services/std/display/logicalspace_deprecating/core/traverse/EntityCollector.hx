package tools.spark.sliced.services.std.display.logicalspace.core.traverse;

class EntityCollector extends PartitionTraverser {
	public var blendedRenderableHead : tools.spark.sliced.services.std.display.logicalspace.core.data.RenderableListItem;
	public var camera : tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var cullPlanes : Dynamic;
	public var directionalLights(default,never) : Dynamic;
	public var entityHead(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.data.EntityListItem;
	public var lightProbes(default,never) : Dynamic;
	public var lights(default,never) : Dynamic;
	public var numMouseEnableds(default,never) : Int;
	public var numTriangles(default,never) : Int;
	public var opaqueRenderableHead : tools.spark.sliced.services.std.display.logicalspace.core.data.RenderableListItem;
	public var pointLights(default,never) : Dynamic;
	public var skyBox(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.base.IRenderable;
	public function new():Void {super();}}
