# Positioning

AdicFlux should currently be described as an experimental sorting proposal built from a specific combination of ingredients:

- an order-preserving signed-to-unsigned key transform,
- a weighted inversion energy using a capped 2-adic closeness term,
- a block-local pressure field,
- energy-checked transport proposals,
- and an exact odd-even cleanup stage.

## What the repository should not claim

- It should not claim to be a proved novel algorithmic family.
- It should not claim superiority over standard-library or classical sorts.
- It should not claim that transport alone is sufficient for exactness.

## Nearby families worth comparing carefully

### Comparison sorts

The exact cleanup phase is an odd-even transposition process. That makes comparison-sort behavior an essential part of the current implementation story, even though the transport phase is not a standard comparison-sort heuristic.

### Radix- and bucket-style methods

AdicFlux does not sort by digit passes, bucket population, or counting frequencies. The 2-adic weighting acts as an interaction term inside a comparison-driven energy model rather than as a radix schedule.

### Local-exchange and cellular styles

The block-local pressure and transport phases are closer in spirit to local interaction or relaxation ideas than to textbook partition/merge pipelines. That similarity should be acknowledged when discussing the design, even if the exact weighting and acceptance rules differ.

## Literature-review tasks before stronger language

- survey local-exchange and transposition-based sorting variants,
- survey integer-sorting work that uses bit structure without being radix sort,
- survey energy-minimization or relaxation-inspired sorting proposals,
- document which components are known ideas versus which combinations appear project-specific.

Until that review is done, "experimental algorithm proposal" is the right framing.
