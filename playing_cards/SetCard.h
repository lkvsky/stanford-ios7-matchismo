//
//  SetCard.h
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/16/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSInteger *symbolType;
@property (nonatomic) NSInteger *symbolCount;
@property (nonatomic) NSInteger *symbolFillType;
@property (nonatomic) NSInteger *symbolColor;

@end
