### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 24c00466-e86f-410c-bb60-6dcb2399b63a
# Load the required Julia packages -
using LinearAlgebra

# ╔═╡ ff56afbd-630f-42c3-9171-ccd808d5589f
md"""

### Background
High Fructose Corn Syrup (HFCS) is a common sweetener in many food products. As a sweetener, HFCS is often compared to granulated table sugar (sucrose is made up of one molecule of glucose and one molecule of fructose), but HFCS is easier to handle and cheaper than granulated table sugar. HFCS comes in two varieties, HFCS-42 and HFCS-55. HFCS-42 and HFCS-55 refer to dry weight fructose compositions of 42% and 55% respectively, the rest being glucose. HFCS-42 is mainly used for processed foods and breakfast cereals, whereas HFCS-55 is used mostly for production of soft drinks.

### Manufacturing Process
Corn is milled to extract corn starch and an "acid-enzyme" process is used, in which the corn-starch solution is acidified to begin breaking up the existing carbohydrates. High-temperature enzymes are added to further metabolize the starch and convert the resulting sugars to fructose.
The first enzyme, alpha-amylase, breaks the long starch chains down into shorter sugar chains (oligosaccharides). 
Glucoamylase, a second enzyme, converts the oligosaccharides to glucose (a common six carbon sugar for biotechnology applications). The resulting solution is filtered to remove protein, then using activated carbon, and then demineralized using ion-exchange resins. 

The purified solution is then run over immobilized xylose isomerase, which converts the sugars to ~50–52% glucose with some unconverted oligosaccharides and 42% fructose (HFCS-42), and again demineralized and again purified using activated carbon. Some is processed into HFCS-90 by liquid chromatography, and then mixed with HFCS-42 to form HFCS-55. The enzymes used in the process are made by microbial fermentation. 
"""

# ╔═╡ c7c294a2-43bf-4ae2-a6cc-f917eb6857a3
md"""

### Model and Assumptions
Let's model the immobilized xylose isomerase step of the HCFS-42 process. 

__Assumptions__:

* The _system_ is a well-mixed reactor holding the immobilized xylose isomerase with a single input and out stream
* The _system_ operates at steady-state
* The _system_ temperature and pressure are held constant
"""

# ╔═╡ 58aff590-027b-4e63-8375-7ea304d1292d
md"""

#### Total mass balance
The number of streams $\mathcal{S}$ = 2 and we are operating at steady state. Thus, the general total mass balance equation:

$$\sum_{s=1}^{\mathcal{S}}v_{s}\dot{m}_{s} = \frac{dm}{dt}$$

becomes:

$$\dot{m}_{1} - \dot{m}_{2} = 0$$
"""

# ╔═╡ 9ad11963-8b06-42dd-9a92-0310893c03fc
md"""

#### Species mass balance equations
The _system_ involves a single reaction (with rate $r_{1}$), and three chemical species, glucose (1), fructose (2) and unreacted oligosaccharides (3). Glucose is converted to fructose by the enzyme (catalyst) xylose isomerase. Thus, the total number of species $\mathcal{M}$ = 3 and the number of streams $\mathcal{S}$ = 2. Therefore, our weight fraction composition matrix $\mathbf{W}$ is a 3 $\times$ 2 array. The $\dot{\mathbf{m}}$ vector is a 2$\times$ 1 column vector, while the generation terms are a 3 $\times$ 1 column vector. Let the rate of generation of species $i$ be given as:

$$\dot{m}_{i,gen} = \sigma_{i1}r_{1}$$

###### Stoichiometric coefficients
The $\sigma_{ij}$ in the generation term is called a _stoichiometric coefficient_. Stoichiometric coefficients relate chemical species with reaction rates.

* if $\sigma_{ij}>0$: species _i_ is __produced__ by reaction _j_
* if $\sigma_{ij}=0$: species _i_ is not connected with reaction _j_
* if $\sigma_{ij}<0$: species _i_ is __consumed__ by reaction _j_

Putting all these together gives the species material balances in matrix-vector form:

$\begin{pmatrix}
w_{11} & -w_{12} \\
w_{21} & -w_{22} \\
w_{31} & -w_{32} \\
\end{pmatrix}
\begin{pmatrix}
\dot{m}_{1} \\
\dot{m}_{2} \\
\end{pmatrix} = - 
\begin{pmatrix}
\sigma_{11}r_{1}\\
\sigma_{21}r_{1}\\
\sigma_{31}r_{1}\\
\end{pmatrix}$

or in compact notion:

$$\mathbf{W}\dot{\mathbf{m}}=\mathbf{b}$$

"""

# ╔═╡ f6dcdae8-e1a1-44da-b085-4859df008dec
# Let's start doing some Julia! (the fun part ...)

# Define mass flow rate vector (kg/hr) -
mdot = [100,100] # kg/hr

# ╔═╡ eb822e57-423a-4662-b402-052a616180d5
# define the composition array -
W = [0.92 -0.50 ; 0.0 -0.42 ; 0.08 -0.08]

# ╔═╡ 2ce2941b-047b-4c19-b757-6a3b3af83d21
# Compute the b-vector (reaction rate vector)
bV = W*mdot

# ╔═╡ 783ce2ee-398e-4d2e-9389-acfaa47b96df
sum(bV)

# ╔═╡ 9ad93173-2896-4aec-bb77-2aa3b51c8b50
md"""

#### Hmmm. Can we increase the flow rate to as fast as we want?
Unfortunately, no. The mass flow in the HFCS-42 process above will be governed by the rate at which xylose isomerase ($E_{1}$, units: kg) can process glucose. The fastest the enzyme can go will be given by:

$$r_{1} = k_{cat}E_{1}$$

where $k_{cat}$ is a _rate constant_, in this case called the turnover rate for xylose isomerase. These constants have been tabulated for many common enzymes in databases such as [BRENDA](https://www.brenda-enzymes.org). Looking at the various records, we find that $k_{cat}$ = 16.2$s^{-1}$.
"""

# ╔═╡ 4444d802-7d3c-4978-b9f3-5dd421c337b6
# How fast can the flow rate be for 10g of enzyme?
# convert to kg
E1 = 10*(1/1000) # convert to kg

# ╔═╡ 146cd344-c295-4d14-aa87-5f0ad4655640
# convert kcat to hr^-1 -
kcat = (16.2)*(3600) # convert to hr^-1

# ╔═╡ 9326629c-679a-4f8b-a06b-4eb39a752aa3
# what is the max rate we can expect for xylose isomerase -
max_rate = kcat*E1 # units: kg/hr

# ╔═╡ bb74b0b6-b209-425c-ad8f-e2cbc16d7670
md"""

#### Solve for flow rate given the reaction rate
If we knew the reaction rate, and the composition matrix were square, we could compute the flow rate by computing the inverse of the composition matrix:

$$\dot{\mathbf{m}} = \mathbf{W}^{-1}\mathbf{b}$$

where $\mathbf{W}^{-1}$ denotes the _inverse_ of the composition matrix $\mathbf{W}$ such that $\mathbf{W}\mathbf{W}^{-1}=\mathbf{W}^{-1}\mathbf{W} = \mathbf{I}$ (the identity matrix). 

However, our compostion matrix is _not square_. We'll have to compute the [pseudo inverse](https://en.wikipedia.org/wiki/Moore–Penrose_inverse). 
Let's put a pin in how we actually compute $\mathbf{W}^{-1}$ for the moment (and let Julia do it for us using the [pinv](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.pinv) command). 

"""

# ╔═╡ 1a010c01-b515-4fd4-9f47-d7595c3a99f2
# compute W inverse -
W_inv = pinv(W)

# ╔═╡ c0da6422-1318-49a3-8405-4a62f4323f55
# what is my bV -
bV_max = [max_rate ; -1*max_rate; 0.0]

# ╔═╡ eb90e0aa-df15-44b3-a11d-29742667fc9f
# compute the maximum flow rate -
mdot_max = W_inv*bV_max

# ╔═╡ a0523812-c4f7-461d-8ef0-1533bb86da3a
md"""
 #### Is there a diffent (less complicated) way to do this?
"""

# ╔═╡ 7920ee9f-cab4-4d20-b0a2-61eda1ada306


# ╔═╡ dc80bb02-0fb5-11ec-0866-0709291e7ff7
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
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ Cell order:
# ╠═24c00466-e86f-410c-bb60-6dcb2399b63a
# ╟─ff56afbd-630f-42c3-9171-ccd808d5589f
# ╟─c7c294a2-43bf-4ae2-a6cc-f917eb6857a3
# ╟─58aff590-027b-4e63-8375-7ea304d1292d
# ╟─9ad11963-8b06-42dd-9a92-0310893c03fc
# ╠═f6dcdae8-e1a1-44da-b085-4859df008dec
# ╠═eb822e57-423a-4662-b402-052a616180d5
# ╠═2ce2941b-047b-4c19-b757-6a3b3af83d21
# ╠═783ce2ee-398e-4d2e-9389-acfaa47b96df
# ╟─9ad93173-2896-4aec-bb77-2aa3b51c8b50
# ╠═4444d802-7d3c-4978-b9f3-5dd421c337b6
# ╠═146cd344-c295-4d14-aa87-5f0ad4655640
# ╠═9326629c-679a-4f8b-a06b-4eb39a752aa3
# ╟─bb74b0b6-b209-425c-ad8f-e2cbc16d7670
# ╠═1a010c01-b515-4fd4-9f47-d7595c3a99f2
# ╠═c0da6422-1318-49a3-8405-4a62f4323f55
# ╠═eb90e0aa-df15-44b3-a11d-29742667fc9f
# ╟─a0523812-c4f7-461d-8ef0-1533bb86da3a
# ╠═7920ee9f-cab4-4d20-b0a2-61eda1ada306
# ╟─dc80bb02-0fb5-11ec-0866-0709291e7ff7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
