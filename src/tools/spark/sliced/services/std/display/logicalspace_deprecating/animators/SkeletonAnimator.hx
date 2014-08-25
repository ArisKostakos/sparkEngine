package tools.spark.sliced.services.std.display.logicalspace.animators;

class SkeletonAnimator extends AnimatorBase implements IAnimator {
	public var forceCPU(default,never) : Bool;
	public var globalMatrices(default,never) : Dynamic;
	public var globalPose(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.SkeletonPose;
	public var skeleton(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.data.Skeleton;
	public var useCondensedIndices : Bool;
	public function new():Void {super();}}
