pieces ← [1‿1‿1‿1⋄0‿0‿0‿0]‿[1‿0‿0⋄1‿1‿1]‿[0‿0‿1⋄1‿1‿1]‿[1‿1⋄1‿1]‿[0‿1‿1⋄1‿1‿0]‿[1‿1‿0⋄0‿1‿1]‿[0‿1‿0⋄1‿1‿1]
x ← y ← r ← 0                          # x, y, rotation
sz ← 20‿10                             # Field size
pcs ← sz⥊0                             # Placed pieces
pc ← •rand.Range ≠pieces               # Current piece index
P ← {sz↑⍉∘⌽⍟(4|𝕨) 𝕩⊑pieces}            # Field with piece index 𝕩 placed to 0,0, rotated 𝕨 times to left
M ← {y‿x𝕊p:                            # Move piece to 𝕨 (y,x)
  Sy‿Sx ← {𝕩◶«‿»}¨>⟜0 y‿x
  Sy⍟y (Sx⌾⍉)⍟(|x) p
}
g ← y‿x M r P pc                       # Initial game state
FL ← ¬∧˝˘                              # Full lines
RL ← ∾·0⊸×⌾⊑·FL⊸⊔⊢                     # Remove full lines and shift the field down
Refresh ← {𝕊: g↩y‿x M r P pc}          # Refresh game state to current position
Init ← {𝕊:                             # Initialize game state for new piece
  x↩y↩r↩0
  pcs+↩g ⋄ pcs RL↩
  pc↩•rand.Range ≠pieces
}
Ok ← 4⊸=·+´+˝ ∧ {¬× +´+˝ 2≤pcs+𝕩}      # Check if game state 𝕩 is valid
Rst ⇐ {𝕊: Init@ ⋄ Refresh@ ⋄ pcs↩sz⥊0} # Reset game state (new game)
End ⇐ {𝕊: ¬Ok g}                       # Check if the game is over
KH ⇐ {𝕊nr‿nx‿ny:                       # Key handler
  nr‿nx‿ny+↩r‿x‿y
  wg ← ny‿nx M nr P pc                 # Wanted game state
  {𝕊: r‿x‿y↩nr‿nx‿ny ⋄ Refresh@}⍟Ok wg # Update game state if wanted game state is valid
}
GameState ⇐ {𝕊: g+pcs}
Step ⇐ {𝕊:
  next ← (y+↩1)‿x M r P pc             # Next game state
  Init⍟¬ Ok next                       # Init new piece if next game state is invalid
  Refresh@                             # Update game state
}
