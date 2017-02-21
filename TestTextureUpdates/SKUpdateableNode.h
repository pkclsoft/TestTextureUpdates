//
//  SKUpdateableNode.h
//  TestTextureUpdates
//
//  Created by Peter Easdown on 13/1/17.
//  Copyright © 2017 PKCLsoft. All rights reserved.
//

/*!
 * A protocol used to define properties and methods for an SKNode or subclass that requires a call from
 * the parent SKScene object during it's update callback.
 */
@protocol SKUpdateableNode

/*!
 * Should be set to YES when the node has an update that needs to be carried out within the -update
 * callback of the parent SKScene object.
 */
@property (atomic, assign) BOOL requiresUpdate;

/*!
 * This message is responsible for implementing any updates required.  Be sure NOT to call this from anywhere
 * but the SKScene-update message as it is assumed that any operations within this might cause problems with the
 * renderer.
 */
- (void) updateNode;

@end /* SKUpdateableNode_h */
