package co.gamep.sliced.services.std.display.logicalspace.entities;

class Mesh extends Entity implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset implements co.gamep.sliced.services.std.display.logicalspace.core.base.IMaterialOwner {
	public var animator : co.gamep.sliced.services.std.display.logicalspace.animators.IAnimator;
	public var castsShadows : Bool;
	public var geometry : co.gamep.sliced.services.std.display.logicalspace.core.base.Geometry;
	public var material : co.gamep.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var shareAnimationGeometry : Bool;
	public var subMeshes(default,never) : Dynamic;
	public function new():Void {super();}}
