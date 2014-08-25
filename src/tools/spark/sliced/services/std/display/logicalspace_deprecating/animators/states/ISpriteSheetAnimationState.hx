package tools.spark.sliced.services.std.display.logicalspace.animators.states;

interface ISpriteSheetAnimationState extends IAnimationState  {
	var currentFrameData(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.SpriteSheetAnimationFrame;
	var currentFrameNumber(default,never) : Int;
}
