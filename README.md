# Scheduling Generator Case study

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
