model ShipCondition

    import SI = Modelica.SIunits;
    
    // State start values
    parameter SI.Position x_0 = 0;
    parameter SI.Position y_0 = 0;
    parameter SI.Angle psi_0 = 0;
    
    // The states
    output SI.Position x(start = x_0);
    output SI.Position y(start = y_0);
    output SI.Angle psi(start = psi_0);
    
    // The control signal
    input SI.Velocity u;
    input SI.Velocity v;
    input SI.AngularVelocity r;
    
equation
    der(x) = u * cos(psi) + v * sin(psi);
    der(y) = u * sin(psi) + v * cos(psi);
    der(psi) = r;
end ShipCondition;