package co.gamep.sliced.services.std.display.logicalspace.animators.states;

class UVClipState extends AnimationClipState implements IUVAnimationState {
	public var currentUVFrame(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	public var nextUVFrame(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	public function new():Void {super();}}
