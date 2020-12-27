model RudderControl
    
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    
    // State start values
    parameter SI.Angle delta_0 = from_deg(10);
    
    // Setting param
    parameter Real psi_min = from_deg(-20);
    parameter Real psi_max = from_deg(+20);
    
    // The states
    output SI.Angle delta(start = delta_0);
    
    // The control signal
    input SI.Angle psi;
    
equation
    
    when psi >= psi_max then
        delta = from_deg(-10);
    elsewhen psi <= psi_min then
        delta = from_deg(10);
    end when;
        
end RudderControl;