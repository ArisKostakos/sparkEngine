package;

import flash.events.Event;
import js.three.*;
import js.Browser;
import js.three.sea3d.Sea3d;
import js.three.sea3d.TrackballControls;

class TestHelloWorld {

	public static var container:Dynamic;
	public static var camera:Dynamic;
	public static var scene:Dynamic;
	public static var clock:Dynamic;
	public static var renderer:Dynamic;
	public static var loader:Dynamic;
	
	public static var controls:Dynamic;
	
	public static function start()
	{
		init();
		animate();
		untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});');
	}
	
	public static function init() 
	{
		container = Browser.document.createElement( 'div' );
		Browser.document.body.appendChild( container );
		
		//
		// three.js
		//
		
		clock = new Clock();
		
		camera = new PerspectiveCamera( 45, Browser.window.innerWidth / Browser.window.innerHeight, 1, 100000 );
		camera.position.z = 100;
		camera.position.y = camera.position.x = 100;				
		
		controls = new TrackballControls(camera, Browser.document);
		controls.rotateSpeed = 2.0;
		controls.zoomSpeed = 1.2;
		controls.panSpeed = 0.8;
		controls.noZoom = false;
		controls.noPan = false;
		controls.staticMoving = true;
		controls.dynamicDampingFactor = 0.1;
		
		scene = new Scene();			

		//	Environment Light
		
		var ambient = new AmbientLight( 0x111111 );
		scene.add( ambient );												
		
		//	Renderer
		
		renderer = new WebGLRenderer();				
		renderer.physicallyBasedShading = true;
		
		renderer.setClearColor( 0x333333, 1 );
		
		renderer.setSize( Browser.window.innerWidth, Browser.window.innerHeight );
		container.appendChild( renderer.domElement );
		
		//Browser.window.addEventListener( 'resize', onWindowResize, false );
		
		camera.aspect = Browser.window.innerWidth / Browser.window.innerHeight;
		camera.updateProjectionMatrix();

		renderer.setSize( Browser.window.innerWidth, Browser.window.innerHeight );
		
		//
		// SEA3D
		//
		
		// inverseX
		var sea3dStandard = false;
		
		if (sea3dStandard)
			camera.scale.set(-1, 1, 1);
		
		//loader = new THREE.SEA3D(); // SEA3D Standard = "false" is default
		loader = new Sea3d(sea3dStandard);
		
		loader.onComplete = function( e ) {
			// get camera from 3ds Max is exist
			if (loader.cameras) {
				var cam = loader.cameras[0];
				
				camera.position = cam.position;
				camera.rotation = cam.rotation;
			}
			
			//document.getElementById('loading').style.visibility = 'hidden';
		}
		
		loader.container = scene;
		loader.load( 'hello-world.sea' );
	}
	
	
	
	public static function animate(?dummy:Float):Bool
	{
		var delta = clock.getDelta();
		
		AnimationHandler.update( delta );	
		
		controls.update();
		
		render();

		js.three.Three.requestAnimationFrame( animate );
		
		return true;
	}
	
	public static function render() 
	{
		renderer.render( scene, camera );
	}
	
	/*
	public function new () 
	{
 var camera = new PerspectiveCamera(20, Browser.window.innerWidth/Browser.window.innerHeight, 1, 10000);
        camera.position.z = 1800;
        var scene = new Scene();
        var light = new DirectionalLight(0xffffff);
        light.position.set(0, 0, 1);
        light.position.normalize();
        scene.add(light);
        var shadowMaterial = new MeshBasicMaterial({
            map: ImageUtils.loadTexture("assets/textures/shadow.png")
        });
        var shadowGeo = new PlaneGeometry(300, 300, 1, 1);
        var mesh = new Mesh(shadowGeo, shadowMaterial);
        mesh.position.y = -250;
        mesh.position.x = -90 * std.Math.PI / 180;
        scene.add(mesh);
        var mesh = new Mesh(shadowGeo, shadowMaterial);
        mesh.position.y = -250;
        mesh.position.x = -400;
        mesh.position.x = -90 * std.Math.PI / 180;
        scene.add(mesh);
        var mesh = new Mesh(shadowGeo, shadowMaterial);
        mesh.position.y = -250;
        mesh.position.x = 400;
        mesh.position.x = -90 * std.Math.PI / 180;
        scene.add(mesh);
        var faceIndices = ['a','b','c','d'];
        var color, f, f2, f3, p, n, vertexIndex;
        var radius = 200;
        var geometry = new IcosahedronGeometry(radius, 1);
        var geometry2 = new IcosahedronGeometry(radius, 1);
        var geometry3 = new IcosahedronGeometry(radius, 1);
        for (i in 0...geometry.faces.length){
            f = geometry.faces[i];
            f2 = geometry2.faces[i];
            f3 = geometry3.faces[i];
            n = Std.is(f, Face3) ? 3 : 4;
            for (j in 0...n){
                vertexIndex = Reflect.field(f, faceIndices[j]);
                p = geometry.vertices[vertexIndex];

                color = new Color(0xffffff);
                color.setHSL( (p.y / radius + 1) /2, 1.0, 0.5 );
                f.vertexColors[j] = color;

                color = new Color(0xffffff);
                color.setHSL( 0, (p.y / radius + 1) / 2, 0.5 );
                f2.vertexColors[j] = color;

                color = new Color(0xffffff);
                color.setHSL(0.125 * vertexIndex/geometry.vertices.length, 1, 0.5);
                f3.vertexColors[j] = color;
            }
        }
        var materials : Array<Material> = [
            cast new MeshLambertMaterial({ color:0xffffff, shading:Three.FlatShading, vertexColors:Three.VertexColors }),
            cast new MeshLambertMaterial({ color:0x000000, shading:Three.FlatShading, wireframe:true, transparent:true })
        ];
        var group1 = SceneUtils.createMultiMaterialObject(geometry, materials);
        group1.position.x = -400;
        group1.rotation.x = -1.87;
        //group1.scale.set(200, 200, 200);
        scene.add(group1);

        var group2 = SceneUtils.createMultiMaterialObject(geometry2, materials);
        group2.position.x = 400;
        group2.rotation.x = 0;
        //group2.scale = group1.scale;
        scene.add(group2);

        var group3 = SceneUtils.createMultiMaterialObject(geometry3, materials);
        group3.position.x = 0;
        group3.rotation.x = 0;
        //group3.scale = group1.scale;
        scene.add(group3);

        var renderer = new WebGLRenderer({ antialias:true });
        renderer.setSize(Browser.window.innerWidth, Browser.window.innerHeight);

        Browser.document.body.appendChild(renderer.domElement);

        var mouseX = 0, mouseY = 0;
        untyped Browser.document.addEventListener('mousemove', function(event){
            mouseX = (event.clientX - Browser.window.innerWidth/2);
            mouseY = (event.clientY - Browser.window.innerHeight/2);
        }, false);


        var timer = new haxe.Timer(std.Math.round(1000/60));
        timer.run = function(){
            camera.position.x += (mouseX - camera.position.x) * 0.05;
            camera.position.y += (-mouseY - camera.position.y) * 0.05;
            camera.lookAt(scene.position);
            renderer.render(scene, camera);
        }
	}
*/
}