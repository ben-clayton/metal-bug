#import "MetalBug.h"

@implementation MetalBug {
    id<MTLDevice> device_;
    id<MTLComputePipelineState> pipeline_state_;
    id<MTLCommandQueue> command_queue_;
    id<MTLBuffer> result_;
}

- (instancetype) initWithDevice: (id<MTLDevice>) device {
    self = [super init];
    if (self) {
        device_ = device;

        NSError* error = nil;
        id<MTLLibrary> library = [device_ newLibraryWithFile:@"shader.metallib" error:&error];

        if (library == nil) {
            NSLog(@"Failed to load the library");
            return nil;
        }

        id<MTLFunction> entrypoint = [library newFunctionWithName:@"entrypoint"];
        if (entrypoint == nil) {
            NSLog(@"Failed to find the entrypoint function");
            return nil;
        }

        // Create a compute pipeline state object.
        pipeline_state_ = [device_ newComputePipelineStateWithFunction: entrypoint error:&error];
        if (pipeline_state_ == nil) {
            NSLog(@"Failed to created pipeline state object, error %@.", error);
            return nil;
        }

        command_queue_ = [device_ newCommandQueue];
        if (command_queue_ == nil) {
            NSLog(@"Failed to create the command queue.");
            return nil;
        }
    }

    return self;
}

- (void) prepareData {
    // Allocate three buffers to hold our initial data and the result.
    result_ = [device_ newBufferWithLength:4 options:MTLResourceStorageModeShared];
}

- (void) sendComputeCommand {
    // Create a command buffer to hold commands.
    id<MTLCommandBuffer> commandBuffer = [command_queue_ commandBuffer];
    assert(commandBuffer != nil);

    // Start a compute pass.
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    assert(computeEncoder != nil);

    [self encodeAddCommand:computeEncoder];

    // End the compute pass.
    [computeEncoder endEncoding];

    // Execute the command.
    [commandBuffer commit];

    // Normally, you want to do other work in your app while the GPU is running,
    // but in this example, the code simply blocks until the calculation is complete.
    [commandBuffer waitUntilCompleted];

    [self verifyResults];
}

- (void)encodeAddCommand:(id<MTLComputeCommandEncoder>)computeEncoder {
    // Encode the pipeline state object and its parameters.
    [computeEncoder setComputePipelineState:pipeline_state_];
    [computeEncoder setBuffer:result_ offset:0 atIndex:0];

    MTLSize gridSize = MTLSizeMake(1, 1, 1);
    MTLSize threadgroupSize = MTLSizeMake(1, 1, 1);

    // Encode the compute command.
    [computeEncoder dispatchThreads:gridSize
              threadsPerThreadgroup:threadgroupSize];
}

- (void) verifyResults {
    uint32_t* result = result_.contents;
    printf("Result: result=%d\n", result[0]);
}
@end
