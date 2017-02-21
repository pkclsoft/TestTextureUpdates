#import <SpriteKit/SpriteKit.h>
#import "SKUpdateableNode.h"

@interface SKAttributedLabelNode : SKSpriteNode <SKUpdateableNode>

@property (nonatomic, retain) NSAttributedString *attributedText;
@property (atomic, assign) BOOL requiresUpdate;

- (id) initWithSize:(CGSize)size;

@end
