### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 64af17f4-c632-425c-a101-9dfa5e8cbd84
# julia setup -
using PlutoUI

# ╔═╡ 35dd2eca-2446-11ec-1de6-0feeace9d4f7
md"""

#### Flash separation of a binary mixtrure of component A and component B

A liquid feed stream that contains 60% component A (1) and 40% component B (2) is seperated in a flash drum operating at P = 1.21 MPa and T = 150$^{\circ}$C. The saturation pressures of pure component A and B can be modeled using the [Antoine equation](https://en.wikipedia.org/wiki/Antoine_equation): 

$$\begin{eqnarray}
\ln\left(P_{1}^{sat}\right) &=& 15 -\frac{3010}{T+250}\\
\ln\left(P_{2}^{sat}\right) &=& 14 -\frac{2700}{T+205}
\end{eqnarray}$$

where $T$ denotes the temperature in units of celcius $^{\circ}$C and $P_{\star}^{sat}$ denotes the saturation pressure in units of kPa for component $\star$. 

##### Assumptions

1. The liquid and vapor phases of all streams are ideal
1. The liquid and vapor phases inside the Flash Drum are ideal (Raoult's law)
1. The liquid and vapor phases inside the Flash Drum reach vapor-liquid equlibrium instantly 

##### Solve:

 * Calculate the fraction of the input stream that exits the drum as liquid
 * Calculate the fraction of the input stream that exits the drum as vapor
 * Calculate the composition of the liquid ($x_{1}$ and $x_{2}$) and vapor phases ($y_{1}$ and $y_{2}$) in the exit streams 

"""

# ╔═╡ 92ff1f65-d717-47a8-9cd3-af71c2855210
PlutoUI.LocalResource("./figs/Fig-Flash.png")

# ╔═╡ 98e43733-8711-4aa4-9081-697dd8865592
begin
	
	# write down some constants -
	T = 150 		# units: C
	P = 1210 		# units: kPa
	z₁ = 0.60 		# units: dimensionless
	z₂ = (1-z₁)		# units: dimensionless
	
	# return -
	nothing 
end

# ╔═╡ 792e101b-e736-46d2-bbf3-a1197a0cc654
md"""

##### Governing equations

Let's start by writing down the governing equations. Starting from the total mol balance:

$$\dot{F} = \dot{L}+\dot{V}$$

we can divide both sides by $\dot{F}$ to give a relationship which constrains the fraction(s) of liquid and vapor in the outlet streams:

$$\hat{L}+\hat{V} = 1$$

Further, we know that the species mol balance around species $i$ is given by:

$$\dot{F}z_{i} = \dot{L}x_{i}+\dot{V}y_{i}\qquad{i=1,2}$$

However, because we assumed ideal vapor and liquid, we know that the liquid and vapor phase equlibrium compositions are related by the fugacity matching condition: $y_{i}P = x_{i}P_{i}^{sat}$. Lastly, we can sum the matching conditions to arrive at an expression which governs the pressure that is only in $x_{i}$:

$$P = x_{1}P_{1}^{sat} + x_{2}P_{2}^{sat}$$

which can be re-written (because we are in a binary mixture) as:

$$P = x_{1}P_{1}^{sat} + \left(1-x_{1}\right)P_{2}^{sat}$$

"""

# ╔═╡ 9e171e7c-953d-4a75-b6f6-cbae930dd1ab
md"""

#### Solve for $x_{1}$ and $x_{2}$:

We can re-arrange the pressure expression to solve for $x_{1}$:

$$x_{1} = \frac{P - P_{2}^{sat}}{P_{1}^{sat} -  P_{2}^{sat}}$$

"""

# ╔═╡ 8e13e386-6fbc-4bdf-8eed-de5bd35247da
# compute P1sat -
P1_sat = exp(15 - (3010)/(T+250))

# ╔═╡ 45a8e5fc-0929-496b-b01a-0e6f27f8b457
# compute P2sat (units: kPa)
P2_sat = exp(14 - (2700)/(T+205))

# ╔═╡ 2bd63a06-0eb6-4e4e-b2b0-78b0ac87e341
# solve for x₁:
x₁ = (P - P2_sat)/(P1_sat - P2_sat)

# ╔═╡ 6b3bcfa8-7487-4f84-abbe-185939d91a80
x₂ = 1 - x₁

# ╔═╡ 50a0b336-e14c-487a-9ba5-25a0024d9766
md"""
#### Solve for $y_{1}$ and $y_{2}$:

Once we have the liquid phase composition, we can use the fugacity matching condition to relate the liquid phase and the vapr phase becuase we have asssumed they are in equilibrium i.e., 

$$y_{i} = x_{i}\left(\frac{P_{i}^{sat}}{P}\right)\qquad{i=1,2}$$

"""

# ╔═╡ 7608d2c9-eb24-4db1-9fb3-452d52770e17
# solve for y₁:
y₁ = x₁ * (P1_sat/P)


# ╔═╡ 76f6cf32-8f87-4df0-b1db-a51ee102f709
# solve for y₂:
y₂ = x₂* (P2_sat/P)

# ╔═╡ ec5378ba-ca2c-4d31-b176-454b2cd99302
md"""

#### Solve for $\hat{L}$ and $\hat{V}$:

Now that we have the composition values in the exit streams, we can use the total mol and species mol balances to estimate the fraction 
of the input feed that exited the unit as liquid $\hat{L}$ and vapur $\hat{V}$. If we divide both sides of the species mol balance by $\dot{F}$ we get the relationship:

$$z_{i} = \hat{L}x_{i}+\hat{V}y_{i}\qquad{i=1,2}$$

which we can use (along with the total mol balances) to solve for $\hat{L}$ and $\hat{V}$ i.e., 

$$\begin{eqnarray}
\hat{L}x_{1}+\hat{V}y_{1} &=& z_{1} \\
\hat{L}+\hat{V} &=& 1
\end{eqnarray}$$

This is a system of 2-equations and 2-unknowns ($\hat{L}$ and $\hat{V}$) that can be solved by substitution or by linear algebra. 

###### Approach 1: Old school subsitution/elimination approach:

Let's rearrange the total mol expression to get $\hat{L}$ in terms of $\hat{V}$:

$$\hat{L} = 1 - \hat{V}$$

which can be subsituted into the species mol balance (let's use component 1):

$$z_{1} = \left(1 - \hat{V}\right)x_{1}+\hat{V}y_{1}$$

and solved for $\hat{V}$:

$$\hat{V} = \frac{z_{1} - x_{1}}{y_{1} - x_{1}}$$

Once we have $\hat{V}$, we can compute $\hat{L}$ from the total mol balance.
"""

# ╔═╡ bb56b509-5279-40f5-b898-e8c1b29dfb5e
# compute Vhat -
Vhat = (z₁ - x₁)/(y₁ - x₁)

# ╔═╡ 3f13e0a8-b58b-4ac7-899b-412154acf0cb
# what is Lhat -
Lhat = 1 - Vhat

# ╔═╡ 745177ba-a88d-496d-b0f6-2e9aca506866
md"""
###### Approach 2: Fancy linear algebra approach:

We can rewrite the 2$\times$2 system of equations into matrix-vector form and then compute the matrix inverse. In particlar, 
the species and total mass balances for component 1 can be written as:

$$\begin{pmatrix}
x_{1} & y_{1} \\
1 & 1 
\end{pmatrix}
\begin{pmatrix}
\hat{L} \\
\hat{V}
\end{pmatrix} = 
\begin{pmatrix}
z_{1} \\
1
\end{pmatrix}$$

which is the form $\mathbf{A}\mathbf{x} = \mathbf{b}$, where the solution takes the form: $\mathbf{x} = \mathbf{A}^{-1}\mathbf{b}$.


"""

# ╔═╡ 4c0a79c3-87b4-4452-ba9e-0de5bd324ac5
# setup A -
A = [x₁ y₁ ; 1 1]

# ╔═╡ a835ed0a-a2d0-4a5b-a8a0-dffd7250e34b
# setup b -
bV = [z₁ ; 1]

# ╔═╡ 2bf7b85f-3118-4fa9-842d-f2c9f3d16dce
# compute the unknown (fractions of L and V)
x = inv(A)*bV

# ╔═╡ b091bbb6-13ce-4b1f-b36b-9964783767d4
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
# ╠═64af17f4-c632-425c-a101-9dfa5e8cbd84
# ╟─35dd2eca-2446-11ec-1de6-0feeace9d4f7
# ╟─92ff1f65-d717-47a8-9cd3-af71c2855210
# ╠═98e43733-8711-4aa4-9081-697dd8865592
# ╟─792e101b-e736-46d2-bbf3-a1197a0cc654
# ╟─9e171e7c-953d-4a75-b6f6-cbae930dd1ab
# ╠═8e13e386-6fbc-4bdf-8eed-de5bd35247da
# ╠═45a8e5fc-0929-496b-b01a-0e6f27f8b457
# ╠═2bd63a06-0eb6-4e4e-b2b0-78b0ac87e341
# ╠═6b3bcfa8-7487-4f84-abbe-185939d91a80
# ╟─50a0b336-e14c-487a-9ba5-25a0024d9766
# ╠═7608d2c9-eb24-4db1-9fb3-452d52770e17
# ╠═76f6cf32-8f87-4df0-b1db-a51ee102f709
# ╟─ec5378ba-ca2c-4d31-b176-454b2cd99302
# ╠═bb56b509-5279-40f5-b898-e8c1b29dfb5e
# ╠═3f13e0a8-b58b-4ac7-899b-412154acf0cb
# ╟─745177ba-a88d-496d-b0f6-2e9aca506866
# ╠═4c0a79c3-87b4-4452-ba9e-0de5bd324ac5
# ╠═a835ed0a-a2d0-4a5b-a8a0-dffd7250e34b
# ╠═2bf7b85f-3118-4fa9-842d-f2c9f3d16dce
# ╟─b091bbb6-13ce-4b1f-b36b-9964783767d4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
