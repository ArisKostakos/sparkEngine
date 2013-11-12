/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep;


import co.gamep.sliced.core.Sliced;
import co.gamep.framework.Framework;
import co.gamep.framework.Assets;
import co.gamep.framework.Config;
import co.gamep.framework.Game;
import flambe.display.BlendMode;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.System;


/**
 * ...
 * @author Aris Kostakos
 */
class Main
{
	private static function main()
    {
		//Init Framework (flambe, graphics, etc..)
		Framework.init();
		
		//Load Minimal Assets (e.g. config files)
		Assets.assetsLoaded.connect(_onAssetsLoaded).once();  //Loads all Assets temporarily
		Assets.init();
    }

	private static function _onAssetsLoaded()
    {
		//Init Config
		Config.init(Assets.config.getFile("config.xml").toString());
		
		//Init Sliced
		Sliced.init();
		
		//Create Display Renderers
		Framework.createDisplayRenderers();
		
		//Create Game
		System.root.add(new Game());
		
		///REMOVE ALL THIS!!!!
		/*
		
		var firstChild:Entity = new Entity();
		var secondChild:Entity = new Entity();
		System.root.addChild(firstChild);
		System.root.addChild(secondChild);
		
		//first child
		firstChild.addChild(new Entity().add(new ImageSprite(Assets.images.getTexture("ball")))); // add on top of stage
		
		var myImage:ImageSprite = new ImageSprite(Assets.images.getTexture("lion"));
		myImage.setScale(0.1);
		myImage.blendMode = BlendMode.Copy;
		firstChild.addChild(new Entity().add(myImage)); // add on top of stage
		
		
		//second child
		var myImage2:ImageSprite = new ImageSprite(Assets.images.getTexture("lion"));
		myImage2.setScale(3.5);
		secondChild.addChild(new Entity().add(myImage2)); // add on top of stage
		
		var myImage3:ImageSprite = new ImageSprite(Assets.images.getTexture("lion"));
		myImage3.setScale(0.1);
		myImage3.blendMode = BlendMode.Copy;
		secondChild.addChild(new Entity().add(myImage3)); // add on top of stage
		*/
    }

}
