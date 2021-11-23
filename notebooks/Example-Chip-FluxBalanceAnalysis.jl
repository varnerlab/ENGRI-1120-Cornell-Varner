### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ d3b9397f-5673-47ca-8a01-62fd985f121f
begin
	
	# load packages -
	using BSON
	using PlutoUI
	using DataFrames
	using GLPK
	using PrettyTables
	
	# setup paths -
	_PATH_TO_ROOT = pwd()
	_PATH_TO_SRC = joinpath(_PATH_TO_ROOT,"src")
	_PATH_TO_MODEL = joinpath(_PATH_TO_ROOT, "model")

	# include my code lib -
	include(joinpath(_PATH_TO_SRC, "Include.jl"))

	# show -
	nothing
end

# ╔═╡ 7bf3ac90-637d-4992-8835-6798d46f71f5
md"""
### Example: Using Flux Balance Analysis to Compute Fractional Conversion

We want to produce a product _P_ (desired product) by converting feedstock A₁ using a cell-free biochemical process operating in a well-mixed continuous microfluidic chip with a single input and a single output, and a liquid reaction volume of V = 100 μL. The reaction network is shown in Fig 1.

__Assumptions__
* Microfluidic chip is well-mixed and operates at steady-state
* Constant T, P on the chip
* Liquid phase is ideal

__Compute__
* Use flux balance analysis to compute the optimal open extent of reaction $\dot{\epsilon}_{i}$, where the objective function is to maximize _P_
* Compute the state table for the mol flow rates into (you decide) and from the chip (requires FBA)
* Compute the fractional conversion of the feedstock A₁

"""

# ╔═╡ 7aa00ab3-b105-415a-a7cf-111afc1829d7
md"""
__Fig. 1__ Schematic of the reaction network operating on the steady-state chip."
"""

# ╔═╡ f2316c41-0c45-4dd2-8749-3d67256b08b4
PlutoUI.LocalResource("./figs/Fig-FBA-ToyNetwork.png")

# ╔═╡ 6a0c8767-6de3-44b2-9d84-04e504e43c1b
md"""
##### Compute the optimal open reaction extents using Flux Balance Analysis (FBA)

The FBA problem is (traditinally) a Linear Programming (LP) problem in which a linear objective function $\mathcal{O}$:

$$\mathcal{O} = \sum_{j=1}^{\mathcal{R}}c_{j}\dot{\epsilon}_{j}$$

is minimized (or maximized) subject to a collection of linear constraints, and bound constraints on the permissible values of the extents $\dot{\epsilon}_{i}$. In this case, we know that the steady-state mol flow rate for species $i$ leaving the chip given (where $s=1$ denotes the inlet and $s=2$ denotes the outlet):

$$\dot{n}_{i,2} = \dot{n}_{i,1} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j}$$

Thus, because $\dot{n}_{i,2}\geq{0}$, the FBA problem is subject to the mol constraints: 

$$\dot{n}_{i,1} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j}\geq{0}\qquad\forall{i}$$

In other words, when searching for the optimal set of $\dot{\epsilon}_{j}$ we have to select values that give physically realistic answers (we can't have a negative mol flow rate). Next, the $\dot{\epsilon}_{j}$ terms are bounded from above and below: 

$$\mathcal{L}_{j}\leq\dot{\epsilon}_{j}\leq\mathcal{U}_{j}\qquad{j=1,2\dots,\mathcal{R}}$$

where the $\mathcal{L}_{j}$ and $\mathcal{U}_{j}$ denote the lower and upper bounds that $\dot{\epsilon}_{j}$ can take. Remember that the open extents are just reaction rates times the volume. Thus, the lower and upper bounds describe the permissible range that we expect the rate _could_ obtain.  

"""

# ╔═╡ 78eb6166-ac8a-4c28-8f8f-ae00b5c78b3f
begin

	# setup the volume -
	V = 100.0*(1.0/1.0e6)

	# setup flow rate in
	n_dot_in = [
		10.0 	; # 1 A₁
		3.0 	; # 2 A₂
		0.0 	; # 3 B
		0.0 	; # 4 P
		1.0 	; # 5 C
		0.0 	; # 6 x
		0.0 	; # 7 y
	]
	
	# Setup STM -
	S = [

		# r₁ r₂ r₃
		-1.0 0.0 0.0 ; # 1 A₁
		0.0 0.0 -1.0 ; # 2 A₂
		1.0 -1.0 0.0 ; # 3 B
		0.0 1.0 0.0  ; # 4 P
		0.0 0.0 1.0  ; # 5 C
		-1.0 0.0 1.0 ; # 6 x
		1.0 0.0 -1.0 ; # 7 y 
	];
	(number_of_states, number_of_reactions) = size(S)

	# set the flux bounds array -
	flux_bounds_array = [

		# ℒ 𝒰
		0.0 10.0 	; # 1 r₁
		0.0 10.0  	; # 2 r₂
		0.0 20.0 	; # 3 r₃
	];

	# set the species bounds array -
	species_bounds_array = [

		# ℒ lower     𝒰 upper
		-n_dot_in[1] 1000.0 				; # 1 A₁
		-n_dot_in[2] 1000.0 				; # 2 A₂
		-n_dot_in[3] 1000.0 				; # 3 B
		-n_dot_in[4] 1000.0 				; # 4 P
		-n_dot_in[5] 1000.0 				; # 5 C
		-n_dot_in[6] 1000.0 				; # 6 x
		-n_dot_in[7] 1000.0 				; # 7 y
	];

	# max P formation -
	obj_vector = zeros(3)
	obj_vector[2] = -1.0

	# show -
	nothing 
end

# ╔═╡ f3efe4fa-c78d-42ab-bf9e-ecd7011874d9
begin

	# compute the optimal flux -
	result = calculate_optimal_flux_distribution(S, flux_bounds_array, species_bounds_array, obj_vector)
	
	# initialize some storage -
	flux_table = Array{Any,2}(undef,number_of_reactions,4)

	# reactions -
	reaction_strings = [
		"A₁ + x => B + y" 	; # 1 r₁
		"B => P" 			; # 2 r₂
		"A₂ + y => C + x" 	; # 3 r₃
	]

	# populate the state table -
	for reaction_index = 1:number_of_reactions
		flux_table[reaction_index,1] = reaction_strings[reaction_index]
		flux_table[reaction_index,2] = result.calculated_flux_array[reaction_index]
		flux_table[reaction_index,3] = flux_bounds_array[reaction_index,1]
		flux_table[reaction_index,4] = flux_bounds_array[reaction_index,2]
	end

	with_terminal() do
		
		# header row -
		flux_table_header_row = (["Reaction","ϵᵢ_dot", "ϵ₁_dot LB", "ϵ₁_dot UB"],["","mol/time", "mol/time", "mol/time"]);
		
		# write the table -
		pretty_table(flux_table; header=flux_table_header_row)
	end
	
end

# ╔═╡ 45740c44-a846-4b7d-acc1-9105aa67e786
begin

	# compute output -
	ϵ_vector = result.calculated_flux_array
	n_dot_out = n_dot_in .+ S*ϵ_vector

	# make a pretty table -
	state_table = Array{Any,2}(undef, number_of_states,3)
	species_array = ["A₁", "A₂", "B", "P", "C", "x","y"]
	for state_index = 1:number_of_states

		# populate -
		state_table[state_index,1] = species_array[state_index]
		state_table[state_index,2] = n_dot_in[state_index]
		state_table[state_index,3] = n_dot_out[state_index]
	end

	with_terminal() do

		# header row -
		state_table_header_row = (["Species","nᵢ_dot_in","nᵢ_dot_out"],["","mol/time", "mol/time"]);
		
		# write the table -
		pretty_table(state_table; header=state_table_header_row)
	end
end

# ╔═╡ 05e4f243-4a1b-4962-a36a-7a931b8e7936
md"""

##### Compute the fractional conversion of A₁ and A₂
The fractional conversion of a _reactant_ species for an _open_ system (with a single input and a single output) is given by:

$$f_{i} = \frac{\dot{n}_{i,j-1} - \dot{n}_{i,j}}{\dot{n}_{i,j-1}}$$

where $\dot{n}_{i,j-1}$ denotes the mol flow rate of species $i$ in stream $j-1$ (inlet), and $\dot{n}_{i,j}$ denotes the mol flow rate of species $i$ in stream $j$ (outlet). 

"""

# ╔═╡ 85db6161-58f6-4fea-ad00-7eb5aae85fd7
with_terminal() do
	
	# compute fᵢ
	f₁ = (n_dot_in[1] - n_dot_out[1])/(n_dot_in[1])
	f₂ = (n_dot_in[2] - n_dot_out[2])/(n_dot_in[2])

	# display -
	println("Fraction conversion A₁ = $(f₁) and A₂ = $(f₂)")
	
end

# ╔═╡ 6c747a6e-4bf7-11ec-2b43-af47c5975080
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BSON = "fbb218c0-5317-5bc6-957e-2ee96dd4b1f0"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
GLPK = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
BSON = "~0.3.4"
DataFrames = "~1.2.2"
GLPK = "~0.15.1"
PlutoUI = "~0.7.19"
PrettyTables = "~1.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[BSON]]
git-tree-sha1 = "ebcd6e22d69f21249b7b8668351ebf42d6dc87a1"
uuid = "fbb218c0-5317-5bc6-957e-2ee96dd4b1f0"
version = "0.3.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "61adeb0823084487000600ef8b1c00cc2474cd47"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.0"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLPK]]
deps = ["BinaryProvider", "CEnum", "GLPK_jll", "Libdl", "MathOptInterface"]
git-tree-sha1 = "8c9b0ce6d476800c7a7e8cc0db5a60e241cf107a"
uuid = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
version = "0.15.1"

[[GLPK_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "01de09b070d4b8e3e1250c6542e16ed5cad45321"
uuid = "e8aa6df9-e6ca-548a-97ff-1f85fc5b8b98"
version = "5.0.0+0"

[[GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

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

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "Printf", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "afa62f733d78f63c2292730994dcb076835cf1d2"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.10.5"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "e071adf21e165ea0d904b595544a8e514c8bb42c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.19"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

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

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

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

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─7bf3ac90-637d-4992-8835-6798d46f71f5
# ╟─7aa00ab3-b105-415a-a7cf-111afc1829d7
# ╟─f2316c41-0c45-4dd2-8749-3d67256b08b4
# ╟─6a0c8767-6de3-44b2-9d84-04e504e43c1b
# ╠═78eb6166-ac8a-4c28-8f8f-ae00b5c78b3f
# ╟─f3efe4fa-c78d-42ab-bf9e-ecd7011874d9
# ╟─45740c44-a846-4b7d-acc1-9105aa67e786
# ╟─05e4f243-4a1b-4962-a36a-7a931b8e7936
# ╟─85db6161-58f6-4fea-ad00-7eb5aae85fd7
# ╟─d3b9397f-5673-47ca-8a01-62fd985f121f
# ╟─6c747a6e-4bf7-11ec-2b43-af47c5975080
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
