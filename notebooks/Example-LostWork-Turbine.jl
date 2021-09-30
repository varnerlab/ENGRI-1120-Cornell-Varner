### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ bb6a9f88-2134-11ec-3337-2bdd2c6747a9
begin
	using PlutoUI
end

# ╔═╡ 7a46f79a-c4f4-4cea-8187-839337a9c962
PlutoUI.LocalResource("./figs/Rankine.png")

# ╔═╡ 88b9e9f5-f1ed-4146-a63d-f941be18c559
md"""

#### Example: Compute the steady-state rate of shaft work $\dot{W}_{sh}$

Compute the steady-state rate of shaft work $\dot{W}_{sh}$ (units: kW), and the irreversible enthlapy change from an insulated turbine with efficiency of $\eta$ =86\%. The working fluid is water with a steady-state flow rate of $\dot{m}$ = 4.0 kg/s. Let the input temperature 
T$_{2}$ = 500$^{\circ}$C and pressure P$_{2}$ = 11 MPa. The temperature of the exit stream from the turbine T$_{3}$ = 100$^{\circ}$C.

"""

# ╔═╡ 5cf4b776-e31a-48c3-be81-1d7517e9db8b
md"""
#### Approach

The steady-state open first law (energy balance) relates the heat, work and enthalpy for the system:

$$\dot{Q}+\dot{W}^{*}_{sh} + \sum_{s}^{\mathcal{S}}v_{s}\dot{m}_{s}H_{s} = 0$$

where $\dot{W}^{*}_{sh}$ denotes the rate of _actual_ shaft work recovered from the turbine. If the turbine is operating _reversibly_ then the rate of shaft work that we actually recover is equal to the theoretical maximum shaft work. Howver, in this problem, we know that the turbine is not operating reversibly, thus we use $\dot{W}^{*}_{sh}$.

Let's begin by throwing out terms in the open energy balance, and solving for the rate of shaft work $\dot{W}^{*}_{sh}$. The problem says the turbine is insulated, thus $\dot{Q}$ = 0. Second, we know that $\mathcal{S}$ = 2, and that the mass flow rate into the turbine $\dot{m}_{2}=\dot{m}_{3}\equiv{\dot{m}}$. Solving for the rate of shaft work gives the expression:

$$\dot{W}^{*}_{sh} = \dot{m}\left(H_{3} - H_{2}\right)_{I}$$

where the $\left(\star\right)_{I}$ terms denotes the enthalpy difference for the _actual irreversible_ process. However, we do not know what the _actual irreversible_ enthalpy difference is, but we do know:

* the turbine efficiency and
* that a reversible adiabatic process is _constant entropy_. 

##### How can we compute $\left(\star\right)_{I}$?

The turbine efficiency is given by:

$$\eta_{T} = \frac{\Delta{H}_{I}}{\Delta{H}_{R}}$$

where $\Delta{H}_{R}$ denotes the enthalpy difference for a _reversible_ process. Using the efficiency expression gives us a method to compute 
$\Delta{H}_{I}$, the _irreversible_ enthalpy difference:

$$\Delta{H}_{I} = \eta_{T}\Delta{H}_{R}$$

which we can substitute into the expression for work to give:

$$\dot{W}^{*}_{sh} = \dot{m}\eta_{T}\left(H_{3} - H_{2}\right)_{R}$$

"""

# ╔═╡ 75376d0d-c4eb-4bc5-a58b-752187aae593
md"""

##### Estimate $\Delta{H}_{R}$ from the Pressure-Enthalpy (PH) diagram 

"""

# ╔═╡ c0d0a66d-4651-4317-9e08-c16ffa290a68
PlutoUI.LocalResource("./figs/PH-diagram-Water-OPs.png")

# ╔═╡ e449301c-c198-4506-9512-02da59cac3f1
md"""
##### Estimate $\Delta{H}_{I}$ and visualize enthalpy difference on a PH-diagram
"""

# ╔═╡ b7ddbd1a-de34-4cd1-ae89-e0c70f3e6c7e
begin
	
	# Data from the problem and the PH-diagram -
	mdot = 4.0 	# units: kg/s
	H₂ = 3400  	# units: kJ/kg
	H₃= 2400  	# units: kJ/kg
	ηₜ = 0.86;	# units: dimensionless
	
	# return -
	nothing
end

# ╔═╡ 571973ba-b1a3-4698-a02a-c8f84337d512
# What is the work recovered from the turbine?
Wdot = ηₜ*(mdot*(H₃ - H₂))

# ╔═╡ 5f4dff5a-5a4c-4948-82df-161e27456578
PlutoUI.LocalResource("./figs/PH-diagram-Water-OPs-IRR.png")

# ╔═╡ db4037dd-d4a3-42a3-a357-2540972294bd
# What is the irreversible enthlapy change?
ΔH_I = ηₜ*(H₃-H₂)

# ╔═╡ c285ccd0-bf5c-423f-9577-361ff21f29ad
md"""
##### What is the rate of entropy generation $\dot{S}_{G}$?

The open second law (entropy balance) at steady-state (with a single heat-transfer surface) is given by:

$$-\left(\sum_{s}^{\mathcal{S}}v_{s}\dot{m}_{s}S_{s} + \frac{\dot{Q}}{T_{\sigma}}\right) = \dot{S}_{G}\geq{0}$$

The turbine is adiabatic, thus $\dot{Q}$ = 0, is operating at steady-state, and we has a single input and output (meaning $\dot{m}_{2}=\dot{m}_{3}\equiv{\dot{m}}$). Putting these ideas together, and throwing out terms in the open entropy balance gives an 
expression for the raye of entropy generation:

$$-\dot{m}\left(S_{2} - S_{3}\right) = \dot{S}_{G}$$

"""

# ╔═╡ 988ab1b3-a5e5-40df-abc5-c36c9d6cf9b9
begin
	# lookup entropy values from the PH diagram -
	S₂ = 6.5 	# units: kJ/kg-K
	S₃ = 7.0 	# units: kJ/kg-K
end

# ╔═╡ c787d47d-7a06-4603-8a12-cdaec354374e
# compute SG -
SG_dot = -1*mdot*(S₂-S₃)

# ╔═╡ bb9d6c95-1391-489c-8c00-d5f27ac832d2
md"""
##### What is the rate of lost work $\dot{W}_{lost}$?
From the drivation in the lectire notes, we know that the rate of lost work $\dot{W}_{lost}$ is given by:

$$\dot{W}_{lost} = \left(\eta_{T} - 1\right)\dot{W}_{sh}$$

However, $\dot{W}_{sh}$ is given by:

$$\dot{W}_{sh} = \dot{m}\Delta{H}_{R}$$

Substituting $\dot{W}_{sh}$ into the lost work expression gives:

$$\dot{W}_{lost} = \left(\eta_{T} - 1\right) \dot{m}\Delta{H}_{R}$$

"""

# ╔═╡ db18c3bf-15b3-47c9-be0b-1f543e07fc19
# compute the reversible (ideal) enthalpy change -
ΔH_R = H₃ - H₂

# ╔═╡ 3fc1d446-16dd-479e-bc80-03df6804f557
W_dot_lost = (ηₜ - 1)*ΔH_R

# ╔═╡ e4681733-6926-44a9-9eea-ace0f74b797d
html"""<style>
main {
    max-width: 1200px;
  	width: 80%;
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
PlutoUI = "~0.7.12"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

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
git-tree-sha1 = "9d8c00ef7a8d110787ff6f170579846f776133a9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "f35ae11e070dbf123d5a6f54cbda45818d765ad2"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.12"

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

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═bb6a9f88-2134-11ec-3337-2bdd2c6747a9
# ╟─7a46f79a-c4f4-4cea-8187-839337a9c962
# ╟─88b9e9f5-f1ed-4146-a63d-f941be18c559
# ╟─5cf4b776-e31a-48c3-be81-1d7517e9db8b
# ╟─75376d0d-c4eb-4bc5-a58b-752187aae593
# ╟─c0d0a66d-4651-4317-9e08-c16ffa290a68
# ╟─e449301c-c198-4506-9512-02da59cac3f1
# ╠═b7ddbd1a-de34-4cd1-ae89-e0c70f3e6c7e
# ╠═571973ba-b1a3-4698-a02a-c8f84337d512
# ╟─5f4dff5a-5a4c-4948-82df-161e27456578
# ╠═db4037dd-d4a3-42a3-a357-2540972294bd
# ╟─c285ccd0-bf5c-423f-9577-361ff21f29ad
# ╠═988ab1b3-a5e5-40df-abc5-c36c9d6cf9b9
# ╠═c787d47d-7a06-4603-8a12-cdaec354374e
# ╟─bb9d6c95-1391-489c-8c00-d5f27ac832d2
# ╠═db18c3bf-15b3-47c9-be0b-1f543e07fc19
# ╠═3fc1d446-16dd-479e-bc80-03df6804f557
# ╟─e4681733-6926-44a9-9eea-ace0f74b797d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
