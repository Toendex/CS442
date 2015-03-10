//
//  MasterViewController.h
//  CS442-assignment2
//
//  Created by T on 3/14/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "ConModel.h"

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property ConModel* model;

@end