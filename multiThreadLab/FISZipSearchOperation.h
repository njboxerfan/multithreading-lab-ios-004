//
//  FISZipSearchOperation.h
//  multiThreadLab
//
//  Created by Bert Carr on 3/19/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISZipCode.h"

@interface FISZipSearchOperation : NSOperation

@property (nonatomic, strong) NSString *searchZipCode;
@property (nonatomic, strong) void(^zipCodeBlock)(FISZipCode *zipCode, NSError *error);

@end
