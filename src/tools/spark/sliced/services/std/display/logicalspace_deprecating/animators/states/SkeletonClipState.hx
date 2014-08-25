package tools.spark.sliced.services.std.display.logicalspace.animators.states;

class SkeletonClipState extends AnimationClipState implements ISkeletonAnimationState {
	public var currentPose(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.SkeletonPose;
	public var nextPose(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.SkeletonPose;
	public function new():Void {super();}}
