
#import "SKAttributedLabelNode.h"

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

- (void) setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    
    [self draw];
}

/**
 * Uncomment this to get the text on display.
 */
//#define DISPLAY_TEXT

- (void) draw {
    NSAttributedString *attrStr = self.attributedText;
    
    if (attrStr == nil) {
        self.texture = nil;
        
        return;
    }

    /**
     * This code will render the attributed string into a texture
     */
#ifdef DISPLAY_TEXT
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    float strHeight = [attrStr boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    float yOffset = (self.size.height - strHeight) / 2.0;
    CGRect rect = CGRectMake(0.0, yOffset, self.size.width, strHeight);

    [attrStr drawInRect:rect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // update Sprite Node with textImage
    SKTexture *labelTexture = [SKTexture textureWithImage:textImage];
#else

    /**
     * In order to demonstrate the problem, I've replaced the above code with a simple texture load
     * from a file.
     */

    SKTexture *labelTexture = [SKTexture textureWithImageNamed:@"art.scnassets/particle.png"];
#endif

    /**
     * I believe that this line is causing the crash because assigning the new texture is being done concurrently with
     * the renderer.  How can I fix this?
     */
    self.texture = labelTexture;

}

@end
