package tools.spark.sliced.services.std.display.logicalspace.cameras;

class Camera3D extends tools.spark.sliced.services.std.display.logicalspace.entities.Entity {
	public var frustumPlanes(default,never) : Dynamic;
	public var lens : tools.spark.sliced.services.std.display.logicalspace.cameras.lenses.LensBase;
	public var viewProjection(default,never) : Dynamic;
	public function new():Void {super();}}
