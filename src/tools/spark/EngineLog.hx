//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package tools.spark;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import flambe.util.Logger;

#else

@:autoBuild(tools.spark.EngineLog.build())
#end
class EngineLog
{
#if macro
    public static function build () :Array<Field>
    {
        var tag = "engine";
        var logger = Context.defined("flambe-server")
            ? macro flambe.server.Node.createLogger(tag)
            : macro flambe.System.createLogger(tag);

        return Macros.buildFields(macro {
            var public__static__logger :flambe.util.Logger = $logger;

            function inline__public__static__info (?text :String, ?args :Array<Dynamic>) {
                logger.info(text, args);
            }

            function inline__public__static__warn (?text :String, ?args :Array<Dynamic>) {
                logger.warn(text, args);
            }

            function inline__public__static__error (?text :String, ?args :Array<Dynamic>) {
                logger.error(text, args);
            }

            function inline__public__static__log (level :flambe.util.Logger.LogLevel,
                    ?text :String, ?args :Array<Dynamic>) {
                logger.log(level, text, args);
            }
        }).concat(Context.getBuildFields());
    }
#end
}