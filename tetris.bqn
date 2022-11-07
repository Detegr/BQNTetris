pieces ← [1‿1‿1‿1⋄0‿0‿0‿0]‿[1‿0‿0⋄1‿1‿1]‿[0‿0‿1⋄1‿1‿1]‿[1‿1⋄1‿1]‿[0‿1‿1⋄1‿1‿0]‿[1‿1‿0⋄0‿1‿1]‿[0‿1‿0⋄1‿1‿1]
x ← 3 ⋄ y ← r ← 0                            # x, y, rotation
sz ← 20‿10 ⋄ pcs ← sz⥊0                      # Field size, placed pieces
pc ← •rand.Range ≠pieces                     # Current piece index
P ← {sz↑⍉∘⌽⍟(4|𝕨) (𝕩+1)×𝕩⊑pieces}            # Field with piece index 𝕩 placed to 0,0, rotated 𝕨 times to left
M ← {y‿x𝕊p:                                  # Move piece to 𝕨 (y,x)
  Sy‿Sx ← {𝕩◶«‿»}¨>⟜0 y‿x
  Sy⍟y (Sx⌾⍉)⍟(|x) p
}
g ← y‿x M r P pc                             # Initial game state
FL ← ×∧˝˘                                    # Full lines
RL ← ∾·0⊸×⌾⊑·¬∘FL⊸⊔⊢                         # Remove full lines and shift the field down
Refresh ← {𝕊: g↩y‿x M r P pc}                # Refresh game state to current position
Init ← {𝕊:                                   # Initialize game state for new piece
  y↩r↩0 ⋄ x↩3
  pcs+↩g ⋄ pcs RL↩
  pc↩•rand.Range ≠pieces
}
Ok ← 4⊸=·+´+˝∘× ∧ {¬× +´+˝ 2⊸≤ pcs+○×𝕩}     # Check if game state 𝕩 is valid
Rst ⇐ {𝕊: Init@ ⋄ Refresh@ ⋄ pcs↩sz⥊0}       # Reset game state (new game)
End ⇐ {𝕊: ¬Ok g}                             # Check if the game is over
Drop ← {𝕊: Ok (y+𝕩)‿x M r P pc ? 𝕊𝕩+1 ; 𝕩-1} # Return the amount of squares needed to drop the piece to the bottom
KH ⇐ {𝕊nr‿nx‿ny‿d:                           # Key handler
  nr‿nx‿ny+↩r‿x‿(y + Drop⍟d 0)
  wg ← ny‿nx M nr P pc                       # Wanted game state
  {𝕊: r‿x‿y↩nr‿nx‿ny ⋄ Refresh@}⍟Ok wg       # Update game state if wanted game state is valid
}
GameState ⇐ {𝕊: g+pcs}
Step ⇐ {𝕊:
  next ← (y+↩1)‿x M r P pc                   # Next game state
  valid ← Ok next
  Init⍟¬ valid                               # Init new piece if next game state is invalid
  Refresh@ ⋄ valid                           # Update game state, return 1 if the step was valid, 0 otherwise
}
