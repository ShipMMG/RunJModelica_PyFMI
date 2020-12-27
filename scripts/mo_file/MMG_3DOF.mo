model MMG_3DOF
    
    import SI = Modelica.SIunits;
    import Math = Modelica.Math;

    // Ship Basic Parameters
    parameter SI.Length L = 2.19048; // 船長Lpp[m]
    parameter SI.Length B = 0.3067; // 船幅[m]
    parameter SI.Length d = 0.10286; // 喫水[m]
    parameter SI.Volume nabla = 0.04495; // 排水量[m^3]
    parameter Real xG = 0.0; // 重心位置[-]
    parameter Real kzz_Lpp = 0.25; // 船長あたりの付加質量[]
    parameter SI.Length Dp = 0.0756; // プロペラ直径[m]
    // parameter Real Cb = 0.6505; // 方形係数[-]
    parameter Real m_ = 0.1822; // 質量(無次元化)[-]
    parameter Real Izz = 0.01138; // 慣性モーメント[-]
    parameter Real Lambda = 2.1683; // アスペクト比[-]
    parameter Real AR_Ld = 0.01867; // 船の断面に対する舵面積比[-]
    parameter Real eta = 0.7916; // プロペラ直径に対する舵高さ(Dp/H)
    parameter Real mx = 0.00601; // 付加質量x(無次元)
    parameter Real my = 0.1521; // 付加質量y(無次元)
    parameter Real Jzz = 0.00729; // 付加質量Izz(無次元)
    parameter Real fa = (6.13*Lambda)/(2.25+Lambda); // 直圧力勾配係数
    parameter Real epsilon = 0.90; // プロペラ・舵位置伴流係数比
    parameter Real tR = 0.441; // 操縦抵抗減少率
    parameter Real aH = 0.232; // 舵力増加係数
    parameter Real xH = -0.711; // 舵力増分作用位置
    parameter Real gammaR = 0.4115; // 整流係数
    parameter Real lr = -0.774; // 船長に対する舵位置
    parameter Real kappa = 0.713; // 修正係数
    parameter Real kx = 0.6417; // 流速増加修正係数
    parameter Real tP = 0.20; // 推力減少率
    parameter Real wpo = 0.326; // 有効伴流率
    
    // Maneuvering Parameters
    parameter Real C1 = 0.48301; // クラスタ特性係数C1
    parameter Real C2 = -0.29765; // クラスタ特性係数C2
    parameter Real C3 = -0.16423; // クラスタ特性係数C3
    parameter Real X_0 = -0.07234; // 線形微係数
    parameter Real X_beta_beta = -0.23840;
    parameter Real X_beta_gamma = -0.03231 + my;
    parameter Real X_gamma_gamma = -0.06405;
    parameter Real X_beta_beta_beta_beta = -0.30047;
    parameter Real Y_beta = 0.85475;
    parameter Real Y_gamma = 0.11461 + mx;
    parameter Real Y_beta_beta_beta = 6.73201;
    parameter Real Y_beta_beta_gamma = -2.23689;
    parameter Real Y_beta_gamma_gamma = 3.38577;
    parameter Real Y_gamma_gamma_gamma = -0.04151;
    parameter Real N_beta = 0.096567;
    parameter Real N_gamma = -0.036501;
    parameter Real N_beta_beta_beta = 0.14090;
    parameter Real N_beta_beta_gamma = -0.46158;
    parameter Real N_beta_gamma_gamma = 0.01648;
    parameter Real N_gamma_gamma_gamma = -0.030404;
    
    // Environments Parameters
    parameter Real rho = 1.025;
    
    // State start values
    parameter SI.Velocity u_0 = 1.21;
    parameter SI.Velocity v_0 = 0;
    parameter SI.AngularVelocity r_0 = 0;
    
    // The states
    output SI.Velocity u(start = u_0);
    output SI.Velocity v(start = v_0);
    output SI.AngularVelocity r(start = r_0);
    
    // The control signal
    input SI.Angle delta;
    input Real npm; // エンジン回転数[rpm]
    
    // The states of simulation
    SI.Velocity U; // 合速度
    SI.Angle beta; // 斜航角
    SI.AngularVelocity gamma_dash; // 無次元化された回頭角速度
    Real J; // 前進常数
    Real K_T; // スラスト係数
    SI.Velocity v_R; // 舵に流入する横方向速度成分
    SI.Velocity u_R; // 舵に流入する前後方向速度成分
    SI.Velocity U_R; // 舵への流入速度
    SI.Angle alpha_R; // 舵への流入角度
    Real F_N; // 舵直圧力
    Real X_H; // 斜航，旋回時の船体に作用する前後方向の流体力
    Real R_0; // 直進時の船体抵抗
    Real X_R; // 斜航，旋回時の舵に作用する前後方向の流体力
    Real X_P; // プロペラ推力
    Real Y_H; // 斜航，旋回時の船体に作用する横方向の流体力
    Real Y_R; // 斜航，旋回時の舵に作用する横方向の流体力
    Real N_H; // 斜航，旋回時の船体に作用する回頭モーメント
    Real N_R; // 斜航，旋回時の舵に作用する回頭モーメント
    
equation
    
    U = sqrt(u^2 + ( v - r * xG )^2);
    beta = if U < 0.001 then 0.0 else Math.asin( - ( v - r * xG ) / U); // "=="がcompileできない？？
    
    gamma_dash = if U < 0.001 then 0.0 else ( r * L ) / U;
    J = if npm < 0.001 then 0.0 else (1.0 - wpo) * u / (npm / Dp);
    K_T = C1 + C2 * J + C3 * (J^2);
    v_R = U * gammaR * ( sin(beta) - lr * gamma_dash );
    u_R = if J < 0.001 then u * (1 - wpo) else sqrt(eta * ( kappa * epsilon * 8.0 * C1 * (npm^2) * (Dp^4) )^2);
    U_R = sqrt( u_R^2 + v_R^2 );
    alpha_R = delta - atan2(v_R, u_R);
    F_N = AR_Ld * fa * (U_R^2) * sin(alpha_R);
    
    X_H = 0.5*rho*L*d*(U^2)*(X_0+X_beta_beta*(beta^2)+X_beta_gamma*beta*gamma_dash+X_gamma_gamma*(gamma_dash^2)+X_beta_beta_beta_beta*(beta^4));
    R_0 = 0.0;
    X_R = -(1.0-tR)*F_N*sin(delta)/L;
    X_P = (1.0-tP)*rho*K_T*(npm^2)*(Dp^4)*(2.0/(rho*d*(L^2)));
    Y_H = 0.5*rho*L*d*(U^2)*(Y_beta*beta+Y_gamma*gamma_dash+Y_beta_beta_gamma*(beta^2)*gamma_dash+Y_beta_gamma_gamma*beta*(gamma_dash^2)+Y_beta_beta_beta*(beta^3)+Y_gamma_gamma_gamma*(gamma_dash^3));
    Y_R = -(1+aH)*F_N*cos(delta)/L;
    N_H = 0.5*rho*(L^2)*d*(U^2)*(N_beta*beta+N_gamma*gamma_dash+N_beta_beta_gamma*(beta^2)*gamma_dash+N_beta_gamma_gamma*beta*(gamma_dash^2)+N_beta_beta_beta*(beta^3)+N_gamma_gamma_gamma*(gamma_dash^3));
    N_R = -(-0.5+aH*xH)*F_N*cos(delta)/(L^2);
    
    der(u) = ((X_H-R_0+X_R+X_P)+(m_+my)*v*r)/(m_+mx);
    der(v) = ((Y_H+Y_R)-(m_+mx)*u*r)/(m_+my);
    der(r) = (N_H+N_R)/(Izz+Jzz);
    
end MMG_3DOF;