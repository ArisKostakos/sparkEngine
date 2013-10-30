package;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import flash.events.ErrorEvent;
import flash.events.Event;


import away3d.primitives.PlaneGeometry;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Vector3D;
import flash.Lib;


class TestAway3dFlash {
	
	private var _view:View3D;
	private var _plane:Mesh;
	
	
	public function new()
	{
		//setup the view
		_view = new View3D();
		_view.width = 600;
		Lib.current.stage.addChild(_view);
		//setup the camera
		_view.camera.z = -600;
		_view.camera.y = 500;
		_view.camera.lookAt(new Vector3D());
		
		//setup the scene
		_plane = new Mesh(new PlaneGeometry(700, 700));
		_view.scene.addChild(_plane);
		
		_view.backgroundColor = 0xFF0000;
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnter);
	}

	
	function onEnter(e:Event):Void
	{
		_plane.rotationY += 1;
		_view.render();
	}
}