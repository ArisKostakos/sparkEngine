package co.gamep.sliced.services.std.display.logicalspace.animators.states;

interface IUVAnimationState extends IAnimationState  {
	var blendWeight(default,never) : Float;
	var currentUVFrame(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	var nextUVFrame(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
}
