model KT_3DOF
    
    import SI = Modelica.SIunits;

    // Maneuvering Parameters
    parameter Real K = 80.0;
    parameter Real T = 150.0;
    
    // State start values
    parameter SI.Velocity u_0 = 10;
    parameter SI.Velocity v_0 = 0;
    parameter SI.AngularVelocity r_0 = 0;
    
    // The states
    output SI.Velocity u(start = u_0);
    output SI.Velocity v(start = v_0);
    output SI.AngularVelocity r(start = r_0);
    
    // The control signal
    input SI.Angle delta;
    
equation
    der(u) = 0.0;
    der(v) = 0.0;
    der(r) = 1.0 / T * (- r + K * delta);
end KT_3DOF;