

#import <Foundation/Foundation.h>

@interface PayController : NSObject
//typedef void(^CompletionBlock)(NSInteger resultStatus);
+(void)payWithString:(NSString* )payStr Block:(void(^)( NSString* resultStatus))block;;
@end
