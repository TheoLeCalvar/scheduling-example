# Scheduling Generator Case study

This repository hosts an example of transformation that combines model transformation with constraints solving to generate an explorable model set.

It is composed of a project containing the definition of the source model used by the transformation.
It is a simple metamodel that defines Projects composed of Tasks and Periods.
Tasks sjould be assigned to Period in order to create a schedule.

The other project is the transformation.
It consists of two sub-transformations, [one](fr.eseo.atlc.example.scheduling.transfo/scheduling2jfx.atl) generating the schedule from a source model, and the [other](fr.eseo.atlc.example.scheduling.transfo/SchedulingConstraints.atl) generating an interactive view.

## Install

Clone this repository and import both project into eclipse.

You need to install these dependencies:

- ATL (if the metapackage contains EMFTVM otherwise see note below)
- EMF - Eclipse Modeling Framework SDK
- EMF - Eclipse Modeling Framework Xcore SDK 
- Eclipse plug-in development environment
- Xtend IDE

If the ATL package does not contain EMFTVM, you may install it from the following repository: http://download.eclipse.org/mmt/atl/updates/releases

## Usage

Run `RunSchedulingGenerator.xtend` to launch the transformation.
Once launched you can move rectangles around to modify the proposed schedule.

You can also press:
- H key to show/hide dependency arrows
- R key to randomize tasks position
- space to print constraints
- escape tu exit the application.

You can change source model by changing which file is loaded by modifing [this file](fr.eseo.atlc.example.scheduling.transfo/src/fr/eseo/atlc/example/scheduling/transfo/RunSchedulingGenerator.xtend#L81).
