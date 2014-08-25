package tools.spark.sliced.services.std.display.logicalspace.animators.states;

class UVClipState extends AnimationClipState implements IUVAnimationState {
	public var currentUVFrame(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	public var nextUVFrame(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.UVAnimationFrame;
	public function new():Void {super();}}
