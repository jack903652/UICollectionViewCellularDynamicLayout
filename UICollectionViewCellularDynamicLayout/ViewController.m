//
//  ViewController.m
//  UICollectionViewCellularDynamicLayout
//
//  Created by bamq on 16/4/14.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewCellularCell.h"
#import "UICollectionViewCellularLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewCellularLayout *layout =[[UICollectionViewCellularLayout alloc] initWithRadius:20 gap:10];
    _collectionView =[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate =self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCellularCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCellularCell class])];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 300;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCellularCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCellularCell class]) forIndexPath:indexPath];
    cell.label.text =[NSString stringWithFormat:@"%ld",(long)indexPath.item];
//    cell.backgroundColor =[UIColor clearColor];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
