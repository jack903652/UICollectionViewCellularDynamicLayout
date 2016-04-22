//
//  UICollectionViewCellularLayout.m
//  UICollectionViewCellularDynamicLayout
//
//  Created by bamq on 16/4/14.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "UICollectionViewCellularLayout.h"
@interface UICollectionViewCellularLayout()
@property(nonatomic,strong)UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) CGFloat latestDelta;
@end
@implementation UICollectionViewCellularLayout
{
    CGFloat width;
    CGFloat gapX;
    CGFloat gapY;
    CGFloat radiusX;
    CGFloat radiusY;
    CGFloat itemCenterXDistance;
    NSInteger column;
    
}

-(instancetype)initWithRadius:(CGFloat)radius gap:(CGFloat)gap{
    self =[super init];
    if (self) {
        _radius =radius;
        _gap =gap;
//        width = CGRectGetWidth(self.collectionView.frame);
        width =375;
        gapX =self.gap*cos(M_PI/6);
        gapY =self.gap;
        radiusX =self.radius;
        radiusY = self.radius*cos(M_PI/6);
        itemCenterXDistance =radiusX+0.5*radiusX+gapX;
        column = (width-2*radiusX-2*gapX)/itemCenterXDistance +1;
        _dynamicAnimator =[[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return self;
}
    
    
- (void)prepareLayout{
    [super prepareLayout];

    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    NSArray *items = [self layoutAttributesForElementsInRect:visibleRect];
    //移除将要不在视图中的动态行为
    [self.dynamicAnimator removeAllBehaviors];
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [items enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 0.0f;
        springBehaviour.damping = 0.8f;
        springBehaviour.frequency = 1.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        [self.dynamicAnimator addBehavior:springBehaviour];
    }];
}
-(NSArray<NSIndexPath *> *)visiableIndexPathInRect:(CGRect )rect{
    CGFloat y =rect.origin.y;
    CGFloat h = rect.size.height;
    CGFloat firstRowHeight =gapY+radiusY*2+0.5*gapY+radiusY+gapY;
    NSInteger row = (y-firstRowHeight)/(radiusY*2+gapY);
    row =MAX(0, row);
    NSInteger maxRow = (y+h-firstRowHeight)/(radiusY*2+gapY)+2;
    NSInteger maxItem =MIN(maxRow*column, [self.collectionView numberOfItemsInSection:0 ]);
    NSMutableArray *array =[NSMutableArray array];
    for (NSInteger i =row*column; i<maxItem; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [array addObject:indexPath];
    }
    return array;
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    if ([arr count] > 0) {
        return arr;
    }
    NSMutableArray *attributes = [NSMutableArray array];
    NSArray *indexPaths = [self visiableIndexPathInRect:rect];
    for (NSIndexPath *path in indexPaths) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:path]];
    }
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger itemColumn = indexPath.item%column;
    NSInteger itemRow = indexPath.item/column;
    attributes.center = CGPointMake(gapX+radiusX+itemColumn*itemCenterXDistance, gapY+radiusX+itemColumn%2*(radiusY+gapY/2)+(2*radiusY+gapY)*itemRow);
    attributes.size =CGSizeMake(2*radiusX, 2*radiusY);
    return attributes;
}

- (CGSize)collectionViewContentSize{
    NSInteger count =[self.collectionView numberOfItemsInSection:0];
    NSInteger row =count/column;
    CGFloat height = gapY+radiusY*2+gapY+radiusY+gapY +(row-1)*(gapY+radiusY*2);
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta =delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)springBehaviour.items.firstObject;
        
        CGPoint center = item.center;
        
        if (delta < 0) {
            
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            
            center.y += MIN(delta, delta*scrollResistance);
        }
        
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    return NO;
}
- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds{
    
}
@end
