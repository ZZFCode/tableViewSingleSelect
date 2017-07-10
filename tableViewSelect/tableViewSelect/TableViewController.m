//
//  TableViewController.m
//  tableViewSelect
//
//  Created by 左忠飞 on 2017/7/10.
//  Copyright © 2017年 左忠飞. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (assign, nonatomic) NSIndexPath       *selIndex;      //单选选中的行
@property (strong, nonatomic) NSMutableArray    *selectIndexs;  //多选选中的行

@property (nonatomic, assign) BOOL              isSingle;       //单选还是多选
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"(单选)";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"多选" style:UIBarButtonItemStylePlain target:self action:@selector(singleSelect)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //初始化多选数组
    _selectIndexs = [NSMutableArray new];
    //初始化刚启动是单选
    _isSingle = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi组,第%zi行",indexPath.section+1,indexPath.row];
    
    
    if (_isSingle) {            //单选
        if (_selIndex == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else{                      //多选
        cell.accessoryType = UIAccessibilityTraitNone;
        for (NSIndexPath *index in _selectIndexs) {
            if (indexPath == index) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return cell;
}

//选中某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSingle) {       //单选
        //取消之前的选择
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
        celled.accessoryType = UITableViewCellAccessoryNone;
        
        //记录当前的选择的位置
        _selIndex = indexPath;
        
        //当前选择的打钩
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{                      //多选
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { //如果为选中状态
            cell.accessoryType = UITableViewCellAccessoryNone; //切换为未选中
            [_selectIndexs removeObject:indexPath]; //数据移除
        }else { //未选中
            cell.accessoryType = UITableViewCellAccessoryCheckmark; //切换为选中
            [_selectIndexs addObject:indexPath]; //添加索引数据到数组
        }
    }
    
}

//组头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//单选还是多选按钮点击事件
-(void)singleSelect{
    _isSingle = !_isSingle;
    if (_isSingle) {
        self.navigationItem.rightBarButtonItem.title = @"多选";
        self.title = @"(单选)";

        [self.selectIndexs removeAllObjects];
        [self.tableView reloadData];
    }else{
        self.title = @"(多选)";
        self.navigationItem.rightBarButtonItem.title = @"单选";
    }
}

@end
