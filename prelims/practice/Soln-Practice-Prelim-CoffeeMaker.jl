### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 458f9f6e-2c17-11ec-08fe-d92011537eff
begin
	using PlutoUI
end

# ╔═╡ 56ff08ee-dcba-4aae-971a-5eec10a5d8c2
md"""
#### Solution: Coffee Maker Problem
"""

# ╔═╡ 28054bbb-cf38-403f-a563-c8a79551c950
md"""$(PlutoUI.LocalResource("./figs/Fig-CoffeeMaker-Problem-P1.png"))"""

# ╔═╡ 3e6a3f82-70fd-4692-8779-9d43f41947a2
begin
	
	# setup problem -
	m_3_dot = 0.5 	# units: kg/min
	m_4_dot = 0.36 	# units: kg/min
	α = 0.25 	 	# units: dimensionless
	H₁ = 104.5 		# units: kJ/kg
	H₂ = 283.5 		# units: kJ/kg
	H₃ = 168.5 		# units: kJ/kg
	H₄ = 722.4 		# units: kJ/kg
	m_coffee = 0.5 	# units: kg
	
	# show -
	nothing
end

# ╔═╡ cfad92dc-25e1-4d45-b94d-9c83888e3695
md"""
a) Determine the flow rate of coffee beans ($\dot{m}_{2}$) and water ($\dot{m}_{1}$) required to make a good cup of coffee (requirement: $\dot{m}_2$ = 1/4$\dot{m}_{1}$).

Start by applying the total mass balance at steady state:

$$\sum_{s=1}^{\mathcal{S}}v_{s}\dot{m}_{s} = 0$$

to the mixer grinder unit:

$$\dot{m}_{1}+\dot{m}_{2} = \dot{m}_{3}$$

In addition to the total mass balance, we also know that $\dot{m}_2$ = 1/4$\dot{m}_{1}$, thus we have two equations and two unknowns which we can solve for $\dot{m}_{1}$ and $\dot{m}_{2}$. You can do this via subsutitution, or by setting a a matrix inversion.

_Substitution approach_: Substitute $\dot{m}_{2}$ = $\alpha\dot{m}_{1}$ into the total mass balance and solve for $\dot{m}_{1}$:

$$\dot{m}_{1} = \frac{\dot{m}_{3}}{1+\alpha}$$

_Matrix vector approach_: We can solve for $\dot{m}_{1}$ and $\dot{m}_{2}$ by setting up the mass balance and coffee requirement as a 2$\times$2 system of equations:

$$\begin{pmatrix}
1 & 1 \\
-\alpha & 1
\end{pmatrix}
\begin{pmatrix}
\dot{m}_{1} \\
\dot{m}_{2} 
\end{pmatrix} = 
\begin{pmatrix}
\dot{m}_{3} \\
0
\end{pmatrix}$$

which is in the form $\mathbf{A}\mathbf{x}$=$\mathbf{b}$. We can compute the matrix
inverse $\mathbf{A}^{-1}$ to estimate $\mathbf{x}.

"""

# ╔═╡ 36a54cd9-d496-4066-872f-311fb1eba987
begin
	
	# subsitution method -
	m_1_dot = (m_3_dot)/(1+α)
	m_2_dot = α * m_1_dot

	# show -
	with_terminal() do
		println("m_1_dot = $(m_1_dot) and m_2_dot = $(m_2_dot)")
	end
end

# ╔═╡ dbe9f642-feca-4d4e-8cb9-1c851066863d
begin
	
	# matrix vector solution for m1 and m2 -
	A = [1 1 ; -α 1];
	b = [m_3_dot ; 0];

	# compute -
	x = inv(A)*b
end

# ╔═╡ ea96f2e5-1e4d-43e8-a9ef-a5f0af703349
md"""
b) Because he can’t plug the coffee maker in, he has to generate power to mix/grind the beans and water. What is the rate of work $\dot{W}_{sh}$ that he must supply to the mixer/grinder if this unit is well insulated?

To estimate the rate of shaft work $\dot{W}_{sh}$, we need to use the open energy balance equation at steady-state:

$$\dot{Q}+\dot{W}_{sh}+\sum_{s=1}^{\mathcal{S}}v_{s}\dot{m}_{s}H_{s} = 0$$

We know from the problem that $\dot{Q}$ = 0, thus we can solve the open energy balance to give an expression for the shaft work:

$$\dot{W}_{sh} = \dot{m}_{3}H_{3} - \left(\dot{m}_{1}H_{1} + \dot{m}_{2}H_{2}\right)$$

You already solved for the mass flow rates $\dot{m}_{i}$, and the enthalpy of each stream is given in the problem, thus, we know everything we need to solve for the work required to grind the beans.

"""

# ╔═╡ a3882553-e45f-49a9-8399-9adaaf02a9e7
W_dot_sh = m_3_dot*H₃ - (m_1_dot*H₁ + m_2_dot*H₂)

# ╔═╡ ff263509-d5a8-4227-898b-67491b99bf51
md"""
c) Prof. V loves high enthalpy coffee! In fact, he refuses to drink coffee unless the enthalpy content is between 475 kJ/kg $\leq{H_{5}}\leq$ 500 kJ/kg. What is the minimum and maximum rate of heat input to the brewer/separator that must be supplied to meet this completely reasonable criteria?

To estimate the heat input into the brewer/separator, we need to estimate $\dot{m}_{5}$ (using a total mass balance around the brewer) and then solve for $\dot{Q}$ of the brewer unit using an open energy balance.

Again, we could do solve using algebra and substitution (first find $\dot{m}_{5}$ using the total mass balance, then find $\dot{Q}$ using the open energy balance). However, I'm lazy (and I'm running out of time to post these solutions!) so I'm going to setup the solution as a matrix vector problem, and then invert the matrix:

$$\begin{pmatrix}
-1 & 0 \\
-H_{5} & 1
\end{pmatrix}
\begin{pmatrix}
\dot{m}_{5}\\
\dot{Q}
\end{pmatrix} = 
\begin{pmatrix}
\dot{m}_{4} - \dot{m}_{3} \\
\dot{m}_{4}H_{4} - \dot{m}_{3}H_{3}
\end{pmatrix}$$

We can solve the problem twice: once for $H_{5}$ = 475 kJ/kg and again for $H_{5}$ = 500 kJ/kg, this will give us the $\dot{Q}$ range (I'll show the calcultion for the lower bound).

"""

# ╔═╡ 6fff5dba-e6e0-42e8-a06d-519fa582695e
begin
	
	# Setup -
	H₅ = 475.0 	# units: kJ/kg
	
	# setup matrix vector form Ax = b, the find x = A^{-1}b
	Ac = [-1 0; -H₅ 1];
	bc = [m_4_dot - m_3_dot ; m_4_dot*H₄ - m_3_dot*H₃];
	
	# solve -
	xc = inv(Ac)*bc
	
	# split -
	m_5_dot = xc[1]
	Qdot = xc[2]
	
	(m_5_dot, Qdot)
end

# ╔═╡ 2387358c-ee90-4594-9023-b03a51867745
md"""
d) Prof. V has five minutes to make coffee before class starts, did he make it in time (1 cup of coffee is $\simeq$ 0.5 kg)?

To estimate the time, we need to write a total mass balance around the coffee cup, however, the coffee cup will __not__ be at steady-state, this we have:

$$\frac{dm}{dt} = \dot{m}_{5}$$

where $m$ denotes the mass of coffee in the cup, and $t$ denotes time. Let's treat the derivative as an infinitesimal, and rearrange the mass balance as:

$$dm = \dot{m}_{5}dt$$

Next, we can integrate both sides (given that $\dot{m}_{5}$ is constant) between an initial point $t_{1}$ (when the cup is empty, define $t_{1}$ = 0) and someother point in time $t_{2}$:

$$m_{2} = m_{1} + \dot{m}_{5}\left(t_{2} - t_{1}\right)$$

However, at $t_{1}$ = 0, we know that the cup is empty, so $m_{1}$ = 0. Thus, we can rearrange and solve for $t_{2}$:

$$t_{2} = \frac{m_{2}}{\dot{m}_{5}}$$

"""

# ╔═╡ cf7f585a-29a0-4df6-a2a1-dd40dd8a9cf0
t₂ = m_coffee/(m_5_dot)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

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
# ╟─56ff08ee-dcba-4aae-971a-5eec10a5d8c2
# ╟─28054bbb-cf38-403f-a563-c8a79551c950
# ╠═3e6a3f82-70fd-4692-8779-9d43f41947a2
# ╟─cfad92dc-25e1-4d45-b94d-9c83888e3695
# ╠═36a54cd9-d496-4066-872f-311fb1eba987
# ╠═dbe9f642-feca-4d4e-8cb9-1c851066863d
# ╟─ea96f2e5-1e4d-43e8-a9ef-a5f0af703349
# ╠═a3882553-e45f-49a9-8399-9adaaf02a9e7
# ╟─ff263509-d5a8-4227-898b-67491b99bf51
# ╠═6fff5dba-e6e0-42e8-a06d-519fa582695e
# ╟─2387358c-ee90-4594-9023-b03a51867745
# ╠═cf7f585a-29a0-4df6-a2a1-dd40dd8a9cf0
# ╠═458f9f6e-2c17-11ec-08fe-d92011537eff
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
