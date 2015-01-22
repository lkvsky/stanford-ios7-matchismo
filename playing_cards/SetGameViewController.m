//
//  SetGameViewController.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 12/10/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "HistoryViewController.h"
#import "SetCardView.h"

@interface SetGameViewController ()
@property (nonatomic) int mode;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (nonatomic) NSMutableArray *cardViews;
@end

@implementation SetGameViewController

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] initWithCapacity:self.numberOfStartingCards];
    
    return _cardViews;
}

- (int)mode
{
    if (!_mode) _mode = 3;
    return _mode;
}

- (SetCardDeck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    if ([self.cardViews count] == 0) {
        [self initCardViews];
        [self addCardsToGrid];
    } else {
        for (SetCardView *cardView in self.cardViews) {
            Card *card = [self.game cardAtIndex:cardView.tag];
            cardView.faceUp = card.isChosen;
            
            if (card.isMatched) {
                [self updateCardView:cardView];
            }
        }
    }
      
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    
    if (self.game.playComplete) {
        NSAttributedString *currentStatus = [self buildStatus:self.game.chosenCards thatMatched:self.game.isMatching];
        [self.statusLabel setAttributedText:currentStatus];
        [self.history addObject:currentStatus];
    } else {
        self.statusLabel.text = @"";
    }
}

- (void)initCardViews
{
    for (NSUInteger cardIndex = 0;
         cardIndex < self.numberOfStartingCards;
         cardIndex++) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardIndex];
        bool viewExists = [self.cardViews count] > 0 && cardIndex <= [self.cardViews count] - 1;
        SetCardView *cardView;
        
        if (viewExists) {
            cardView = [self.cardViews objectAtIndex:cardIndex];
        } else {
            cardView = [[SetCardView alloc] init];
        }
        
        cardView.symbolCount = card.symbolCount;
        cardView.symbolFillType = card.symbolFillType;
        cardView.symbolType = card.symbolType;
        cardView.symbolColor = card.symbolColor;
        cardView.faceUp = card.isChosen;
        cardView.tag = cardIndex;
        cardView.alpha = 1.0;
        
        if (!viewExists) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapCard:)];
            [cardView addGestureRecognizer:tap];
            [self.cardViews addObject:cardView];
            [self.gridView addSubview:cardView];
        }
    }
}

- (void)addCardsToGrid
{
    NSUInteger cardViewIndex = 0;
    for (NSUInteger rowIndex = 0;
         rowIndex < self.grid.rowCount;
         rowIndex++) {
        for (NSUInteger columnIndex = 0;
             columnIndex < self.grid.columnCount;
             columnIndex++) {
            SetCardView *cardView = [self.cardViews objectAtIndex:cardViewIndex];
            cardView.frame = [self.grid frameOfCellAtRow:rowIndex inColumn:columnIndex];
            
            if (cardViewIndex == [self.cardViews count] - 1) {
                break;
            } else {
                cardViewIndex++;
            }
        }
    }
}

- (NSMutableAttributedString *)buildStatus:(NSArray *)setCards
              thatMatched:(BOOL)isMatch
{
    NSMutableAttributedString *baseString;
    
    if (isMatch) {
       baseString = [[NSMutableAttributedString alloc] initWithString:@"Yay! you matched "];
    } else {
        baseString = [[NSMutableAttributedString alloc] initWithString:@"Sorry! "];
    }

    NSMutableAttributedString *cardString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *delimiter = [[NSAttributedString alloc] initWithString:@", "];
    
    for (SetCard *card in setCards) {
        [cardString appendAttributedString:[SetCardView getDesignForSymbol:card.symbolType withCount:card.symbolCount inColor:card.symbolColor withFill:card.symbolFillType]];
    
        if (cardString != [setCards lastObject]) {
            [cardString appendAttributedString:delimiter];
        }
    }

    if (isMatch) {
        [baseString appendAttributedString:cardString];
    } else {
        [baseString appendAttributedString:cardString];
        [baseString appendAttributedString:[[NSAttributedString alloc] initWithString:@" do not match!"]];
    }
    
    return baseString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfStartingCards = 12;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    [self updateUI];
}


@end
