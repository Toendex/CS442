//
//  AddCommentViewController.m
//  CS442-final
//
//  Created by T on 5/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController {
    
    MBProgressHUD *HUD;
}

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
    _comment=[[Comment alloc] init];
    _comment.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
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

- (IBAction)commentToServer:(id)sender {
    NSString *text=self.textField.text;
    if([text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Reject" message:@"Please input something." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    PFUser *user=[PFUser currentUser];
    _comment.user=user;
    _comment.date=[NSDate date];
    _comment.postID=_post.ID;
    _comment.text=text;
    _comment.indexOfImg=self.indexOfImg;                         //!
    _comment.xCoordinate=[NSNumber numberWithFloat:self.coordinate.x];
    _comment.yCoordinate=[NSNumber numberWithFloat:self.coordinate.y];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Commenting";
    [HUD show:YES];
    
    [_comment doComment];
}

#pragma mark - CommentDelegate

-(void)didEndComment
{
    [HUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end