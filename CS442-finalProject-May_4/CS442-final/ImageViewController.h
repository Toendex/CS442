//
//  ImageViewController.h
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostModel.h"
#import "CommentModel.h"
#import "GrayView.h"
#import "AddCommentViewController.h"
#import "CoordinateConverter.h"
#import "CommentView.h"

@interface ImageViewController : UIViewController <UIScrollViewDelegate,GrayViewDelegate,CommentDelegate,CoordinateConvertDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationBarLeftButtom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hideShowButton;
@property (strong, nonatomic) Post *post;

- (IBAction)startAddComment:(id)sender;
- (IBAction)hideShowText:(id)sender;
- (IBAction)hideShowComments:(id)sender;
- (IBAction)hideShowCommentNumSelection:(id)sender;

@end
