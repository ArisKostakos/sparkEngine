package tools.spark.framework.flambe2_5D.spritesheet;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Texture;
import flambe.Entity;
import flambe.math.Rectangle;
import flambe.math.Point;
import tools.spark.framework.flambe2_5D.spritesheet.Size;
import flambe.SpeedAdjuster;
import flambe.util.Assert;
import flambe.display.Sprite;

/**
 * ...
 * @author Ang Li(李昂)
 */
class SpriteSheetPlayer extends Component
{
	var plist : Array<PlistEntry>;
	var texture : Texture;
	var _spriteFramesInfo : Array<SpriteFrame>;
	var sprites : Array<SpriteSheet>;
	var _root : Entity;
	public var currentIndex : Int = 0;
	public var currentFrame : SpriteSheet;
	public var paused : Bool = false;
	var isLooping : Bool = false;
	
	var oldTime : Float;
	var curTime : Float;
	var speed : Float;
	
	public function new(pack : AssetPack, plistName : String, textureName:String) //Aris
	{
		var xmlDoc : Xml = Xml.parse(pack.getFile(plistName).toString());
		
		plist = PlistParser.parse(xmlDoc);
		_spriteFramesInfo = new Array<SpriteFrame>();
		sprites = new Array<SpriteSheet>();
		
		if (texture == null) {
			var name:String = textureName; //aris
			texture = pack.getTexture(name);
		}
		
		this._addSpriteFramesWithDictionary();
		_initSprites();
		_root = new Entity();
		
		speed = -1;
	}
	
	private function _addSpriteFramesWithDictionary() {
		
		for (p in plist) {
			var rect : Rectangle = new Rectangle(p.x, p.y, p.width, p.height);
			var rotated : Bool = p.rotated;
			var offset : Point = new Point(p.sourceColorX, p.sourceColorY);
			var size : Size = new Size(0, 0);
			var frame : SpriteFrame = 
			SpriteFrame.createWithTexture(texture, rect, rotated, offset, size);

			this._spriteFramesInfo.push(frame);
		}
	}
	
	private function _initSprites() {
		currentFrame = new SpriteSheet(_spriteFramesInfo[0]);
		currentIndex++;
	}
	
	public function play() {
		if (_root.get(SpriteSheet) == null) {
			_root.add(currentFrame);
			currentFrame.centerAnchor(); //Aris
		}
		currentIndex = 0;
		paused = false;
	}
	
	public function loop() {
		play();
		isLooping = true;
	}
	
	override public function onAdded() 
	{
		owner.addChild(_root);
		//owner.add(_speedAdjuster);
		oldTime = Date.now().getTime();
		curTime = Date.now().getTime();
	}
	
	override public function onRemoved()
	{
		_root.parent.removeChild(_root);
        this.currentFrame.frame = _spriteFramesInfo[0];
		currentIndex = 0;
		paused = false;
		isLooping = false;
	}
	
	
	//Aris comment: This is retarded. dt is available, and he's doing cur-old time stuff :~
	//on the bright side, it is based on ms, not frames.. so it's frame-independant. speed is given in ms i think
	override public function onUpdate(dt:Float)
	{
		if (speed != -1) {
			curTime = Date.now().getTime();
			if (curTime - oldTime < speed) {
				return;
			} else {
				oldTime = curTime;
			}
		}
		
		if (!paused && currentFrame != null) {
			if (currentIndex == _spriteFramesInfo.length) {
				if (isLooping) {
					currentIndex = 0;
				} else {
					paused = true;
				}
				
			}
			
			if (!paused) {
				currentFrame.frame = _spriteFramesInfo[currentIndex++];
			}
			
		}
	}
	
	@:keep public function setCurrentFrame(index : Int) {
		currentIndex = index;
		currentFrame = sprites[index];
	}
	
	public function setSpeed(s : Float) {
		this.speed = s;
	}
}