### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ bd0378cb-ca70-4803-b5fc-7bd08ad1b9f3
md"""
#### Practice Problem: Multiple Chemical Reactions in a Single CSTR

Component $A$ is converted to $B$ (desired product) and $C$ (undesired product) in single well-mixed continuous stirred tank reactor (CSTR) with a single input and output and the following reaction chemistry: 

$$\begin{eqnarray}
\hat{r}_{1}: A &\rightleftharpoons& B\\
\hat{r}_{2}: A &\rightleftharpoons& C\\
\end{eqnarray}$$

The substrate $A$ (component 1) is supplied to the reactor at 10 mol/hr, where the input stream has a volumetric flow rate of $\dot{F}_{1}$ = 2 L/hr. The fractional conversion of $A$ was measured and found to be equal to 70%. Lastly, the extent of the desired reaction was estimated to $\dot{\epsilon}_{1}$ = 1.5 mol/hr. 

__Assumptions__:
* The CSTR is well-mixed, operating at steady-state, and has a constant volume V = 14L
* The CSTR has a single input stream and a single output stream
* Neither of the chemical reactions occur in the streams
* There is no $B$ or $C$ in the input stream

__Compute__:
* The chemical reaction rate(s) $\hat{r}_{1}$ and $\hat{r}_{2}$
* The mol flow rates of all components in the CSTR exit stream
* If $\hat{r}_{1}$ and $\hat{r}_{2}$ are irreversible, and first-order in $A$, compute the forward rate constants $k_{1}$ and $k_{2}$ for reaction 1 and 2, respectively. 

"""

# ╔═╡ 4bab103c-3d4b-11ec-1ceb-9566ca26ce6b
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

# ╔═╡ Cell order:
# ╟─bd0378cb-ca70-4803-b5fc-7bd08ad1b9f3
# ╟─4bab103c-3d4b-11ec-1ceb-9566ca26ce6b
