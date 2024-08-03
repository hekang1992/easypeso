//
//  SPMemory.h
//  EasePeso
//
//  Created by apple on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPMemory : NSObject
+ (uint64_t)memoryUsage;

+ (long long)getAvailableMemorySize;

+ (NSString *)innerIPAdress;
@end

NS_ASSUME_NONNULL_END
