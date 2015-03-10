//
//  ETableViewCell.h
//  CS442-assignment4
//
//  Created by T on 5/9/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ETableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wonLabel;


- (void)doInitWithGame:(Game *)game;

@end
