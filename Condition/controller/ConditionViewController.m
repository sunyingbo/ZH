#import "ConditionViewController.h"
#import "ConditionView.h"
#import "ConditionTableViewNewCell.h"
#import "CreatFatherFile.h"

@interface ConditionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,weak)UIView *conditionView;

@property (nonatomic,strong)CreatFatherFile *cf;

@end

@implementation ConditionViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=self.category;
    if (self.searchConditionArr.count>0) {
        self.dataArr=[NSMutableArray arrayWithArray:self.searchConditionArr];
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    __weak typeof(self)weakSef=self;
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        [weakSef removeConditionView];
    } WithIdentity:@"removeConditionNew"];
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
    } WithIdentity:@"addConditionNew"];
    
    [TabBarAndNavagation setRightBarButtonItemTitle:@"开始搜索" TintColor:[UIColor blackColor] target:self action:@selector(searchAction)];
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(back)];
    self.title=@"条件搜索";
    
    self.tableView.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.2];
    
    [self.tableView cornerRadiusWithFloat:20 borderColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.4] borderWidth:2];
}
- (void)dealloc{
    [ZHBlockSingleCategroy removeBlockWithIdentity:@"addConditionNew"];
    [ZHBlockSingleCategroy removeBlockWithIdentity:@"removeConditionNew"];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchAction{
    //开始进行搜索
    if (self.dataArr.count>0) {
        [ZHBlockSingleCategroy runBlockNSStringIdentity:@"searchAction" Str1:[self.dataArr componentsJoinedByString:@" "]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ZHBlockSingleCategroy runBlockNSStringIdentity:@"searchAction" Str1:@""];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)addConditionView{
    ConditionView *view=[[NSBundle mainBundle]loadNibNamed:@"ConditionView" owner:self options:0][0];
    view.frame=CGRectMake(0, (self.view.height-343)/2.0, self.view.width, 343);
    view.type=1;
    UIView *bgview=[[UIView alloc]initWithFrame:self.view.bounds];
    bgview.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [bgview addSubview:view];
    self.conditionView=bgview;
    [view cornerRadiusWithFloat:20];
    [self.view addSubview:bgview];
}
- (void)removeConditionView{
    [self.conditionView removeFromSuperview];
}
#pragma mark - 必须实现的方法:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConditionTableViewNewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConditionTableViewNewCell"];
    if(indexPath.row==self.dataArr.count){
        [cell refreshUI:@"添加新的条件"];
    }else if(indexPath.row==self.dataArr.count+1){
        [cell refreshUI:@"清空"];
    }else{
        [cell refreshUI:self.dataArr[indexPath.row]];
    }
    return cell;
}

#pragma mark - 必须实现的方法:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArr.count){
        [self addConditionView];
    }else if (indexPath.row==self.dataArr.count+1){
        [ZHAlertAction alertWithTitle:@"清空?" withMsg:nil addToViewController:self withCancleBlock:nil withOkBlock:^{
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

@end
