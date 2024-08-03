//
//  SPTransFormAddress.h
//  EasePeso
//
//  Created by apple on 2024/4/12.
//

#import <Foundation/Foundation.h>
#import <BRPickerView/BRPickerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPTransFormAddress : NSObject
/// 地址
+ (NSArray <BRProvinceModel *>*)fetchProvinceModelArr:(NSArray *)dataSourceArr;

@end

NS_ASSUME_NONNULL_END
