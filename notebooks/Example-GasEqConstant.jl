### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ be57f61e-a9f1-40dc-a692-676c14f03aa4
begin
	using PlutoUI
	using PrettyTables
end

# ╔═╡ f7c935c8-f577-4e38-b242-7e262bd446e1
md"""
##### Example: Gas Phase Reaction with a non-constant number of mols
The reversible _gas phase_ chemical reaction (R1):

$$\begin{equation}
  A_{(g)}+B_{(g)}\leftrightharpoons{C_{(g)}}
\end{equation}$$

is carried out at T = 298.15 K, and an _unknown_ pressure P (bar). The volume of the reactor V = 20L is constant. At these conditions, the teaching team measured the equilibrium extent of reaction $\epsilon^{\star}$ = 0.90 mol. 
Let A = 1, B = 2 and C = 3. We start with $n^{\circ}_{1}$ = 2.0 mol, $n^{\circ}_{2}$ = 1.0 mol and 
$n^{\circ}_{3}$ = 0.0 mol.

__Assumptions__: 
* (i) P$^{\circ}$ = 1 bar;
* (ii) R = 8.314 $\times$10$^{-2}$ L bar mol$^{-1}$ K$^{-1}$ and R = 8.314 J mol$^{-1}$ K$^{-1}$;
* (iii) the vapor phase is _ideal_;
* (iv) the ideal gas law is valid at these reaction conditions

__Compute__:
  * (a) Compute all state (mol) values at the reaction conditions
  * (b) Starting from the general equilibrium expression for a single vapor phase reaction, estimate a value for $K$ for R1 at T = 298.15 K and system pressure.
  * (c) Estimate the value of the Gibbs energy of reaction $\Delta{G}^{\circ}$ (kJ/mol) from the equilibrium constant $K$. Is the reaction: favorable or not favorable?
"""

# ╔═╡ 861c1cf4-ce56-43ec-bca1-6974d72240f5
md"""
##### (a) Compute the composition table
To compute the entries in the composition table, we use the definition of the extent of reaction, and the reaction stoichiometry, to calculate the final number of mols (given the initial number of mols):

$$n_{i} = n_{i}^{\circ}+\sigma_{i1}\epsilon_{1}$$

In this problem, we have a single reaction, and at equilibrium $\epsilon_{1}=\epsilon^{\star}=0.90$ mol. To compute mol fractions (which appear in the equilibrium constant expressions), we divide each species mol number by the total i.e., $y_{i}$ = $n_{i}/n_{T}$.
"""

# ╔═╡ 5e423631-becf-4351-99f2-10da34eb5675
# Setup initial composition table -
begin
	
	# how many species do we have?
	number_of_species = 3
	number_of_state_cols = 5
	
	# setup the state table -> species x items
	initial_state_table = Array{Union{Number,Nothing, String},2}(undef, number_of_species, number_of_state_cols)

	# put stuff into the table from the problem -
	initial_state_table[1,1] = "A" 		# species 
	initial_state_table[1,2] = -1 		# stoichiometric coeff -
	initial_state_table[1,3] = 2.0 		# initial number of mols 
	initial_state_table[1,4] = nothing 	# final number of mols
	initial_state_table[1,5] = nothing 	# mol fraction 
	
	initial_state_table[2,1] = "B" 		# species 
	initial_state_table[2,2] = -1 		# stoichiometric coeff -
	initial_state_table[2,3] = 1.0 		# initial number of mols 
	initial_state_table[2,4] = nothing 	# final number of mols
	initial_state_table[2,5] = nothing 	# mol fraction 
	
	initial_state_table[3,1] = "C" 		# species 
	initial_state_table[3,2] = 1 		# stoichiometric coeff -
	initial_state_table[3,3] = 0.0 		# initial number of mols 
	initial_state_table[3,4] = nothing 	# final number of mols
	initial_state_table[3,5] = nothing 	# mol fraction 
	
	with_terminal() do
	
		# header row -
		state_table_header_row = (["species","σ","initial n","final n","yᵢ"],["","dimensionless","mol","mol","dimensionless"]);

		# write the table -
		pretty_table(initial_state_table; header=state_table_header_row)
	end
end

# ╔═╡ 4c722cf0-97d5-4ac2-9533-ae216ce89d19
# compute the final number of mols -
begin
	# setup as MV calculation (faster) -
	n_initial = [2.0 ; 1.0 ; 0.0];
	S = [-1 ; -1 ; 1];
	ϵ = 0.90
	
	# compute final mol -
	n_final = n_initial + S*ϵ
end

# ╔═╡ 67b1906f-0c64-4cca-9d26-4383eeb370c0
# compute the mol frac -
begin
	n_total = sum(n_final)
	y_array = (1/n_total)*n_final
end

# ╔═╡ bf499485-c101-452d-85f8-be4d6f7a34aa
begin
	
	final_state_table = copy(initial_state_table)
	
	# put stuff into the table from the problem -
	final_state_table[1,1] = "A" 			# species 
	final_state_table[1,2] = -1 			# stoichiometric coeff -
	final_state_table[1,3] = 2.0 			# initial number of mols 
	final_state_table[1,4] = n_final[1] 	# final number of mols
	final_state_table[1,5] = y_array[1] 	# mol fraction 
	
	final_state_table[2,1] = "B" 			# species 
	final_state_table[2,2] = -1 			# stoichiometric coeff -
	final_state_table[2,3] = 1.0 			# initial number of mols 
	final_state_table[2,4] = n_final[2] 	# final number of mols
	final_state_table[2,5] = y_array[2] 	# mol fraction 
	
	final_state_table[3,1] = "C" 			# species 
	final_state_table[3,2] = 1 				# stoichiometric coeff -
	final_state_table[3,3] = 0.0 			# initial number of mols 
	final_state_table[3,4] = n_final[3] 	# final number of mols
	final_state_table[3,5] = y_array[3] 	# mol fraction 
	
	with_terminal() do
	
		# header row -
		state_table_header_row = (["species","σ","initial n","final n","yᵢ"],["","dimensionless","mol","mol","dimensionless"]);

		# write the table -
		pretty_table(final_state_table; header=state_table_header_row)
	end
end

# ╔═╡ e305af93-5ef0-413c-8c7d-68737cc1ffc4
md"""
##### (b) Estimate the equilibrium constant K
The general expression for the equilibrium constant for a gas phase reaction is:

$$\begin{equation}
  \left(\frac{P}{P^{\circ}}\right)^{-\sigma_{1}}K = \prod_{i=1}^{\mathcal{M}}\left(y_{i}\hat{\phi}^{v}_{i}\right)^{\sigma_{i1}}
\end{equation}$$

However, we know a few things from the problem. First, the gas phase is ideal so the fugacity coefficient $\hat{\phi}^{v}_{i}\rightarrow{1},\forall{i}$. Next, we know that the overall stoichiometric coefficient $\sigma_{1}$ = -1, and
$P^{\circ}$ = 1 bar. Finally, while we do not know the pressure, we do know that the gas can treated as an _ideal_ gas, meaning we can use the ideal gas law to describe the pressure i.e., 

$$P = \frac{n_{T}RT}{V}$$

Putting these ideas together, the general expression for the equilibrium gas phase equilibrium constant becomes:

$$K = \frac{1}{P}\prod_{i=1}^{\mathcal{M}}\left(y_{i}\right)^{\sigma_{i1}}$$

or after further simplification:

$$K = \frac{1}{P}\left(\frac{y_{3}}{y_{1}y_{2}}\right)$$

"""

# ╔═╡ 9183cb07-8e42-4440-aab4-cde1e101af05
md"""
__First step__: Compute the unkown pressure P (units: bar)
"""

# ╔═╡ 07db3757-926f-4391-aeae-be7240998f09
# compute the Pressure -
begin
	
	# use the IGL to estimate the equilibrium pressure -
	V = 20.0 					# units: L
	T = 298.15 					# units: K
	R_bar = (8.314)*10^(-2)			# units: L bar mol$^{-1}$ K$^{-1}$
	P = (n_total*R_bar*T)/(V)		# units: bar
	
	# display the pressure -
	with_terminal() do
		println("Pressure = $(P) bar")
	end
end

# ╔═╡ f51e4de0-1c39-45ca-933f-1826abcbf1f3
md"""
__Compute__: the equilibrium constant K given P and composition
"""

# ╔═╡ 3421b268-a3d6-48b5-819e-d9cbd14ee687
# compute the K -
begin
	
	# get the mol frac's from the final state table -
	y₁ = final_state_table[1,5]
	y₂ = final_state_table[2,5]
	y₃ = final_state_table[3,5]
	
	# compute the K -
	K = (1/P)*(y₃/(y₁*y₂))
	
	with_terminal() do
		# print -
		println("K = $(K)")
	end
end

# ╔═╡ dd52da8d-106b-4385-8576-6fc030ce90d1
md"""
##### (c) Estimate the ΔG$^{\circ}$ for the reaction
At equilibrium we know that the constant K and the ΔG$^{\circ}$ of reaction are related by:

$$\ln K = -\frac{\Delta{G}^{\circ}}{RT}$$

which we can use to solve for ΔG$^{\circ}$ given that we know the equilibrium constant $K$:

$$\Delta{G}^{\circ} = RT\ln K$$

"""

# ╔═╡ 22ce61af-1a3d-4214-8b98-dc463e3d61b8
with_terminal() do
	R = 8.314*(1/1000) # units: kJ/mol-K
	ΔG = -R*T*log(K)
	println("ΔG = $(ΔG) kJ/mol")
end

# ╔═╡ 7bfe56b8-3639-11ec-1f61-9d52526c146d
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
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

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
git-tree-sha1 = "f19e978f81eca5fd7620650d7dbea58f825802ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.0"

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
# ╟─f7c935c8-f577-4e38-b242-7e262bd446e1
# ╟─861c1cf4-ce56-43ec-bca1-6974d72240f5
# ╟─5e423631-becf-4351-99f2-10da34eb5675
# ╠═4c722cf0-97d5-4ac2-9533-ae216ce89d19
# ╠═67b1906f-0c64-4cca-9d26-4383eeb370c0
# ╟─bf499485-c101-452d-85f8-be4d6f7a34aa
# ╟─e305af93-5ef0-413c-8c7d-68737cc1ffc4
# ╟─9183cb07-8e42-4440-aab4-cde1e101af05
# ╠═07db3757-926f-4391-aeae-be7240998f09
# ╟─f51e4de0-1c39-45ca-933f-1826abcbf1f3
# ╠═3421b268-a3d6-48b5-819e-d9cbd14ee687
# ╟─dd52da8d-106b-4385-8576-6fc030ce90d1
# ╠═22ce61af-1a3d-4214-8b98-dc463e3d61b8
# ╟─be57f61e-a9f1-40dc-a692-676c14f03aa4
# ╟─7bfe56b8-3639-11ec-1f61-9d52526c146d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
