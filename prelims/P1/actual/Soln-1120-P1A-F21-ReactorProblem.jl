### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 828b5fdc-2f57-11ec-2ba2-bd6c394912fa
begin
	using PlutoUI
	using LinearAlgebra
	using PrettyTables
end

# ╔═╡ 8c65af87-71e1-45ed-a635-d97a6e6b7a3e
md"""$(PlutoUI.LocalResource("./figs/Fig-ReactorFilter-F21.png"))

__Fig 1: Reactor-Filter problem schematic.__ Starting material A is converted to product B by enzyme E in a well-mixed reactor with volume V. The reactor is well insulated. The output from the reactor is fed into a filtration unit that has no moving parts and is NOT well insulated."""

# ╔═╡ b56695f3-68c1-4b76-8cc8-bb57d7e34699
md"""
Consider the reaction/separation process shown in Fig 1.
    A starting material $A$ is converted to product $B$ by enzyme $E$ in a well-mixed and well-insulated reactor.
    Mixing is achieved in the reactor using a mechanical stirring device. 
    The enzyme $E$ is immobilized in the reactor (does not flow out), and is stable. Downstream of the reactor,
    a filtration device separates unreacted starting material $A$ from product $B$.
    The filtration unit has no moving parts, and is NOT well insulated. 

 __Assumptions:__
* the reactor and filtration units operate at steady-state; 
* neglect changes in the kinetic and potential energy in the systems and streams;
* the volume of the reactor is $V$ = 14 L;
* the density of the systems and streams is constant $\rho$ = 1.2 kg/L.

"""

# ╔═╡ 59a9a683-e2da-4690-9950-80e2bcedbb18
md"""

__Compute:__
* (a) Compute the missing values for the mol and volumetric flow rates if the specific reaction rate $\hat{r}_{1}$ = 6.0 mmol L$^{-1}$ min$^{-1}$.
* (b) Compute the missing mass flow rate values.
* (c) Compute the rate of work $\dot{W}_{sh}$ (kJ/min) required to keep the reactor well mixed.
* (d) Compute the rate of heat flow $\dot{Q}$ (kJ/min) into (or from) the filtration unit.
"""

# ╔═╡ f198f507-e5ca-4ec1-a2bd-648965f94780
md"""
##### a) Compute the missing mol and volumetric flow rates in the table.

###### Volumetric flow rates:
Let's start with the volumetric flow rates. You can compute the volumetic flow rate from the _total mass balance_ equation. At steady state, for _any process unit_ we know that:

$$\sum_{s}v_{s}\dot{m}_{s} = 0$$
However, we know that $\dot{m}_{s}$ = $\rho_{s}\dot{F}_{s}$, where $\rho_{s}$ denotes the density of stream $s$ (units: kg/L), and $\dot{F}_{s}$ denotes the volumetric flow rate for stream $s$ (units: L/min). Thus, we can re-write the total mass balance in terms of the volumetric flow rates:

$$\sum_{s}v_{s}\rho_{s}\dot{F}_{s} = 0$$
In this problem (from the assumptions) we have assumed that the density of all streams was the same (and constant) i.e., $\rho_{1}=\rho_{2}\dots\rho_{\mathcal{S}}\equiv\rho$ which means we can pull the density out of the sum, and divide by $\rho$ to give:

$$\sum_{s}v_{s}\dot{F}_{s} = 0$$

For the __reactor__ we have a single in and a single out, so $\dot{F}_{1}$ = $\dot{F}_{2}$. However, for the __filter__ we have a single in, but two exit streams, thus: $\dot{F}_{2} = \dot{F}_{3}+\dot{F}_{4}$
"""

# ╔═╡ 3e17b4fe-1025-471b-ba7e-f257d3f9ef0b
md"""
###### Mol flow rates:

To compute the missing mol flow rates, we start with the steady-state species mol balance equation (which is true for any process unit):

$$\sum_{s}v_{s}\dot{n}_{k,s}+\dot{n}_{gen,k} = 0$$

where $\dot{n}_{k,s}$ denotes the flow of mols of species $k$ in stream $s$, and
$\dot{n}_{gen,k}$ denotes the generation (reaction) terms for species $k$ that are occuring inside the process unit (system). Lastly, we known (in the absence of cells) that the generation (reaction) term(s) are given by:

$$\dot{n}_{gen,k} = \left(\sum_{r}\sigma_{kr}\hat{r}_{r}\right)V$$

where $\sigma_{kr}$ denotes the stoichiometric coefficient for species $k$ in reaction $r$, and $\hat{r}_{r}$ denotes the _specific reaction rate_ for reaction $r$ (units: mmol/min-L) and $V$ denotes volume (units: L). For this problem, we have a single reaction whose rate $\hat{r}_{1}$ which was given in the problem, the volume $V$ was given, and $\sigma_{11}$ = -1 and $\sigma_{21}$ = +1, where $A$ = 1 and $B$ = 2.

For the __reactor__, the species mol balances are given by:

$$\begin{eqnarray}
\dot{n}_{11} -\dot{n}_{12} -\hat{r}_{1}V &=& 0\\
\dot{n}_{21} -\dot{n}_{22} +\hat{r}_{1}V &=& 0\\
\end{eqnarray}$$

For the __filtration unit__, the species mol balances are given by:

$$\begin{eqnarray}
\dot{n}_{12} -\dot{n}_{13} - \dot{n}_{14} &=& 0\\
\dot{n}_{22} -\dot{n}_{23} - \dot{n}_{24} &=& 0\\
\end{eqnarray}$$
"""

# ╔═╡ 75e41abc-bf6b-42b6-a400-3e68b49e53a1
begin
	
	# data given in the problem setup -
	n11 = 100.0 	# units: mol/min
	n21 = 0.0 		# units: mol/min
	n14 = 14.0 		# units: mol/min
	n24 = 0.0 		# units: mol/min
	F1_dot = 10.0 	# units: L/min
	F3_dot = 4.0 	# units: L/min
	
	# reaction terms -
	r1_hat = 3.0    # units: mmol/min-L
	V = 14.0 		# units: L
	
	# show - 
	nothing 
end

# ╔═╡ 51cf0922-fa58-4335-9f34-ae033203f4df
# matrix vector around reactor and filtration -
begin
	
	# setup both units - unknowns: n12, n22, n13, n23, F2_dot and F4_dot -
	AT = [-1 0 0 0 0 0; 0 -1 0 0 0 0; 1 0 -1 0 0 0; 0 1 0 -1 0 0; 0 0 0 0 -1 0; 0 0 0 0 1 -1];
	bT = [-n11 + r1_hat*V ; -n21 - r1_hat*V ; n14 ; n24 ; -F1_dot ; F3_dot]
	x_dot = inv(AT)*bT
	n12 = x_dot[1]
	n22 = x_dot[2]
	n13 = x_dot[3]
	n23 = x_dot[4]
	F2_dot = x_dot[5]
	F4_dot = x_dot[6]
	
	# show -
	nothing
end

# ╔═╡ 99d53a10-dc5e-43ae-8095-4ef594f9c420
begin
	# put all the data into a table, so we can display the solution using the PrettyTable.j package -
	data_table = zeros(4,4)
	
	# row 1 -
	data_table[1,1] = 1
	data_table[1,2] = n11
	data_table[1,3] = n21
	data_table[1,4] = F1_dot
	
	# row 2 -
	data_table[2,1] = 2
	data_table[2,2] = n12
	data_table[2,3] = n22
	data_table[2,4] = F2_dot
	
	# row 3 -
	data_table[3,1] = 3
	data_table[3,2] = n13
	data_table[3,3] = n23
	data_table[3,4] = F3_dot
	
	# row 4 -
	data_table[4,1] = 4
	data_table[4,2] = n14
	data_table[4,3] = n24
	data_table[4,4] = F4_dot
	
	
	with_terminal() do
		
		# setup the table -
		header_row = (["Stream","n1,i","n2,i","Vol Flow Rate"],["","[mmol/min]","[mmol/min]","[L/min]"]);
		
		# write the table -
		pretty_table(data_table; header=header_row)
	end
end

# ╔═╡ ccee2491-9a2e-45d2-a607-f27b54ad66ae
md"""
###### b) Compute the missing mass flow rates in the table.

To compute the missing mass flow rates, we apply a total mass balance to each process unit. At steady-state we know that:

$$\sum_{s}v_{s}\dot{m}_{s} = 0$$

For the __reactor__ we have a single in (given) and a single out, thus: $\dot{m}_{1}=\dot{m}_{2}$. However, for the filter we have a single in $\dot{m}_{2}$ but two output streams $\dot{m}_{3}$ and $\dot{m}_{4}$, thus:

$$\dot{m}_{2} = \dot{m}_{3} + \dot{m}_{4}$$

"""

# ╔═╡ c3967197-6c0c-4f7f-ac02-20a95ba921ca
begin
	
	# setup problem -
	m1_dot = 12.0 	# units: kg/min
	m3_dot = 4.8 	# units: kg/min
	
	# reactor -
	m2_dot = m1_dot
	
	# filter -
	m4_dot = m2_dot - m3_dot
	
	# show -
	nothing
end

# ╔═╡ 230abf7b-db83-49b9-a0d0-124aa2b328e5
begin
	
	# initialize -
	mass_data_table = zeros(4,4)
	
	# row 1
	mass_data_table[1,1] = 1
	mass_data_table[1,2] = 1.2
	mass_data_table[1,3] = m1_dot
	mass_data_table[1,4] = 120.9

	# row 2
	mass_data_table[2,1] = 2
	mass_data_table[2,2] = 1.2
	mass_data_table[2,3] = m2_dot
	mass_data_table[2,4] = 200.9

	# row 3
	mass_data_table[3,1] = 3
	mass_data_table[3,2] = 1.2
	mass_data_table[3,3] = m3_dot
	mass_data_table[3,4] = 125.0

	# row 3
	mass_data_table[4,1] = 4
	mass_data_table[4,2] = 1.2
	mass_data_table[4,3] = m4_dot
	mass_data_table[4,4] = 260.0
	
	with_terminal() do 
		
		# setup the table -
		mass_header_row = (["Stream","density","mdot_i","H"],["","[kg/L]","[kg/min]","[kJ/kg]"]);
		
		# write the table -
		pretty_table(mass_data_table; header=mass_header_row)
		
	end
end

# ╔═╡ 00a50f4a-838e-4f5a-b01d-0a754ca5a256
md"""
###### c) Compute the rate of work $\dot{W}_{sh}$ (kJ/min) required to keep the reactor well mixed.

To compute the rate of work, we start from the steady-state open energy balance equation:

$$\dot{Q}+\dot{W}_{sh}+\sum_{s}v_{s}\dot{m}_{s}H_{s} = 0$$

and throw out (or simplify) terms that don't apply to reactor process unit. First, 
for the reactor we have a single input and a single output, thus $\dot{m}_{1}=\dot{m}_{2}$. Next, the reactor is well-insulated, thus, we know that $\dot{Q}$ = 0. Putting these ideas together gives:

$$\dot{W}_{sh} + \dot{m}_{1}\left(H_{1}-H_{2}\right) = 0$$ or (after we solve for work):

$$\dot{W}_{sh} = \dot{m}_{1}\left(H_{2}-H_{1}\right)$$.
"""

# ╔═╡ 1f41d0db-abb1-48c6-8651-655ba4f73686
begin
	# alias the H's
	H₁ = mass_data_table[1,4];
	H₂ = mass_data_table[2,4];
	H₃ = mass_data_table[3,4];
	H₄ = mass_data_table[4,4];
	
	# compute the ΔH -
	ΔH = (H₂ - H₁)
	
	# compute the work -
	W = m1_dot*ΔH
end

# ╔═╡ ddaabaaa-f1dd-4853-9412-f7972dc4dc6d
md"""
###### d) Compute the rate of heat flow $\dot{Q}$ (kJ/min) into (or from) the filtration unit.

To compute the rate of heat transfer, we start from the steady-state open energy balance equation:

$$\dot{Q}+\dot{W}_{sh}+\sum_{s}v_{s}\dot{m}_{s}H_{s} = 0$$

and throw out (or simplify) terms that don't apply to filtration process unit.
First, the filtration unit has no moving parts, thus, the rate of shaft work $\dot{W}_{sh}$. However, unlike the reactor, we have a single input but multiple outputs, thus, the energy balance for the filtration unit is given by:

$$\dot{Q} + \dot{m}_{2}H_{2} - \dot{m}_{3}H_{3} - \dot{m}_{4}H_{4} = 0$$

All the enthalpies were given in the problem, and we know the $\dot{m}_{s}$ from part b). To compute $\dot{Q}$:

$$\dot{Q} = \dot{m}_{3}H_{3} + \dot{m}_{4}H_{4} - \dot{m}_{2}H_{2}$$

"""

# ╔═╡ 8196a83d-b705-479a-b8fd-551f1ef95bd3
begin
	# compute the Qdot -
	Q_dot = m3_dot*H₃ + m4_dot*H₄ - m2_dot*H₂
end

# ╔═╡ db72171c-3964-4992-8d00-c9f8217a829d
html"""
<style>
main {
    max-width: 1200px;
    width: 95%;
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
PlutoUI = "~0.7.16"
PrettyTables = "~1.2.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

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

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "98f59ff3639b3d9485a03a72f3ab35bab9465720"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.6"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "69fd065725ee69950f3f58eceb6d144ce32d627d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.2"

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

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

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
# ╟─8c65af87-71e1-45ed-a635-d97a6e6b7a3e
# ╟─b56695f3-68c1-4b76-8cc8-bb57d7e34699
# ╟─59a9a683-e2da-4690-9950-80e2bcedbb18
# ╟─f198f507-e5ca-4ec1-a2bd-648965f94780
# ╟─3e17b4fe-1025-471b-ba7e-f257d3f9ef0b
# ╠═75e41abc-bf6b-42b6-a400-3e68b49e53a1
# ╠═99d53a10-dc5e-43ae-8095-4ef594f9c420
# ╟─51cf0922-fa58-4335-9f34-ae033203f4df
# ╟─ccee2491-9a2e-45d2-a607-f27b54ad66ae
# ╠═c3967197-6c0c-4f7f-ac02-20a95ba921ca
# ╟─230abf7b-db83-49b9-a0d0-124aa2b328e5
# ╟─00a50f4a-838e-4f5a-b01d-0a754ca5a256
# ╠═1f41d0db-abb1-48c6-8651-655ba4f73686
# ╟─ddaabaaa-f1dd-4853-9412-f7972dc4dc6d
# ╠═8196a83d-b705-479a-b8fd-551f1ef95bd3
# ╠═828b5fdc-2f57-11ec-2ba2-bd6c394912fa
# ╟─db72171c-3964-4992-8d00-c9f8217a829d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
