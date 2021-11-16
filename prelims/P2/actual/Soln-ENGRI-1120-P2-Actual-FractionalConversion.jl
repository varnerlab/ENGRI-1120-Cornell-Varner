### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 0936d1be-fb87-4e39-9573-8b1ddd4fd496
begin
	using PrettyTables
	using PlutoUI
end

# ╔═╡ a4feb3e1-48dd-4b74-9e64-65eec798b34c
md"""

### Solution: Open NH$_{3}$ CSTR Decomposition Problem

The teaching team built a reactor in the basement of Olin Hall to produce H$_{2}$ continuously by decomposing NH$_{3}(g)$ according to the reaction:

$$2NH_{3}~{\rightleftharpoons}~{N_{2}+3H_{2}}$$

The feed stream into the reactor (stream 1) consists of 32.0 mol/s of NH$_{3}$(g) and 0.1 mol/s of H$_{2}$O(g) (a contaminant that does not participate in the reaction).  There are no products in the feed stream. At the outlet (stream 2), the teaching team measured 47.24 mol/s of H$_{2}$ leaving the reactor.

__Assumptions__
* The gas phase is ideal
* The ideal gas law is a valid equation of state for this reactor
* The reactor operates at steady-state
* The reactor has a constant T, P and V

__Compute__
* Compute the open extent of reaction $\dot{\epsilon}_{1}$ for the decomposition reaction
* Compute the missing values in the state table XXX.
* Compute the fractional conversion of NH$_{3}$(g).

"""

# ╔═╡ 77e5e456-ca08-4d64-8927-d856e9eed328
begin

	# setup problem -
	n_dot_input = [
		32.0 	; # 1 NH₃ units: mol/s
		0.0 	; # 2 N₂ units: mol/s
		0.0 	; # 3 H₂ units: mol/s
		0.1 	; # 4 H₂O units: mol/s
	];

	# we only know 1 output -
	n_dot_32 = 47.24 # units: mol/s

	# stoichiometry -
	S = [
		-2.0 	; # 1 NH₃
		1.0 	; # 2 N₂
		3.0 	; # 3 H₂
		0.0 	; # 4 H₂O
	];

	# show -
	nothing
end

# ╔═╡ ba730327-4135-4301-9a78-a86c2a777834
md"""
###### a) Compute the open extent of reaction $\dot{\epsilon}_{1}$ (units: mol/s) for NH$_{3}$(g) decomposition.

To compute the open extent $\dot{\epsilon}_{1}$, we start by writing down the species mol balances for NH$_{3}$ (1), 
N$_{2}$ (2), H$_{2}$ (3) and H$_{2}$O (4) at steady-state (where we have substituted the stoichiometric coefficients and input flow rates):

$$\begin{eqnarray}
\dot{n}_{12} &=& \dot{n}_{11} - 2\dot{\epsilon_{1}} \\ 
\dot{n}_{22} &=& \dot{\epsilon_{1}} \\
\dot{n}_{32} &=& 3\dot{\epsilon_{1}} \\
\dot{n}_{42} &=& \dot{n}_{41} \\
\end{eqnarray}$$

From the problem, we know $\dot{n}_{32}$. Thus, we can use the output condition for H$_{2}$ and the H$_{2}$ balance to estimate $\dot{\epsilon}_{1}$.
"""

# ╔═╡ 6a73f92f-c191-4622-9c37-016327616900
begin

	# compute the open extent -
	ϵ₁_dot = (n_dot_32/S[3])

	# display -
	with_terminal() do
		println("ϵ₁_dot = $(ϵ₁_dot) mol/s")
	end
end

# ╔═╡ 5f3c9de7-1d2e-4577-bf4f-e56c7eb579ab
md"""
###### b) Compute the missing values in the state table for the open NH$_{3}$ problem
Now that we have the open extent, we can compute all the missing values by solving the species mol balances for the outlet flow rates:

$$\dot{n}_{i2} = \dot{n}_{i1} + \sigma_{i1}\dot{\epsilon}_{1}\qquad{i=1,2,\cdots,4}$$
"""

# ╔═╡ 636b6093-c8e7-410d-9df0-d7466efa458b
begin

	# solve for outlet -
	n_dot_output = n_dot_input .+ S*ϵ₁_dot

	# just for the lol's - lets compute the yᵢ's
	n_total_dot = sum(n_dot_output)
	y_output = (1/n_total_dot)*n_dot_output

	# build a pretty table -
	# header row -
	state_table_header_row = (["Species","σ_i1","nᵢ_dot_in","nᵢ_dot_out","yᵢ_out"],["","","mol/s", "mol/s", ""]);

	# setup state table data array =
	state_table_array = Array{Any,2}(undef, 5,5)
	
	# NH3 -
	state_table_array[1,1] = "NH₃"
	state_table_array[1,2] = S[1]
	state_table_array[1,3] = n_dot_input[1]
	state_table_array[1,4] = n_dot_output[1]
	state_table_array[1,5] = y_output[1]

	# N2 -
	state_table_array[2,1] = "N₂"
	state_table_array[2,2] = S[2]
	state_table_array[2,3] = n_dot_input[2]
	state_table_array[2,4] = n_dot_output[2]
	state_table_array[2,5] = y_output[2]

	# H2 -
	state_table_array[3,1] = "H₂"
	state_table_array[3,2] = S[3]
	state_table_array[3,3] = n_dot_input[3]
	state_table_array[3,4] = n_dot_output[3]
	state_table_array[3,5] = y_output[3]

	# H20 -
	state_table_array[4,1] = "H₂O"
	state_table_array[4,2] = S[4]
	state_table_array[4,3] = n_dot_input[4]
	state_table_array[4,4] = n_dot_output[4]
	state_table_array[4,5] = y_output[4]
	
	# total -
	state_table_array[5,1] = "Total"
	state_table_array[5,2] = sum(S)
	state_table_array[5,3] = sum(n_dot_input)
	state_table_array[5,4] = sum(n_dot_output)
	state_table_array[5,5] = sum(y_output)

	# display the state table -
	with_terminal() do
		# write the table -
		pretty_table(state_table_array; header=state_table_header_row)
	end	
end

# ╔═╡ e700a677-a565-41e6-b7ad-56d9a500229d
md"""

###### c) Compute the fractional conversion of NH$_{3}$(g)
For an open system with a single input and a single output, the fractional conversion is defined as:

$$f_{i} = \frac{\dot{n}_{i1} - \dot{n}_{i2}}{\dot{n}_{i1}}\qquad{i=1}$$

But this has the sample conceptual meaning as the closed system version; in the numerator, we are computing the consumption of reactant species $i$ by the reaction in the CSTR and then dividing by the mol flow rate of $i$ entering into the reactor. 

"""

# ╔═╡ 35d8f807-f6cb-407b-b3f8-cab053d68ca8
begin

	# compute f₁:
	f₁ = (n_dot_input[1] - n_dot_output[1])/(n_dot_input[1])

	# display -
	with_terminal() do
		println("Fractional conversion of NH₃ f₁ = $(f₁)")
	end
end

# ╔═╡ 65225bd2-4186-11ec-3709-6bba7ee9bd05
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
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
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

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

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

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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
# ╟─a4feb3e1-48dd-4b74-9e64-65eec798b34c
# ╠═77e5e456-ca08-4d64-8927-d856e9eed328
# ╟─ba730327-4135-4301-9a78-a86c2a777834
# ╠═6a73f92f-c191-4622-9c37-016327616900
# ╟─5f3c9de7-1d2e-4577-bf4f-e56c7eb579ab
# ╠═636b6093-c8e7-410d-9df0-d7466efa458b
# ╟─e700a677-a565-41e6-b7ad-56d9a500229d
# ╟─35d8f807-f6cb-407b-b3f8-cab053d68ca8
# ╠═0936d1be-fb87-4e39-9573-8b1ddd4fd496
# ╟─65225bd2-4186-11ec-3709-6bba7ee9bd05
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
