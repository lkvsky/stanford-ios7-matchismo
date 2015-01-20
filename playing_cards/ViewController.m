//
//  ViewController.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 11/18/14.
//  Copyright (c) 2014 Kyle Lucovsky. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "HistoryViewController.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "Grid.h"

@interface ViewController ()
@property (nonatomic) int mode;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *grid;
@end

@implementation ViewController

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] initWithCapacity:self.numberOfStartingCards];
        
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = 80.0 / 120.0;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    
    return _grid;
}

- (int)mode
{
    if (!_mode) _mode = 2;
    return _mode;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards
                                                          usingDeck:[self createDeck]
                                                          usingMode:self.mode];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}


- (void)tapCard:(UISwipeGestureRecognizer *)sender
{
    [self.game chooseCardAtIndex:sender.view.tag];
    [self updateUI];
}

- (IBAction)touchDealButton:(UIButton *)sender
{
    self.game = nil;
    [self updateUI];

}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
        HistoryViewController *historyVC = (HistoryViewController *)segue.destinationViewController;
        historyVC.history = self.history;
    }
}

#define CARDSPACINGINPERCENT 0.08

- (void)initCardViews
{
    for (NSUInteger cardIndex = 0;
         cardIndex < self.numberOfStartingCards;
         cardIndex++) {
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardIndex];
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        
        cardView.tag = cardIndex;
        cardView.suit = card.suit;
        cardView.rank = card.rank;
        cardView.faceUp = card.isChosen;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapCard:)];
        [cardView addGestureRecognizer:tap];
        [self.cardViews addObject:cardView];
        [self.gridView addSubview:cardView];
    }
    
    NSUInteger cardViewIndex = 0;
    for (NSUInteger rowIndex = 0;
         rowIndex < self.grid.rowCount;
         rowIndex++) {
        for (NSUInteger columnIndex = 0;
             columnIndex < self.grid.columnCount;
             columnIndex++) {
            PlayingCardView *cardView = [self.cardViews objectAtIndex:cardViewIndex];
            cardView.frame = [self.grid frameOfCellAtRow:rowIndex inColumn:columnIndex];
            
            if (cardViewIndex == [self.cardViews count] - 1) {
                break;
            } else {
                cardViewIndex++;
            }
        }
    }
}

- (void)updateCardView:(PlayingCardView *)cardView
{
    [cardView setAlpha:0.7];
}

- (void)updateUI
{
    if ([self.cardViews count] == 0) {
        [self initCardViews];
    } else {
        for (PlayingCardView *cardView in self.cardViews) {
            Card *card = [self.game cardAtIndex:cardView.tag];
            cardView.faceUp = card.isChosen;
            
            if (card.isMatched) {
                [self updateCardView:cardView];
            }
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    
    if (self.game.playComplete) {
        NSAttributedString *currentStatus = [self buildStatus:self.game.chosenCards thatMatched:self.game.isMatching withScoreOf:self.game.score];
        [self.statusLabel setAttributedText:currentStatus];
        [self.history addObject:currentStatus];
    } else {
        self.statusLabel.text = @"";
    }
}

- (NSAttributedString *)buildStatus:(NSArray *)cards
              thatMatched:(BOOL)isMatch
              withScoreOf:(NSUInteger)score
{
    NSMutableArray *cardContents = [[NSMutableArray alloc] init];
    NSString *baseString = @"";
    
    for (Card *card in cards) {
        [cardContents addObject:card.contents];
    }
    
    NSString *cardString = [cardContents componentsJoinedByString:@", "];
    
    if (isMatch) {
        baseString = [@"Yay! You matched " stringByAppendingString:cardString];
        NSString *withScore = [NSString stringWithFormat:@" with score of %d", (int)score];
        
        return [[NSAttributedString alloc] initWithString:[baseString stringByAppendingString:withScore]];
    } else {
        baseString = [@"Sorry! " stringByAppendingString:cardString];
        
        return [[NSAttributedString alloc] initWithString:[baseString stringByAppendingString:@" do not match!"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfStartingCards = 18;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    [self updateUI];
}

@end
