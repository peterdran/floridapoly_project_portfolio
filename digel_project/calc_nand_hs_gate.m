%parameters from multisim
v_cc = 5;
v_be = 0.75;
v_bc = 0.75;
i_cmax = 1e-3;
v_ce = 0.3; %saturated
v_ol = v_ce;
%v_d = 0.75;
v_oh = 3.4;
i_n1 = 1e-3;
n = 4;
beta_f = 100;
beta_r = 6.092;
c_f = 25e-12;
t_smax = 225e-9;
t_dmax = 10e-9;
%params from experimental verification
%v_be = 0.677;
%v_bc = ;
%v_cesat = 8.1e-3;
%beta_f = 100;

%computation steps
r_1 = beta_r * ((v_cc - 2*v_be - v_bc)/i_n1);
r_2 = ((1+beta_f)*(v_cc - 2*v_be - v_oh)/(n*i_n1));
i_b1 = ((v_cc - 2*v_be - v_bc)/r_1); %output "low"
i_no = beta_r*((v_cc - v_ce - v_be)/r_1); %output "low"
i_b2 = (1 + beta_r)*i_b1; %output "high"
i_c2 = ((v_cc - v_be - v_ce)/r_2); %output "high"
i_e2 = i_c2 + i_b2; %output "high"
i_r = 0.4 * i_e2; %output "high"
r_b = v_be/i_r; %while there's technically no resistor base, this is the equivalent
%resistance to the base recovery circuit
i_b3 = i_e2 - i_r; %output "high"
i_c3max = beta_f * i_b3;
i_Lo = n * i_no; %output "low"
isDesignValid = i_c3max > i_Lo; %if true, design can support the fanout current
k_ODF = i_c3max / i_Lo; %if large, then can support much more fanout quantity
r_4 = ((v_cc - v_oh - v_ce - v_be)/i_cmax);
r_5 = ((v_oh + v_be)/i_b3);
i_br = v_be/r_b;
r_6 = ((v_be - v_ce)/(i_br/(1+1/beta_f)));
r_3 = 2 * r_6;
%prop delay calcs
r_l = v_oh / (n*i_n1);
c_l = n * c_f;
tao_r = (r_4 + r_l) * c_l;
vo_mid = (v_oh - v_ol)/2;
t_r = tao_r * log((v_cc - v_ol)/(v_cc - vo_mid));%matlab log is eq. to ln()
tao_f = r_l * c_l;
t_f = tao_f * log((2 * v_oh)/(v_oh + v_ol));
t_plh = t_smax + t_r;
t_phl = t_dmax + t_f;
t_pd = (t_plh + t_phl)/2;
%noise margin calcs
v_il = (2*v_be + v_bc) - v_be;
v_ih = 2*v_be + v_bc;
nm_h = v_oh - v_ih;
nm_l = v_il - v_ol;
