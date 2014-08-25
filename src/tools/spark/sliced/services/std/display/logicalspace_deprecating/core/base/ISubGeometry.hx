package tools.spark.sliced.services.std.display.logicalspace.core.base;

interface ISubGeometry  {
	var UVData(default,never) : Dynamic;
	var UVOffset(default,never) : Int;
	var UVStride(default,never) : Int;
	var autoDeriveVertexNormals : Bool;
	var autoDeriveVertexTangents : Bool;
	var faceNormals(default,never) : Dynamic;
	var indexData(default,never) : Dynamic;
	var numTriangles(default,never) : Int;
	var numVertices(default,never) : Int;
	var parentGeometry : Geometry;
	var scaleU(default,never) : Float;
	var scaleV(default,never) : Float;
	var secondaryUVOffset(default,never) : Int;
	var secondaryUVStride(default,never) : Int;
	var vertexData(default,never) : Dynamic;
	var vertexNormalData(default,never) : Dynamic;
	var vertexNormalOffset(default,never) : Int;
	var vertexNormalStride(default,never) : Int;
	var vertexOffset(default,never) : Int;
	var vertexPositionData(default,never) : Dynamic;
	var vertexStride(default,never) : Int;
	var vertexTangentData(default,never) : Dynamic;
	var vertexTangentOffset(default,never) : Int;
	var vertexTangentStride(default,never) : Int;
}
