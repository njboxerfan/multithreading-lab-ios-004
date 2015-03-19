//
//  FISZipSearchOperation.m
//  multiThreadLab
//
//  Created by Bert Carr on 3/19/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISZipSearchOperation.h"

@implementation FISZipSearchOperation

-(void) main
{
    NSError *error = [[NSError alloc] init];
    
    FISZipCode *locatedZipCode = [[FISZipCode alloc] init];
    
    BOOL isFound = NO;
    
    NSDictionary *errorZipNotFound = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Zip Code Error", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Couldn't find that zip code", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please try again.", nil)};
    
    NSDictionary *errorZipInvalid = @{
                                      NSLocalizedDescriptionKey: NSLocalizedString(@"Zip Code Error", nil),
                                      NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Zip Codes need to be 5 digits", nil),
                                      NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please re-enter", nil)};
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
    NSString *strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *zipCodeArray = [[strFile componentsSeparatedByString:@"\n"] mutableCopy];
    
    [zipCodeArray removeObjectAtIndex:0];
    
    if ( [self.searchZipCode length] == 5 && [self hasDigits:self.searchZipCode] )
    {
        for ( NSString *zipCode in zipCodeArray )
        {
            NSMutableArray *zipCodeDetails = [[zipCode componentsSeparatedByString:@","] mutableCopy];
            
            NSMutableCharacterSet *alphanumericPlusWhiteSpace = [NSMutableCharacterSet alphanumericCharacterSet];
            
            [alphanumericPlusWhiteSpace formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ( [zipCodeDetails[0] length] > 0 )
            {
                zipCodeDetails[0] = [[zipCodeDetails[0] componentsSeparatedByCharactersInSet:[alphanumericPlusWhiteSpace invertedSet]]objectAtIndex:1];
            }
            
            if ( [zipCodeDetails[0] isEqualToString: self.searchZipCode] )
            {
                isFound = YES;
                
                if ( [zipCodeDetails[1] length] > 0 )
                {
                    locatedZipCode.latitude = [NSString stringWithFormat:@"%@",zipCodeDetails[1]];
                }
                
                if ( [zipCodeDetails[2] length] > 0 )
                {
                    locatedZipCode.longitude = [NSString stringWithFormat:@"%@",zipCodeDetails[2]];
                }
                
                if ( [zipCodeDetails[3] length] > 0 )
                {
                    locatedZipCode.city = [[zipCodeDetails[3] componentsSeparatedByCharactersInSet:[alphanumericPlusWhiteSpace invertedSet]]objectAtIndex:1];
                }
                
                if ( [zipCodeDetails[4] length] > 0 )
                {
                    locatedZipCode.state = [[zipCodeDetails[4] componentsSeparatedByCharactersInSet:[alphanumericPlusWhiteSpace invertedSet]]objectAtIndex:1];
                }
                
                if ( [zipCodeDetails[5] length] > 0 )
                {
                    locatedZipCode.county = [[zipCodeDetails[5] componentsSeparatedByCharactersInSet:[alphanumericPlusWhiteSpace invertedSet]]objectAtIndex:1];
                }
            }
        }
        
        if ( ! isFound )
        {
            locatedZipCode = nil;
            error = [NSError errorWithDomain:@"SearchZipOperation"
                                        code:-72
                                    userInfo:errorZipNotFound];
        }
    }
    else
    {
        locatedZipCode = nil;
        error = [NSError errorWithDomain:@"SearchZipOperation"
                                    code:-72
                                userInfo:errorZipInvalid];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.zipCodeBlock(locatedZipCode, error);
    }];
}

- (BOOL) hasDigits:(NSString *)input
{
    return [input rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location == NSNotFound;
}

@end
