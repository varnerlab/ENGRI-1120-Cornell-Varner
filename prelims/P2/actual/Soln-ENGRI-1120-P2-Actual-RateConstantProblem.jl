### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 96523da4-6c7a-4c38-830d-7106b02e4427
begin
	using PrettyTables
	using PlutoUI
end

# ╔═╡ 3a69160a-1fc1-443d-b405-4b2c5967809c
md"""

#### Solution: Rate constant problem

The teaching team is building a mathematical model of an NH$_{3}$(g) decomposition process running in an _open_ CSTR that lives in the basement of Olin Hall. Let's help them estimate the forward
($k_{1}^{+}$) and reverse ($k_{1}^{-}$) rate constants for that model. 

The gas phase reaction occurring in the _open_ CSTR is (reaction 1):

$$\begin{equation*}
    2NH_{3}(g)~{\rightleftharpoons}~N_{2}(g)+3H_{2}(g)
\end{equation*}$$

The reactor has a single input ($s=1$) and a single output ($s=2$) and a constant volume of V = 14L.
NH$_{3}$(g) with a concentration of $C_{1,1}$ = 10.0 mol/L is fed into the reactor at $\dot{F}$ = 4.0 L/s. The feed stream does not contain the reaction products.  

The fractional conversion of NH$_{3}$ is $f_{1}$ = 0.92 (or 92%).

__Assumptions__: 
* the gas phase is ideal;
* the ideal gas law is valid in the reactor;
* the reactor operates at steady-state;
* the reactor operates at a constant T, P and V;
* the reactor is well-mixed;
* the decomposition of NH$_{3}$(g) follows mass-action kinetics and is not auto-catalytic. 
"""

# ╔═╡ 2510656c-03b4-4fe5-94cb-74eca1da3770
md"""
Prelim version: $(@bind prelim_version_flag Select(["first"=>"GAMMA-1","second"=>"DELTA-1"]))
"""

# ╔═╡ a5422467-17c4-4de9-874e-cfa00798fea5
begin

	# setup problem specific data -
	if (isequal(prelim_version_flag, "first") == true)

		# version: γ
		V = 14.0 		# units: L
		F_dot = 4.0 	# units: L/s
		f₁ = 0.92 		# units: dimensionless
		θ = 19094.6 	# units: complicated ...
		
	elseif (isequal(prelim_version_flag, "second") == true)

		# version: δ
		V = 24.0 		# units: L
		F_dot = 6.0 	# units: L/s
		f₁ = 0.67 		# units: dimensionless
		θ = 319.95 		# units: complicated
		
	end

	# stoichiometry -
	S = [
		-2.0 ; # 1 NH3
		1.0  ; # 2 N2
		3.0  ; # 3 H2
	];

	# setup initial -
	C_feed = [
		10.0 	; 	# 1 NH3 units: mol/L
		0.0 	; 	# 2 N2 units: mol/L
		0.0 	; 	# 3 H2 units: mol/L
	];

	# show -
	nothing
end

# ╔═╡ e732a348-e6f3-431a-8f8d-b010e5c0ebd8
md"""
###### a) Starting from the _dynamic_ species mole balance for component $i$, derive the steady-state concentration balance.
We did this derivation on T before the prelim in class. Start with:

$$\frac{dn_{i}}{dt} = \sum_{s}v_{s}\dot{n}_{is} + \left(\sum_{j}\sigma_{ij}\hat{r}_{j}\right)V$$

We need concentration, so the accumulation terms can be re-written in terms of concentration:

$$\frac{dn_{i}}{dt} = V\frac{dC_{i}}{dt}+C_{i}\frac{dV}{dt}$$

and the transport terms can be written in terms of concentration as well:

$$\sum_{s}v_{s}\dot{n}_{is} = \sum_{s}v_{s}\dot{F}_{s}C_{is}$$

Putting these two things together gives:

$$V\frac{dC_{i}}{dt}+C_{i}\frac{dV}{dt} = \sum_{s}v_{s}\dot{F}_{s}C_{is} + \left(\sum_{j}\sigma_{ij}\hat{r}_{j}\right)V$$.

In this problem we are at a steady-state, have constant volume, and have a single input (s=1) and output stream (s=2) and a single reaction $\hat{r}_{1}$, thus:

$$\dot{F}\left(C_{i1} - C_{i1}\right) + \sigma_{i1}\hat{r}_{1}V = 0$$

Dividing both sides by $V$ gives:

$$D\left(C_{i1} - C_{i1}\right) + \sigma_{i1}\hat{r}_{1} = 0$$

which can be rewritten in terms of the residence time by dividing both sides by the dilution rate $D$:

$$\left(C_{i1} - C_{i1}\right) + \tau\sigma_{i1}\hat{r}_{1} = 0\qquad{i=1,2,\dots,\mathcal{M}}$$

"""

# ╔═╡ becf596e-4032-4569-a728-98d6feed2900
md"""
###### b) Using the concentration balances, compute the missing values in the concentration state table
The trick to this problem is realizing that we can write the fractional conversion in terms of concentration.
The fractional conversion $f_{i}$ is defined as:

$$f_{i} = \frac{\dot{n}_{i1} - \dot{n}_{i2}}{\dot{n}_{i1}}\qquad{i=1}$$

for an open system. However, we know that the mol flow rate of component $i$ in-stream $j$ can be written in terms of concentration: $\dot{n}_{ij}=\dot{F}_{j}C_{ij}$. Thus, we could re-write fractional conversion as:

$$f_{i} = \frac{\dot{F}_{1}C_{i1} - \dot{F}_{2}C_{i2}}{\dot{F}_{1}C_{i1}}\qquad{i=1}$$

However, we have a single input, a single output and constant volume, thus $\dot{F}_{1}=\dot{F}_{2}\equiv\dot{F}$:

$$f_{i} = \frac{\dot{F}C_{i1} - \dot{F}C_{i2}}{\dot{F}C_{i1}}\qquad{i=1}$$

The volumetric flow rate terms cancel, giving:

$$f_{i} = \frac{C_{i1} - C_{i2}}{C_{i1}}\qquad{i=1}$$

Following the same logic as the lecture, the practice prelim (and discussion questions) we can eliminate the $C_{i2}$ from
the species concentration balance and connect the reaction term(s) with the fractional conversion. In this case, solving for $\hat{r}_{1}$ we get:

$$\hat{r}_{1} = -f_{i}\frac{C_{i1}}{\tau\sigma_{i1}}$$

Once we have $\hat{r}_{1}$, we can compute the missing values in the state table.

"""

# ╔═╡ df3c6d90-47a5-42ae-b145-d1396abf2991
begin

	# compute the concentration -
	τ = V/F_dot; # units: s

	# compute the reaction rate -
	r₁_hat = -1*(C_feed[1]*f₁)/(τ*S[1])

	# compute the concentrations -
	C_out = C_feed .+ τ*S*r₁_hat

	# build a pretty table -
	# header row -
	state_table_header_row = (["Species","σ_i1","Cᵢ_in","Cᵢ_out"],["","","mol/L", "mol/L"]);

	# setup state table data array =
	state_table_array = Array{Any,2}(undef, 3,4)
	
	# NH3 -
	state_table_array[1,1] = "NH₃"
	state_table_array[1,2] = S[1]
	state_table_array[1,3] = C_feed[1]
	state_table_array[1,4] = C_out[1]

	# N2 -
	state_table_array[2,1] = "N₂"
	state_table_array[2,2] = S[2]
	state_table_array[2,3] = C_feed[2]
	state_table_array[2,4] = C_out[2]

	# H2 -
	state_table_array[3,1] = "H₂"
	state_table_array[3,2] = S[3]
	state_table_array[3,3] = C_feed[3]
	state_table_array[3,4] = C_out[3]

	# display the state table -
	with_terminal() do
		# write the table -
		pretty_table(state_table_array; header=state_table_header_row)
	end	
end

# ╔═╡ 0a800c55-1e80-4806-a7e1-3f037a23b642
with_terminal() do

	println("Estimated reaction rate r₁_hat = $(r₁_hat) mol/L-s")
end

# ╔═╡ 330d048e-2ade-4c30-b188-b6102f18ae77
md"""
##### c) Compute values (and units) for the forward and reverse rate constants

The net rate law for this problem (using the assumption of mass-action kinetics) is given by:

$$\hat{r}_{1} = k_{1}^{+}\left[NH_{3}\right]^2 - k_{1}^{-}\left[N_{2}\right]\left[H_{2}\right]^3$$

The strategy that we can use to solve this problem: we know $\hat{r}_{1}$, and all the concentrations from the state table. However, we do NOT know the rate constants. It would appear that we have two unknows (and only one equation) but in the problem we gave you an additional constraint that the forward and reverse rate constants were related through the expression:

$$k_{1}^{+} = {\theta}k_{1}^{-}$$

where the value of $\theta$ depended on the prelim version. This extra constraint gives you two equations and two unknowns that you could use to solve for each of the rate constants. 
Alternatively, you could also pose this in matrix-vector form and solve for both rate constants at the same time. In particular we could write:

$$\begin{bmatrix}
\left[NH_{3}\right]^2 & -\left[N_{2}\right]\left[H_{2}\right]^3 \\
1.0 & -\theta
\end{bmatrix}
\begin{pmatrix}
k_{1}^{+} \\
k_{1}^{-}
\end{pmatrix} = 
\begin{bmatrix}
\hat{r}_{1} \\
0.0
\end{bmatrix}$$

which is of the form $\mathbf{Ax} = \mathbf{b}$ and can ve solved by computing the inverse $\mathbf{x} = \mathbf{A}^{-1}\mathbf{b}$

"""

# ╔═╡ 2beae6c3-ddca-4dd2-8cfc-4a5552e0deac
begin

	# alias -
	NH₃ = C_out[1]
	N₂ = C_out[2]
	H₂ = C_out[3]

	# compute the A -
	A = [
		NH₃^2 -(N₂)*(H₂)^3 ;
		1.0 -θ ;
	];

	b = [
		r₁_hat ;
		0.0 ;
	]

	# compute rate constant vector -
	k_vec_estimate = inv(A)*b

	# display -
	with_terminal() do
		println("k₁_f = $(k_vec_estimate[1]) units: hmmmm and k₁_r = $(k_vec_estimate[2]) units: hmmmm.")
	end
end

# ╔═╡ 15693b60-65fc-4b9d-a48a-51447c93ae0d
md"""
###### Units:

The net rate has units of mol/L-s. Thus, the rate constants must have units such the forward and reverse rates have units of mol/L-s. Thus, by inspection:

* Units of $k_{1}^{+}$ will be L mol$^{-1}$ s$^{-1}$
* Units of $k_{1}^{-}$ will be L$^{3}$ mol$^{-3}$ s$^{-1}$

"""

# ╔═╡ 5ea224af-e9c9-437a-9727-641647ed0201
begin

	# alias -
	C12 = C_out[1]
	C22 = C_out[2]
	C32 = C_out[3]

	# make the θ some multiple of a hypothetical Keq -
	k1_minus = 0.01
	k1_plus = (r₁_hat + k1_minus*(C22)*(C32)^3)*(1/(C12)^2)
	θₜ = (k1_plus/k1_minus)

	# compute the A -
	AM = [
		C12^2 -(C22)*(C32)^3 ;
		1.0 -θₜ ;
	];

	bV = [
		r₁_hat ;
		0.0 ;
	]

	# compute rate constant vector -
	k_vec = inv(AM)*bV

	# test -
	test_rate = k_vec[1]*(C12)^2 - k_vec[2]*(C22)*(C32)^3

	# theta_test = 
	theta_test = k_vec[1]/k_vec[2]

	# values -
	(k_vec, θₜ, theta_test, r₁_hat, test_rate)
end

# ╔═╡ b8b580e8-4308-11ec-09c3-b7a14ae5b5d1
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
# ╠═3a69160a-1fc1-443d-b405-4b2c5967809c
# ╟─2510656c-03b4-4fe5-94cb-74eca1da3770
# ╠═a5422467-17c4-4de9-874e-cfa00798fea5
# ╟─e732a348-e6f3-431a-8f8d-b010e5c0ebd8
# ╟─becf596e-4032-4569-a728-98d6feed2900
# ╠═df3c6d90-47a5-42ae-b145-d1396abf2991
# ╠═0a800c55-1e80-4806-a7e1-3f037a23b642
# ╟─330d048e-2ade-4c30-b188-b6102f18ae77
# ╠═2beae6c3-ddca-4dd2-8cfc-4a5552e0deac
# ╠═15693b60-65fc-4b9d-a48a-51447c93ae0d
# ╠═5ea224af-e9c9-437a-9727-641647ed0201
# ╠═96523da4-6c7a-4c38-830d-7106b02e4427
# ╟─b8b580e8-4308-11ec-09c3-b7a14ae5b5d1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
