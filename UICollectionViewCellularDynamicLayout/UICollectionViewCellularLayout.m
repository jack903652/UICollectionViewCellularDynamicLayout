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
-(instancetype)init{
    self =[super init];
    if (self) {
        
    }
    return self;
}
- (void)prepareLayout{
    [super prepareLayout];
    width = CGRectGetWidth(self.collectionView.frame);
    gapX =self.gap*cos(M_PI/6);
    gapY =self.gap;
    radiusX =self.radius;
    radiusY = self.radius*cos(M_PI/6);
    itemCenterXDistance =radiusX+0.5*radiusX+gapX;
    column = (width-2*radiusX-2*gapX)/itemCenterXDistance +1;
//    _dynamicAnimator =[[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
//    CGSize contentSize = self.collectionViewContentSize;
//    NSArray *items = [self layoutAttributesForElementsInRect:CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
//    if (self.dynamicAnimator.behaviors.count == 0) {
//        [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
//            UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj
//                                                                        attachedToAnchor:[obj center]];
//            behaviour.length = 0.0f;
//            behaviour.damping = 0.5f;
//            behaviour.frequency = 1.0f;
//            [self.dynamicAnimator addBehavior:behaviour];
//        }];
//    }
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
//    for (NSInteger i = 0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
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
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    UIScrollView *scrollView = self.collectionView;
//    
//    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
//    
//    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
//    
//    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
//        
//        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
//        
//        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
//        
//        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
//        
//        UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
//        
//        CGPoint center = item.center;
//        
//        if (delta < 0) {
//            
//            center.y += MAX(delta, delta*scrollResistance);
//        }
//        else {
//            
//            center.y += MIN(delta, delta*scrollResistance);
//        }
//        
//        item.center = center;
//        
//        [self.dynamicAnimator updateItemUsingCurrentState:item];
//    }];
//    return NO;
//}
@end
