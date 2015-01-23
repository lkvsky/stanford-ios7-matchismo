//
//  SetCardView.m
//  playing_cards
//
//  Created by Kyle Lucovsky on 1/22/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setSymbolType:(NSInteger *)symbolType
{
    _symbolType = symbolType;
    [self setNeedsDisplay];
}

- (void)setSymbolColor:(NSInteger *)symbolColor
{
    _symbolColor = symbolColor;
    [self setNeedsDisplay];
}

- (void)setSymbolFillType:(NSInteger *)symbolFillType
{
    _symbolFillType = symbolFillType;
    [self setNeedsDisplay];
}

- (void)setSymbolCount:(NSInteger *)symbolCount
{
    _symbolCount = symbolCount;
    [self setNeedsDisplay];
};

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        [self drawSymbols];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (UIColor *)color
{
    if ((int)self.symbolColor == 1) return [UIColor magentaColor];
    else if ((int)self.symbolColor == 2) return [UIColor greenColor];
    else return [UIColor purpleColor];
}

#define SYMBOL_HEIGHT 0.25
#define SYMBOL_WIDTH 0.8
#define SYMBOL_STROKE_WEIGHT 0.02
#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5

- (void)fill:(UIBezierPath *)path
{
    if ((int)self.symbolFillType == 1) {
        [[self color] setFill];
        [path fill];
    } else if ((int)self.symbolFillType == 2) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_STROKE_WEIGHT;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}

- (void)drawSymbols
{
    CGFloat centerX = self.bounds.size.width / 2;
    CGFloat centerY = self.bounds.size.height/2;
    CGFloat spacingOffset = SYMBOL_STROKE_WEIGHT * centerY;
    CGFloat yOffset = SYMBOL_HEIGHT * centerY;
    
    if ((int)self.symbolCount == 1) {
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY)];
    } else if ((int)self.symbolCount == 2) {
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY - yOffset - spacingOffset)];
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY + yOffset + spacingOffset)];
    } else {
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY)];
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY - (2 * yOffset) - spacingOffset)];
        [self drawSymbolAtPoint:CGPointMake(centerX, centerY + (2 * yOffset) + spacingOffset)];
    }
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ((int)self.symbolType == 1) [self drawDiamondAtPoint:point];
    else if ((int)self.symbolType == 2) [self drawOvalAtPoint:point];
    else [self drawSquiggleAtPoint:point];
}

- (void)drawDiamondAtPoint:(CGPoint)point
{
    CGFloat dx = self.bounds.size.width * SYMBOL_WIDTH / 2;
    CGFloat dy = self.bounds.size.width * SYMBOL_HEIGHT /2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(point.x - dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_STROKE_WEIGHT;
    [[self color] setStroke];
    [path stroke];
    [self fill:path];
}

- (void)drawOvalAtPoint:(CGPoint)point
{
    CGFloat dx = self.bounds.size.width * SYMBOL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SYMBOL_HEIGHT / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2.0 * dx, 2.0 * dy) cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_STROKE_WEIGHT;
    [[self color] setStroke];
    [path stroke];
    [self fill:path];
}

#define SQUIGGLE_CURVE_FACTOR 0.5

- (void)drawSquiggleAtPoint:(CGPoint)point
{
    CGFloat dx = self.bounds.size.width * SYMBOL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SYMBOL_HEIGHT / 2;
    CGFloat dsqx = dx * SQUIGGLE_CURVE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_CURVE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dsqx, point.y + dsqy) controlPoint:CGPointMake(point.x - dx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y) controlPoint1:point controlPoint2:CGPointMake(point.x + dx, point.y + dy * 2)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dsqx, point.y - dsqy) controlPoint:CGPointMake(point.x + dx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y) controlPoint1:point controlPoint2:CGPointMake(point.x - dx, point.y - dy * 2)];
    path.lineWidth = self.bounds.size.width * SYMBOL_STROKE_WEIGHT;
    [[self color] setStroke];
    [path stroke];
    [self fill:path];
}

#pragma mark - Text Version

+ (NSMutableAttributedString *)getDesignForSymbol:(NSInteger *)symbolType withCount:(NSInteger *)symbolCount inColor:(NSInteger *)symbolColor withFill:(NSInteger *)symbolFillType
{
    NSMutableAttributedString *cardDesign = [[NSMutableAttributedString alloc] initWithString:[SetCardView getSymbol:symbolType withCount:symbolCount]];
    [cardDesign addAttributes:[SetCardView getSymbolAttributes:symbolColor withFill:symbolFillType] range:(NSRange){0, (int)[cardDesign.string length]}];
    
    return cardDesign;
}

- (NSMutableAttributedString *)getDesign
{
    NSMutableAttributedString *cardDesign = [[NSMutableAttributedString alloc] initWithString:[SetCardView getSymbol:self.symbolType withCount:self.symbolCount]];
    [cardDesign addAttributes:[SetCardView getSymbolAttributes:self.symbolColor withFill:self.symbolFillType] range:(NSRange){0, (int)[cardDesign.string length]}];
    
    return cardDesign;
}

+ (NSMutableDictionary *)getSymbolAttributes:(NSInteger *)symbolColor withFill:(NSInteger *)symbolFillType
{
    NSMutableDictionary *fontStyles = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                                                        }];
    UIColor *symbolColorForUi;
    
    if ((int)symbolColor == 1) {
        symbolColorForUi = [UIColor magentaColor];
    } else if ((int)symbolColor == 2) {
        symbolColorForUi = [UIColor greenColor];
    } else {
        symbolColorForUi = [UIColor purpleColor];
    }
    
    if ((int)symbolFillType == 3) {
        [fontStyles setObject:symbolColorForUi forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    } else if ((int)symbolFillType == 2) {
        [fontStyles setObject:symbolColorForUi forKey:NSStrokeColorAttributeName];
        [fontStyles setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [fontStyles setObject:[symbolColorForUi colorWithAlphaComponent:0.5] forKey:NSForegroundColorAttributeName];
    } else {
        [fontStyles setObject:symbolColorForUi forKey:NSForegroundColorAttributeName];
    }
    
    return fontStyles;
}

+ (NSMutableString *)getSymbol:(NSInteger *)symbolType withCount:(NSInteger *)symbolCount
{
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i < (int)symbolCount; i++) {
        if ((int)symbolType == 1) {
            [baseString appendString:@"▲"];
        } else if ((int)symbolType == 2) {
            [baseString appendString:@"●"];
        } else if ((int)symbolType == 3) {
            [baseString appendString:@"■"];
        }
    }
    
    return baseString;
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib { [self setup]; }

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setup];
    return self;
}

@end
