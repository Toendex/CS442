//
//  Comment.h
//  CS442-final
//
//  Created by T on 5/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"

@protocol CommentDelegate;

@interface Comment : NSObject

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSDate *date;
@property (strong) NSString *text;
@property (strong) NSString *postID;
@property (strong) NSNumber *indexOfImg;
@property (strong) NSNumber *xCoordinate;
@property (strong) NSNumber *yCoordinate;
@property (weak,nonatomic) id<CommentDelegate> delegate;

-(void)doComment;
+(Comment *)initWithPFCommentObject:(PFObject *)commentObject;

@end


@protocol CommentDelegate <NSObject>

-(void)didEndComment;

@end