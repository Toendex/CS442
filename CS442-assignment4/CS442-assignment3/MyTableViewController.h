//
//  MyTableViewController.h
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PieceView.h"
#import "TTableViewCell.h"
#import "ATableViewCell.h"
#import "ETableViewCell.h"
#import "GameModel.h"

@interface MyTableViewController : UITableViewController <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

- (IBAction)logOut:(id)sender;
- (IBAction)addNewGame:(id)sender;
- (IBAction)pullToRefresh:(id)sender;

@end
