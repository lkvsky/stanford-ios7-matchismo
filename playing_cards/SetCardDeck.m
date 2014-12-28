//
//  SetCardDeck.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/16/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    NSMutableArray *cardTypes = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];

    if (self) {
        for (NSString *symbolType in cardTypes) {
            for (NSString *symbolCount in cardTypes) {
                for (NSString *symbolFillType in cardTypes) {
                    for (NSString *symbolColor in cardTypes) {
                        SetCard *setCard = [[SetCard alloc] init];
                        setCard.symbolType = (NSInteger *)[symbolType integerValue];
                        setCard.symbolCount = (NSInteger *)[symbolCount integerValue];
                        setCard.symbolFillType = (NSInteger *)[symbolFillType integerValue];
                        setCard.symbolColor = (NSInteger *)[symbolColor integerValue];
                        [self addCard:setCard];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
