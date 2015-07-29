//
//  ViewController.m
//  Dropit
//
//  Created by Rostyslav Kobizsky on 7/27/15.
//  Copyright (c) 2015 Wire IT College. All rights reserved.
//

#import "ViewController.h"
#import "DropBehavior.h"
#import "BazierPath.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BazierPath *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropBehavior *dropBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;
@end

static CGSize DROP_SIZE = { 40, 40 };

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DROP_SIZE = CGSizeMake(CGRectGetWidth(self.gameView.bounds)/40, CGRectGetWidth(self.gameView.bounds)/40);
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompletedRows];
}

- (BOOL)removeCompletedRows {
    NSMutableArray *dropsToRemove = [NSMutableArray new];
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [NSMutableArray new];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width - DROP_SIZE.width/2; x += DROP_SIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if (hitView.superview == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
            }
        }
        if (!dropsFound.count) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if (dropsToRemove.count) {
        for (UIView *dropView in dropsToRemove) {
            [self.dropBehavior removeItem:dropView];
        }
        [self animateRemovingDrops: dropsToRemove];
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove {
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    } completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (DropBehavior *)dropBehavior {
    if (!_dropBehavior) {
        _dropBehavior = [[DropBehavior alloc] init];
        [self.animator addBehavior:_dropBehavior];
    }
    return _dropBehavior;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

- (void)attachDroppingViewToPoint:(CGPoint)anchorPoint {
    if (self.droppingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView *droppingView = self.droppingView;
        __weak typeof(self) wSelf = self;
        self.attachment.action = ^{
            UIBezierPath *line = [[UIBezierPath alloc] init];
            [line moveToPoint:wSelf.attachment.anchorPoint];
            [line addLineToPoint:droppingView.center];
            wSelf.gameView.path = line;
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
    }
}

- (void)drop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];

    self.droppingView = dropView;
    [self.dropBehavior addItem:dropView];
}

- (UIColor *)randomColor {
    switch (arc4random() % 5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

@end
