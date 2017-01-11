#import <SpriteKit/SpriteKit.h>

@interface SKAttributedLabelNode : SKSpriteNode

@property (nonatomic, retain) NSAttributedString *attributedText;

- (id) initWithSize:(CGSize)size;

@end
