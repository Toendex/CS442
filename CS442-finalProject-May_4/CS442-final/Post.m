//
//  Post.m
//  CS442-final
//
//  Created by T on 4/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "Post.h"

@implementation Post

-(id)init
{
    self=[super init];
    if(self) {
        _imgs=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addImage:(UIImage *)image
{
    [_imgs addObject:image];
}

-(NSInteger)imageCount
{
    return [_imgs count];
}

-(UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    int n=indexPath.row;
    if ([_imgs count]<n) {
        return nil;
    }
    return [_imgs objectAtIndex:n];
}

-(void)doPost
{
    NSMutableArray *imageArray=[[NSMutableArray alloc] init];
    for (int i=0; i<[_imgs count]; i++) {
        NSData *imageData=UIImagePNGRepresentation([_imgs objectAtIndex:i]);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        [imageArray addObject:imageFile];
    }
    PFObject *postTS = [PFObject objectWithClassName:@"Post"];
    PFACL *acl=[PFACL ACL];
    [acl setPublicReadAccess:YES];
    postTS.ACL=acl;
    postTS[@"user"]=_user;
    postTS[@"date"]=_date;
    postTS[@"title"]=_title;
    postTS[@"contentText"]=_contentText;
    postTS[@"imageArray"]=imageArray;
    //    [postTS setObject:user forKey:@"user"];
    //    [postTS setObject:[NSDate date] forKey:@"date"];
    //    [postTS setObject:self.titleField.text forKey:@"title"];
    //    [postTS setObject:self.contentTextField.text forKey:@"contentText"];
    //    [postTS setObject:imageArray forKey:@"imageArray"];
    [postTS saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            ;
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.delegate didEndPost];
    }];
}

//+(Post *)tempInitWithImageName:(NSString *)imgName
//{
//    Post *post=[[Post alloc] init];
//    [post.imgs addObject:[UIImage imageNamed:imgName]];
//    return post;
//}

+(Post *)initWithPFPostObject:(PFObject *)postObject
{
    Post *post=[[Post alloc] init];
    NSArray *imageArray=postObject[@"imageArray"];
    if ([imageArray count]==0) {
        NSLog(@"imageArray==0!");
        return nil;
    }
    post.title=postObject[@"title"];
    post.contentText=postObject[@"contentText"];
    post.user=postObject[@"user"];
    post.date=postObject[@"date"];
    post.ID=[postObject objectId];
    for(PFFile *imageFile in imageArray)
        [post.imgs addObject:[UIImage imageWithData:[imageFile getData]]];
    return post;
}

@end
