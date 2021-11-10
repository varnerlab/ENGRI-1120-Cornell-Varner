### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ b787a8ca-7bd4-40a7-8574-334c72eda77d
begin
	using PrettyTables
	using PlutoUI
end

# ╔═╡ 67909d8a-421f-41cb-bc87-c1488be36074
md"""
### Practice Problem: Gas Phase Chemical Reaction Equilibrium Calculation

The gas-phase reaction:

$$A_{(g)}+B_{(g)} ~{\rightleftarrows}~ 2C_{(g)}$$

occurs in a closed well-mixed reactor with constant volume V = 10~L, a constant T = 500$^{\circ}$C, but with an unknown pressure (measured in bar). Initailly, there is 2 mol of A and 1 mol of B and no product C. Let the index of A = 1, B = 2 and C = 3. The Gibbs energies of formation at standard temperature and pressure are given by: $G_{1}^{\circ}$ = -2.0 kJ/mol,  $G_{2}^{\circ}$ = -3.6 kJ/mol and $G_{3}^{\circ}$ = -6.7 kJ/mol, respectively. 

The teaching team measured the equilibrium extent of reaction $\epsilon^{\star}_{1}$ = 0.67 mol for these conditions. However, the _mythical mole meter_ used by the teaching team to measure this extent has been acting up (and may be giving the wrong reading).

__Assume__:
* The gas phase is _ideal_ for all components
* The ideal gas law is valid for this system
* The reference pressure $P^{\circ}$ = 1 bar.
* R = 8.314 J mol$^{-1}$ K$^{-1}$ and R = 0.08314 bar L mol$^{-1}$ K$^{-1}$.

__Question__:
* Is the measured equilibrium extent of reaction consistent with the problem setup?  

"""

# ╔═╡ 80b572d7-3400-4373-af66-a394fe45296f
begin

	# setup the problem -
	V = 10.0 			# units: L
	T = (500+273.15)	# units: K
	R = 0.008314 		# units: kJ mol^-1 K^-1
	R_bar = 0.08314 	# units: bar L mol^-1 K^-1
	Pₒ = 1.0 			# units: bar

	# G_formation_array -
	G_formation_array = [
		-2.0 ; # 1 G_A units: kJ/mol
		-3.6 ; # 2 G_B units: kJ/mol
		-6.7 ; # 3 G_C units: kJ/mol
	];

	# reaction stoichiometry -
	S = [
		-1.0 ; 	# 1 A
		-1.0 ; 	# 2 B
		2.0 ; 	# 3 C
	];

	# initial mol -
	n_initial = [
		2.0 ; # 1 A units: mol
		1.0 ; # 2 B units: mol
		0.0 ; # 3 C units: mol
	];

	# what is the measured extent?
	ϵ₁ = 0.67 # units: mol

	# show -
	nothing
end

# ╔═╡ 9c7e21c6-dfe3-4f3e-b2e0-23d7ab578619
md"""
#### Solution: Compute the Eqilibrium constant $K$ using two different approaches and compare

To determine if the _mythical mole meter_ is correct, we can compute the equilibrium constant using the extent $\epsilon_{1}$, and then compare that value with the equilibrium constant computed using the $\Delta{G}^{\circ}$. If the values are the same, the _mythical mole meter_ is working, otherwise the _mythical mole meter_ is broken (and giving bad measurements of the extent).

"""

# ╔═╡ 4a63eb66-7090-41d0-80b3-94b56f5edebf
md"""
###### Compute K$_{\Delta{G}}$: equilibrium constant using the ΔG values 
"""

# ╔═╡ 4e10a9b5-cb5e-4b4a-87b4-0ce024a1ad6f
begin

	# compute the ΔG -
	ΔG = sum(G_formation_array.*S)
	RT = R*T
	
	# compute the equlibrium constant using the ΔG -
	K_ΔG = exp(-ΔG/RT)

	# display -
	with_terminal() do
		println("K_ΔG = $(K_ΔG)")
	end
end

# ╔═╡ 9f253794-d773-48bc-a1b5-94ca242ff798
md"""
###### Compute K$_{\epsilon}$: equilibrium constant using the extent values

Let's compute the equilibrium constant from the extent of reaction. Setup the state table using the species mole balance:

$$n_{i} = n^{\circ}_{i} + \sigma_{i1}\epsilon_{1}$$

"""

# ╔═╡ 47e684a6-773b-4009-b7cc-23dc2fbf4a4b
begin

	# compute the final number of mols, mol fraction -
	n_final = n_initial .+ S*ϵ₁
	n_total = sum(n_final)
	y_final = (1/n_total)*n_final

	# setup data array =
	state_table_array = Array{Any,2}(undef, 3,5)

	# A -
	state_table_array[1,1] = "A"
	state_table_array[1,2] = S[1]
	state_table_array[1,3] = n_initial[1]
	state_table_array[1,4] = n_final[1]
	state_table_array[1,5] = y_final[1]
	
	# B -
	state_table_array[2,1] = "B"
	state_table_array[2,2] = S[2]
	state_table_array[2,3] = n_initial[2]
	state_table_array[2,4] = n_final[2]
	state_table_array[2,5] = y_final[2]

	# C -
	state_table_array[3,1] = "C"
	state_table_array[3,2] = S[3]
	state_table_array[3,3] = n_initial[3]
	state_table_array[3,4] = n_final[3]
	state_table_array[3,5] = y_final[3]
	
	
	# setup a pretty table =
	# header row -
	state_table_header_row = (["Species","σ_i1","nᵢ_initial","nᵢ_final","yᵢ_final"],["","","mol", "mol", ""]);

	with_terminal() do
		# write the table -
		pretty_table(state_table_array; header=state_table_header_row)
	end
	
end

# ╔═╡ 8dca4509-6d6b-41c2-9d22-81c4563a5136
md"""
Now that we have the state table, we can use the gas phase equlibrium expression:

$$\prod_{i=1}^{\mathcal{M}}\left(y_{i}\hat{\phi}_{i}^{v}\right)^{\sigma_{i1}} = \left(\frac{P}{P^{\circ}}\right)^{-\sigma_{1}}K$$

To compute the equlibrium constant using the extent. Becuase we have assumed ideality, all the fugacity coefficient terms $\hat{\phi}^{v}_{i}\rightarrow\forall{i}$. In addition the pressure term is 1 becuase $\sigma_{1} = 0$ (the number of moles is conserved). 
Thus, the equilibrium constant is given by:

$$K = \frac{y_{3}}{y_{1}y_{2}}$$
"""

# ╔═╡ b7c489c1-513b-4c1c-b22a-9c0738e4a62e
begin

	# compute the overall stoichiometric coefficient -
	σ₁ = sum(S);

	# Compute pressure term -
	P = (1/V)*(R_bar*T)*n_total
	P_term = (P/Pₒ)^(-σ₁)
	
	# compute the K -
	K_ϵ = (y_final[1]^S[1])*(y_final[2]^S[2])*(y_final[3]^S[3])*(1/P_term)

	with_terminal() do
		println("K_ϵ = $(K_ϵ)")
	end
end

# ╔═╡ 9ce4fb80-a6da-4a3d-88f2-83092be1f340
md"""
### Bummer. K$_{\Delta{G}}$ $\neq$ K$_{\epsilon}$ $\longrightarrow$ the _mythical mole meter_ is broken!
"""

# ╔═╡ ccc364fe-3d4a-11ec-3415-0753629989e9
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
PlutoUI = "~0.7.18"
PrettyTables = "~1.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0ec322186e078db08ea3e7da5b8b2885c099b393"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.0"

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
git-tree-sha1 = "57312c7ecad39566319ccf5aa717a20788eb8c1f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.18"

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
# ╟─67909d8a-421f-41cb-bc87-c1488be36074
# ╠═80b572d7-3400-4373-af66-a394fe45296f
# ╟─9c7e21c6-dfe3-4f3e-b2e0-23d7ab578619
# ╟─4a63eb66-7090-41d0-80b3-94b56f5edebf
# ╠═4e10a9b5-cb5e-4b4a-87b4-0ce024a1ad6f
# ╟─9f253794-d773-48bc-a1b5-94ca242ff798
# ╠═47e684a6-773b-4009-b7cc-23dc2fbf4a4b
# ╟─8dca4509-6d6b-41c2-9d22-81c4563a5136
# ╠═b7c489c1-513b-4c1c-b22a-9c0738e4a62e
# ╟─9ce4fb80-a6da-4a3d-88f2-83092be1f340
# ╠═b787a8ca-7bd4-40a7-8574-334c72eda77d
# ╟─ccc364fe-3d4a-11ec-3415-0753629989e9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
