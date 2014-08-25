package tools.spark.sliced.services.std.display.logicalspace.entities;

class Mesh extends Entity implements tools.spark.sliced.services.std.display.logicalspace.library.assets.IAsset implements tools.spark.sliced.services.std.display.logicalspace.core.base.IMaterialOwner {
	public var animator : tools.spark.sliced.services.std.display.logicalspace.animators.IAnimator;
	public var castsShadows : Bool;
	public var geometry : tools.spark.sliced.services.std.display.logicalspace.core.base.Geometry;
	public var material : tools.spark.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var shareAnimationGeometry : Bool;
	public var subMeshes(default,never) : Dynamic;
	public function new():Void {super();}}
