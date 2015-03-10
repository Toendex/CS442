//
//  CollectionViewFlowLayout.h
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewFlowLayout : UICollectionViewFlowLayout

-(CGSize)sizeOfCellAtIndexPath:(NSIndexPath *)indexPath;
-(void)refresh;

@end
