//
//  TTableViewCell.h
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieceView.h"
#import "Game.h"

@interface TTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PieceView *firstPiece;
@property (weak, nonatomic) IBOutlet PieceView *secondPiece;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerName;

- (void)doInitWithGame:(Game *)game;
@end
