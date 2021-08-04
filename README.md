# Example project of a Metal shader compiler bug

## Building

```bash
mkdir build
cmake ..
make
```

## Running

The bug can be reproduced with:

```bash
cd build # if you're not in ./build already
MTL_SHADER_VALIDATION=0 ./metal-bug
```
The bug can be worked around by either:

* Running with `MTL_SHADER_VALIDATION=1`.
* Changing `INDEX_WITH_CLAMPING` in `shader.metal` to `0`
* Inlining the arrays in the `tint_array_wrapper` structures.
