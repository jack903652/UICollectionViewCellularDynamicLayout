//
//  UICollectionViewCellularLayout.h
//  UICollectionViewCellularDynamicLayout
//
//  Created by bamq on 16/4/14.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCellularLayout : UICollectionViewLayout
@property(nonatomic,assign,readonly)CGFloat gap;
@property(nonatomic,assign,readonly)CGFloat radius;
-(instancetype)initWithRadius:(CGFloat)radius gap:(CGFloat)gap;
@end
