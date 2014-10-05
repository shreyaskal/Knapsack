//
//  Crypto.h
//  Knapsack
//
//  Created by Shreyas Kalyan on 10/4/14.
//  Copyright (c) 2014 Shreyas Kalyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface Crypto : NSObject

- (NSString*) sha256HashFor:(NSString*)input;

@end
