//
//  ImageCollectionViewController.h
//  Ubergram
//
//  Created by David Mazza on 2/6/15.
//  Copyright (c) 2015 David Mazza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewController : UICollectionViewController<UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
