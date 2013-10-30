package;

import js.Browser;

class TestAway3dHtml5 {



	
	public function new()
	{
        //haxe.macro.Compiler.includeFile("vendor/Away3D.next.js");
		haxe.macro.Compiler.includeFile("vendor/Away3D.next.min.js");	
				
		untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});');
		
		
		untyped __js__('
		
		var examples;
(function (examples) {
    var Basic_View = (function () {
        /**
* Constructor
*/
        function Basic_View() {
            var _this = this;
            //setup the view
            this._view = new away.containers.View3D();
			
			this._view.y = 0;
            this._view.x = 300;
			this._view.width = 600;
            this._view.height = 400;
			
            //setup the camera
            this._view.camera.z = -600;
            this._view.camera.y = 500;
            this._view.camera.lookAt(new away.geom.Vector3D());

            //setup the materials
            this._planeMaterial = new away.materials.TextureMaterial();

            //setup the scene
            this._plane = new away.entities.Mesh(new away.primitives.PlaneGeometry(700, 700), this._planeMaterial);
            this._view.scene.addChild(this._plane);

            //setup the render loop
            window.onresize = function (event) {
                return _this.onResize(event);
            };

            this.onResize();

            this._timer = new away.utils.RequestAnimationFrame(this.onEnterFrame, this);
            this._timer.start();

            away.library.AssetLibrary.addEventListener(away.events.LoaderEvent.RESOURCE_COMPLETE, this.onResourceComplete, this);

            //plane textures
            away.library.AssetLibrary.load(new away.net.URLRequest("assets/floor_diffuse.jpg"));
        }
        /**
* render loop
*/
        Basic_View.prototype.onEnterFrame = function (dt) {
            this._plane.rotationY += 1;

            this._view.render();
        };

        /**
* Listener function for resource complete event on asset library
*/
        Basic_View.prototype.onResourceComplete = function (event) {
            var assets = event.assets;
            var length = assets.length;

            for (var c = 0; c < length; c++) {
                var asset = assets[c];

                console.log(asset.name, event.url);

                switch (event.url) {
                    case "assets/floor_diffuse.jpg":
                        this._planeMaterial.texture = away.library.AssetLibrary.getAsset(asset.name);
                        break;
                }
            }
        };

        /**
* stage listener for resize events
*/
        Basic_View.prototype.onResize = function (event) {
            if (typeof event === "undefined") { event = null; }
            //this._view.y = 0;
            //this._view.x = 0;
            //this._view.width = window.innerWidth;
            //this._view.height = window.innerHeight;
        };
        return Basic_View;
    })();
    examples.Basic_View = Basic_View;
})(examples || (examples = {}));

window.onload = function () {
    new examples.Basic_View();
};
		
		');
	}
	
}