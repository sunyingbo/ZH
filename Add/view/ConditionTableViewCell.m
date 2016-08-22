#import "ConditionTableViewCell.h"
#import "SubContitionTabViewCell.h"
#import "ZHBlockSingleCategroy.h"
@interface ConditionTableViewCell ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)ConditionCellModel * dataModel;
@end


@implementation ConditionTableViewCell
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)refreshUI:(ConditionCellModel *)dataModel{
    _dataModel=dataModel;
    _dataArr=dataModel.conditionArrM;
    [self.tableView reloadData];
    __weak typeof(self)weakSef=self;
    [ZHBlockSingleCategroy addBlockWithNSString:^(NSString *str1) {
        for (NSString *str in weakSef.dataArr) {
            if ([[str1 substringFromIndex:[str1 rangeOfString:@"个"].location+1] isEqualToString:[str substringFromIndex:[str rangeOfString:@"个"].location+1]]) {
                NSInteger index=[weakSef.dataArr indexOfObject:str];
                [weakSef.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSef.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [ZHHelp AlertMsg:[[str1 substringFromIndex:[str1 rangeOfString:@"个"].location+1]stringByAppendingString:@"已经添加"]];
                [weakSef.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                return;
            }
        }
        [weakSef.dataArr addObject:str1];
        [weakSef.tableView reloadData];
        [weakSef.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSef.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } WithIdentity:@"addCondition"];
}

- (void)awakeFromNib {
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView cornerRadiusWithFloat:10 borderColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0] borderWidth:2];
}

#pragma mark - 必须实现的方法:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubContitionTabViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SubContitionTabViewCell"];
    [cell cornerRadiusWithFloat:10];
    cell.backgroundColor=[[UIColor blueColor] colorWithAlphaComponent:0.2];
    if(indexPath.row==self.dataArr.count){
        [cell refreshUI:@"添加新的条件"];
    }else if(indexPath.row==self.dataArr.count+1){
        [cell refreshUI:@"清空"];
    }else{
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArr.count){
        [ZHBlockSingleCategroy runBlockNULLIdentity:@"addConditionView"];
    }else if (indexPath.row==self.dataArr.count+1){
        [ZHAlertAction alertWithTitle:@"清空?" withMsg:nil addToViewController:[self getViewController] withCancleBlock:nil withOkBlock:^{
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
        } ActionSheet:NO];
    }
}

/**可以编辑*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArr.count) {
        return NO;
    }
    return YES;
}

/**编辑风格*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

/**设置编辑的控件  删除,置顶,收藏*/
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置删除按钮
    UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    return  @[deleteRowAction];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end


