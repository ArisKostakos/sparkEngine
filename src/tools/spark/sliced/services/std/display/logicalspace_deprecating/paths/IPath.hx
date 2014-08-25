package tools.spark.sliced.services.std.display.logicalspace.paths;

interface IPath  {
	var numSegments(default,never) : Int;
	var segments(default,never) : Dynamic;
}
