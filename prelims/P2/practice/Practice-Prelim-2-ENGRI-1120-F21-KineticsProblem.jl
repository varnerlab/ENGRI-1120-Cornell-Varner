### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ 2bb195db-311f-4191-95a1-04d6a4b75d74
md"""
#### Practice Problem: Some interesting nuggets about equilibrium and kinetics

a) Starting from the mass-action kinetic expression for the _net_ rate of reaction of $j$ denoted by $\hat{r}_{j}$:

$$\hat{r}_{j} = k^{+}_{j}\prod_{i\in\mathcal{M}^{+}}\left[X_{i}\right]^{-\sigma_{ij}} - 
k^{-}_{j}\prod_{i\in\mathcal{M}^{-}}\left[X_{i}\right]^{-\sigma_{ij}}$$ show that equilibrium constant for reaction $j$, denoted by $K_{j}$, equals:

$$K_{j} = \frac{k_{j}^{+}}{k_{j}^{-}}$$ 

where $\left[X_{i}\right]$ denotes the concetration of component $i$, $k_{j}^{+}$ denotes the forward rate constant, $k_{j}^{+}$ denotes the backward rate constant, $i\in\mathcal{M}^{+}$ denotes the indicies of the reactants for the forward reaction, and $i\in\mathcal{M}^{-}$ denotes the indicies of the reactants in the reverse direction for reaction $j$. The quantity $\sigma_{ij}$ denotes the stoichiometric coefficient governing the behavior of component $i$ in reaction $j$. 

b) If $k_{j}^{-}\rightarrow{0}$, what does that say about the $\Delta{G}$ of the reaction $j$?

c) Can chemical equilibrium occur in an _open_ system? Explain your answer in terms of an open system at steady-state with a single in/out stream, and the reaction $A\rightleftharpoons{B}$, versus a closed system with the same reaction.

d) If we gave you concentration measurements for $A$ as a function of time at different temperatures for a closed system in which the reaction $A\rightleftharpoons{B}$ was occurring, explain how you would use it to compute rate constants, activation energies, frequency factors, etc, assuming the kinetics were first-order? 

"""

# ╔═╡ 40f90c69-76c9-41fa-9fe5-2c3410d6bc43
md"""
#### Solutions
"""

# ╔═╡ cf9767ca-133c-4322-959d-3eb680013f63
md"""
###### a) Starting from the mass-action kinetic expression for the _net_ rate of reaction of $j$ denoted by $\hat{r}_{j}$:

$$\hat{r}_{j} = k^{+}_{j}\prod_{i\in\mathcal{M}^{+}}\left[X_{i}\right]^{-\sigma_{ij}} - 
k^{-}_{j}\prod_{i\in\mathcal{M}^{-}}\left[X_{i}\right]^{-\sigma_{ij}}$$ show that equilibrium constant for reaction $j$, denoted by $K_{j}$, equals:

$$K_{j} = \frac{k_{j}^{+}}{k_{j}^{-}}$$ 

At equilibrium, the _net rate_ of all reversible reactions is zero $\hat{r}_{j} = 0$. Thus,

$$k^{+}_{j}\prod_{i\in\mathcal{M}^{+}}\left[X_{i}\right]^{-\sigma_{ij}} = k^{-}_{j}\prod_{i\in\mathcal{M}^{-}}\left[X_{i}\right]^{-\sigma_{ij}}$$

of after some rearrangement:

$$\frac{k_{j}^{+}}{k_{j}^{-}} = \frac{\prod_{i\in\mathcal{M}^{-}}\left[X_{i}\right]^{-\sigma_{ij}}}{\prod_{i\in\mathcal{M}^{+}}\left[X_{i}\right]^{-\sigma_{ij}}}$$

The right-hand side of this expression is the product concentrations divided by the reactant concentrations , which is the equilibrium constant you've developed in your chemistry courses. Thus:

$$\frac{k_{j}^{+}}{k_{j}^{-}}=K_{j}$$ 

"""

# ╔═╡ bd2184c1-a656-4e54-9f0d-fcc9009e4b04


# ╔═╡ 64a749bc-423b-413a-afb3-c4e32d53da04
md"""
###### b) If $k_{j}^{-}\rightarrow{0}$, what does that say about the $\Delta{G}$ of the reaction $j$?

As the rate of the back reaction goes to zero, the reaction becomes irreversible. To link this to $\Delta{G}$ of the reaction, we know that:

$$\Delta{G} = -RT\ln{K}$$ 

or (after substitution) of the ratio of rate constants:

$$\Delta{G} = -RT\ln\left({\frac{k_{j}^{+}}{k_{j}^{-}}}\right)$$

As $k_{j}^{-}\rightarrow{0}$ the $\Delta{G}\rightarrow{-\infty}$, thus reaction becomes incresingly energetically favorable.  

"""

# ╔═╡ 9abaaaaa-8bfb-45a2-8da2-c53e7310ba0a


# ╔═╡ 36bf5490-13b5-4da8-8ef9-00e519983c11
md"""
###### c) Can chemical equilibrium occur in an open system? 

Open an system can reach steady-state, but equilibrium has the additional constraint that all net reactions are equal to zero. Thus, let's consider the case when we have a CSTR with a single input ($s=1$) and a single output ($s=2$) and a reversible single reaction $\hat{r}_{1}$. The species mole balance for component $i$ would be:

$$\dot{n}_{i1} - \dot{n}_{i2} + \sigma_{i1}\hat{r}_{1}V = 0$$

If an open system were at equilibrium (as opposed to steady-state), then $\hat{r}=0$ which implies:

$$\dot{n}_{i1} = \dot{n}_{i2}$$

which is clearly not true in general. Thus, an open system can not reach equilibrium, but rather operates at a steady-state.

"""

# ╔═╡ 85eaab6b-b7fe-421a-a2e7-f2634b7eca25
md"""
###### d) Estimation of kinetic parameters from data

If we have a closed system, we could wait until the system reached equilibrium and then get the ratio of the rate constants from the value of the equilibrium constant. 

Next, as we approach eqilibrium we could measured the concentration of A (or B) as a function of time. Becuase we are a closed system we know that:

$$\frac{d\left[A\right]}{dt} = -\hat{r}_{1}$$

meaning the slope of an $\left[A\right]$ versus time plot would give the reaction rate. Futher since rate constants are only functions of temperature, we could use _measurements_ of the equilibrium constant, and $\left[A\right]$ and $\left[B\right]$ concentrations at the same temperature $T$ to arrive at something like (when we are near equilibrium):

$$\hat{r}_{1}\simeq k_{1}^{+}\left(\left[A\right] - \frac{\left[B\right]}{K}\right)$$

where $k_{1}^{-} = k_{1}^{+}K^{-1}$ to estimate the forward rate constant. Lastly, to get frequency factor and the activation energy we could use the linearized version of the [Arrhenius equation](https://en.wikipedia.org/wiki/Arrhenius_equation) in combination with the required measurements.

"""

# ╔═╡ 6a67ec88-3d92-11ec-0fca-f5f1f3e769b3
html"""
<style>
main {
    max-width: 1200px;
    width: 75%;
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

# ╔═╡ Cell order:
# ╟─2bb195db-311f-4191-95a1-04d6a4b75d74
# ╟─40f90c69-76c9-41fa-9fe5-2c3410d6bc43
# ╟─cf9767ca-133c-4322-959d-3eb680013f63
# ╟─bd2184c1-a656-4e54-9f0d-fcc9009e4b04
# ╟─64a749bc-423b-413a-afb3-c4e32d53da04
# ╟─9abaaaaa-8bfb-45a2-8da2-c53e7310ba0a
# ╟─36bf5490-13b5-4da8-8ef9-00e519983c11
# ╟─85eaab6b-b7fe-421a-a2e7-f2634b7eca25
# ╟─6a67ec88-3d92-11ec-0fca-f5f1f3e769b3
