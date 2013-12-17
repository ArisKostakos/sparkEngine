package co.gamep.sliced.services.std.display.logicalspace.core.base;

interface IMaterialOwner  {
	var animator(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.IAnimator;
	var material : co.gamep.sliced.services.std.display.logicalspace.materials.MaterialBase;
}
