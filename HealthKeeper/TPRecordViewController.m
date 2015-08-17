//
//  TPRecordViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPRecordViewController.h"
#import "TPTestAnswerTableViewCell.h"
#import "TPTestListCollectionViewCell.h"
@interface TPRecordViewController ()
@property (nonatomic) int tableViewSelectedRow;
@property (nonatomic) int  collectionViewSelectedRow;
@end

@implementation TPRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.tabBarController.tabBar.hidden = YES;
    self.myAnswerTableView.delegate = self;
    self.myAnswerTableView.dataSource = self;
    self.tableViewSelectedRow = 99;
    self.collectionViewSelectedRow = 99;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"TPTestListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
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
#pragma mark  tableView datasource &delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *theCell = @"cell";
    TPTestAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theCell ];
    if (cell==nil){
        cell= [[[NSBundle mainBundle]loadNibNamed:@"TPTestAnswerTableViewCell" owner:nil options:nil] firstObject];
    }
    if (indexPath.row==self.tableViewSelectedRow){
        cell.cellTitleLabel.backgroundColor = [UIColor colorWithRed:0.267 green:0.655 blue:0.357 alpha:1.000];
        cell.cellTitleLabel.textColor = [UIColor whiteColor];
        cell.cellTitleDesLabel.textColor = [UIColor colorWithRed:0.267 green:0.655 blue:0.357 alpha:1.000];
//        cell.cellTitleDesLabel.backgroundColor = [UIColor colorWithRed:0.267 green:0.655 blue:0.357 alpha:1.000];
        
    }
    else{
        cell.cellTitleLabel.backgroundColor = [UIColor whiteColor];
        cell.cellTitleLabel.textColor = [UIColor blackColor];
        cell.cellTitleDesLabel.textColor = [UIColor blackColor];
        //cell.cellTitleDesLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableViewSelectedRow = (int)indexPath.row;
    [self.myAnswerTableView reloadData];
}

#pragma  mark  collectionView delegate &datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"cell";
    TPTestListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.cellIndexLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
@end
