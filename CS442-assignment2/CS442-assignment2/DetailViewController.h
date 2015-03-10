//
//  DetailViewController.h
//  CS442-assignment2
//
//  Created by T on 3/14/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "ConModel.h"


@interface DetailViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property ConModel* model;
@property NSInteger index;

- (IBAction)textFieldChanged:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
