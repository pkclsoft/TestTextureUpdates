#import "GameScene.h"
#import "NSAttributedString+DDHTML.h"

#import "SKAttributedLabelNode.h"

//#define USE_CONTAINER_NODE 1

#ifdef USE_CONTAINER_NODE
#import "SKContainerNode.h"
#endif

@interface GameScene()

@property (nonatomic, retain) SKLabelNode *normalLabel;
@property (nonatomic, retain) SKAttributedLabelNode *attributedLabel;
@property (nonatomic, retain) NSMutableArray<SKNode<SKUpdateableNode>*> *updateableNodes;

#ifdef USE_CONTAINER_NODE
@property (nonatomic, retain) SKContainerNode *containerNode;
#else
@property (nonatomic, retain) SKNode *containerNode;
#endif

@end

@implementation GameScene {
    NSUInteger counter;
}

- (id) initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self != nil) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        counter = 0;

#ifdef USE_CONTAINER_NODE
        self.containerNode = [SKContainerNode node];
#else
        self.containerNode = [SKNode node];
#endif

        self.normalLabel = [SKLabelNode labelNodeWithText:@"normalLabel"];
        self.normalLabel.position = CGPointMake(0.0, size.height/4.0);
        [self.containerNode addChild:self.normalLabel];

        self.attributedLabel = [[SKAttributedLabelNode alloc] initWithSize:CGSizeMake(size.width*0.8, size.height*0.3)];

        self.attributedLabel.position = CGPointMake(0.0, size.height/-4.0);
        self.attributedLabel.attributedText = [NSAttributedString attributedStringFromHTML:@"<b><font color=\"#aaaaaa\">attributedLabel</font></b>"];
        [self.containerNode addChild:self.attributedLabel];

        [self addChild:self.containerNode];

        self.updateableNodes = [NSMutableArray array];

        [self.updateableNodes addObject:self.attributedLabel];

        [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.1];
    }
    
    return self;
}

+ (GameScene*) gameSceneWithSize:(CGSize)size {
    return [[GameScene alloc] initWithSize:size];
}

// If you want to see what happens when children are removed, uncomment this.
#define TEST_REMOVAL

// There are three methods of removing children.  These three can be tested individually by uncommenting
// one (only) of these lines.  If the test works, then the console will show the line:
//
//  SKAttributedLabelNode.removeFromParent
//
#ifdef TEST_REMOVAL
#define TEST_VIA_REMOVE_FROM_PARENT
//#define TEST_VIA_REMOVE_ALL_CHILDREN
//#define TEST_VIA_REMOVE_CHILDREN
#endif

- (void) updateLabels {
    NSString *labelText = [NSString stringWithFormat:@"count: %lu", (unsigned long)counter];
    self.normalLabel.text = labelText;

    counter++;

    /**
     * Commenting out this line prevents the crash.  The crash seems to happen as a result of the assigning of a new
     * texture to the attributedLabel node.
     */
    NSString *htmltext = [NSString stringWithFormat:@"<b><font color=\"#aaaaaa\">attributed %@</font></b>", labelText];
    self.attributedLabel.attributedText = [NSAttributedString attributedStringFromHTML:htmltext];

#ifndef TEST_REMOVAL
    [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.01];
#else
    if (counter < 100) {
        [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.01];
    } else {
#ifdef TEST_VIA_REMOVE_FROM_PARENT
        // Calling this, ideally will cause all children of self.containerNode to be removed from the tree via
        // a call to their -removeFromParent message.
        //
        [self.containerNode removeFromParent];
#endif

#ifdef TEST_VIA_REMOVE_ALL_CHILDREN
        // Another test is to see if -removeAllChildren tells the children they are being removed.
        //
        [self.containerNode removeAllChildren];
#endif

#ifdef TEST_VIA_REMOVE_CHILDREN
        // Another test is to see if -removeChildrenInArray: tells the children they are being removed.
        //
        [self.containerNode removeChildrenInArray:self.containerNode.children];
#endif

        // Doing this, in addtion to the node removal should result in the node being released, and a dealloc
        // call to the label node.
        //
        [self.updateableNodes removeObject:self.attributedLabel];
        self.attributedLabel = nil;

    }
#endif

}

-(void) update:(NSTimeInterval)currentTime {
    @synchronized (self.updateableNodes) {
        [self.updateableNodes enumerateObjectsUsingBlock:^(SKNode<SKUpdateableNode> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.requiresUpdate == YES) {
                [obj updateNode];
            }
        }];
    }
}

- (void) dealloc {
}

- (void) addUpdateableNode:(SKNode<SKUpdateableNode>*)node {
    @synchronized (self.updateableNodes) {
        [self.updateableNodes addObject:node];
    }
}

- (void) removeUpdateableNode:(SKNode<SKUpdateableNode>*)node {
    // Ensure that the node is no longer displayable by removing it from the node tree.
    //
    [node removeFromParent];

    // Now remove it from the list of updateable nodes.
    @synchronized (self.updateableNodes) {
        [self.updateableNodes removeObject:node];
    }
}

@end
