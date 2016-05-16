
#import "PayController.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation PayController


+(void)payWithString:(NSString *)payStr Block:(void (^)(NSString *))block{
    NSString *appScheme = @"zhifubaoPay";
    [[AlipaySDK defaultService] payOrder:payStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (resultDic[@"resultStatus"]) {
            NSString* result =[NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
            if (block) {
                block(result);
            }
        }
    }];



}

@end
