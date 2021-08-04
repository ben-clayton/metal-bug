# Example project of a Metal shader compiler bug

## Reproduced on:

```
 Big Sur 11.5.1 (20G80)
 Model Name: MacBook Pro
 Model Identifier: MacBookPro16,1
 Processor Name: 8-Core Intel Core i9
```

## Building

```bash
mkdir build
cmake ..
make
```

## Running

The bug can be reproduced on a AMD Radeon Pro 5500M with:

```bash
cd build # if you're not in ./build already
MTL_SHADER_VALIDATION=0 ./metal-bug
```

Which will give the output:

```
2021-08-04 16:29:03.392 metal-bug[57948:563874] Failed to created pipeline state object, error Error Domain=CompilerError Code=2 "Compiler encountered an internal error" UserInfo={NSLocalizedDescription=Compiler encountered an internal error}.
```

The bug can be worked around by either:

* Running with `MTL_SHADER_VALIDATION=1`.
* Changing `INDEX_WITH_CLAMPING` in `shader.metal` to `0`
* Inlining the arrays in the `tint_array_wrapper` structures.
* Using an Intel GPU device
