# Scheduling Generator Case study

This repository hosts an example of transformation that combines model transformation with constraints solving to generate an explorable model set.

It is composed of a project containing the definition of the source model used by the transformation.
It is a simple metamodel that defines Projects composed of Tasks and Periods.
Tasks should be assigned to Period in order to create a schedule.

The other project is the transformation.
It consists of two sub-transformations, [one](fr.eseo.atlc.example.scheduling.transfo/scheduling2jfx.atl) generating the schedule from a source model and the [other](fr.eseo.atlc.example.scheduling.transfo/SchedulingConstraints.atl) generating an interactive view.

## Install

A VirtualBox VM image with Eclipse installed and configured is available [here](https://gdsn.fr/research/atlc.ova).
Use `atlc` as both user and password.


Otherwise you can directly install the demo from this repository.
Make sure that your JRE provides a JavaFX runtime.
Then clone this repository and import both projects into eclipse.

Then you need to install these dependencies from the eclipse "Install new software" menu:

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


## Examples


![Interaction with a schedule](https://gdsn.fr/atlc/img/scheduling.gif)

![Screenshot of a schedule](https://gdsn.fr/atlc/img/scheduling-full.png)

