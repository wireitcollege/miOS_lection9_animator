//
//  DropBehavior.h
//  Dropit
//
//  Created by Rostyslav Kobizsky on 7/28/15.
//  Copyright (c) 2015 Wire IT College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
