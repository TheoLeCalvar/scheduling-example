package fr.eseo.atlc.example.scheduling.transfo

import fr.eseo.atol.gen.ATOLGen
import fr.eseo.atol.gen.ATOLGen.Metamodel
import fr.eseo.atol.gen.plugin.constraints.common.Constraints

@ATOLGen(transformation="scheduling2jfx.atl", metamodels=#[
	@Metamodel(name="Scheduling", impl=Scheduling),
	@Metamodel(name="JFX", impl=JFX),
	@Metamodel(name="Constraints", impl=Constraints)
], extensions = #[Constraints])
class Scheduling2JFX {

}