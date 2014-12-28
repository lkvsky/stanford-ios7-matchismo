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

@interface ViewController ()
@property (nonatomic) int mode;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation ViewController

- (int)mode
{
    if (!_mode) _mode = 2;
    return _mode;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
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

- (void)updateUI
{
    
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    }
    
    if (self.game.playComplete) {
        NSAttributedString *currentStatus = [self buildStatus:self.game.chosenCards thatMatched:self.game.isMatching withScoreOf:self.game.score];
        [self.statusLabel setAttributedText:currentStatus];
        [self.history addObject:currentStatus];
    } else {
        self.statusLabel.text = @"";
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
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

@end
