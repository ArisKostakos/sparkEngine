package co.gamep.sliced.services.std.display.logicalspace.animators.states;

interface ISpriteSheetAnimationState extends IAnimationState  {
	var currentFrameData(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.SpriteSheetAnimationFrame;
	var currentFrameNumber(default,never) : Int;
}
