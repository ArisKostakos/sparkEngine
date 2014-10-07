/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * @author Aris Kostakos
 */

interface IActiveViewReference 
{
  var viewEntity( default, null ):IGameEntity;
  var renderer( default, null ):IRenderer;
}