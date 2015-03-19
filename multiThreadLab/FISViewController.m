//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "FISZipSearchOperation.h"
#import "FISZipCode.h"

@interface FISViewController ()

@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

- (IBAction)searchZipCodeTapped:(id)sender;

@end

@implementation FISViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.accessibilityLabel=@"Main View";

    self.view.backgroundColor = [UIColor whiteColor];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(alternateBackgroundColor)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alternateBackgroundColor
{
    if ( self.view.backgroundColor == [UIColor whiteColor] )
    {
        self.view.backgroundColor = [UIColor blueColor];
    }
    else if ( self.view.backgroundColor == [UIColor blueColor] )
    {
        self.view.backgroundColor = [UIColor redColor];
    }
    else if ( self.view.backgroundColor == [UIColor redColor] )
    {
        self.view.backgroundColor = [UIColor purpleColor];
    }
    else if ( self.view.backgroundColor == [UIColor purpleColor] )
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)searchZipCodeTapped:(id)sender
{
    NSOperationQueue *searchOperationQueue = [[NSOperationQueue alloc] init];
    searchOperationQueue.maxConcurrentOperationCount = 1;
    
    FISZipSearchOperation *newSearchZipOperation = [[FISZipSearchOperation alloc] init];
    
    newSearchZipOperation.searchZipCode = self.zipCode.text;
    newSearchZipOperation.zipCodeBlock = ^void(FISZipCode *zipCode, NSError *error) {
        
        if ( ! zipCode )
        {
            [self showAlertWithError:error];
        }
        else
        {
            self.countyLabel.text = zipCode.county;
            self.stateLabel.text = zipCode.state;
            self.cityLabel.text = zipCode.city;
            self.longitudeLabel.text = zipCode.longitude;
            self.latitudeLabel.text = zipCode.latitude;
        }
    };
    
    [searchOperationQueue addOperation:newSearchZipOperation];
}

-(void)showAlertWithError: (NSError *) error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                   message:error.localizedFailureReason
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {}];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
