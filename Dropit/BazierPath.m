//
//  BazierPath.m
//  Dropit
//
//  Created by Rostyslav Kobizsky on 7/29/15.
//  Copyright (c) 2015 Wire IT College. All rights reserved.
//

#import "BazierPath.h"

@implementation BazierPath


- (void)setPath:(UIBezierPath *)path {
    _path = path;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.path stroke];
}


@end
