//
//  MyLogInViewController.m
//  CS442-final
//
//  Created by T on 4/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "MyLogInViewController.h"

@interface MyLogInViewController ()

@end

@implementation MyLogInViewController

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
    // Do any additional setup after loading the view.
    UILabel *label=[[UILabel alloc] init];
    label.text=@"M I X";
    label.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:45];
    label.textColor=[UIColor whiteColor];
    [label sizeToFit];
    self.logInView.logo = label; // logo can be any UIView
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
