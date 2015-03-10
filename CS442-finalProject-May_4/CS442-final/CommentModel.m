//
//  CommentModel.m
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel {
    
}

-(id)initWithPostID:(NSString *)postID
{
    self=[super init];
    if(self) {
        _postID=postID;
    }
    return self;
}

- (void)readComments {
    _comments=[[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"postID" equalTo:self.postID];
    NSArray *cts=[query findObjects];
    for (PFObject *obj in cts) {
        Comment *ct=[Comment initWithPFCommentObject:obj];
        if(ct)
            [_comments insertObject:ct atIndex:0];
    }
}

- (Comment*)getCommentWithIndex:(NSUInteger)index
{
    return [self.comments objectAtIndex:index];
}

@end
