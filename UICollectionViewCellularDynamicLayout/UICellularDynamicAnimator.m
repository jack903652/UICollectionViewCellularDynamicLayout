//
//  UICellularDynamicAnimator.m
//  UICollectionViewCellularDynamicLayout
//
//  Created by bamq on 16/4/22.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "UICellularDynamicAnimator.h"

@implementation UICellularDynamicAnimator
{

}
-(instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self =[super initWithCollectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}
- (NSArray<id<UIDynamicItem>> *)itemsInRect:(CGRect)rect{
    return nil;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
