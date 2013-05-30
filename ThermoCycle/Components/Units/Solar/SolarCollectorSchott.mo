within ThermoCycle.Components.Units.Solar;
model SolarCollectorSchott
replaceable package Medium1 = Media.R245fa constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);
// PARAMETERS //
constant Real  pi = Modelica.Constants.pi;
//FOCUS
parameter Boolean PTR = true "Set true to use the 2008 PTR collector";
//parameter Boolean UVAC "Choose type of collector";
// Optical Parameter Values give an eta_opt = 0.7263 //
parameter Real eps1 = 0.9754 "HCE Shadowing";
parameter Real eps2 = 0.994 "Tracking error";
parameter Real eps3 = 0.98 "Geometry error";
parameter Real rho_cl = 0.935 "Mirror reflectivity";
parameter Real eps4 = 0.962566845 "Dirt on Mirrors";
parameter Real eps5 = 0.981283422 "Dirt on HCE";
parameter Real eps6 = 0.96 "Unaccounted FORSE DA LEVARE";
// Parameter for coefficient of heat transfer air
parameter Modelica.SIunits.Pressure Patm "Atmosphere Pressure [Pa]";
//GEOMETRIES
parameter Integer N = 2 "Number of nodes";
parameter Integer Nt = 1 "Number of tubes";
parameter Modelica.SIunits.Length L "Length of tube";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
    "Internal volume of the metal tube";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";
// TUBE PROPERTIES
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube";
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.0025 "tube thickness";
                      //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
//TEMPERATURE INITIALIZATION GLASS AND METAL WALL
parameter Modelica.SIunits.Temperature T_g_start_in
    "Temperature at the inlet of the glass" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_g_start_out
    "Temperature at the outlet of the glass" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_in
    "Temperature at the inlet of the tube" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_out
    "Temperature at the outlet of the tube" annotation (Dialog(tab="Initialization"));
// Flow-1D
// Parameters for convective heat transfer in the fluid //
  import ThermoCycle.Functions.Enumerations.HTtypes;
parameter HTtypes HTtype=HTtypes.LiqVap
    "Working fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT";
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.MassFlowRate Mdotnom "Total nominal Mass flow";
// Fluid initial values
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Intialization options", tab="Initialization"));
//NUMERICAL OPTION
  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  Components.HeatFlow.Walls.AbsorberSchott absorberSchott(
    eps1=eps1,
    eps2=eps2,
    eps3=eps3,
    rho_cl=rho_cl,
    eps4=eps4,
    eps5=eps5,
    eps6=eps6,
    N=N,
    L=L,
    A_P=A_P,
    Dext_t=Dext_t,
    th_t=th_t,
    PTR=PTR)
    annotation (Placement(transformation(extent={{-24,6},{14,40}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-86,60},{-46,100}}),
        iconTransformation(extent={{-72,60},{-32,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-88,20},{-48,60}}),
        iconTransformation(extent={{-72,10},{-32,50}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-88,-18},{-48,22}}),
        iconTransformation(extent={{-72,-38},{-32,2}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-86,-54},{-46,-14}}),
        iconTransformation(extent={{-72,-94},{-32,-54}})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,80},{10,100}}),
        iconTransformation(extent={{-10,92},{10,112}})));
  Components.FluidFlow.Pipes.Flow1Dim flow1Dim(redeclare package Medium = Medium1,
    N=N,
    A=A_lateral,
    V=V_tube_int,
    Mdotnom=Mdotnom,
    Unom_l=Unom_l,
    Unom_tp=Unom_tp,
    Unom_v=Unom_v,
    pstart=pstart,
    Tstart_inlet=Tstart_inlet,
    Tstart_outlet=Tstart_outlet,
    Mdotconst=Mdotconst,
    max_der=max_der,
    filter_dMdt=filter_dMdt,
    max_drhodt=max_drhodt,
    TT=TT,
    steadystate=steadystate_T_fl,
    HTtype=HTtype,
    Discretization=Discretization)
                                  annotation (Placement(transformation(
        extent={{-27.5,-31.5},{27.5,31.5}},
        rotation=90,
        origin={44.5,23.5})));
equation
  connect(Theta, absorberSchott.Theta) annotation (Line(
      points={{-68,40},{-52,40},{-52,38},{-42,38},{-42,28.61},{-22.29,28.61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v_wind, absorberSchott.v_wind) annotation (Line(
      points={{-66,80},{-50,80},{-50,78},{-36,78},{-36,37.45},{-21.91,37.45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OutFlow, flow1Dim.OutFlow) annotation (Line(
      points={{0,90},{44.2375,90},{44.2375,46.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, flow1Dim.InFlow) annotation (Line(
      points={{0,-90},{28,-90},{28,-86},{44.5,-86},{44.5,0.583333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(absorberSchott.wall_int, flow1Dim.Wall_int) annotation (Line(
      points={{12.1,23},{20.5,23},{20.5,23.5},{31.375,23.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tamb, absorberSchott.Tamb) annotation (Line(
      points={{-68,2},{-56,2},{-56,4},{-42,4},{-42,19.6},{-22.48,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DNI, absorberSchott.DNI) annotation (Line(
      points={{-66,-34},{-52,-34},{-52,-32},{-32,-32},{-32,11.27},{-22.29,
          11.27}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-60,-100},{60,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-60,-100},{60,100}},
          preserveAspectRatio=true),  graphics={Rectangle(
          extent={{-60,100},{60,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid), Text(
          extent={{-30,60},{42,-44}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="Schott")}));
end SolarCollectorSchott;