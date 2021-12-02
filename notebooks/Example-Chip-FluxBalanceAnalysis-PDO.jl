### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 52266654-9a67-4262-88dd-8f88ccec7289
begin

	# load some external packages 
	using PlutoUI
	using DataFrames
	using BSON
	using GLPK
	using PrettyTables
	
	# setup my paths (where are my files?)
	_PATH_TO_ROOT = pwd() 
	_PATH_TO_SRC = joinpath(_PATH_TO_ROOT,"src")
	_PATH_TO_MODEL = joinpath(_PATH_TO_ROOT,"model")
	_PATH_TO_FIGS = joinpath(_PATH_TO_ROOT,"figs")
	
	# load the ENGRI 1120 project code library -
	include(joinpath(_PATH_TO_SRC,"Include.jl"))

	# load the model -
	MODEL = BSON.load(joinpath(_PATH_TO_MODEL,"model_v2.bson"), @__MODULE__)

	# show -
	nothing
end

# ╔═╡ 69f55401-5f11-4d62-8707-09da24981690
md"""

#### Example: Cell Free Production and Purification of 1,3-propanediol from Glycerol

We want to produce a product 1,3-propanediol (PDO; desired product) from the feedstock Glycerol using a cell-free biochemical process operating in a well-mixed continuous microfluidic chip with two inputs and a single output, and a liquid reaction volume of V = 100 μL. Possible reaction pathways reproduced from:

* [Frazão, C.J.R., Trichez, D., Serrano-Bataille, H. et al. Construction of a synthetic pathway for the production of 1,3-propanediol from glucose. Sci Rep 9, 11576 (2019). https://doi.org/10.1038/s41598-019-48091-7](https://www.nature.com/articles/s41598-019-48091-7)

are shown in Fig 1. 

__Assumptions__
* Microfluidic chip is well-mixed and operates at steady-state
* Constant T, P on the chip
* Liquid phase is ideal

__Compute__
* Use flux balance analysis to compute the optimal open extent of reaction $\dot{\epsilon}_{i}$, where the objective function is to maximize PDO
* Compute the state and flux table for the mol flow rates given an input flow composition (mol flow rate)
* Compute the number of separation passes required to generate a stream with a 95% purity of PDO 
"""

# ╔═╡ ffe55797-fcd5-4f33-9766-91b8b0939278
PlutoUI.LocalResource(joinpath(_PATH_TO_FIGS,"Fig-PDO-Pathways.png"))

# ╔═╡ 4cdfb112-2551-4123-bf00-ef168798faa9
md"""
##### Setup the Flux Balance Analysis (FBA) problem to estimate the optimal reaction extents $\dot{\epsilon}_{j}$
"""

# ╔═╡ 404fdbb1-99ac-41e6-9312-ba1f5745f3fc
begin

	# setup the FBA calculation for the project -

	# === SELECT YOUR PRODUCT HERE ==================================================== #
	# What rate are trying to maximize? (select your product)
	# rn:R08199 = isoprene
	# rn:28235c0c-ec00-4a11-8acb-510b0f2e2687 = PGDN
	# rn:rn:R09799 = Hydrazine
	# rn:R03119 = 3G
	idx_target_rate = find_reaction_index(MODEL,:reaction_number=>"rn:R03119")
	# ================================================================================= #

	# First, let's build the stoichiometric matrix from the model object -
	(cia,ria,S) = build_stoichiometric_matrix(MODEL);

	# Next, what is the size of the system? (ℳ = number of metabolites, ℛ = number of reactions)
	(ℳ,ℛ) = size(S)

	# Next, setup a default bounds array => update specific elements
	# We'll correct the directionality below -
	Vₘ = (13.7)*(3600)*(50e-9)*(1000) # units: mmol/hr
	flux_bounds = [-Vₘ*ones(ℛ,1) Vₘ*ones(ℛ,1)]

	# update the flux bounds -> which fluxes can can backwards? 
	# do determine this: sgn(v) = -1*sgn(ΔG)
	updated_flux_bounds = update_flux_bounds_directionality(MODEL,flux_bounds)

	# hard code some bounds that we know -
	updated_flux_bounds[44,1] = 0.0

	# What is the default mol flow input array => update specific elements
	# strategy: start with nothing in both streams, add material(s) back
	n_dot_input_stream_1 = zeros(ℳ,1)	# stream 1
	n_dot_input_stream_2 = zeros(ℳ,1)	# stream 2

	# === YOU NEED TO CHANGE BELOW HERE ====================================================== #
	# Let's lookup stuff that we want/need to supply to the chip to get the reactiont to go -
	# what you feed *depends upon your product*
	compounds_that_we_need_to_supply = [
		"oxygen", "glycerol", "sucrose"
	]

	# what are the amounts that we need to supply to chip (units: mmol/hr)?
	mol_flow_values = [
		10.0 	; # oxygen mmol/hr
		Vₘ 		; # glycerol mmol/hr
		10.0 	; # sucrose
	]
	# === YOU NEED TO CHANGE ABOVE HERE ====================================================== #

	idx_supply = Array{Int64,1}()
	for compound in compounds_that_we_need_to_supply
		idx = find_compound_index(MODEL,:compound_name=>compound)
		push!(idx_supply,idx)
	end
	
	# supply -
	n_dot_input_stream_1[idx_supply] .= mol_flow_values
	
	# setup the species bounds array -
	species_bounds = [-1.0*(n_dot_input_stream_1.+n_dot_input_stream_2) 1000.0*ones(ℳ,1)]

	# Lastly, let's setup the objective function -
	c = zeros(ℛ)
	c[idx_target_rate] = -1.0

	# show -
	nothing
end

# ╔═╡ d8f20936-2ab5-417e-aed2-c63a894f6499
begin
	
	# compute the optimal flux -
	result = calculate_optimal_flux_distribution(S, updated_flux_bounds, species_bounds, c);

	# get the open extent vector -
	ϵ_dot = result.calculated_flux_array

	# did this converge?
	with_terminal() do

		# get exit/status information from the solver -
		exit_flag = result.exit_flag
		status_flag = result.status_flag

		# display -
		println("Computed optimal flux distribution. Solver: exit_flag = 0: $(exit_flag==0) and status_flag = 5: $(status_flag == 5)")
	end
end

# ╔═╡ 40878d6d-6b69-4eac-a148-f7b86f3c89df
md"""
##### Table 1: Flux table for maximizing flux = $(idx_target_rate)

The [GNU Linear Programming Kit solver](https://www.gnu.org/software/glpk/) produced an estimate of the (open) reaction extents $\dot{\epsilon}_{j}~\forall{j}$ given your constraints. We can then use these values to compute the output composition.


"""

# ╔═╡ 1e2fffcc-9c02-445d-a313-870f3dc1c706
with_terminal() do

	# initialize some storage -
	flux_table = Array{Any,2}(undef,ℛ,6)

	# what are the reaction strings? -> we can get these from the MODEL object 
	reaction_strings = MODEL[:reactions][!,:reaction_markup]
	reaction_id = MODEL[:reactions][!,:reaction_number]

	# populate the state table -
	for reaction_index = 1:ℛ
		flux_table[reaction_index,1] = reaction_index
		flux_table[reaction_index,2] = reaction_id[reaction_index]
		flux_table[reaction_index,3] = reaction_strings[reaction_index]
		flux_table[reaction_index,4] = flux_bounds[reaction_index,1]
		flux_table[reaction_index,5] = flux_bounds[reaction_index,2]

		# clean up the display -
		tmp_value = abs(ϵ_dot[reaction_index])
		flux_table[reaction_index,6] = tmp_value < 1e-6 ? 0.0 : ϵ_dot[reaction_index]
	end

	# header row -
	flux_table_header_row = (["i","RID","R","ϵ₁_dot LB", "ϵ₁_dot UB", "ϵᵢ_dot"],
		["","","", "mmol/hr", "mmol/hr", "mmol/hr"]);
		
	# write the table -
	pretty_table(flux_table; header=flux_table_header_row)
end

# ╔═╡ 3193dc2f-5822-4718-89e9-2c92eae5c0b1
md"""
##### Table 2: State table for maximizing flux = $(idx_target_rate)

The flux balance analysis problem produces estimates for the optimal value of the (open) reaction extents $\dot{\epsilon}_{j}~\forall{j}$ (units: mmol/hr). We can then use the steady-state species mol balances to compute the output composition (stream 1, 2 are inputs, stream 3 is an output):

$$\dot{n}_{i,3} = \dot{n}_{i,1}+\dot{n}_{i,2} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j}\qquad{i=1,2,\dots,\mathcal{M}}$$

In addition, since we have the molecular weight of each of the compounds in the model (provided in the MODEL compounds table), we can compute the species mass flow rate $\dot{m}_{i,3}~\forall{i}$, and the mass fraction of component $i$ in stream 3, $\omega_{i,3}~\forall{i}$.
"""

# ╔═╡ 0ba02949-6b61-49d6-a585-9852bec5bfe8
begin

	# compute the mol flow rate out of the device -
	n_dot_output = (n_dot_input_stream_1 + n_dot_input_stream_2 + S*ϵ_dot);

	# get the array of MW -
	MW_array = MODEL[:compounds][!,:compound_mw]

	# convert the output mol stream to a mass stream -
	mass_dot_output = (n_dot_output.*MW_array)*(1/1000)

	# what is the total coming out?
	total_mass_out = sum(mass_dot_output)
	
	
	with_terminal() do

		# what are the compound names and code strings? -> we can get these from the MODEL object 
		compound_name_strings = MODEL[:compounds][!,:compound_name]
		compound_id_strings = MODEL[:compounds][!,:compound_id]
		
		# how many molecules are in the state array?
		ℳ_local = length(compound_id_strings)
	
		# initialize some storage -
		state_table = Array{Any,2}(undef,ℳ_local,9)

		# get the uptake array from the result -
		uptake_array = result.uptake_array

		# populate the state table -
		for compound_index = 1:ℳ_local
			state_table[compound_index,1] = compound_index
			state_table[compound_index,2] = compound_name_strings[compound_index]
			state_table[compound_index,3] = compound_id_strings[compound_index]
			state_table[compound_index,4] = n_dot_input_stream_1[compound_index]
			state_table[compound_index,5] = n_dot_input_stream_2[compound_index]
			

			# for display -
			tmp_value = abs(n_dot_output[compound_index])
			state_table[compound_index,6] = (tmp_value) <= 1e-6 ? 0.0 : n_dot_output[compound_index]

			# show the Δ -
			tmp_value = abs(uptake_array[compound_index])
			state_table[compound_index,7] = (tmp_value) <= 1e-6 ? 0.0 : uptake_array[compound_index]

			# show the mass -
			tmp_value = abs(mass_dot_output[compound_index])
			state_table[compound_index,8] = (tmp_value) <= 1e-6 ? 0.0 : mass_dot_output[compound_index]

			# show the mass fraction -
			# show the mass -
			tmp_value = abs(mass_dot_output[compound_index])
			state_table[compound_index,9] = (tmp_value) <= 1e-6 ? 0.0 : (1/total_mass_out)*mass_dot_output[compound_index]
		end

		# header row -
		state_table_header_row = (["i","name","id","n₁_dot", "n₂_dot", "n₃_dot","Δn_dot", "m₃_dot", "ωᵢ_output"],
			["","","","mmol/hr", "mmol/hr", "mmol/hr", "mmol/hr", "g/hr", ""]);
		
		# write the table -
		pretty_table(state_table; header=state_table_header_row)
	end
end

# ╔═╡ 6e7365bc-e9ee-4182-89be-34eff2a70950
md"""
#### Separation of 1,3 propanediol using the Magical Sepration Units (MSU)

The magical separation units (MSUs) for the project have one stream in, and two streams out (called the top, and bottom, respectively) and a fixed separation ratio for all products (that's what makes them magical), where the desired product is _always_ in the top stream at some ratio $\theta$. In particular, if we denote $i=\star$ as the index for the desired product (in this case 1,3 propanediol), then after one pass (stream 1 is the input, stream 2 is the top, and stream 3 is the bottom) we have:

$$\begin{eqnarray}
\dot{m}_{\star,2} &=& \theta_{\star}\dot{m}_{\star,1}\\
\dot{m}_{\star,3} &=& (1-\theta_{\star})\dot{m}_{\star,1}\\
\end{eqnarray}$$

for the product. In this case, we set $\theta_{\star}$ = 0.75. On the other hand, for _all_ other materials in the input, we have $\left(1-\theta_{\star}\right)$ in the top, and $\theta_{\star}$ in the bottom, i.e.,

$$\begin{eqnarray}
\dot{m}_{i,2} &=& (1-\theta_{\star})\dot{m}_{i,1}\qquad{\forall{i}\neq\star}\\
\dot{m}_{i,3} &=& \theta_{\star}\dot{m}_{i,1}\\
\end{eqnarray}$$

If we chain these units together we can achieve a desired degree of separation. This type of arrangement gives rise to a binary separation tree shown in Fig 2. 

Fig 2. [Binary separation tree](https://en.wikipedia.org/wiki/Binary_tree) where a single input stream is fractionated at each level of the tree at a fixed ratio.

$(PlutoUI.LocalResource(joinpath(_PATH_TO_FIGS,"Fig-BTree.png")))
"""

# ╔═╡ 9ea5990a-30e8-4704-b85c-2f33ee6e92ce
md"""
The richest product stream will always be the top stream. Thus, after three separation operations (level $l=4$ in tree) the composition in the top stream will be (stream 8 using the numbering down convention):

$$\begin{eqnarray}
\dot{m}_{\star,8} &=& \left[\theta_{\star}^{l-1}\right]\dot{m}_{\star,1}\qquad{i=\star}\\
\dot{m}_{i,8} &=& \left[(1-\theta_{\star})^{l-1}\right]\dot{m}_{i,1}\qquad{\forall{i}\neq\star}\\
\end{eqnarray}$$

"""

# ╔═╡ 0e22c74b-603f-4f86-84cc-32e1ac6bb1c6
begin

	# define the split -
	θ = 0.75

	# most of the "stuff" has a 1 - θ in the up, and a θ in the down
	u = (1-θ)*ones(ℳ,1)
	d = θ*ones(ℳ,1)

	# However: the desired product has the opposite => correct for my compound of interest -
	idx_target_compound = find_compound_index(MODEL,:compound_name=>"propane-1,3-diol")

	# correct defaults -
	u[idx_target_compound] = θ
	d[idx_target_compound] = 1 - θ

	# let's compute the composition of the *always up* stream -
	
	# how many levels are we going to have?
	number_of_levels = 7
	
	# initialize some storage -
	species_mass_flow_array_top = zeros(ℳ,number_of_levels)
	species_mass_flow_array_bottom = zeros(ℳ,number_of_levels)

	for species_index = 1:ℳ
		value = mass_dot_output[species_index]
		species_mass_flow_array_top[species_index,1] = value
		species_mass_flow_array_bottom[species_index,1] = value
	end
	
	for level = 2:number_of_levels

		# compute the mass flows coming out of the top -
		m_dot_top = mass_dot_output.*(u.^(level-1))
		m_dot_bottom = mass_dot_output.*(d.^(level-1))

		# update my storage array -
		for species_index = 1:ℳ
			species_mass_flow_array_top[species_index,level] = m_dot_top[species_index]
			species_mass_flow_array_bottom[species_index,level] = m_dot_bottom[species_index]
		end
	end
	
	# what is the mass fraction in the top stream -
	species_mass_fraction_array_top = zeros(ℳ,number_of_levels)
	species_mass_fraction_array_bottom = zeros(ℳ,number_of_levels)
	
	# this is a dumb way to do this ... you're better than that JV come on ...
	T_top = sum(species_mass_flow_array_top,dims=1)
	T_bottom = sum(species_mass_flow_array_bottom,dims=1)
	for level = 1:number_of_levels

		# get the total for this level -
		T_level_top = T_top[level]
		T_level_bottom = T_bottom[level]

		for species_index = 1:ℳ
			species_mass_fraction_array_top[species_index,level] = (1/T_level_top)*(species_mass_flow_array_top[species_index,level])
			species_mass_fraction_array_bottom[species_index,level] = (1/T_level_bottom)*(species_mass_flow_array_bottom[species_index,level])
		end
	end
end

# ╔═╡ 5e5d80c9-b52f-49f9-932c-c334b8b00796
species_mass_flow_array_top[idx_target_compound,:]

# ╔═╡ 27138f88-f353-4c38-9b98-8652f260d907
species_mass_fraction_array_top[idx_target_compound,:]

# ╔═╡ 9b43ebda-188c-4315-96c3-20ea8f6e665e
species_mass_fraction_array_bottom[26,:]

# ╔═╡ 63d1340a-52bf-11ec-0890-43ada50baa38
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
PlutoUI = "~0.7.21"
PrettyTables = "~1.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

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
git-tree-sha1 = "92b7de61ecb616562fd2501334f729cc9db2a9a6"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.10.6"

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
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

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
# ╟─69f55401-5f11-4d62-8707-09da24981690
# ╟─ffe55797-fcd5-4f33-9766-91b8b0939278
# ╟─4cdfb112-2551-4123-bf00-ef168798faa9
# ╠═404fdbb1-99ac-41e6-9312-ba1f5745f3fc
# ╟─d8f20936-2ab5-417e-aed2-c63a894f6499
# ╟─40878d6d-6b69-4eac-a148-f7b86f3c89df
# ╟─1e2fffcc-9c02-445d-a313-870f3dc1c706
# ╟─3193dc2f-5822-4718-89e9-2c92eae5c0b1
# ╟─0ba02949-6b61-49d6-a585-9852bec5bfe8
# ╟─6e7365bc-e9ee-4182-89be-34eff2a70950
# ╟─9ea5990a-30e8-4704-b85c-2f33ee6e92ce
# ╠═0e22c74b-603f-4f86-84cc-32e1ac6bb1c6
# ╠═5e5d80c9-b52f-49f9-932c-c334b8b00796
# ╠═27138f88-f353-4c38-9b98-8652f260d907
# ╠═9b43ebda-188c-4315-96c3-20ea8f6e665e
# ╠═52266654-9a67-4262-88dd-8f88ccec7289
# ╟─63d1340a-52bf-11ec-0890-43ada50baa38
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
