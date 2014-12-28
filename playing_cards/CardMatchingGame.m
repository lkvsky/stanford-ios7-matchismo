//
//  CardMatchingGame.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSUInteger mode;
@property (nonatomic, readwrite) NSMutableArray *chosenCards;
@property (nonatomic, readwrite) BOOL isMatching;
@property (nonatomic, readwrite) BOOL playComplete;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        usingMode:(NSUInteger)mode
{
    self = [super init];
    self.mode = mode;
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)setGameMode:(NSUInteger)mode
{
    self.mode = mode;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{

    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            [self.chosenCards removeAllObjects];
            NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [self.chosenCards addObject:otherCard];
                    [cardsToMatch addObject:otherCard];
                }
            }
            
            if ([cardsToMatch count] == self.mode - 1) {
                int matchScore = [card match:cardsToMatch];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in cardsToMatch) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                    self.isMatching = YES;
                    self.playComplete = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in cardsToMatch) {
                        otherCard.chosen = NO;
                    }
                    self.isMatching = NO;
                    self.playComplete = YES;
                }
                
                [self.chosenCards addObject:card];
                
                for (Card *otherCard in cardsToMatch) {
                    if (![self.chosenCards containsObject:otherCard]) {
                        [self.chosenCards addObject:otherCard];                        
                    }
                }
            } else {
                self.playComplete = NO;
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (void)startNextMatch
{
    [self.chosenCards removeAllObjects];
}

@end
