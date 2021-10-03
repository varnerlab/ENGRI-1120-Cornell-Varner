### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 50a16b1b-f79f-43ad-a5b4-71c99afba8ca
# julia stuff -
using PlutoUI

# ╔═╡ 26a6730a-21dd-11ec-3bbc-430e71b09495
md"""

#### Analysis of the Throttle Valve in the Vapor Compression Refrigeration Cycle (VCRC)

The throttle valve is used in the VCRC to convert a high-pressure saturated liquid stream to a vapor liquid mixture at lower pressure that is then fed into the evaporator. The throttle value is an _irreversible_ adiabatic operation.

Saturated T-508B enters into a throttle value at P$_{1}$ = 0.8 MPa (operating point $\mathcal{O}_{1}$) and exits at P$_{2}$ = 0.1 MPa (operating point $\mathcal{O}_{2}$). The mass flow rate of R-508B is $\dot{m}$ = 10 kg/s. The throttle value operates at steady-state. 

Compute the following using enthalpy, entropy and R-508B pressure-enthalpy diagram:

1. The temperatures at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$
1. The enthapy values at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$, and the difference across the throttle valve
1. The entropy values at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$, and the difference across the throttle value
1. Is there entropy generation between $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$? If so, can we compute $\dot{S}_{G}$?
1. What is the _quality_ of the outlet of the throttle valve?

"""

# ╔═╡ 3e2e945e-f5ee-4e28-87db-681e33726cb8
mdot = 10.0 	# units: kg/s

# ╔═╡ effcdabc-95ce-4a6c-8f47-b9b59c2d08b7
md"""
##### Pressure-Enthaplpy diagram for E-508B
"""

# ╔═╡ ed264b61-aca9-42b3-ab2e-0ba94fd26e30
PlutoUI.LocalResource("./figs/Fig-PH-508B-F1.png")

# ╔═╡ 52557b82-e273-478c-8572-115f90a24062
md"""

##### Lookup: The temperatures at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$

We can lookup the temperatures at each operating point from the R-508B PH diagram. 
"""

# ╔═╡ cb43d69c-abbc-45af-8775-3be12f0da20a
# Temperatures from the PH diagram
begin
	
	T₁ = -41.0 # units C (orange T)
	T₂ = -89.0 # units C (blue T)
	
	# return -
	(T₁,T₂)
end

# ╔═╡ ee496dc4-c9dc-46ee-bbae-49b41602626a
md"""

##### Compute: The _enthapy_ values at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$, and the difference across the throttle valve

Throttle valves are _isoenthalpic_ i.e., there is no _enthaply_ change across the valve. To see this, let's start with the steady-state open energy balance:

$$\dot{Q}+\dot{W}_{sh}+\dot{W}_{b}+\sum_{s=1}^{\mathcal{S}}v_{s}\dot{m}_{s}H_{s} = 0$$

There is a single input, and a single output so we can show from the total mass balance that $\dot{m}_{1}=\dot{m}_{2}\equiv\dot{m}$. Next, a throttle valve is _adiabatic_, thus, $\dot{Q}$ = 0. Finally, there are no moving parts in a throttle valve and the system is at steady-state so there is no time-dependent boundary expansion or shart work terms i.e., $\dot{W}_{b}$ = 0 and $\dot{W}_{sh}$ = 0. Putting all these toget gives the energy balance:

$$\dot{m}\left(\sum_{s=1}^{\mathcal{S}}v_{s}H_{s}\right) = 0$$

Since $\dot{m}\neq{0}$, the summation term must be zero, or $H_{1}=H_{2}$.

"""

# ╔═╡ 67efc9e2-8edc-4551-b49d-c787c920230d
# Enthalpy from the PH-diagram
begin
	H₁ = 140.0 		# units: kJ/kg
	H₂ = 140.0 		# units: kJ/kg
	ΔH = H₂ - H₁ 	# units: kJ/kg
	
	# return -
	(H₁,H₂, ΔH)
end

# ╔═╡ 2990c0d2-b160-4b7b-9821-36cf744440a0
md"""

##### Compute: The _entropy_ values at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$, and the difference across the throttle valve. Is there entropy generation?

Yes, there will be an entropy difference between $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$ (and entropy generation) because throttle values are _irreversible_. We can lookup the entropy values at $\mathcal{O}_{1}$ and $\mathcal{O}_{2}$ and use the open second law (entropy balance) to compute the rate of entropy generation $\dot{S}_{G}$.

"""

# ╔═╡ d6960e86-cb59-4a9f-81cb-a3a54ae272f1
# Entropy values from the PH-diagram
begin
	S₁ = (0.75 + 0.8)/2 # units: kJ/kg-K
	S₂ = 0.8 			# units: kJ/kg-K
	ΔS = (S₂ - S₁)		# units: kJ/kg-G
	
	# return -
	(S₁,S₂, ΔS)
end

# ╔═╡ c301e469-9bca-475e-8e0d-101d0214ba0c
md"""
###### Compute the rate of entropy generation $\dot{S}_{G}$

Start from the open second law (entropy balance):

$$-\left(\sum_{s=1}^{\mathcal{S}}v_{s}\dot{m}_{s}S_{s}+\frac{\dot{Q}}{T_{\sigma}}\right) = \dot{S}_{G}$$

There is a single input, and a single output so we can show from the total mass balance that $\dot{m}_{1}=\dot{m}_{2}\equiv\dot{m}$. 
Next, a throttle valve is _adiabatic_, thus, $\dot{Q}$ = 0. Finally, we have an expression for the rate of entropy generation:

$$-\dot{m}\left(\sum_{s=1}^{\mathcal{S}}v_{s}S_{s}\right) = \dot{S}_{G}$$

or (after running the summation out):

$$\dot{m}\left(S_{2} - S_{1}\right) = \dot{S}_{G}$$

"""

# ╔═╡ 5c72e8ac-24d0-4212-b3e8-b20a9c5c0171
# compute the rate of entropy generation -
S_dot_gen = mdot*(S₂ - S₁)	# units: kJ/s-K -or- W/K

# ╔═╡ d1de9861-f6a0-487c-9ef7-35fd3f1b6a68
md"""
#### Compute: what is the quality of the stream exiting the throttle valve?

The term _quality_ (denoted by $\theta$) in this context (or in the context of the Rankine cycle) refers to the fraction of vapor in the stream. To compute this, let's start with the expression for the entropy $S_\star$ which is valid for operating point $\star$ under the saturation dome (at some constant T):

$$S_{\star} = \theta_\star{S}_{v}+\left(1-\theta_\star\right)S_{l}$$

where $S_{v}$ denotes the entropy of a saturated vapor at T, $S_{l}$ denotes the entropy of a saturated liquid at T, and $\theta_\star$ denotes the quality of operating point $\star$ at T. We can lookup values for $S_{v}$ and $S_{l}$ as a function of T from the PH-diagram (or the associated saturation tables). 

To comput $\theta_\star$ we can rearrange the expression above to give:

$$\theta_\star = \frac{S_{\star}- S_{l}}{S_{v} - S_{l}}$$

"""

# ╔═╡ 96bfd2aa-0ffc-4ed5-be20-1f3ca8bb88bb
begin
	
	# Lookup from the R-508B saturation table for T = -89C
	Sₗ = 0.5232 # units: kJ/kg-K
	Sᵥ = 1.4124 # units: kJ/kg-K
	
	# return -
	nothing
end

# ╔═╡ a80a7162-8aee-4a54-9199-bf2e5a0a0769
θ = (S₂ - Sₗ)/(Sᵥ - Sₗ)

# ╔═╡ 8f92b67f-555a-4797-b8fb-3bea29951f25
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
PlutoUI = "~0.7.14"
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
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "d1fb76655a95bf6ea4348d7197b22e889a4375f4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.14"

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
# ╠═50a16b1b-f79f-43ad-a5b4-71c99afba8ca
# ╟─26a6730a-21dd-11ec-3bbc-430e71b09495
# ╠═3e2e945e-f5ee-4e28-87db-681e33726cb8
# ╟─effcdabc-95ce-4a6c-8f47-b9b59c2d08b7
# ╠═ed264b61-aca9-42b3-ab2e-0ba94fd26e30
# ╟─52557b82-e273-478c-8572-115f90a24062
# ╠═cb43d69c-abbc-45af-8775-3be12f0da20a
# ╟─ee496dc4-c9dc-46ee-bbae-49b41602626a
# ╠═67efc9e2-8edc-4551-b49d-c787c920230d
# ╟─2990c0d2-b160-4b7b-9821-36cf744440a0
# ╠═d6960e86-cb59-4a9f-81cb-a3a54ae272f1
# ╟─c301e469-9bca-475e-8e0d-101d0214ba0c
# ╠═5c72e8ac-24d0-4212-b3e8-b20a9c5c0171
# ╟─d1de9861-f6a0-487c-9ef7-35fd3f1b6a68
# ╠═96bfd2aa-0ffc-4ed5-be20-1f3ca8bb88bb
# ╠═a80a7162-8aee-4a54-9199-bf2e5a0a0769
# ╟─8f92b67f-555a-4797-b8fb-3bea29951f25
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
