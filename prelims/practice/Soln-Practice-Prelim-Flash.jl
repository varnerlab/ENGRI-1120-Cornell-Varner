### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 9d286b46-73ae-49f7-b834-791b9ef95420
begin
	using PlutoUI
end

# ╔═╡ 4abf8eda-2c36-11ec-3cdb-4104751a59ad
md"""

#### Solution: Flash Practice Problem

"""

# ╔═╡ c017ef4d-a828-4f46-922a-453d72636c39
md"""$(PlutoUI.LocalResource("./figs/Fig-VLE-Ideal-Pxy-P2-F19.png"))"""

# ╔═╡ d5b781d8-6e6a-4bc9-9b45-1272e1b86e61
md"""
a) What temperature $T$ (K) is the Flash drum operating at?

To find the temperature, we can solve the Antoine equation for $T$. 
As a reminder, the Antoine equation is given by (note this is the $\log_{10}$ version):

$$\begin{equation}
\log_{10}\left(P_{i}^{sat}~[\mathrm{bar}]\right) = A - \frac{B}{C+T[K]}
\end{equation}$$

where the Antoine parameters are given in the problem. We can solve for $T$ to get the expression:

$$T = - \left(C + \frac{B}{\log_{10}P^{sat}_{i} - A}\right)$$

We can choose _either_ pure component endpoints, let's choose pure component 1 which gives $P_{1}^{sat}\simeq$15.9 bar.
"""

# ╔═╡ e86e41b3-d39b-4986-b1cd-4ed34eaabae5
begin
	
	# what are the A, B, and C for component 1?
	A₁ = 4.45 		# units: AU
	B₁ = 718.1 		# units: 1/K
	C₁ = -22.01 	# units: K
	
	A₂ = 3.98 		# units: AU
	B₂ = 677.1 		# units: 1/K
	C₂ = -24.51 	# units: K
	
	P1sat = 15.9 	# units: bar
	P2sat = 7.5 	# units: bar
	P = 10.5 		# units: bar
	
	# esimate T -
	T = -(C₁ + B₁/(log10(P1sat) - A₁))
	
	with_terminal() do
		println("T = $(round(T; digits=2)) K")
	end
end

# ╔═╡ 796fd591-bf7f-4b94-af8f-f5b7ab25e563
md"""
b) Estimate the outlet composition and the mol flow rates for the input, liqud and vapor streams

The equlibrium compositions can be estimated directly from the _Pxy_ diagram: 

* The composition of the liquid stream exiting the drum $x^{eq}_{1}\simeq$ 0.34
* The composition of the vapor stream exiting the drum $y^{eq}_{1}\simeq$ 0.53

To estimate the mol flow rate of liquid and vapor that leaves the flash drum, we can use the lever rule and the species mol balance (as discussed in lecture and discussion). The Flash Lever Rule (FLR) is given as:

$$\frac{\dot{L}}{\dot{V}} = \frac{y^{eq}_{i} - z_{i}}{z_{i} - x_{i}^{eq}}$$

_Substitution_: We can re-arrange the FLR, to solve for $\dot{L}$ in terms of $\dot{V}$, and then subsutute that into the total mol balance to solve for $\dot{V}$:

$$\dot{V} = \dot{F}\left(\frac{b}{a} + 1\right)^{-1}$$ 
Once we have $\dot{V}$ we can then solve for $\dot{L}$. 

_Matrix-vector_: Alternatively, we could set this problem up in matrix vector form:

$$\begin{pmatrix}
1 & 1 \\
1 & -\frac{b}{a}
\end{pmatrix}
\begin{pmatrix}
\dot{L} \\
\dot{V}
\end{pmatrix} = 
\begin{pmatrix}
\dot{F} \\
0
\end{pmatrix}$$

and solve for $\dot{L}$ and $\dot{V}$ directly by inverting the 2$\times$2 matrix.

"""

# ╔═╡ 453aba4c-fc32-46a7-ad1c-0c360a5dc886
begin
	
	# from the diagram -
	y1_eq = 0.53
	x1_eq = 0.34
	z1 = 0.42
	F_dot = 10 # units: mol/t
	
	# compte b and a -
	b = (y1_eq - z1)
	a = (z1 - x1_eq)
	
	# setup Ax = b
	A = [1 1 ; 1 -(b/a)]
	b = [F_dot; 0];
	
	# solve for L_dot and V_dot -
	x_graph = inv(A)*b
	L_dot = x_graph[1]
	V_dot = x_graph[2]
	
	with_terminal() do 
		println("L_dot = $(round(L_dot; digits=1)) mol/t and V_dot = $(round(V_dot; digits=1)) mol/t")
	end
end

# ╔═╡ c4f4a653-cd23-4c9a-9b3d-10da27ca9d79
md"""
c) Numerical check on graphically values. If the pressure summation expression:

$$\begin{equation}
        \sum_{i=1}^{\mathcal{M}}z_{i}\left[\frac{P_{i}^{sat}}{P}\left(\frac{\dot{V}}{\dot{F}}\right)+\frac{\dot{L}}{\dot{F}}\right]^{-1} = 1
\end{equation}$$ 

is _significantly_ different than 1 (greater than $\pm$ 10% difference), please re-estimate your graphical values (show your work).
"""

# ╔═╡ 2c1378b9-08e3-42ef-9239-fd86fd85cd38
begin
	
	# we only have two terms, since we are binary
	term_1 = z1*((P1sat/P)*(V_dot/F_dot)+(L_dot/F_dot))^-1
	term_2 = (1-z1)*((P2sat/P)*(V_dot/F_dot)+(L_dot/F_dot))^-1
	test_value = (term_1 + term_2)
	frac_error = (1.0 - test_value)*100
	
	with_terminal() do
		println("Percentage diff: $(round(frac_error; digits=2))%")
	end
end

# ╔═╡ 91f257b4-b480-4179-b68a-760824600949
md"""

d) _Analytically_ check your graphical composition estimates by computing $x^{eq}_{1}$ and $y^{eq}_{1}$ using the your VLE model and mol balances.

Strategy:
* Solve for $P_{i}^{sat}$ using the estimated $T$ from part a)
* Solve for $x^{eq}_{1}$ using the pressure expression (then $x^{eq}_{2}$ = $1 - x^{eq}_{1}$).
* Solve for $y^{eq}_{1}$ using the VLE model: $y^{eq}_{1}P$ = $x^{eq}_{1}P_{1}^{sat}$. (and then $y^{eq}_{2}$ = $1 - y^{eq}_{1}$).
* Solve 2$\times$2 system for $\dot{L}$ and $\dot{V}$ (either 2 species balances, or 1 species balance and the total mol balance)

"""

# ╔═╡ f167be1a-2801-4cc6-b036-6d6688dddb44
begin
	
	# 1) compute the saturation pressures -
	P1sat_aeq = 10^(A₁ - (B₁/(C₁ + T)))
	P2sat_aeq = 10^(A₂ - (B₂/(C₂ + T)))
	
	with_terminal() do
		println("P1sat_aeq = $(round(P1sat_aeq; digits=2)) bar and P2sat_aeq = $(round(P2sat_aeq; digits=2)) bar")
	end
end

# ╔═╡ b8002941-f892-46b8-9c27-1cb08cc3c71b
begin
	
	# 2) estimate x1_eq from the pressure expression -
	x1_eq_a = (P - P2sat_aeq)/(P1sat_aeq - P2sat_aeq)
	x2_eq_a = 1 - x1_eq_a
	
	with_terminal() do
		println("x1_eq = $(round(x1_eq_a; digits=2)) and x2_eq = $(round(x2_eq_a; digits=2))")
	end
end

# ╔═╡ 52fba159-cafc-4293-ab32-6b965ca957b8
begin
	
	# 3) estimate y1_eq and y2_eq -
	y1_eq_a = (x1_eq_a)*(P1sat_aeq/P)
	y2_eq_a = 1 - y1_eq_a
	
	with_terminal() do
		println("y1_eq = $(round(y1_eq_a; digits=2)) and y2_eq = $(round(y2_eq_a; digits=2))")
	end
end

# ╔═╡ ed9fe0d8-0d9b-4ad2-b327-44d9798cc666
begin
	
	# 4) solve for the flow rates. We could do this as a traditional substitution, but lets be quick and setup as matrix vector 
	A_flow = [x1_eq_a y1_eq_a ; x2_eq_a y2_eq_a]
	b_flow = [F_dot*z1 ; F_dot*(1 - z1)]
	flow_vec = inv(A_flow)*b_flow
	
	# out -
	with_terminal() do
		println("L_dot = $(round(flow_vec[1]; digits=1)) mol/t and V_dot = $(round(flow_vec[2]; digits=1)) mol/t")
	end
end

# ╔═╡ dbfacc23-773b-49bb-a531-f460aacf5f98
html"""
<style>
main {
    max-width: 1200px;
    width: 90%;
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
</style>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─4abf8eda-2c36-11ec-3cdb-4104751a59ad
# ╟─c017ef4d-a828-4f46-922a-453d72636c39
# ╟─d5b781d8-6e6a-4bc9-9b45-1272e1b86e61
# ╠═e86e41b3-d39b-4986-b1cd-4ed34eaabae5
# ╟─796fd591-bf7f-4b94-af8f-f5b7ab25e563
# ╠═453aba4c-fc32-46a7-ad1c-0c360a5dc886
# ╟─c4f4a653-cd23-4c9a-9b3d-10da27ca9d79
# ╠═2c1378b9-08e3-42ef-9239-fd86fd85cd38
# ╟─91f257b4-b480-4179-b68a-760824600949
# ╠═f167be1a-2801-4cc6-b036-6d6688dddb44
# ╠═b8002941-f892-46b8-9c27-1cb08cc3c71b
# ╠═52fba159-cafc-4293-ab32-6b965ca957b8
# ╠═ed9fe0d8-0d9b-4ad2-b327-44d9798cc666
# ╟─dbfacc23-773b-49bb-a531-f460aacf5f98
# ╟─9d286b46-73ae-49f7-b834-791b9ef95420
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
