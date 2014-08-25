package tools.spark.sliced.services.std.display.logicalspace.extrusions;

class Elevation extends tools.spark.sliced.services.std.display.logicalspace.entities.Mesh {
	public var depth : Float;
	public var height : Float;
	public var maxElevation : Int;
	public var minElevation : Int;
	public var segmentsH : Int;
	public var smoothedHeightMap(default,never) : Dynamic;
	public var width : Float;
	public function new():Void {super();}}
