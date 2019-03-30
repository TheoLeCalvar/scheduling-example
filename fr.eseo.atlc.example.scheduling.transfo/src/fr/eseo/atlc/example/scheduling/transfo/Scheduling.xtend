package fr.eseo.atlc.example.scheduling.transfo

import fr.eseo.aof.xtend.utils.AOFAccessors
import fr.eseo.atlc.example.scheduling.SchedulingPackage

import static fr.eseo.atol.gen.MetamodelUtils.*
import fr.eseo.atlc.example.scheduling.Period

@AOFAccessors(SchedulingPackage)
class Scheduling {
	public val __load = <Period, Float>oneDefault(0.0f)[
		_load
	]
}