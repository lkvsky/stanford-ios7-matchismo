//
//  SetCard.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/16/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        SetCard *otherCard = [otherCards firstObject];
        
        if ([self isMatchedWith:otherCard]) {
            score = 4;
        }
    }
    
    if ([otherCards count] == 2) {
        SetCard *firstMatch = [otherCards firstObject];
        SetCard *secondMatch = [otherCards lastObject];
        
        if ([self isMatchedWith:(firstMatch) and:secondMatch]) {
            score = 4;
        }
    }
    
    return score;
}

- (BOOL)isMatchedWith:(SetCard *)otherCard
{
    return otherCard.symbolType == self.symbolType || otherCard.symbolCount == self.symbolCount || otherCard.symbolFillType  ==self.symbolFillType || otherCard.symbolColor == self.symbolColor;
}

- (BOOL)isMatchedWith:(SetCard *)firstMatch and:(SetCard *)secondMatch
{
        return (firstMatch.symbolType == self.symbolType && self.symbolType == secondMatch.symbolType) || (firstMatch.symbolCount == self.symbolCount && secondMatch.symbolCount == self.symbolCount) || (firstMatch.symbolFillType  == self.symbolFillType && secondMatch.symbolFillType == self.symbolFillType) || (firstMatch.symbolColor == self.symbolColor && secondMatch.symbolColor == self.symbolColor);
}

@end
