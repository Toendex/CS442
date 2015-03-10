//
//  Comment.m
//  CS442-final
//
//  Created by T on 5/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(id)init
{
    self=[super init];
    if(self) {
        ;
    }
    return self;
}

-(void)doComment
{
    PFObject *commentTS = [PFObject objectWithClassName:@"Comment"];
    PFACL *acl=[PFACL ACL];
    [acl setPublicReadAccess:YES];
    commentTS.ACL=acl;
    commentTS[@"user"]=_user;
    commentTS[@"date"]=_date;
    commentTS[@"postID"]=_postID;
    commentTS[@"text"]=_text;
    commentTS[@"indexOfImg"]=_indexOfImg;
    commentTS[@"xCoordinate"]=_xCoordinate;
    commentTS[@"yCoordinate"]=_yCoordinate;
    
    [commentTS saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            ;
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.delegate didEndComment];
    }];
}

+(Comment *)initWithPFCommentObject:(PFObject *)commentObject
{
    Comment *ct=[[Comment alloc] init];
    ct.user=commentObject[@"user"];
    ct.date=commentObject[@"date"];
    ct.postID=commentObject[@"postID"];
    ct.text=commentObject[@"text"];
    ct.indexOfImg=commentObject[@"indexOfImg"];
    ct.xCoordinate=commentObject[@"xCoordinate"];
    ct.yCoordinate=commentObject[@"yCoordinate"];
    return ct;
}

@end