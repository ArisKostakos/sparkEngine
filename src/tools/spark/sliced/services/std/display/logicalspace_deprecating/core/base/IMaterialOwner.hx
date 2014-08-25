package tools.spark.sliced.services.std.display.logicalspace.core.base;

interface IMaterialOwner  {
	var animator(default,never) : tools.spark.sliced.services.std.display.logicalspace.animators.IAnimator;
	var material : tools.spark.sliced.services.std.display.logicalspace.materials.MaterialBase;
}
