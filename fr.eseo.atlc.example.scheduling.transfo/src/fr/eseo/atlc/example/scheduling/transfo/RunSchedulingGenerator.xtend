package fr.eseo.atlc.example.scheduling.transfo

import com.google.common.collect.BiMap
import com.google.common.collect.HashBiMap
import fr.eseo.atlc.constraints.Constraint
import fr.eseo.atlc.constraints.ConstraintGroup
import fr.eseo.atlc.example.scheduling.Period
import fr.eseo.atlc.example.scheduling.Project
import fr.eseo.atlc.example.scheduling.SchedulingFactory
import fr.eseo.atlc.example.scheduling.SchedulingPackage
import fr.eseo.atlc.example.scheduling.Task
import fr.eseo.atlc.example.scheduling.transfo.JFX.Figure
import fr.eseo.atol.gen.AbstractRule
import fr.eseo.atol.gen.plugin.constraints.solvers.Constraints2Cassowary
import fr.eseo.atol.gen.plugin.constraints.solvers.Constraints2Choco
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Random
import javafx.application.Application
import javafx.scene.Node
import javafx.scene.Scene
import javafx.scene.input.KeyEvent
import javafx.scene.input.MouseButton
import javafx.scene.layout.Pane
import javafx.scene.shape.Line
import javafx.scene.shape.Rectangle
import javafx.scene.text.Text
import javafx.stage.Stage
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.papyrus.aof.core.AOFFactory
import org.eclipse.papyrus.aof.core.IBox
import org.eclipse.papyrus.aof.core.IOne

import static extension fr.eseo.aof.exploration.OCLByEquivalence.*
import static extension fr.eseo.atol.gen.JFXUtils.*

class RunSchedulingGenerator extends Application {
	val IBox<Node> nodes
	val IBox<ConstraintGroup> constraints
	var Constraints2Cassowary c2cas
	var Constraints2Choco c2cho
	val r = new Random

	val root = new Pane

	val transfo = new Scheduling2JFX

	val Project project

	val hideLine = AOFFactory.INSTANCE.createOne(false)

	val BiMap<EObject, Node> transformationCache = HashBiMap.create

	val Map<Rectangle, Period> semesterCache = new HashMap

	def static void main(String[] args) {
		launch(args)
	}

	new() {
		extension val JFX = transfo.JFXMM
		extension val CR = transfo.SchedulingMM
		// Init meta model
		val rs = new ResourceSetImpl

		rs.resourceFactoryRegistry.extensionToFactoryMap.put(
			"xmi",
			new XMIResourceFactoryImpl
		)
		rs.packageRegistry.put(
			SchedulingPackage.eNS_URI,
			SchedulingPackage.eINSTANCE
		)

		// create a resource
		val resource = rs.getFileResource("data.xmi")
//		val resource = rs.getFileResource("data-simplified.xmi")
		project = resource.contents.get(0) as Project
		val NbPeriods = project.numberOfPeriods
		project.periods.addAll(
			(0..<NbPeriods).map[ n |
				SchedulingFactory.eINSTANCE.createPeriod => [
					number = n
				]
			]
		)

		val refiningTransfo = new SchedulingConstraints
		refiningTransfo.refine(resource)

		project.tasks.forEach[
			period = project.periods.get(0)
		]

		val courses_pairs = project._tasks.collect[it -> transfo.Task(it).g]
		val courses = courses_pairs.collect[value]
		val semesters_pairs = project._periods.collect[it -> transfo.Period(it).g]
		val semesters = semesters_pairs.collect[value]

		courses_pairs.forEach[p |
			p.value.nodes.filter(Rectangle).forEach[
				transformationCache.put(p.key, it)
			]
		]
		semesters_pairs.forEach[p |
			p.value.nodes.filter(Rectangle).forEach[
				transformationCache.put(p.key, it)
				semesterCache.put(it, p.key)
			]
		]

		val figures = semesters.concat(courses).closure[
			it._children
		]
		nodes = figures.collectMutable[
			it?._nodes ?: AbstractRule.emptySequence
		]
		constraints = figures.collectMutable[
			it?._constraints ?: AbstractRule.emptySequence
		]

		val allConstraints =
			constraints
				.union(
					refiningTransfo.allContents(resource, null).collect[
						refiningTransfo.trace.get(it)
					].select[it !== null].collectMutable[
						if(it === null) {
							return AbstractRule.emptySequence
						}
						AOFFactory.INSTANCE.createSequence(
							values.filter(ConstraintGroup) as ConstraintGroup[]
						)
					]
				)

		c2cho = new Constraints2Choco(transfo.JFXMM, transfo.SchedulingMM)
		c2cho.defaultLowerBound = 0
		c2cho.defaultUpperBound = 6
		c2cho.apply(allConstraints.select[solver == "choco"].collect[it as Constraint])
		c2cho.solve

		c2cas = new Constraints2Cassowary(transfo.JFXMM, transfo.SchedulingMM)
		c2cas.apply(allConstraints.select[solver == "cassowary"].collect[it as Constraint])
		c2cas.solve

		nodes.filter[_movable.get].forEach[
			onPress
			onDrag
		]
		nodes.filter[_hideable.get].forEach[
			visibleProperty.toBox.bind(hideLine)
		]
	}

	// target element accessor for ListPatterns
	def static g(List<Object> l) {
		l.get(0) as Figure
	}

	override start(Stage stage) throws Exception {
		// Setup GUI stuff
		val scene = new Scene(root, 800, 800);
		stage.setScene(scene);
		stage.setTitle("scheduling");
		stage.show();

		//Quit app on escape keypress
		scene.addEventHandler(KeyEvent.KEY_PRESSED, [KeyEvent t |
			switch t.getCode {
				case ESCAPE: {
					stage.close
				}
				case SPACE: {
					c2cas.debug
					c2cho.debug
				}
				case H: hideLine.toggle
				case R: {
					val maxX = scene.width * 0.9
					val maxY = 600 * 0.9
					randomizePositions(maxX, maxY)
				}
				default: {}
			}
		]);

		root.children.toBox.bind(
				nodes.select(Arrow).collect[it as Node]
			.concat(
				nodes.select(Rectangle).collect[it as Node]
			).concat(
				nodes.select(Text).collect[it as Node]
			).concat(
				nodes.select(Line).collect[it as Node]
			)
		)
		root.style = "-fx-background-color: #ffffff;"

		randomizePositions(scene.width * 0.9, 350 * 0.9)
	}

	def randomizePositions(double maxX, double maxY) {
		for (n : nodes) {
			switch (n) {
				Rectangle: {
					c2cas.suggestValue(n.xProperty, r.nextDouble * maxX)
					c2cas.suggestValue(n.yProperty, r.nextDouble * maxY)
				}
			}
		}
	}

	def toggle(IOne<Boolean> it) {
		set(!get)
	}

	var dx = 0.0
	var dy = 0.0

	def onPress(Node it) {
		onMousePressed = [e |
			val t = e.target
			switch t {
				Rectangle: {
					dx = e.x - t.x
					dy = e.y - t.y
					e.consume
				}
			}
		]
	}

	def onDrag(Node it) {
		onMouseDragged = [e |
			val t = e.target
			switch t {
				Rectangle:
					switch (e.button) {
						case MouseButton.PRIMARY: {
							val smNodes = semesterCache.filter[k, v | k.contains(e.x, e.y)]
							if (!smNodes.empty) {
								val p = smNodes.entrySet.get(0)
								val s = p.value
								val c = transformationCache.inverse.get(t) as Task //TODO; check if exists elsewhere

								if (c.period != s) {
									c2cho.suggest(c, 'period', s)
									if (!c2cho.solve) {
										println("No solution found, ignoring suggestion")
									}
								}
								c2cas.suggestValue(t.xProperty, e.x - dx)
								c2cas.suggestValue(t.yProperty, e.y - dy)
							}
							e.consume
						}
						default: {}
					}
				}
		]
	}
	
	def getFileResource(ResourceSet rs, String file) {
		rs.getResource(URI.createFileURI(file), true)
	}
}