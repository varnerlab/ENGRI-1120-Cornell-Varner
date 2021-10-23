### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ 2b00f9f2-53f3-4525-a3e4-708109259b6c
# Julia environment -
begin
	using PlutoUI
	using PrettyTables
end

# ╔═╡ c7822c42-2f57-11ec-3b48-2b2ea80c6f23
md"""$(PlutoUI.LocalResource("./figs/Fig-ModRankine-Heat-Recycle-F20.png"))
__Fig 1.__ Schematic of the unit operations of a modified organic Rankine cycle in which α percent of the heat from the condenser is recycled to the boiler through a heat exchanger."""

# ╔═╡ 796a9adb-7573-4ec1-881f-ab39d98032ae
md"""
The Organic Rankine Cycle (ORC) is an _open_ four step thermodynamic process used to generate power that uses organic compounds as working fluids (Fig. 1). In the cycle, path $\mathcal{P}_{ij}$ connects operating point $\mathcal{O}_{i}$ to $\mathcal{O}_{j}$:


* Path $\mathcal{P}_{12}$: $\left(1~\rightarrow~2\right)$: _isobaric_ heating in a boiler from operating point $\mathcal{O}_{1}$ to $\mathcal{O}_{2}$
* Path $\mathcal{P}_{23}$: $\left(2~\rightarrow~3\right)$: _adiabatic_ expansion in a turbine from operating point $\mathcal{O}_{2}$ to $\mathcal{O}_{3}$
* Path $\mathcal{P}_{34}$: $\left(3~\rightarrow~4\right)$: _isobaric_ cooling in a condenser from operating point $\mathcal{O}_{3}$ to $\mathcal{O}_{4}$
* Path $\mathcal{P}_{41}$: $\left(4~\rightarrow~1\right)$: _adiabatic_ compression in a pump from operating point $\mathcal{O}_{4}$ to $\mathcal{O}_{1}$


"""

# ╔═╡ d65087c7-1b55-4aeb-bda6-fd4039b64863
md"""

__Assumptions:__

* (i) the cycle operates at steady-state; 
* (ii) the working fluid R-508B (Suva 95) has a mass flow rate of $\dot{m}$ = 1.25 kg s$^{-1}$;
* (iii) the turbine efficiency is $\eta_{T}$ = 70\%; 
* (iv) _neglect_ the enthalpy and temperature change from the pump (assume T$_{4}\simeq$~T$_{1}$ and H$_{4}\simeq$~H$_{1}$);
* (v) neglect changes in the kinetic and potential energy in the system and streams.
    
"""

# ╔═╡ 1d0dbac8-8a12-4ba0-862b-e7a2860e2b6e
md"""
###### Example State Table for the Mod Rankine Problem
You get the $H$, $S$, $T$ and $P$ values from the problem statement, and from the working fluid PH-diagram (or data sheets). When completing the state table, always assume _unless explicitly asked otherwise_ reversibility for turbine.
"""

# ╔═╡ f561e6bd-63d0-43db-9bcb-5135afdfe7d4
begin

# 	# Version: δ
# 	# setup the state table -
# 	state_table_data_array = zeros(4,5)
	
# 	# setup each row -
# 	# row 1:
# 	state_table_data_array[1,1] = -100.0
# 	state_table_data_array[1,2] = 2200.0
# 	state_table_data_array[1,3] = 78.1
# 	state_table_data_array[1,4] = 0.4716
# 	state_table_data_array[1,5] = 0.0
	
# 	# row 2:
# 	state_table_data_array[2,1] = 20.0
# 	state_table_data_array[2,2] = 2200.0
# 	state_table_data_array[2,3] = 307.2
# 	state_table_data_array[2,4] = 1.4038
# 	state_table_data_array[2,5] = 1.0
	
# 	# row 3:
# 	state_table_data_array[3,1] = -100.0
# 	state_table_data_array[3,2] = 48.0
# 	state_table_data_array[3,3] = 240.3
# 	state_table_data_array[3,4] = 1.4038
# 	state_table_data_array[3,5] = 0.97
	
# 	# row 4:
# 	state_table_data_array[4,1] = -100.0
# 	state_table_data_array[4,2] = 48.0
# 	state_table_data_array[4,3] = 78.1
# 	state_table_data_array[4,4] = 0.4716
# 	state_table_data_array[4,5] = 0.0
	
	# show -
	nothing 
end

# ╔═╡ 2cef6853-6624-428a-81c4-4e8fdb8727f7
begin
	
	# Version: γ (don't forget to change mdot, ηₜ and α)
	
	# setup the state table -
	state_table_data_array = zeros(4,5)
	
	# setup each row -
	# row 1:
	state_table_data_array[1,1] = -90.0
	state_table_data_array[1,2] = 2200.0
	state_table_data_array[1,3] = 86.8
	state_table_data_array[1,4] = 0.5184
	state_table_data_array[1,5] = 0.0
	
	# row 2:
	state_table_data_array[2,1] = 20.0
	state_table_data_array[2,2] = 2200.0
	state_table_data_array[2,3] = 307.2
	state_table_data_array[2,4] = 1.4038
	state_table_data_array[2,5] = 1.0
	
	# row 3:
	state_table_data_array[3,1] = -90.0
	state_table_data_array[3,2] = 90.0
	state_table_data_array[3,3] = 249.
	state_table_data_array[3,4] = 1.4038
	state_table_data_array[3,5] = 0.99
	
	# row 4:
	state_table_data_array[4,1] = -90.0
	state_table_data_array[4,2] = 90.0
	state_table_data_array[4,3] = 86.8
	state_table_data_array[4,4] = 0.5184
	state_table_data_array[4,5] = 0.0
	
	# show -
	nothing 
end

# ╔═╡ 50bcce4a-981b-4b70-9fa6-98ad9f7b39e4
with_terminal() do
	
	# header row -
	state_table_header_row = (["T","P","H","S","θ"],["°C","kPa","kJ/kg","kJ/kg-K","dimensionless"]);

	# write the table -
	pretty_table(state_table_data_array; header=state_table_header_row)
end

# ╔═╡ d2bd39f1-8d81-404d-bea6-70ea8e19cea1
# do this computation in matrix - vector form
begin

	# setup process connectivity array A - change for γ and δ
	m_dot = 1.5 	# units: kg/s
	ηₜ = 0.75 		# units: dimensionless
	A = [-m_dot m_dot 0; 0 -m_dot m_dot ; m_dot 0 -m_dot];
	
	# get the H's
	H₁ = state_table_data_array[1,3] # units: kJ/kg
	H₂ = state_table_data_array[2,3] # units: kJ/kg
	H₃ = state_table_data_array[3,3] # units: kJ/kg
	H₄ = state_table_data_array[4,3] # units: kJ/kg
	H_vec = [H₁ ; H₂ ; H₃]; 
	
	# compute the RHS -
	bV = A*H_vec	
end

# ╔═╡ 37101508-f1a7-42ed-b446-a9b21001c7b0
with_terminal() do
	
	# path table -
	path_table_data_array = zeros(5,3)
	
	# values -
	# row 1:
	path_table_data_array[1,1] = bV[1]
	path_table_data_array[1,2] = 0.0
	path_table_data_array[1,3] = 0.0
	
	# row 2:
	path_table_data_array[2,1] = 0.0
	path_table_data_array[2,2] = bV[2]
	path_table_data_array[2,3] = (ηₜ)*bV[2]
	
	# row 3:
	path_table_data_array[3,1] = bV[3]
	path_table_data_array[3,2] = 0.0
	path_table_data_array[3,3] = 0.0
	
	# row 4:
	path_table_data_array[4,1] = 0.0
	path_table_data_array[4,2] = 0.0
	path_table_data_array[4,3] = 0.0
	
	# row 5:
	path_table_data_array[5,1] = bV[1]+bV[3]
	path_table_data_array[5,2] = bV[2]
	path_table_data_array[5,3] = 0.0
	
	# header row -
	path_table_header_row = (["Qdot","Wdot (ideal)","Wdot (actual)"],["kJ/s","kJ/s","kJ/s"]);

	# write the table -
	pretty_table(path_table_data_array; header=path_table_header_row)
end

# ╔═╡ eab84d4f-1a60-478e-9d3e-92d1b466e142
md"""
###### Efficiency w/no heat recycle
"""

# ╔═╡ c6eca5d9-48b9-48bf-9bfa-de7359549e00
eff_no_recyle = -1*(bV[2])/(bV[1])

# ╔═╡ b7153ddf-b153-4b9c-9fea-aab1fe30471d
md"""
###### Efficiency w/heat recycle
"""

# ╔═╡ ac0f2a28-a8aa-4031-b69c-71e8f6047574
begin
	
	# what is the fraction of heat that we are going to recycle?
	α = 0.10
	
	# What is the amount of recycled heat -
	Q_dot_recycled = α*abs(bV[3])
	
	# what is the new amount of heat put into the boiler?
	Q_dot_new = bV[1] - Q_dot_recycled
	
	# compute new efficiency -
	eff_recyle = -1*(bV[2])/(Q_dot_new)
end

# ╔═╡ 15dbf654-25cc-43e5-8526-d3e62ca3271a
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
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
PlutoUI = "~0.7.16"
PrettyTables = "~1.2.3"
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
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

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
# ╟─c7822c42-2f57-11ec-3b48-2b2ea80c6f23
# ╟─796a9adb-7573-4ec1-881f-ab39d98032ae
# ╟─d65087c7-1b55-4aeb-bda6-fd4039b64863
# ╟─1d0dbac8-8a12-4ba0-862b-e7a2860e2b6e
# ╠═f561e6bd-63d0-43db-9bcb-5135afdfe7d4
# ╠═2cef6853-6624-428a-81c4-4e8fdb8727f7
# ╠═50bcce4a-981b-4b70-9fa6-98ad9f7b39e4
# ╠═d2bd39f1-8d81-404d-bea6-70ea8e19cea1
# ╠═37101508-f1a7-42ed-b446-a9b21001c7b0
# ╟─eab84d4f-1a60-478e-9d3e-92d1b466e142
# ╠═c6eca5d9-48b9-48bf-9bfa-de7359549e00
# ╟─b7153ddf-b153-4b9c-9fea-aab1fe30471d
# ╠═ac0f2a28-a8aa-4031-b69c-71e8f6047574
# ╠═2b00f9f2-53f3-4525-a3e4-708109259b6c
# ╟─15dbf654-25cc-43e5-8526-d3e62ca3271a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
