package tools.spark.sliced.services.std.display.logicalspace.animators.states;

interface IUVAnimationState extends IAnimationState  {
	var blendWeight(default,never) : Float;
	var currentUVFrame(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	var nextUVFrame(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
}
