//
//  GameViewController.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/23/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gridView;
@end

@implementation GameViewController

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

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards
                                                          usingDeck:[self createDeck]
                                                          usingMode:self.mode];
    return _game;
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (Deck *)createDeck
{
    return [[Deck alloc] init];
}

- (void)updateCardView:(UIView *)cardView
{
    [cardView setAlpha:0.7];
}

- (void)tapCard:(UISwipeGestureRecognizer *)sender
{
    [self.game chooseCardAtIndex:sender.view.tag];
    [self updateUI];
}

- (IBAction)touchDealButton:(UIButton *)sender
{
    self.game = nil;
    [self initCardViews];
    [self updateUI];
    
}

- (void)updateUI {}

- (void)initCardViews {};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
