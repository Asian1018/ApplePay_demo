//
//  NSNull+JSON.m
//  colorRun
//
//  Created by zhidian on 16/1/20.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull(JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

//- (NSString *)description { return @"(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key{ return nil; }

- (BOOL)boolValue { return NO; }

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}

@end
