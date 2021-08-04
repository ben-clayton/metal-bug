#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "MetalBug.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        MetalBug* metal_bug = [[MetalBug alloc] initWithDevice:device];
        [metal_bug prepareData];
        [metal_bug sendComputeCommand];
    }
    return 0;
}
