#define INDEX_WITH_CLAMPING 1

#include <metal_stdlib>

using namespace metal;
struct Result {
  /* 0x0000 */ uint value;
};
struct tint_array_wrapper {
  uint arr[10];
};
struct tint_array_wrapper_1 {
  float arr[3];
};
struct S {
  tint_array_wrapper startCanary;
  tint_array_wrapper_1 data;
  tint_array_wrapper endCanary;
};

#if INDEX_WITH_CLAMPING
#define INDEX(i) min(i, 9u)
#else
#define INDEX(i) i
#endif

uint runTest() {
  S s = {};
  for(uint i = 0u; (i < 10u); i = (i + 1u)) {
    s.startCanary.arr[INDEX(i)] = 4294967295u;
    s.endCanary.arr[INDEX(i)] = 4294967295u;
  }
  s.data.arr[0] = float();
  for(uint i = 0u; (i < 10u); i = (i + 1u)) {
    if ((s.startCanary.arr[INDEX(i)] != 4294967295u)) {
      return s.startCanary.arr[INDEX(i)];
    }
    if ((s.endCanary.arr[INDEX(i)] != 4294967295u)) {
      return s.endCanary.arr[INDEX(i)];
    }
  }
  return 0u;
}

kernel void entrypoint(device Result& result [[buffer(0)]]) {
  result.value = runTest();
  return;
}
