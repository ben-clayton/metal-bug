#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetalBug : NSObject
- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)prepareData;
- (void)sendComputeCommand;
@end

NS_ASSUME_NONNULL_END
