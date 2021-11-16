### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 3a69160a-1fc1-443d-b405-4b2c5967809c
md"""


The teaching team is building a mathematical model of an NH$_{3}$(g) decomposition process running in an _open_ CSTR that lives in the basement of Olin Hall. Let's help them estimate the forward
($k_{1}^{+}$) and reverse ($k_{1}^{-}$) rate constants for that model. 

The gas phase reaction occurring in the _open_ CSTR is (reaction 1):

$$\begin{equation*}
    2NH_{3}(g)~{\rightleftharpoons}~N_{2}(g)+3H_{2}(g)
\end{equation*}$$

The reactor has a single input ($s=1$) and a single output ($s=2$) and a constant volume of V = 14L.
NH$_{3}$(g) with a concentration of $C_{1,1}$ = 10.0 mol/L is fed into the reactor at $\dot{F}$ = 4.0 L/s. The feed stream does not contain the reaction products.  

The fractional conversion of NH$_{3}$ is $f_{1}$ = 0.92 (or 92%).

__Assumptions__: 
* the gas phase is ideal;
* the ideal gas law is valid in the reactor;
* the reactor operates at steady-state;
* the reactor operates at a constant T, P and V;
* the reactor is well-mixed;
* the decomposition of NH$_{3}$(g) follows mass-action kinetics and is not auto-catalytic. 
"""

# ╔═╡ a5422467-17c4-4de9-874e-cfa00798fea5
begin

	# setup problem specific data -
	prelim_version = :γ
	if (prelim_version == :γ)

		V = 14.0 		# units: L
		F_dot = 4.0 	# units: L/s
		f₁ = 0.92 		# units: dimensionless
		
	elseif (prelim_version == :δ)

		V = 24.0 		# units: L
		F_dot = 6.0 	# units: L/s
		f₁ = 0.67 		# units: dimensionless
		
	end

	# stoichiometry -
	S = [
		-2.0 ; # 1 NH3
		1.0  ; # 2 N2
		3.0  ; # 3 H2
	];

	# setup initial -
	C_feed = [
		10.0 	; 	# 1 NH3 units: mol/L
		0.0 	; 	# 2 N2 units: mol/L
		0.0 	; 	# 3 H2 units: mol/L
	];

	# show -
	nothing
end

# ╔═╡ df3c6d90-47a5-42ae-b145-d1396abf2991
begin

	# compute the concentration -
	τ = V/F_dot; # units: s

	# compute the extent -
	r₁_hat = -1*(C_feed[1]*f₁)/(τ*S[1])

	# compute the concentrations -
	C_out = C_feed .+ τ*S*r₁_hat

	# show -
	(C_out, r₁_hat)
end

# ╔═╡ 5ea224af-e9c9-437a-9727-641647ed0201
begin

	# alias -
	C12 = C_out[1]
	C22 = C_out[2]
	C32 = C_out[3]

	# make the θ some multiple of a hypothetical Keq -
	k1_minus = 0.01
	k1_plus = (r₁_hat + k1_minus*(C22)*(C32)^3)*(1/(C12)^2)
	θ = (k1_plus/k1_minus)

	# compute the A -
	AM = [
		C12^2 -(C22)*(C32)^3 ;
		1.0 -θ ;
	];

	bV = [
		r₁_hat ;
		0.0 ;
	]

	# compute rate constant vector -
	k_vec = inv(AM)*bV

	# test -
	test_rate = k_vec[1]*(C12)^2 - k_vec[2]*(C22)*(C32)^3

	# theta_test = 
	theta_test = k_vec[1]/k_vec[2]

	# values -
	(k_vec, θ, theta_test, r₁_hat, test_rate)
end

# ╔═╡ b8b580e8-4308-11ec-09c3-b7a14ae5b5d1
html"""
<style>
main {
    max-width: 1200px;
    width: 85%;
    margin: auto;
    font-family: "Roboto, monospace";
}

a {
    color: blue;
    text-decoration: none;
}

.H1 {
    padding: 0px 30px;
}
</style>"""

# ╔═╡ Cell order:
# ╟─3a69160a-1fc1-443d-b405-4b2c5967809c
# ╠═a5422467-17c4-4de9-874e-cfa00798fea5
# ╠═df3c6d90-47a5-42ae-b145-d1396abf2991
# ╠═5ea224af-e9c9-437a-9727-641647ed0201
# ╟─b8b580e8-4308-11ec-09c3-b7a14ae5b5d1
