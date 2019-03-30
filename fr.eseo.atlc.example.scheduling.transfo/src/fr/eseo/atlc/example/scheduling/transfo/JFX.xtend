package fr.eseo.atlc.example.scheduling.transfo

import fr.eseo.atlc.constraints.ConstraintGroup
import fr.eseo.atol.gen.Metaclass
import java.util.HashMap
import java.util.Map
import javafx.beans.property.ObjectProperty
import javafx.geometry.VPos
import javafx.scene.Node
import javafx.scene.paint.Paint
import javafx.scene.shape.Circle
import javafx.scene.shape.Line
import javafx.scene.shape.Rectangle
import javafx.scene.shape.Shape
import javafx.scene.text.Text
import org.eclipse.papyrus.aof.core.AOFFactory
import org.eclipse.papyrus.aof.core.IOne
import org.eclipse.xtend.lib.annotations.Data

import static fr.eseo.atol.gen.MetamodelUtils.*

import static extension fr.eseo.atol.gen.JFXUtils.*

class JFX {
	public static val Metaclass<Text> Text = [new Text()]
	public static val Metaclass<Line> Line = [new Line()]
	public static val Metaclass<Arrow> Arrow = [new Arrow()]
	public static val Metaclass<Circle> Circle = [new Circle()]
	public static val Metaclass<Rectangle> Rectangle = [new Rectangle()]
	public static val Metaclass<Figure> Figure = [new Figure()]

	@Data
	static class Figure {
		val nodes = AOFFactory.INSTANCE.<Node>createSequence
		val constraints = AOFFactory.INSTANCE.<ConstraintGroup>createSequence
		val children = AOFFactory.INSTANCE.<Figure>createSequence
	}

	def _id(Node e) {
		e.idProperty
	}

	def _text(Text e) {
		e.textProperty
	}

	def _width(Rectangle r) {
		r.widthProperty
	}

	def _nodes(Figure it) {
		nodes
	}

	def _constraints(Figure it) {
		constraints
	}

	def _children(Figure it) {
		children
	}

	def asMutableString(ObjectProperty<Paint> it) {
		toBox.collect([it?.toString], [Paint.valueOf(it)])
	}

	public val __stroke = [
		stroke_.asMutableString
	]

	public val __fill = [_fill.asMutableString]

	dispatch def stroke_(Shape it) {
		it.strokeProperty
	}

	dispatch def stroke_(Arrow it) {
		it.strokeProperty
	}

	def _fill(Shape it) {
		it.fillProperty
	}

	public val __movable = [_movable]

	val movableNodes = new HashMap<Node, IOne<Boolean>>

	def <K, V> fluentPut(Map<K, V> it, K k, V v) {
		put(k, v)
		v
	}

	def _movable(Node it) {
		movableNodes.get(it) ?:
			movableNodes.fluentPut(it, AOFFactory.INSTANCE.createOne(false))
	}

	public val __hideable = [_hideable]

	val hideableNodes = new HashMap<Node, IOne<Boolean>>

	def _hideable(Node it) {
		hideableNodes.get(it) ?:
			hideableNodes.fluentPut(it, AOFFactory.INSTANCE.createOne(false))
	}

	public val __textOrigin = <Text, VPos>enumConverterBuilder([textOriginProperty.toBox], VPos, "")

	// readonly
	def _height(Text it) {
		layoutBoundsProperty.collectDouble[height]
	}

	// readonly
	def _width(Text it) {
		layoutBoundsProperty.collectDouble[width]
	}
}
