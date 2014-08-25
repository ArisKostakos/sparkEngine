package tools.spark.sliced.services.std.display.logicalspace.animators.nodes;

interface ISpriteSheetAnimationNode  {
	var currentFrameData(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.SpriteSheetAnimationFrame;
	var currentFrameNumber(default,never) : Int;
}
