package tools.spark.sliced.services.std.display.logicalspace.core.base;

interface IRenderable extends IMaterialOwner  {
	var UVData(default,never) : Dynamic;
	var castsShadows(default,never) : Bool;
	var indexData(default,never) : Dynamic;
	var inverseSceneTransform(default,never) : Dynamic;
	var mouseEnabled(default,never) : Bool;
	var numTriangles(default,never) : Int;
	var numVertices(default,never) : Int;
	var sceneTransform(default,never) : Dynamic;
	var shaderPickingDetails(default,never) : Bool;
	var sourceEntity(default,never) : tools.spark.sliced.services.std.display.logicalspace.entities.Entity;
	var uvTransform(default,never) : Dynamic;
	var vertexData(default,never) : Dynamic;
	var vertexNormalData(default,never) : Dynamic;
	var vertexStride(default,never) : Int;
	var vertexTangentData(default,never) : Dynamic;
}
