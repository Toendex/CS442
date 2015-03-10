//
//  CollectionViewController.h
//  CS442-final
//
//  Created by T on 3/31/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"

@interface CollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong,atomic) UIRefreshControl *refreshControl;

-(void)doReload;

@end
