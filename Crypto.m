//
//  Crypto.m
//  Knapsack
//
//  Created by Shreyas Kalyan on 10/4/14.
//  Copyright (c) 2014 Shreyas Kalyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Crypto.h"

@implementation Crypto : NSObject

-(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end