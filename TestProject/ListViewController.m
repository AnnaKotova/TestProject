//
//  ListViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ListViewController.h"
#import "TravelInfoViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    UserViewStyle _viewStyle;
}


@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSMutableArray * travelInfoArray; //TravelInfo from CoreData
@property (nonatomic, retain) UICollectionView * collectionView;
@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic) BOOL isHaveSearchFilter;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger countOfTravelItems;

@end

@implementation ListViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem * changeStyleBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Table"
                                                                                 style:UIBarButtonItemStyleDone
                                                                                target:self action:@selector(_changeStyleBarButtonItemAction)] autorelease];
    _viewStyle = ViewTile;
    self.navigationItem.rightBarButtonItem = changeStyleBarButtonItem;
    
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)] autorelease];
    self.searchBar.delegate = self;
    [self.searchBar setShowsCancelButton:YES];
    [self.searchBar setEnablesReturnKeyAutomatically:YES];
    self.isHaveSearchFilter = false;
    self.countOfTravelItems = [DataSource.sharedDataSource getCountOfTravelItems];
    self.currentPage = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_viewStyle == ViewTable)
    {
        [self.tableView reloadData];
    }
    else if(_viewStyle == ViewTile)
    {
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning!");
}

#pragma mark - Properties Setters and Getters

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[[UITableView alloc] initWithFrame:self.view.frame] autorelease];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled = YES;
        UIRefreshControl *refreshControl = [[[UIRefreshControl alloc] init] autorelease];
        [refreshControl addTarget:self action:@selector(_refreshTableView:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
    }
    return _tableView;
}

- (NSArray *)travelInfoArray
{
    if(!_travelInfoArray)
    {
        _travelInfoArray = [[NSMutableArray arrayWithArray:[DataSource.sharedDataSource getTravelItemCollectionByPage:self.currentPage]] retain];
    }
    return _travelInfoArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(72, 72);
        _collectionView = [[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)
                                              collectionViewLayout:flowLayout ] retain];
        [flowLayout autorelease];
        UIRefreshControl * refreshControl = [[[UIRefreshControl alloc] init] autorelease];
        [refreshControl addTarget:self action:@selector(_refreshCollectionView:) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:refreshControl];
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setBounces:YES];
        [_collectionView setAlwaysBounceVertical:YES];
    }
    return _collectionView;
}


#pragma mark - UICollectionView Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.travelInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    TravelItem * info =(TravelItem *) self.travelInfoArray[indexPath.row];
    
    if(info)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)] ;
        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[info.imagePath] options:nil];
        for (PHAsset * asset in fetchResult)
        {
            [PHImageManager.defaultManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                imageView.image = result;
            }];
        }
        [cell addSubview:imageView];
        [cell setBackgroundView:imageView];
        [imageView release];
        UILabel * labelUICollectionCell = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, cell.bounds.size.width, 15)];
        labelUICollectionCell.text = info.name;
        labelUICollectionCell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        labelUICollectionCell.textColor = [UIColor whiteColor];
        labelUICollectionCell.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        labelUICollectionCell.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:labelUICollectionCell];
        [cell bringSubviewToFront:labelUICollectionCell];
        [labelUICollectionCell autorelease];
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TravelInfoViewController * tivController = [[[TravelInfoViewController alloc] initWithCurrentIndex:indexPath.row] autorelease];
    [self.navigationController pushViewController:tivController animated:YES];
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.travelInfoArray.count - 1 && self.travelInfoArray.count <= self.countOfTravelItems)
    {
        self.currentPage++;
        [self.travelInfoArray addObjectsFromArray:[DataSource.sharedDataSource getTravelItemCollectionByPage:self.currentPage]];
        [self.tableView reloadData];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.tableView)
    {
        CGFloat yPos = - scrollView.contentOffset.y;
        if (yPos > 0)
        {
            if(!self.tableView.tableHeaderView)
            {
                self.tableView.tableHeaderView = self.searchBar;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelInfoViewController * tivController;
    if(self.isHaveSearchFilter)
    {
        tivController = [[TravelInfoViewController alloc] initWithTravelModel:(TravelItem *) self.travelInfoArray[indexPath.row]];
    }
    else
    {
       tivController = [[[TravelInfoViewController alloc] initWithCurrentIndex:indexPath.row] autorelease];
    }
    
    [self.navigationController pushViewController:tivController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.travelInfoArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [[tableView dequeueReusableCellWithIdentifier: CellIdentifier] retain];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TravelItem * info = (TravelItem *) self.travelInfoArray[indexPath.row];

    if (info)
    {
        [cell.textLabel setText: info.name];
        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[info.imagePath] options:nil];
        PHImageRequestOptions * option = [PHImageRequestOptions new];
        option.synchronous = YES;
        for (PHAsset * asset in fetchResult)
        {
            [PHImageManager.defaultManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                 cell.imageView.image = result;
            }];
        }
        [option release];
    }
    return [cell autorelease];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TravelItem * itemToremove = self.travelInfoArray[indexPath.row];
        [DataSource.sharedDataSource removeTravelItem:itemToremove];
        [DataSource.sharedDataSource saveContexChanges];
        _travelInfoArray = nil;
        [self.tableView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.travelInfoArray removeAllObjects];
    if([searchText isEqualToString:@""])
    {
        for (NSInteger i = 0; i <=  self.currentPage; i++) {
            [self.travelInfoArray addObjectsFromArray:[DataSource.sharedDataSource getTravelItemCollectionByPage:i]];
        }
        self.isHaveSearchFilter = NO;
    }
    else
    {
        NSString * predicateRequest = [NSString stringWithFormat:@"(name contains[c] '%@')",searchText];
        [self.travelInfoArray addObjectsFromArray:[DataSource.sharedDataSource getTravelItemCollection:predicateRequest]];
        self.isHaveSearchFilter = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - Private Section

- (void)_refreshTableView:(UIRefreshControl *) refreshControl
{
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (void)_changeStyleBarButtonItemAction
{
    if(_viewStyle == ViewTile)
    {
        self.navigationItem.rightBarButtonItem.title = @"Table";
        [self.view bringSubviewToFront:self.tableView];
        _viewStyle = ViewTable;
    }
    else if (_viewStyle == ViewTable)
    {
        self.navigationItem.rightBarButtonItem.title = @"Tile";
        [self.view bringSubviewToFront:self.collectionView];
        _viewStyle = ViewTile;
    }
}

- (void)_refreshCollectionView:(UIRefreshControl *) sender {
    [self.collectionView reloadData];
    [sender endRefreshing];
}
@end
