//
//  TTableViewCell.m
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "TTableViewCell.h"

@implementation TTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self.firstPiece setColor:[UIColor redColor].CGColor];
    [self.secondPiece setColor:[UIColor yellowColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)doInitWithGame:(Game *)game
{
    if([game player:1]==nil)
        self.firstPlayerName.text=@"(No opponent yet)";
    else
        self.firstPlayerName.text=[game player:1].username;
    if([game player:2]==nil)
        self.secondPlayerName.text=@"(No opponent yet)";
    else
        self.secondPlayerName.text=[game player:2].username;
}

@end
