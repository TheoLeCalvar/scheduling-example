package fr.eseo.atlc.example.scheduling.transfo

import fr.eseo.aof.extensions.AOFExtensions
import fr.eseo.atol.gen.ATOLGen
import fr.eseo.atol.gen.ATOLGen.Metamodel
import fr.eseo.atol.gen.plugin.constraints.common.Constraints
import java.util.HashMap
import java.util.Map

@ATOLGen(transformation="SchedulingConstraints.atl", metamodels = #[
	@Metamodel(name = "Scheduling", impl = Scheduling),
	@Metamodel(name="Constraints", impl=Constraints)
]
, extensions = #[Constraints])
class SchedulingConstraints implements AOFExtensions {

	public val trace = new HashMap<Object, Map<String, Object>>
}