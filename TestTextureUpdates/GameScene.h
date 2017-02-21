#import <SpriteKit/SpriteKit.h>
#import "SKUpdateableNode.h"

@interface GameScene : SKScene

#pragma mark - Construction

+ (GameScene*) gameSceneWithSize:(CGSize)size;

- (void) addUpdateableNode:(SKNode<SKUpdateableNode>*)node;
- (void) removeUpdateableNode:(SKNode<SKUpdateableNode>*)node;

@end
