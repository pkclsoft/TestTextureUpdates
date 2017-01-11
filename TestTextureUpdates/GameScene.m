#import "GameScene.h"
#import "NSAttributedString+DDHTML.h"

#import "SKAttributedLabelNode.h"

@interface GameScene()

@property (nonatomic, retain) SKLabelNode *normalLabel;
@property (nonatomic, retain) SKAttributedLabelNode *attributedLabel;

@end

@implementation GameScene {
    NSUInteger counter;
}

- (id) initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self != nil) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        counter = 0;

        self.normalLabel = [SKLabelNode labelNodeWithText:@"normalLabel"];
        self.normalLabel.position = CGPointMake(0.0, size.height/4.0);
        [self addChild:self.normalLabel];

        self.attributedLabel = [[SKAttributedLabelNode alloc] initWithSize:CGSizeMake(size.width*0.8, size.height*0.3)];

        self.attributedLabel.position = CGPointMake(0.0, size.height/-4.0);
        self.attributedLabel.attributedText = [NSAttributedString attributedStringFromHTML:@"<b><font color=\"#aaaaaa\">attributedLabel</font></b>"];
        [self addChild:self.attributedLabel];

        [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.1];
    }
    
    return self;
}

+ (GameScene*) gameSceneWithSize:(CGSize)size {
    return [[GameScene alloc] initWithSize:size];
}

- (void) updateLabels {
    NSString *labelText = [NSString stringWithFormat:@"count: %lu", (unsigned long)counter];
    self.normalLabel.text = labelText;

    counter++;

    /**
     * Commenting out this line prevents the crash.  The crash seems to happen as a result of the assigning of a new
     * texture to the attributedLabel node.
     */
    self.attributedLabel.attributedText = [NSAttributedString attributedStringFromHTML:@"<b><font color=\"#aaaaaa\">attributedLabel</font></b>"];

    [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.01];

}

- (void) dealloc {
}

#pragma mark - Zoom in and out


@end
