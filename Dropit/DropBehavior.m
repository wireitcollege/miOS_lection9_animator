//
//  DropBehavior.m
//  Dropit
//
//  Created by Rostyslav Kobizsky on 7/28/15.
//  Copyright (c) 2015 Wire IT College. All rights reserved.
//

#import "DropBehavior.h"

@interface DropBehavior ()

@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;

@end

@implementation DropBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collision];
    }
    return self;
}

- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9;
    }
    return _gravity;
}

- (UICollisionBehavior *)collision {
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    
    return _collision;
}

- (void)addItem:(id <UIDynamicItem>)item {
    [self.gravity addItem:item];
    [self.collision addItem:item];
}
- (void)removeItem:(id <UIDynamicItem>)item {
    [self.gravity removeItem:item];
    [self.collision removeItem:item];

}


@end
