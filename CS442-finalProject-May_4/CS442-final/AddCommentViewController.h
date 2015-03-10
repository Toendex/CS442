//
//  AddCommentViewController.h
//  CS442-final
//
//  Created by T on 5/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Post.h"
#import "Parse/Parse.h"

@interface AddCommentViewController : UIViewController <MBProgressHUDDelegate, CommentDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (strong, atomic) Comment *comment;
@property (strong, atomic) Post *post;
@property CGPoint coordinate;
@property NSNumber *indexOfImg;


- (IBAction)commentToServer:(id)sender;

@end
