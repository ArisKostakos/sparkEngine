package tools.spark.sliced.services.std.display.logicalspace.animators.states;

interface IVertexAnimationState extends IAnimationState  {
	var blendWeight(default,never) : Float;
	var currentGeometry(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.base.Geometry;
	var nextGeometry(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.base.Geometry;
}
