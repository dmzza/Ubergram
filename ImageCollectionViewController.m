//
//  ImageCollectionViewController.m
//  Ubergram
//
//  Created by David Mazza on 2/6/15.
//  Copyright (c) 2015 David Mazza. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>

@interface ImageCollectionViewController ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *resultData;

@end

@implementation ImageCollectionViewController

static NSString * const reuseIdentifier = @"ImageCell";

- (void)awakeFromNib {
  self.images = [[NSMutableArray alloc] init];
  self.resultData = [[NSMutableData alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.


  NSString *query = @"uber";
  NSString *googleImagesURL = @"https://ajax.googleapis.com/ajax/services/search/images"; //[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", query];
    NSDictionary *searchParameters = @{
                                       @"v": @"1.0",
                                       @"q": query
                                       };
//   TODO: handle error
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:googleImagesURL parameters:searchParameters error:nil];
//  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:googleImagesURL]];
  [NSURLConnection connectionWithRequest:request delegate:self];




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];

  cell.backgroundColor = [UIColor whiteColor];
  cell.imageResultView.image = self.images[indexPath.item];

    return cell;
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

//- (void)downloadImageAtURL:(NSString *)imageURL {
//  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//  NSURL *URL = [NSURL URLWithString:imageURL];
//  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//    NSLog(@"File downloaded to: %@", filePath);
//  }];
//  [downloadTask resume];
//}



#pragma mark - NSURLConnection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  // TODO: handle error
  NSError *error;
  NSDictionary *imageData = [NSJSONSerialization JSONObjectWithData:self.resultData options:0 error:&error];

  if (error) {
    NSLog(@"Data: %@", [[NSString alloc] initWithData:self.resultData encoding:NSUTF8StringEncoding]);
    NSLog(@"Data error: %@", error.description);
  }

  NSArray *imageResults = imageData[@"responseData"][@"results"];
  NSLog(@"Number of results:%lu", (unsigned long)imageResults.count);

  for (NSDictionary *result in imageResults) {
    NSString *imageURL = result[@"unescapedUrl"];
    [self.images addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
  }
  [self.collectionView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.resultData appendData:data];

}

#pragma mark - UISearchBar delegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  NSString *query = searchBar.text;
  NSString *googleImagesURL = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", query];
//  NSDictionary *searchParameters = @{
//                                     @"v": @"1.0",
//                                     @"q": query
//                                     };
  // TODO: handle error
//  NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:googleImagesURL parameters:searchParameters error:nil];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:googleImagesURL]];
  [NSURLConnection connectionWithRequest:request delegate:self];
}


@end
