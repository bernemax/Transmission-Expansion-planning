option profile = 1;
option profiletol = 0.01;

set
*time set
t /t1*t24/
*generator set
g /g1*g13/
*line set
l /l1*l60/
*node set
n /n1*n32/
*expansion Korridor
k /k1*k4/
*years in model
year/1*3/

*referenze node
ref(n) /n1/
exist_nodes(n) /n1*n24/
prosp_nodes(n) /n25*n32/
exist_lines(l) /l1*l34/
prosp_lines(l) /l35*l60/
Map_send(l,n)                       mapping of sending-line to node
Map_res(l,n)                        mapping of resiving-line to node
Map_gen(g,n)                        mapping of the generation to node
Map_prosp_send_Line_node(l,n)       mapping of prospective sending-line to node
Map_prosp_res_Line_node(l,n)        mapping of prospective resiving-line to node
Map_prosp_nodeconnection(l,n)
;

alias
(t,tt), (year,period)
;
scalars
Sbase /100/
M    /1000/
ILmax /100000/
dis   /0.06/
intr  /0.1/
;
Parameter
genup                       upload table for generation data\parameter like costs\startups and co.
lineup                      upload table for line data

demand(n,t,year)

P_max(g)
P_min(g)
P_init(g)
ramp_up(g)
ramp_down(g)

ramp_up_reserve(g)             Maximum up reserve capacity of generating unit
ramp_down_reserve(g)           Maximum down reserve capacity of generating unit

gen_costs(g)
su_costs(g)

line_cap(l)                 line capacity
b(l)                        line susceptance = 1\line reactance

Inv_costs(l,year)
price(n,t,year)

line_investment(l)
total_investment(l,year)
ANF(year)
Discount(year)
;

table System_demand (t,year,*)  Total system demand for each t
*first column: set t . year 1 to year 10
             load
t1.1*3       1775.835
t2.1*3       1669.815
t3.1*3       1590.3
t4.1*3       1563.795
t5.1*3       1563.795
t6.1*3       1590.3
t7.1*3       1961.37
t8.1*3       2279.43
t9.1*3       2517.975
t10.1*3      2544.48
t11.1*3      2544.48
t12.1*3      2517.975
t13.1*3      2517.975
t14.1*3      2517.975
t15.1*3      2464.965
t16.1*3      2464.965
t17.1*3      2623.995
t18.1*3      2650.5
t19.1*3      2650.5
t20.1*3      2544.48
t21.1*3      2411.955
t22.1*3      2199.915
t23.1*3      1934.865
t24.1*3      1669.815
*$offtext
;

table Load_share (n,*,year) Load distribution of the Total system demand  
         share.1    share.2     share.3
n1       0.038      0.068       0.018
n2       0.034      0.064       0.054
n3       0.063      0.003       0.033
n4       0.026      0.026       0.056
n5       0.025      0.025       0.005
n6       0.048      0.048       0.068
n7       0.044      0.044       0.024
n8       0.06       0.091       0.080
n9       0.061      0.030       0.041
n10      0.068      0.038       0.088
n11      0          0.030       0.040
n12      0          0.020       0.030
n13      0.093      0.093       0.023
n14      0.068      0.068       0.098
n15      0.111      0.050       0.081
n16      0.035      0.035       0.055
n17      0          0.011       0.017
n18      0.117      0.100       0.060
n19      0.030      0.030       0.050
n20      0.045      0.030       0.015
n21      0          0.010       0.010
n22      0          0.030       0.025
n23      0          0.017       0.005
n24      0          0.017       0
n25      0          0           0.020
n26      0          0.012       0
n27      0.034      0.010       0.014
;
*########################################################set & parameter loading####################################################
$onecho > IEEE.txt
set=Map_gen                     rng=Mapping!A2:B14                rdim=2 cDim=0
set=Map_send                    rng=Mapping!D2:E35                rdim=2 cDim=0    
set=Map_res                     rng=Mapping!G2:H35                rdim=2 cDim=0
set=Map_prosp_send_Line_node    rng=Mapping!J2:K27                rdim=2 cDim=0
set=Map_prosp_res_Line_node     rng=Mapping!M2:N27                rdim=2 cDim=0
            
par=genup                       rng=Generation!A1:R14             rdim=1 cDim=1
par=lineup                      rng=lines!A2:D70                  rdim=1 cDim=1

$offecho

$onUNDF
$call   gdxxrw Data_IEEE_24.xlsx @IEEE.txt
$GDXin  Data_IEEE_24.gdx
$load   Map_gen, Map_send, Map_res, Map_prosp_send_Line_node, Map_prosp_res_Line_node
$load   genup, lineup
$offUNDF
;
Map_prosp_nodeconnection(l,n)$Map_prosp_send_Line_node(l,n)= yes;
Map_prosp_nodeconnection(l,n)$Map_prosp_res_Line_node(l,n) = yes;
;
**********************************************************parameter assignment*******************************************************
P_max(g)            =   genup(g,'Pi_max')
;
P_min(g)            =   genup(g,'Pi_min')
;
P_init(g)           =   genup(g,'Pi_init')
;
ramp_up(g)          =   genup(g,'Ri_up')
;
ramp_down(g)        =   genup(g,'Ri_down')
;
ramp_up_reserve(g)  =   genup(g,'Ri+')
;             
ramp_down_reserve(g)=   genup(g,'Ri-')
;
gen_costs(g)        =   genup(g,'Ci')
;
su_costs(g)         =   genup(g,'Ci_su')
;
demand(n,t,year)    =   system_demand(t,year,'load')*load_share(n,'share',year)+EPS
;
line_cap(l)         =   lineup(l,'cap')
;   
b(l)                =   lineup(l,'b')
;
Inv_costs(l,year)   =   lineup(l,'Inv_costs')
;
ANF(year)           =   (((1 + dis)**(ord(year) - 1)) * dis)/ (((1+dis)**ord(year)) - 1)
;
Discount(year)      =    1 / (1+intr)**(ord(year) -1 )
;
*execute_unload "check.gdx";
*$stop
*############################################################variables########################################################
Variables
Costs
Power_flow(l,t,year)
Theta(n,t,year)
Su(g,t,year)

;

Positive variables
gen(g,t,year)
P_on(g,t,year)

X_dem(n,t,year)
LS(n,t,year)
;
Binary Variable
x(l,t,year)
z(n,t,year)

;
*#############################################################Equations#######################################################
Equations
Total_costs
*Line_investment

LineNode
Conect_constr


Balance

max_gen
max_cap
min_cap
startup_constr
Ramp_up_constr
Ramp_down_constr
P_on_start


Ex_line_angle
Ex_Line_neg_flow
Ex_line_pos_flow
Prosp_line_neg_flow
Prosp_line_pos_flow
Linearization_prosp_line_neg
Linearization_prosp_line_pos

prosp_substat_neg
Prosp_substat_pos

*LS_det
binary_restr
Theta_LB
Theta_UB
Theta_ref
;
*#################################################################Objective function#############################################

Total_costs..                costs                  =e=   (sum((g,t,year), gen(g,t,year) * gen_costs(g))
                                                        + sum((g,t,year), Su(g,t,year) * su_costs(g))
                                                        + sum((n,t,year), LS(n,t,year) * 3000)
                                                        + sum((n,t,year), X_dem(n,t,year) * 100))
                                
                                                        + sum((l,t,year),Inv_costs(l,year)* ANF(year) * (x(l,t,year)))
                                
;
*##################################################################Energy balance################################################

Balance(n,t,year)..          demand(n,t,year) - LS (n,t,year) + X_dem(n,t,year) =e=  sum(g$Map_gen(g,n), gen(g,t,year))

                                                        + sum(l$Map_res(l,n),power_flow(l,t,year))
                                                        - sum(l$Map_send(l,n),power_flow(l,t,year))
                                                 
                                                        + sum(l$Map_prosp_res_Line_node(l,n), power_flow(l,t,year))
                                                        - sum(l$Map_prosp_send_Line_node(l,n), power_flow(l,t,year))
                                                      

;
*##################################################################Investment budget#############################################

*Line_investment..                                      sum((t,k,l)$prosp_lines(l),Inv_costs(l)*x(l,t)) =l= ILmax
*;
LineNode(n,l,t,year)..                                  x(l,t,year)$Map_prosp_nodeconnection(l,n)     =l=  z(n,t,year)$Map_prosp_nodeconnection(l,n)     
;
Conect_constr(n,t,year)..                               sum(l,x(l,t,year)$prosp_lines(l)) =g= 2 * z(n,t,year)$prosp_nodes(n)
;
*##################################################################Generation funcioning##########################################

max_gen(g,t,year)..                                     Gen(g,t,year)  =l= P_on(g,t,year)
;
max_cap(g,t,year)..                                     P_on(g,t,year) =l= P_max(g) 
;
min_cap(g,t,year)$(ord(t) gt 1)..                       P_on(g,t,year)  =g=  P_min(g)
;
startup_constr(g,t,year)..                              P_on(g,t,year) - P_on(g,t-1,year) =l= Su(g,t,year)
;
Ramp_up_constr(g,t,year)$(ord(t) gt 1)..                Su(g,t,year) =l= ramp_up(g)
;
Ramp_down_constr(g,t,year)$(ord(t) gt 1)..              Su(g,t,year) =g= -ramp_down(g)
;
P_on_start(g,t,year)$(ord(t) = 1)..                     P_on(g,t,year) =e= P_init(g)
;

*###############################################################Grid technical functioning#########################################

Ex_line_angle(l,t,year)$exist_lines(l)..                     power_flow(l,t,year) =e=  (B(l)*(sum(n$Map_send(l,n), Theta(n,t,year))-sum(n$Map_res(l,n), Theta(n,t,year)))) * Sbase
;
Ex_line_neg_flow(l,t,year)$exist_lines(l)..                  power_flow(l,t,year) =g= -Line_cap(l)
;
Ex_line_pos_flow(l,t,year)$exist_lines(l)..                  power_flow(l,t,year) =l=  Line_cap(l)
;

Prosp_line_neg_flow(l,t,year)$prosp_lines(l)..               power_flow(l,t,year) =g= -sum((tt,period)$((ord(tt) le ord(t))and (ord(period) le ord(year))),x(l,tt,period) * Line_cap(l))  
;
Prosp_line_pos_flow(l,t,year)$prosp_lines(l)..               power_flow(l,t,year) =l=  sum((tt,period)$((ord(tt) le ord(t))and (ord(period) le ord(year))),x(l,tt,period) * Line_cap(l))  
;
Linearization_prosp_line_neg(l,t,year)$prosp_lines(l)..      -sum((tt,period)$((ord(tt) le ord(t))and (ord(period) le ord(year))),(1-x(l,tt,period)))*M   =l= power_flow(l,t,year) - B(l) * (sum(n$Map_send(l,n),Theta(n,t,year))-sum(n$Map_res(l,n),Theta(n,t,year))) * Sbase
;
Linearization_prosp_line_pos(l,t,year)$prosp_lines(l)..      sum((tt,period)$((ord(tt) le ord(t))and (ord(period) le ord(year))),(1-x(l,tt,period)))*M    =g= power_flow(l,t,year) - B(l) * (sum(n$Map_send(l,n),Theta(n,t,year))-sum(n$Map_res(l,n),Theta(n,t,year))) * Sbase
;

Theta_LB(n,t,year)$exist_nodes(n)..                           -3.1415         =l= Theta(n,t,year)
;
Theta_UB(n,t,year)$exist_nodes(n)..                           3.1415          =g= Theta(n,t,year)
;
Theta_ref(n,t,year)$exist_nodes(n)..                          Theta(n,t,year)$ref(n) =l= 0
;

prosp_substat_neg(n,t,year)$prosp_nodes(n)..                  -z(n,t,year) * 3.1415 =l= Theta(n,t,year)
;
Prosp_substat_pos(n,t,year)$prosp_nodes(n)..                  z(n,t,year)  * 3.1415 =g= Theta(n,t,year)
;
binary_restr(l)$prosp_lines(l)..                              sum((t,year), x(l,t,year)) =l= 1 +EPS
;
*#############################################################solving##############################################################




Model TEP_IEEE_24 /all/;
*option limrow = 1e9;
TEP_IEEE_24.scaleopt = 1
;

solve TEP_IEEE_24 using MIP minimizing costs;

x.fx(l,t,year) = x.l(l,t,year)
;
z.fx(n,t,year) = z.l(n,t,year)
;

price(n,t,year) = Balance.m(n,t,year)*(-1);

line_investment(l) = sum((t,year), Inv_costs(l,year) * x.l(l,t,year));
total_investment(l,year) = sum((tt,period),Inv_costs(l,year)* ANF(year) * (x.l(l,tt,period)));

execute_unload "check.gdx" 
;



