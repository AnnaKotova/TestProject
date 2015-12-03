//
//  ListViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ListViewController.h"
#import "TravelInfoViewController.h"

@interface ListViewController ()

@property (nonatomic) UITableView* tableView;

@property (nonatomic) TravelCollection* travelInfoArray;//TravelInfo from CoreData

@end

@implementation ListViewController

-(UITableView*) tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(TravelCollection*) travelInfoArray {
    if(!_travelInfoArray) {
        _travelInfoArray = [[TravelCollection alloc] init];
    }
    return _travelInfoArray;
}

-(void) viewDidUnload {
    [super viewDidUnload];
    [self.tableView release];
    [self.travelInfoArray release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    NSLog(@"%d",self.travelInfoArray.travelPoints.count);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning!");
    // Dispose of any resources that can be recreated.
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"%f %f %@ %@ %@",info.latitude,info.longitude,info.name,info.imageUrl,info.soundUrl);
    TravelInfoViewController* tivController = [[TravelInfoViewController alloc] initWithModel:self.travelInfoArray andCurrentIndex:indexPath.row];
    [self.navigationController pushViewController:tivController animated:YES];
    [tivController release];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.travelInfoArray.travelPoints.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TravelModel* info =(TravelModel*) self.travelInfoArray.travelPoints[indexPath.row];
    if (info) {
    //NSLog(@"%f %f %@ %@ %@",info.latitude,info.longitude,info.name,info.imageUrl,info.soundUrl);
        [cell.textLabel setText:info.name];
    }
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
