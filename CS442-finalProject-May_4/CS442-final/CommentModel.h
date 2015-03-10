//
//  CommentModel.h
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import <Parse/Parse.h>

@interface CommentModel : NSObject

@property (strong) NSString *postID;
@property (strong, atomic) NSMutableArray *comments;

- (id)initWithPostID:(NSString *)postID;
- (void)readComments;
- (Comment*)getCommentWithIndex:(NSUInteger)index;

@end
