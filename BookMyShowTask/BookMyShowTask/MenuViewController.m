//
//  MenuViewController.m
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 12/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCollectionViewCell.h"
#import "LocationListVC.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MenuCollectionViewCell *cell = (MenuCollectionViewCell *)sender;
    
    
    LocationListVC *detailvc = (LocationListVC*)[segue destinationViewController];
    detailvc.CarryCategoryStr=[cell.lbl.text lowercaseString];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imgViw = cell.imgviw;
    UILabel *lbl = cell.lbl;
    // Configure the cell
    
    switch (indexPath.row) {
        case 0:
        {
            imgViw.image=[UIImage imageNamed:@"food.png"];
            lbl.text=@"Food";
        }
            break;
        case 1:
        {
            imgViw.image=[UIImage imageNamed:@"gym.png"];
            lbl.text=@"Gym";
        }
            break;
        case 2:
        {
            imgViw.image=[UIImage imageNamed:@"hospital.png"];
            lbl.text=@"Hospital";
        }
            break;
        case 3:
        {
            imgViw.image=[UIImage imageNamed:@"school-kids.png"];
            lbl.text=@"School";
        }
            break;
        case 4:
        {
            imgViw.image=[UIImage imageNamed:@"spa.png"];
            lbl.text=@"Spa";
        }
            break;
        case 5:
        {
            imgViw.image=[UIImage imageNamed:@"restaurent.png"];
            lbl.text=@"Restaurent";
        }
            break;
        default:
            break;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"NearLocations" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = CGRectInset(self.view.bounds, 8.0f, 8.0f);
    // Adjust cell size

    return CGSizeMake(rect.size.width/2, 160.0f);
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
