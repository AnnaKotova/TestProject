//
//  ListViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ListViewController.h"
#import "TravelInfoViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSArray * travelInfoArray;//TravelInfo from CoreData

@end

@implementation ListViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if(self.travelInfoArray)
    {
        self.travelInfoArray = nil;
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
        _travelInfoArray = [[DataSource.sharedDataSource getTravelItemCollection] retain];
    }
    return _travelInfoArray;
}

#pragma mark - Properties Setters and Getters

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelInfoViewController * tivController = [[[TravelInfoViewController alloc] initWithCurrentIndex:indexPath.row] autorelease];
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
    
    TravelItem * info =(TravelItem *) self.travelInfoArray[indexPath.row];
    if (info)
    {
        [cell.textLabel setText: info.name];
        cell.imageView.image = [[[UIImage alloc] initWithContentsOfFile:info.imageUrl] autorelease];
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

#pragma mark - Private Section

- (void)_refreshTableView:(UIRefreshControl *) refreshControl {
    _travelInfoArray = nil;
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

@end
