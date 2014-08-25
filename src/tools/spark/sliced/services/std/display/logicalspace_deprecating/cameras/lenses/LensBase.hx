package tools.spark.sliced.services.std.display.logicalspace.cameras.lenses;

class LensBase {
	public var aspectRatio : Float;
	public var far : Float;
	public var frustumCorners : Dynamic;
	public var matrix : Dynamic;
	public var near : Float;
	public var unprojectionMatrix(default,never) : Dynamic;
	public function new():Void {}}
