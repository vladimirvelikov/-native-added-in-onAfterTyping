package;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.TypeDefinition;
import haxe.macro.Type.ModuleType;

/**
 * ...
 * @author Vladimir Velikov
 */
class ReplaceMacro{
	static var firstPass:Bool = true;
	public static function build():Array<Field> {
		Context.onAfterTyping(onAfterTyping);
		return null;
	}
	
	static function defineReplacingClass() {
		var pack = [];
		var name = "ReplacingClass";
		
		var constructorExpr = Context.parse("{trace('Replacing class instantiated.');}", Context.currentPos());
		var constructor:Field = {
			name:"new",
			kind:FieldType.FFun( { expr:constructorExpr, ret:null, args: [] } ),
			pos:Context.currentPos(),
			access:[Access.APublic]
		}
		var replacingClassTD:TypeDefinition = {
			pack:pack,
			name:name,
			pos:Context.currentPos(),
			kind:TDClass(null, []),
			fields:[constructor],
			meta:[{name:"@:keep", pos:Context.currentPos()}]
		}
		
		Context.defineType(replacingClassTD);
	}
	
	static function onAfterTyping(types:Array<ModuleType>):Void {
		if (firstPass) {
			firstPass = false;
			Compiler.addMetadata("@:native('ReplacingClass')", "ReplacedClass");   //this doesn't have the expected effect as it does when the class is marked with @:native before compilation.
			defineReplacingClass();
			Compiler.exclude("ReplacedClass");
		}
	}
}