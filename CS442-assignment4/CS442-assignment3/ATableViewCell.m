//
//  ATableViewCell.m
//  CS442-assignment4
//
//  Created by T on 5/10/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ATableViewCell.h"

@implementation ATableViewCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)doInitWithGame:(Game *)game
{
    NSString *str=[NSString stringWithFormat:@"Game created by   %@",[game creator].username];
    self.textLabel.text=str;
}

@end
