package;

import flash.events.Event;
import js.three.*;
import js.Browser;
import js.three.sea3d.Sea3d;
import js.three.sea3d.TrackballControls;

class TestThreeJsRaw {



	
	public static function start()
	{
              haxe.macro.Compiler.includeFile("vendor/three.js/three.js");
				haxe.macro.Compiler.includeFile("vendor/three.js/loaders/sea3d/SEA3D.js");
				haxe.macro.Compiler.includeFile("vendor/three.js/loaders/sea3d/SEA3DLoader.js");
				haxe.macro.Compiler.includeFile("vendor/three.js/loaders/sea3d/SEA3DDeflate.js");
				haxe.macro.Compiler.includeFile("vendor/three.js/loaders/sea3d/SEA3DLZMA.js");
				haxe.macro.Compiler.includeFile("vendor/three.js/TrackballControls.js");
				
				
				
				
				
		untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});');
		
		
		untyped __js__("
		
		var container, camera, scene, clock, renderer, loader, controls, delta;
			
			init();
			animate();

			function init() {
				
				container = document.createElement( 'div' );
				document.body.appendChild( container );
				
				//
				// three.js
				//
				
				clock = new THREE.Clock();
				
				camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 100000 );
				camera.position.z = 100;
				camera.position.y = camera.position.x = 100;				
				
				controls = new THREE.TrackballControls(camera, document);
				controls.rotateSpeed = 2.0;
				controls.zoomSpeed = 1.2;
				controls.panSpeed = 0.8;
				controls.noZoom = false;
				controls.noPan = false;
				controls.staticMoving = true;
				controls.dynamicDampingFactor = 0.1;
				
				scene = new THREE.Scene();				

				//	Environment Light
				
				var ambient = new THREE.AmbientLight( 0x111111 );
				scene.add( ambient );												
				
				//	Renderer
				
				renderer = new THREE.WebGLRenderer();				
				renderer.physicallyBasedShading = true;
				
				renderer.setClearColor( 0x333333, 1 );
				
				renderer.setSize( window.innerWidth, window.innerHeight );
				container.appendChild( renderer.domElement );
				
				//window.addEventListener( 'resize', onWindowResize, false );
				
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( window.innerWidth, window.innerHeight );
				
				
				//
				// SEA3D
				//
				
				// inverseX
				var sea3dStandard = false;
				
				if (sea3dStandard)
					camera.scale.set(-1, 1, 1);
				
				//loader = new THREE.SEA3D(); // SEA3D Standard = 'false' is default
				loader = new THREE.SEA3D(sea3dStandard);
				
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
			

			
			function animate() {	
				delta = clock.getDelta();
				
				THREE.AnimationHandler.update( delta );	
				
				controls.update();
				if (loader.meshes) loader.meshes[0].rotation.y +=0.01;
				render();

				requestAnimationFrame( animate );
			}

			function render() {
				renderer.render( scene, camera );
			}
		
		
		
		");
	}
	
}