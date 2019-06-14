package;


//@:native("ReplacingClass")//ReplacedClass will be correctly replaced by the macro generated ReplacingClass if uncommented
@:build(ReplaceMacro.build())
class ReplacedClass{

	public function new() {
		trace("replaced class instantiated.");
	}
	
}