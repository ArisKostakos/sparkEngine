package tools.spark.sliced.services.std.display.logicalspace.primitives;

class SkyBox extends tools.spark.sliced.services.std.display.logicalspace.entities.Entity implements tools.spark.sliced.services.std.display.logicalspace.core.base.IRenderable {
	public var UVData(default,never) : Dynamic;
	public var animator(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.IAnimator;
	public var castsShadows(default,never) : Bool;
	public var indexData(default,never) : Dynamic;
	public var material : tools.spark.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var numTriangles(default,never) : Int;
	public var numVertices(default,never) : Int;
	public var sourceEntity(default,never) : tools.spark.sliced.services.std.display.logicalspace.entities.Entity;
	public var uvTransform(default,never) : Dynamic;
	public var vertexData(default,never) : Dynamic;
	public var vertexNormalData(default,never) : Dynamic;
	public var vertexNormalOffset(default,never) : Int;
	public var vertexOffset(default,never) : Int;
	public var vertexStride(default,never) : Int;
	public var vertexTangentData(default,never) : Dynamic;
	public var vertexTangentOffset(default,never) : Int;
	public function new():Void {super();}}
