#import "AddViewController.h"

#import "DetailTableViewCell.h"
#import "ConditionTableViewCell.h"
#import "ImageImportTableViewCell.h"
#import "StoryBoardImportTableViewCell.h"
#import "ReplaceCleanTableViewCell.h"
#import "ZHBlockSingleCategroy.h"

#import "ConditionView.h"
@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString *selfMyID;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,weak)UIView *conditionView;
@end

@implementation AddViewController

- (void)changeDataArr:(SearchCellModel *)dataModel{
    self.selfMyID=dataModel.MyID;
    _dataArr=[NSMutableArray array];
    
    DetailCellModel *modelDetail=[DetailCellModel new];
    modelDetail.category=dataModel.category;
    modelDetail.noChange=YES;
    [_dataArr addObject:modelDetail];
    
    ConditionCellModel *modelCondition=[ConditionCellModel new];
    if (dataModel.condition.length>0) {
        modelCondition.conditionArrM=[NSMutableArray array];
        for (NSString *str in [dataModel.condition componentsSeparatedByString:@" "]) {
            if (str.length>0) {
                [modelCondition.conditionArrM addObject:str];
            }
        }
    }else{
        modelCondition.conditionArrM=[NSMutableArray array];
    }
    [_dataArr addObject:modelCondition];
    
    ImageImportCellModel *modelImageImport=[ImageImportCellModel new];
    modelImageImport.noChange=YES;
    modelImageImport.imagePath=dataModel.iconImage;
    [_dataArr addObject:modelImageImport];
    
    StoryBoardImportCellModel *modelStoryBoardImport=[StoryBoardImportCellModel new];
    modelStoryBoardImport.noChange=YES;
    modelStoryBoardImport.stroyboardPath=dataModel.storyboard;
    [_dataArr addObject:modelStoryBoardImport];
    
    //加入最后一个重置和添加的cell
    [_dataArr addObject:@"取消和修改"];
}

#pragma mark 完成
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
        DetailCellModel *modelDetail=[DetailCellModel new];
        [_dataArr addObject:modelDetail];
        ConditionCellModel *modelCondition=[ConditionCellModel new];
        [_dataArr addObject:modelCondition];
        ImageImportCellModel *modelImageImport=[ImageImportCellModel new];
        [_dataArr addObject:modelImageImport];
        StoryBoardImportCellModel *modelStoryBoardImport=[StoryBoardImportCellModel new];
        [_dataArr addObject:modelStoryBoardImport];
        
        //加入最后一个重置和添加的cell
        [_dataArr addObject:@"重置和添加"];
    }
    return _dataArr;
}

- (BOOL)check{
    ImageImportCellModel *modelImageImport=self.dataArr[2];
    if(modelImageImport.imagePath.length<=0){
        [ZHHelp AlertMsg:@"图片不能为空"];
        return NO;
    }
    if([ZHFileManager fileExistsAtPath:modelImageImport.imagePath]==NO){
        [ZHHelp AlertMsg:@"哥,你刚刚把图片删了"];
        return NO;
    }
    StoryBoardImportCellModel *modelStoryBoardImport=self.dataArr[3];
    if(modelStoryBoardImport.stroyboardPath.length<=0){
        [ZHHelp AlertMsg:@"stroyBoard路径不能为空"];
        return NO;
    }
    if([ZHFileManager fileExistsAtPath:modelStoryBoardImport.stroyboardPath]==NO){
        [ZHHelp AlertMsg:@"哥,你刚刚把CodeRobot.stroyBoard删了"];
        return NO;
    }
    return YES;
}
- (BOOL)addActionIsChange:(BOOL)change{
    if ([self check]==NO) {
        return NO;
    }
    
    DetailCellModel *modelDetail=self.dataArr[0];
    ConditionCellModel *modelCondition=self.dataArr[1];
    ImageImportCellModel *modelImageImport=self.dataArr[2];
    StoryBoardImportCellModel *modelStoryBoardImport=self.dataArr[3];
    
    NSString *MyID=@"",*category=@"",*condition=@"",*imagename=@"",*storyboard=@"",*detail=@"",*viewcontroller=@"";
    
    category=modelDetail.category;
    condition =[modelCondition.conditionArrM componentsJoinedByString:@" "];
    imagename=modelImageImport.imagePath;
    storyboard=modelStoryBoardImport.stroyboardPath;
    NSString *newImagePath=modelImageImport.ImagePathNew;
    
    NSString *copyImagePath,*copyStoryBoardPath;
    copyImagePath=[ZHHelp getOlnyOneFilePathToAppWithPathExtension:[[ZHFileManager getFileNameFromFilePath:imagename] pathExtension]];
    copyStoryBoardPath=[ZHHelp getOlnyOneFilePathToAppWithPathExtension:[[ZHFileManager getFileNameFromFilePath:storyboard] pathExtension]];
    
    if(change==NO){
        
        //开始复制一份图片
        [ZHHelp saveFileToApp:[ZHFileManager getFileNameFromFilePath:copyImagePath] withRealFilePath:imagename];
        
        //开始复制一份StoryBoard
        [ZHHelp saveFileToApp:[ZHFileManager getFileNameFromFilePath:copyStoryBoardPath] withRealFilePath:storyboard];
    }
    else if(change==YES){
        
        //开始复制一份图片
        if (newImagePath.length>0) {
            copyImagePath=[ZHHelp getOlnyOneFilePathToAppWithPathExtension:[[ZHFileManager getFileNameFromFilePath:newImagePath] pathExtension]];
            [ZHHelp saveFileToApp:[ZHFileManager getFileNameFromFilePath:copyImagePath]withRealFilePath:newImagePath];
            [ZHHelp deleteFileFromApp:[ZHFileManager getFileNameFromFilePath:imagename]];
        }
    }
    
    if(change==NO){
        MyID=[NSString stringWithFormat:@"%d%d%d",arc4random(),arc4random(),arc4random()];
        while ([[ZHFMDBHelp defaultZHFMDBHelp]HasExistInfo:MyID]) {
            MyID=[NSString stringWithFormat:@"%d%d%d",arc4random(),arc4random(),arc4random()];
        }
        [[ZHFMDBHelp defaultZHFMDBHelp]insertDataWithMyID:MyID withCategory:category withCondition:condition withImagename:copyImagePath withStoryboard:copyStoryBoardPath withDetail:detail withViewcontroller:viewcontroller];
    }else{
        [[ZHFMDBHelp defaultZHFMDBHelp]updataDataWithTitle:self.selfMyID withCategory:category withCondition:condition withImagename:imagename withStoryboard:storyboard withDetail:detail withViewcontroller:@""];
    }
    return YES;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    if (self.selfMyID.length>0) {
        self.title=@"修改搜索条件";
    }else
        self.title=@"添加";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [TabBarAndNavagation setTitleColor:[UIColor blackColor] forNavagationBar:self];
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(back)];
    
    __weak typeof(self)weakSelf=self;
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        ConditionView *view=[[NSBundle mainBundle]loadNibNamed:@"ConditionView" owner:weakSelf options:0][0];
        view.frame=CGRectMake(0, (weakSelf.view.height-343)/2.0, weakSelf.view.width, 343);
        UIView *bgview=[[UIView alloc]initWithFrame:weakSelf.view.bounds];
        bgview.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        [bgview addSubview:view];
        weakSelf.conditionView=bgview;
        [view cornerRadiusWithFloat:20];
        [weakSelf.view addSubview:bgview];
    } WithIdentity:@"addConditionView"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        if (weakSelf.conditionView) {
            [weakSelf.conditionView removeFromSuperview];
        }
    } WithIdentity:@"removeConditionView"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        if([weakSelf addActionIsChange:NO]){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ZHBlockSingleCategroy runBlockNSIntegerIdentity:@"reloadData" Intege1:1];
        }
    } WithIdentity:@"addAction"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        //删除MainStoryBoard
        for (id obj in weakSelf.dataArr) {
            if ([obj isKindOfClass:[StoryBoardImportCellModel class]]) {
                StoryBoardImportCellModel *model=
                ((StoryBoardImportCellModel *)obj);
                if (model.stroyboardPath.length>0) {
                    [[NSFileManager defaultManager]removeItemAtPath:model.stroyboardPath error:nil];
                }
            }
        }
        [weakSelf.dataArr removeAllObjects];
        weakSelf.dataArr=nil;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    } WithIdentity:@"cleanAction"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        ConditionCellModel *modelCondition=weakSelf.dataArr[1];
        [modelCondition.conditionArrM removeAllObjects];
        ImageImportCellModel *modelImageImport=weakSelf.dataArr[2];
        modelImageImport.imagePath=@"";
        StoryBoardImportCellModel *modelStoryBoardImport=weakSelf.dataArr[3];
        modelStoryBoardImport.stroyboardPath=@"";
        [weakSelf.tableView reloadData];
    } WithIdentity:@"cleanDo"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        if ([weakSelf addActionIsChange:YES]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ZHBlockSingleCategroy runBlockNSIntegerIdentity:@"reloadData" Intege1:0];
        }
    } WithIdentity:@"updataOldAction"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } WithIdentity:@"returnIndex"];
    [ZHBlockSingleCategroy addBlockWithNSString:^(NSString *str1) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:str1 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    } WithIdentity:@"AlertMsg"];
}
- (BOOL)checkNeedNOGiveUp{
    ConditionCellModel *modelCondition=self.dataArr[1];
    if (modelCondition.conditionArrM.count>0) {
        return YES;
    }
    ImageImportCellModel *modelImageImport=self.dataArr[2];
    if(modelImageImport.imagePath.length>0){
        return YES;
    }
    StoryBoardImportCellModel *modelStoryBoardImport=self.dataArr[3];
    if(modelStoryBoardImport.stroyboardPath.length>0){
        return YES;
    }
    return NO;
}
- (void)back{
    if(self.selfMyID.length>0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    //提示是否需要保存
    if ([self checkNeedNOGiveUp]) {
        ZHAlertAction *zh=[ZHAlertAction new];
        [zh alertWithTitle:@"提示" withMsg:@"你还没有保存,是否返回主页" addToViewController:self withCancleBlock:nil withOkBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } ActionSheet:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        DetailCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0;
        }
    }else if (section==2){
        ImageImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0;
        }
    }else if (section==3){
        StoryBoardImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0;
        }
    }
    return 1;
}
- (void)setCell:(UITableViewCell *)cell{
    [cell cornerRadiusWithFloat:10 borderColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.6] borderWidth:2];
    cell.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.2];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        DetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        DetailCellModel *model=self.dataArr[indexPath.section];
        [self setCell:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell refreshUI:model];
        return cell;
    }else if (indexPath.section==1){
        ConditionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConditionTableViewCell"];
        ConditionCellModel *model=self.dataArr[indexPath.section];
        [self setCell:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell refreshUI:model];
        return cell;
    }else if (indexPath.section==2){
        ImageImportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ImageImportTableViewCell"];
        ImageImportCellModel *model=self.dataArr[indexPath.section];
        [self setCell:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell refreshUI:model];
        return cell;
    }else if (indexPath.section==3){
        StoryBoardImportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StoryBoardImportTableViewCell"];
        StoryBoardImportCellModel *model=self.dataArr[indexPath.section];
        [self setCell:cell];
        DetailCellModel *detailModel=self.dataArr[0];
        cell.detailModel=detailModel;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell refreshUI:model];
        return cell;
    }else if (indexPath.section==4){
        ReplaceCleanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReplaceCleanTableViewCell"];
        [cell refreshUI:self.dataArr[indexPath.section]];
        [self setCell:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 120;
    }else if (indexPath.section==1){
        return 221;
    }else if (indexPath.section==2){
        return 400;
    }else if (indexPath.section==3){
        return 125;
    }else if (indexPath.section==4){
        return 63;
    }
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        DetailCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0.01;
        }
    }
    if (section==2) {
        ImageImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0.01;
        }
    }
    if (section==3) {
        StoryBoardImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return 0.01;
        }
    }
    return 30.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        DetailCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return nil;
        }
        return @"设置类型";
    }
    if (section==1) {
        return @"设置搜索条件(非必填)";
    }
    if (section==2) {
        ImageImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return nil;
        }
        return @"设置图片(必填)";
    }
    if (section==3) {
        StoryBoardImportCellModel *model=self.dataArr[section];
        if (model.noChange) {
            return nil;
        }
        return @"导入cell(必填)";
    }
    if (section==4) {
        return @"保存或重置";
    }
    return @"";
}
@end