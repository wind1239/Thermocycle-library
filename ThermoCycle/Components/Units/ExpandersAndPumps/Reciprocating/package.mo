within ThermoCycle.Components.Units.ExpandersAndPumps;
package Reciprocating "A reciprocating machine with different connectors"
  extends Modelica.Icons.Package;


  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Reciprocating Machines</font></h4></p>
<p>A package that provides some basic models for dynamic modelling of reciprocating machines. A base class (BaseClasses.PartialRecipMachine) takes care of the internal slider-crank-mechanism and also provides an animation thanks to the Modelica.Mechanics.Multibody package. Interaction with other parts of your model us possible via rotational flange connectors (Modelica.Mechanics.Rotational.Interfaces.Flange_xxx) that convey torque and can be connected to other components. Please have a look at the examples to see how to use the connectors.</p>
<p>In order to create your own components from the units in this package, you should redefine geometry and initial conditions. Please note that there are two base classes that can be used for your own geometry, BaseClasses.BaseGeometry and BaseClasses.SimpleGeometry both provide all the necessary inputs. As the name suggests, BaseClasses.SimpleGeometry should be easier to use, but does not provide all the flexibility, e.g. no piston pin offset from crankshaft centre. </p>
<p>This work uses many components from the Modelica standard library and adds only a few things, please be aware that there are many devoted people behind the development of Modelica libraries and their implementations.</p>
<p>Licensed by the Modelica Association under the Modelica License 2</p>
<p>Copyright &copy; 2011-2013 Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark</p>
<p>Main contributor: Jorrit Wronski (jowr@mek.dtu.dk)</p>
</html>"),
       Icon(graphics={Bitmap(
          extent={{-80,60},{60,-80}},
          imageSource=
              "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",
          fileName=
              "modelica://ComponentsExtMedia2/ComponentsExtMedia/pkg_reciprocating.jpg")}));
end Reciprocating;
