
#import "SKAttributedLabelNode.h"

@interface SKAttributedLabelNode()

@property (nonatomic, strong) SKTexture* updatedLabelTexture;

@end

@implementation SKAttributedLabelNode
- (id) initWithSize:(CGSize)size {
    self = [super initWithColor:[UIColor clearColor] size:size];

    if (self != nil) {
    }
    
    return self;
}

- (void) dealloc {
    NSLog(@"SKAttributedLabelNode.dealloc");

}

- (void) removeFromParent {
    NSLog(@"SKAttributedLabelNode.removeFromParent");
    
    [self.children enumerateObjectsUsingBlock:^(SKNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParent];
    }];

    [super removeFromParent];
}

- (void) setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    
    [self draw];
}

- (void) draw {
    NSAttributedString *attrStr = self.attributedText;
    
    if (attrStr == nil) {
        self.texture = nil;
        
        return;
    }

    /**
     * This code will render the attributed string into a texture
     */
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    float strHeight = [attrStr boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    float yOffset = (self.size.height - strHeight) / 2.0;
    CGRect rect = CGRectMake(0.0, yOffset, self.size.width, strHeight);

    [attrStr drawInRect:rect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // update Sprite Node with textImage
    self.updatedLabelTexture = [SKTexture textureWithImage:textImage];

    /**
     * I believe that this line is causing the crash because assigning the new texture is being done concurrently with
     * the renderer.  How can I fix this?
     */
    self.requiresUpdate = YES;
}

#pragma mark - SKUpdateableNode Protocol Implementation

/*!
 * Required because updating/replacing the texture needs to be done within the scene's update callback.
 */
- (void) updateNode {
    self.texture = self.updatedLabelTexture;
    self.updatedLabelTexture = nil;

    // Now reset the flag.
    //
    self.requiresUpdate = NO;
}

@end
