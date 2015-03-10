//
//  CollectionViewFlowLayout.m
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "CollectionViewFlowLayout.h"
#import "PostModel.h"

#define HORI_INTERVAL 4
#define VETI_INTERVAL 4

@implementation CollectionViewFlowLayout {
    PostModel *postModel;
    int correntComp;
    NSMutableArray *attributesArray;
    float length[2];
}

-(void)prepareLayout
{
    CGFloat a=self.minimumInteritemSpacing;
    CGFloat b=self.minimumLineSpacing;
    UIEdgeInsets c=self.sectionInset;
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    correntComp=0;
    postModel=[PostModel sharedSingleton];
    attributesArray=[[NSMutableArray alloc] init];
    [self calculateAttributes];
}

-(void)calculateAttributes {
    length[0]=HORI_INTERVAL/2;
    length[1]=HORI_INTERVAL/2;
    for(int i=0;i<[postModel count];i++) {
        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImage *image=[[postModel postAtIndex:i].imgs objectAtIndex:0];
        float width=(self.collectionView.bounds.size.width-HORI_INTERVAL)/2;
        float height=image.size.height*width/image.size.width;
        CGSize size=CGSizeMake(width, height);
        attributes.size = size;
        if(length[0]>length[1]) {
            attributes.center = CGPointMake(self.collectionView.bounds.size.width*3/4+HORI_INTERVAL/4,length[1]+height/2.0);
            length[1]=length[1]+height+VETI_INTERVAL;
        }
        else {
            attributes.center = CGPointMake(self.collectionView.bounds.size.width/4-HORI_INTERVAL/4,length[0]+height/2.0);
            length[0]=length[0]+height+VETI_INTERVAL;
        }
        [attributesArray addObject:attributes];
    }
}

-(void)refresh {
    [self calculateAttributes];
}

-(CGSize)sizeOfCellAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size=((UICollectionViewLayoutAttributes *)attributesArray[indexPath.row]).size;
    return size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes* attributes in attributesArray)
        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            NSLog(@"%.1f, %.1f, %.1f, %.1f", attributes.frame.origin.x, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height);
            [array addObject:attributes];
        }
    NSLog(@"%d items",[array count]);
//    NSLog(@"%.1f, %.1f, %.1f, %.1f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    return attributesArray;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
//{
//    if(path.row<[attributesArray count]) {
//        return attributesArray[path.row];
//    }
//    while (path.row>=[attributesArray count]) {
//        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
//        UIImage *image=[imgs imageAtIndex:path.row];
//        float width=self.collectionView.bounds.size.width/2-2;
//        float height=image.size.height*width/image.size.width;
//        CGSize size=CGSizeMake(width, height);
//        attributes.size = size;
//        if(length[0]>length[1]) {
//            attributes.center = CGPointMake(width*1.5+3,length[1]+height/2.0);
//            length[1]+=height;
//        }
//        else {
//            attributes.center = CGPointMake(width/2.0+1,length[0]+height/2.0);
//            length[0]+=height;
//        }
//        [attributesArray addObject:attributes];
//    }
//    return attributesArray[path.row];
//}

@end
