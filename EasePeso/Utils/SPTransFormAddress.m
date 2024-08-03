//
//  SPTransFormAddress.m
//  EasePeso
//
//  Created by apple on 2024/4/12.
//

#import "SPTransFormAddress.h"

@implementation SPTransFormAddress

+ (NSArray <BRProvinceModel *>*)fetchProvinceModelArr:(NSArray *)dataSourceArr {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in dataSourceArr) {
        BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
        proviceModel.code = [NSString stringWithFormat:@"%@", [proviceDic objectForKey:@"hateful"]];
        proviceModel.name = [proviceDic objectForKey:@"ilove"];
        proviceModel.index = [dataSourceArr indexOfObject:proviceDic];
        NSArray *cityList = [proviceDic objectForKey:@"indulgent"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in cityList) {
            BRCityModel *cityModel = [[BRCityModel alloc]init];
            cityModel.code = [NSString stringWithFormat:@"%@", [cityDic objectForKey:@"hateful"]];
            cityModel.name = [cityDic objectForKey:@"ilove"];
            cityModel.index = [cityList indexOfObject:cityDic];
            NSArray *areaList = [cityDic objectForKey:@"indulgent"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in areaList) {
                BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                areaModel.code = [NSString stringWithFormat:@"%@", [areaDic objectForKey:@"hateful"]];
                areaModel.name = [areaDic objectForKey:@"ilove"];
                areaModel.index = [areaList indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    return [tempArr1 copy];
}
@end
