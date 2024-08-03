//
//  SPMemory.m
//  EasePeso
//
//  Created by apple on 2024/3/29.
//

#import "SPMemory.h"
#import <mach/mach.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation SPMemory

+ (uint64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}

// 获取当前可用内存
+ (long long)getAvailableMemorySize {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}
 

+ (NSString *)innerIPAdress {
   NSString *innerAddress = @"";
   struct ifaddrs *interfaces = NULL;
   struct ifaddrs *temp_addr = NULL;
   int success = 0;
   
   success = getifaddrs(&interfaces);
   
   if (success == 0) { // 0 表示获取成功
       temp_addr = interfaces;
       while (temp_addr != NULL) {
           if( temp_addr->ifa_addr->sa_family == AF_INET) {
               // 判断是否是wifi连接
               if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                   // C String 转 NSString
                   innerAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
               }
           }
           temp_addr = temp_addr->ifa_next;
       }
   }
   
   freeifaddrs(interfaces);
   return innerAddress;
}
@end
