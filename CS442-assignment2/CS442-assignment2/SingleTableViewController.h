//
//  SingleTableViewController.h
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConModel.h"

@interface SingleTableViewController : UITableViewController <UITextFieldDelegate, UITabBarControllerDelegate>

@property ConModel* model;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)doneTapped:(id)sender;
- (IBAction)textFieldChanged:(id)sender;

@end
