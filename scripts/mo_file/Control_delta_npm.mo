model Control_delta_npm
    
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    
    // State start values
    parameter SI.Angle delta_0 = from_deg(20);
    parameter Real npm_0 = 20.833;
    
    // Setting param
    parameter Real psi_min = from_deg(-10);
    parameter Real psi_max = from_deg(+10);
    
    // The states
    output SI.Angle delta(start = delta_0);
    output Real npm(start = npm_0);
    
    // The control signal
    input SI.Angle psi;
    input SI.Velocity u; // not_used
    input SI.Velocity v; // not_used
    
equation
    npm = npm_0;
    when psi >= psi_max then
        delta = from_deg(-20);
    elsewhen psi <= psi_min then
        delta = from_deg(20);
    end when;
end Control_delta_npm;