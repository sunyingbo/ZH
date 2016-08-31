#import "SearchViewController.h"
#import "ConditionViewController.h"
#import "SearchTableViewCell.h"
#import "AddViewController.h"
#import "LagerImageViewController.h"
#import "ZHStroyBoardToPureHandMVC.h"
#import "ZHStroyBoardToMVC.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (nonatomic,strong)NSMutableArray *dataSearchArr;
@property (nonatomic,copy)NSString *categorySelect;
@property (nonatomic,strong)NSMutableArray *AllCategroyArrM;

@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (nonatomic,strong)NSArray *searchConditionArr;

@property (weak, nonatomic) IBOutlet UIButton *selectTBCell;
@property (weak, nonatomic) IBOutlet UIButton *selectCVCell;
@property (weak, nonatomic) IBOutlet UILabel *showAllSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *showAllDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *backUpLabel;

@end

@implementation SearchViewController

- (NSMutableArray *)AllCategroyArrM{
    if (!_AllCategroyArrM) {
        _AllCategroyArrM=[NSMutableArray array];
    }
    return _AllCategroyArrM;
}
- (NSMutableArray *)dataSearchArr{
    if (!_dataSearchArr) {
        _dataSearchArr=[NSMutableArray array];
    }
    return _dataSearchArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkBackUp];
}
- (void)checkBackUp{
    NSString *mainPath=[ZHHelp getHomeDirector];
    mainPath =[mainPath stringByAppendingPathComponent:@"Documents/CodeRobet备份"];
    NSString *macFilePath=[mainPath stringByAppendingPathComponent:@"file"];
    [ZHFileManager creatDirectorIfNotExsit:macFilePath];
    NSString *macSQlitePath=[mainPath stringByAppendingPathComponent:@"SQlite"];
    [ZHFileManager creatDirectorIfNotExsit:macSQlitePath];
    NSInteger macStoryBoardCount=[ZHFileManager subPathFileArrInDirector:macFilePath hasPathExtension:@[@"storyboard"]].count;
    
    [ZHHelp creatMainPath];
    NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appFilePath=[saveSslectImagePath stringByAppendingPathComponent:@"file"];
    NSInteger appStoryBoardCount=[ZHFileManager subPathFileArrInDirector:appFilePath hasPathExtension:@[@"storyboard"]].count;
    
    self.backUpLabel.hidden=YES;
    
    if ([[ZHFMDBHelp defaultZHFMDBHelp]selectDataCount]==0) {
        if (macStoryBoardCount>appStoryBoardCount) {
            self.backUpLabel.text=@"导入备份\n数据";
            self.backUpLabel.hidden=NO;
        }
    }
    if ([[ZHFMDBHelp defaultZHFMDBHelp]selectDataCount]>0) {
        if (macStoryBoardCount!=appStoryBoardCount) {
            self.backUpLabel.text=@"备份数据";
            self.backUpLabel.hidden=NO;
        }
    }
}
- (void)outPut:(SearchCellModel *)model Type:(NSInteger)type{//type=1纯手写模式 2非纯手写模式
    
    [MBProgressHUD showHUDAddedToView:self.view animated:YES];
    
    NSString *mainPath=[ZHHelp getHomeDirector];
    mainPath =[mainPath stringByAppendingPathComponent:@"Documents"];
    NSString *storyBoardFile=@"";
    //这里要进行判断,第一假如选择的类型为tableViewCell,那么就需要只导出一个StoryBoard,并且需要将Cell的MVC全部导出
    if([self.categorySelect isEqualToString:@"UITableViewCell"]){
        NSArray *models;
        if ([self countSelectSearchArr]<1) {
            models=@[model];
        }else{
            NSMutableArray *arrM=[NSMutableArray arrayWithArray:[self selectModelsFromSearchArr]];
            if (![arrM containsObject:model]) {
                [arrM addObject:model];
            }
            models=arrM;
        }
        //提出cells
        NSMutableArray *TableCells=[NSMutableArray array];
        CGFloat minHeight=10000;
        for (SearchCellModel *subModel in models) {
            [[ZHFMDBHelp defaultZHFMDBHelp]addCountById:subModel.MyID];
//            1.找到storyboard
            NSString *storyboardPath=subModel.storyboard;
//            2.提取cells
            NSString *needCellText=[self getCellTextFromStroyBoardFile:storyboardPath];
            //3.提取最小高度
            CGFloat height=[self getCellHeight:needCellText];
            if (height<minHeight) {
                minHeight=height;
            }
            //将cells添加到数组中
            [TableCells addObject:needCellText];
        }
        storyBoardFile=[ZHHelp getTableCellsInsertCells:TableCells];
        storyBoardFile=[storyBoardFile stringByReplacingOccurrencesOfString:@"$$###$$" withString:[NSString stringWithFormat:@"%ld",(NSInteger)minHeight]];
    }
    else if([self.categorySelect isEqualToString:@"UICollectionViewCell"]){
        
        NSArray *models;
        if ([self countSelectSearchArr]<1) {
            models=@[model];
        }else{
            NSMutableArray *arrM=[NSMutableArray arrayWithArray:[self selectModelsFromSearchArr]];
            if (![arrM containsObject:model]) {
                [arrM addObject:model];
            }
            models=arrM;
        }
        //提出cells
        NSMutableArray *collectionViewCells=[NSMutableArray array];
        CGFloat maxHeight=0;
        CGFloat maxWidth=0;
        for (SearchCellModel *subModel in models) {
            [[ZHFMDBHelp defaultZHFMDBHelp]addCountById:subModel.MyID];
            //            1.找到storyboard
            NSString *storyboardPath=subModel.storyboard;
            //            2.提取cells
            NSString *needCellText=[self getCollectionViewCellTextFromStroyBoardFile:storyboardPath];
            //3.提取最小高度
            CGFloat height=[self getCellHeight:needCellText];
            if (height>maxHeight) {
                maxHeight=height;
            }
            CGFloat width=[self getCellWidth:needCellText];
            if (width>maxWidth) {
                maxWidth=width;
            }
            //将cells添加到数组中
            [collectionViewCells addObject:needCellText];
        }
        storyBoardFile=[ZHHelp getCollectionCellsInsertCells:collectionViewCells];
        storyBoardFile=[storyBoardFile stringByReplacingOccurrencesOfString:@"$$$###$$$" withString:[NSString stringWithFormat:@"%ld",(NSInteger)maxWidth]];
        storyBoardFile=[storyBoardFile stringByReplacingOccurrencesOfString:@"###$$$###" withString:[NSString stringWithFormat:@"%ld",(NSInteger)maxHeight]];
    }
    
    NSString *storyBoardPath=[mainPath stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:model.storyboard]];
    [storyBoardFile writeToFile:storyBoardPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *filesPath=@"";
    if (type==1) {
        filesPath=[[ZHStroyBoardToPureHandMVC new] StroyBoard_To_PureHand_MVC:storyBoardPath];
    }else if (type==2){
        filesPath=[[ZHStroyBoardToMVC new] StroyBoard_To_MVC:storyBoardPath];
    }
    NSString *newFilesPath=[mainPath stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:filesPath]];
    [ZHFileManager moveItemAtPath:filesPath toPath:[mainPath stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:filesPath]]];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSArray *fileArr=[ZHChangeCodeFileName getChangeNamesFromFilePath:newFilesPath];
    NSString *jsonString=[ZHChangeCodeFileName getOldNameAndSetStringByPathArr:fileArr];
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    [jsonString writeToFile:macDesktopPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZHAlertAction alertWithTitle:@"请在mac桌面上的代码助手.m,重新修改MVC文件名,请命名不要以数字开头" withMsg:@"修改好了,再点击下面的生成代码选项" addToViewController:self ActionSheet:NO otherButtonBlocks:@[^{
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedToView:self.view animated:YES];
            
            hud.label.text = @"修改中...";
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *result=[ZHChangeCodeFileName changeMultipleCodeFileName:newFilesPath];
                [ZHFileManager moveItemAtPath:newFilesPath toPath:filesPath];
                if (type==1) {
                    [ZHFileManager removeItemAtPath:storyBoardPath];
                }else if (type==2){
                    [ZHFileManager moveItemAtPath:storyBoardPath toPath:[filesPath stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:storyBoardPath]]];
                }
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result.length>0) {
                        hud.label.text = result;
                        [ZHFileManager removeItemAtPath:filesPath];
                        if (type==2){
                            [ZHFileManager removeItemAtPath:[filesPath stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:storyBoardPath]]];
                        }
                    }else
                        hud.label.text = @"生成成功";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    });
                });
            });
        },^{
            [ZHFileManager removeItemAtPath:storyBoardPath];
            [ZHFileManager removeItemAtPath:newFilesPath];
        }] otherButtonTitles:@[@"已填写好,生成代码到桌面",@"放弃这次代码生成"]];
    });
    [self clear];
}
- (void)clear{
    [self cleanSelectArr];
    [self checkShowSelect];
}

- (void)addAction{
    [TabBarAndNavagation pushViewController:@"AddViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
}
- (void)moreFuncAction{
    [TabBarAndNavagation pushViewController:@"MoreFunctionViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableViewSearch cornerRadiusWithFloat:5 borderColor:[[UIColor blueColor]colorWithAlphaComponent:0.6] borderWidth:2];
    
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"搜索" TintColor:[UIColor redColor] target:self action:@selector(gotoConditionView)];
    [TabBarAndNavagation setRightBarButtonItemTitle:@"更多功能" TintColor:[UIColor redColor] target:self action:@selector(moreFuncAction)];
    
    self.title=@"CodeRobot";
    self.tableViewSearch.delegate=self;
    self.tableViewSearch.dataSource=self;
    self.tableViewSearch.contentInset=UIEdgeInsetsMake(0, 0, 70, 0);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self selectTBCellAction];
    
    __weak typeof(self)weakSef=self;
    [ZHBlockSingleCategroy addBlockWithNSString:^(NSString *str1) {
        [weakSef searchAction:(str1)];
    } WithIdentity:@"searchAction"];
    
    [ZHBlockSingleCategroy addBlockWithNSInteger:^(NSInteger Integer) {
        if (Integer==1)[weakSef reloadDataWithNeedScrollToTop:YES];
        else [weakSef reloadDataWithNeedScrollToTop:NO];
    } WithIdentity:@"reloadData"];
    
    [ZHBlockSingleCategroy addBlockWithNSString:^(NSString *str1) {
        //查看大图
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LagerImageViewController *vc=[sb instantiateViewControllerWithIdentifier:@"LagerImageViewController"];
        vc.imagePath=str1;
        [weakSef presentViewController:vc animated:NO completion:nil];
    } WithIdentity:@"LagerImage"];
    [ZHBlockSingleCategroy addBlockWithNSInteger:^(NSInteger Integer) {
        [weakSef singleTap:Integer];
    } WithIdentity:@"SingleTap"];
    [ZHBlockSingleCategroy addBlockWithNULL:^{
        [weakSef checkShowSelect];
    } WithIdentity:@"selectCell"];
    
    [self.addLabel cornerRadius];
    [self.addLabel addUITapGestureRecognizerWithTarget:self withAction:@selector(addAction)];
    
    [self.selectTBCell addTarget:self action:@selector(selectTBCellAction) forControlEvents:1<<6];
    [self.selectCVCell addTarget:self action:@selector(selectCVCellAction) forControlEvents:1<<6];
    [self.showAllDataLabel addUITapGestureRecognizerWithTarget:self withAction:@selector(showAllData)];
    [self.showAllSelectLabel addUITapGestureRecognizerWithTarget:self withAction:@selector(showAllSelect)];
    [self.backUpLabel addUITapGestureRecognizerWithTarget:self withAction:@selector(backUpAction)];
    self.showAllSelectLabel.hidden=self.showAllDataLabel.hidden=YES;
    [self.showAllDataLabel cornerRadius];
    [self.showAllSelectLabel cornerRadius];
    [self.backUpLabel cornerRadius];
    self.backUpLabel.adjustsFontSizeToFitWidth=YES;
    self.backUpLabel.numberOfLines=0;
    
}
- (void)backUpAction{
    
    NSString *mainPath=[ZHHelp getHomeDirector];
    mainPath =[mainPath stringByAppendingPathComponent:@"Documents/CodeRobet备份"];
    [ZHFileManager creatDirectorIfNotExsit:mainPath];
    NSString *macFilePath=[mainPath stringByAppendingPathComponent:@"file"];
    [ZHFileManager creatDirectorIfNotExsit:macFilePath];
    NSString *macSQlitePath=[mainPath stringByAppendingPathComponent:@"SQlite"];
    [ZHFileManager creatDirectorIfNotExsit:macSQlitePath];
    NSInteger macStoryBoardCount=[ZHFileManager subPathFileArrInDirector:macFilePath hasPathExtension:@[@"storyboard"]].count;
    
    [ZHHelp creatMainPath];
    NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appFilePath=[saveSslectImagePath stringByAppendingPathComponent:@"file"];
    NSString *SQlitePath=[saveSslectImagePath stringByAppendingPathComponent:@"SQlite"];
    NSInteger appStoryBoardCount=[ZHFileManager subPathFileArrInDirector:appFilePath hasPathExtension:@[@"storyboard"]].count;
    
    if ([self.backUpLabel.text hasPrefix:@"导入备份"]) {
        if ([[ZHFMDBHelp defaultZHFMDBHelp]selectDataCount]==0) {
            if (macStoryBoardCount>appStoryBoardCount) {
                MBProgressHUD *hud =[MBProgressHUD showHUDAddedToView:self.view animated:YES];
                
                hud.label.text = @"导入备份数据...";
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [[ZHFMDBHelp defaultZHFMDBHelp]closeDataBase];
                    [ZHFileManager removeItemAtPath:appFilePath];
                    [ZHFileManager removeItemAtPath:SQlitePath];
                    
                    [ZHFileManager copyItemAtPath:macFilePath toPath:appFilePath];
                    [ZHFileManager copyItemAtPath:macSQlitePath toPath:SQlitePath];
                    
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud.label.text = @"导入成功,1s后退出";
                        self.backUpLabel.hidden=YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            exit(0);
                        });
                    });
                });
            }
        }
    }else if ([self.backUpLabel.text isEqualToString:@"备份数据"]){
        if ([[ZHFMDBHelp defaultZHFMDBHelp]selectDataCount]>0) {
            if (macStoryBoardCount!=appStoryBoardCount) {
                MBProgressHUD *hud =[MBProgressHUD showHUDAddedToView:self.view animated:YES];
                
                hud.label.text = @"备份数据...";
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [ZHFileManager removeItemAtPath:macFilePath];
                    [ZHFileManager removeItemAtPath:macSQlitePath];
                    [ZHFileManager copyItemAtPath:appFilePath toPath:macFilePath];
                    [ZHFileManager copyItemAtPath:SQlitePath toPath:macSQlitePath];
                    
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.backUpLabel.hidden=YES;
                        hud.label.text = @"备份数据成功";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        });
                    });
                });
                
            }
        }
    }
}
- (void)selectTBCellAction{
    [self.selectTBCell setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self.selectCVCell setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self groupByCategory:@"UITableViewCell"];
    self.categorySelect=@"UITableViewCell";
}
- (void)selectCVCellAction{
    [self.selectTBCell setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.selectCVCell setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [self groupByCategory:@"UICollectionViewCell"];
    self.categorySelect=@"UICollectionViewCell";
}
- (void)singleTap:(NSInteger)section{
    SearchCellModel *model=self.dataSearchArr[section];
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(alertController) weakAlertController=alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    NSString *export;
    //如果打上了勾
    if ([self countSelectSearchArr]>=1) {
        //如果这个勾刚好打到自己的cell上,并且是点击自己的cell来导出
        if ([self countSelectSearchArr]==1&&[[self selectModelsFromSearchArr]containsObject:model]) {
            export=@"生成代码到桌面";
        }else{
            export=@"和已选中的一起生成代码到桌面";
        }
    }else{
        export=@"生成代码到桌面";
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:export style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZHAlertAction alertWithTitle:@"选择模式" withMsg:nil addToViewController:self withCancleBlock:^{
                [self outPut:model Type:1];
            }withOkBlock:^{
                [self outPut:model Type:2];
            } cancelButtonTitle:@"纯手写模式(不要StoryBoard)" OkButtonTitle:@"非纯手写模式(要StoryBoard)" ActionSheet:NO];
        });
        
    }];
    
    UIAlertAction *updataAction = [UIAlertAction actionWithTitle:@"修改搜索条件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanSelectArr];
        //修改
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddViewController *vc=[sb instantiateViewControllerWithIdentifier:@"AddViewController"];
        [vc changeDataArr:model];
        [self.navigationController pushViewController:vc animated:YES];
        
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *lookLagerImage = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZHBlockSingleCategroy runBlockNSStringIdentity:@"LagerImage" Str1:model.iconImage];
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:lookLagerImage];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:updataAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    [ZHBlockSingleCategroy removeBlockWithIdentity:@"searchAction"];
    [ZHBlockSingleCategroy removeBlockWithIdentity:@"searchDetailAction"];
    [[ZHFMDBHelp defaultZHFMDBHelp]allSubCountValue];
}

/**根据条件进行搜索*/
- (void)searchAction:(NSString *)condition{
    if (condition.length>0) {
        self.searchConditionArr=[condition componentsSeparatedByString:@" "];
    }else{
        self.searchConditionArr=nil;
    }
    NSMutableArray *outcomArrM=[NSMutableArray array];
    
    if (condition.length>0) {
        for (SearchCellModel *model in self.AllCategroyArrM) {
            if ([self MeetCondition:model.condition withSubCondition:condition]) {
                [outcomArrM addObject:model];
            }
        }
        self.dataSearchArr=outcomArrM;
        [self.tableViewSearch reloadData];
    }else{
        for (SearchCellModel *model in self.AllCategroyArrM) {
            [outcomArrM addObject:model];
        }
        self.dataSearchArr=outcomArrM;
        [self.tableViewSearch reloadData];
    }
    
}
- (NSInteger)countSelectSearchArr{
    NSInteger count=0;
    for (SearchCellModel *model in self.dataSearchArr) {
        if (model.select) {
            count++;
        }
    }
    return count;
}
- (NSArray *)selectModelsFromSearchArr{
    NSMutableArray *arrM=[NSMutableArray array];
    for (SearchCellModel *model in self.dataSearchArr) {
        if (model.select) {
            [arrM addObject:model];
        }
    }
    return arrM;
}
- (void)cleanSelectArr{
    for (NSInteger i=0; i<self.dataSearchArr.count; i++) {
        SearchCellModel *model=self.dataSearchArr[i];
        model.select=NO;
    }
    [self.tableViewSearch reloadData];
}
- (BOOL)MeetCondition:(NSString *)condition withSubCondition:(NSString *)subCondition{
    NSDictionary *conditionDic=[self getConditionArrFromCondition:condition];
    NSDictionary *subConditionDic=[self getConditionArrFromCondition:subCondition];
    
    //开始比较
    for (NSString *str in subConditionDic) {
        //在子条件中,如果父节点不存在这个条件,就不行
        if (conditionDic[str]==nil||[conditionDic[str] integerValue]<[subConditionDic[str] integerValue]) {
            return NO;
        }
    }
    return YES;
}
- (NSDictionary *)getConditionArrFromCondition:(NSString *)conditon{
    NSArray *arrTemp=[conditon componentsSeparatedByString:@" "];
    NSMutableDictionary *conditionDicM=[NSMutableDictionary dictionary];
    for (NSString *strTemp in arrTemp) {
        NSArray *subArr=[strTemp componentsSeparatedByString:@"个"];
        if(subArr.count==2){
            [conditionDicM setValue:subArr[0] forKey:subArr[1]];
        }
    }
    return conditionDicM;
}
- (void)reloadDataWithNeedScrollToTop:(BOOL)needScrollToTop{
    [MBProgressHUD showHUDAddedToView:self.view animated:YES];
    [self groupByCategory:self.categorySelect];
    if (needScrollToTop) {
        [self.tableViewSearch scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataSearchArr.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)gotoConditionView{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConditionViewController *vc=[sb instantiateViewControllerWithIdentifier:@"ConditionViewController"];
    vc.category=self.categorySelect;
    vc.searchConditionArr=self.searchConditionArr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)groupByCategory:(NSString *)category{
    
    self.dataSearchArr=[NSMutableArray arrayWithArray:[[ZHFMDBHelp defaultZHFMDBHelp]selectDataWithCategory:category]];
    
    for (SearchCellModel *model in self.dataSearchArr) {
        if ([model.condition rangeOfString:@"个"].location!=NSNotFound) {
            model.havCondition=YES;
        }else{
            model.havCondition=NO;
        }
    }
    
    self.AllCategroyArrM=[self.dataSearchArr mutableCopy];
    
    [self.tableViewSearch reloadData];
    
    if (self.dataSearchArr.count==0) {
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedToView:self.view animated:YES];
        
        hud.label.text = @"无数据";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
- (void)checkShowSelect{
    NSInteger count=0;
    for (SearchCellModel *model in self.AllCategroyArrM) {
        if (model.select) {
            count++;
        }
    }
    if (count>0) {
        self.showAllSelectLabel.hidden=NO;
        self.showAllDataLabel.hidden=NO;
        return;
    }
    self.showAllSelectLabel.hidden=YES;
    self.showAllDataLabel.hidden=YES;
}
- (void)showAllData{
    NSMutableArray *arrM=[NSMutableArray array];
    for (SearchCellModel *model in self.AllCategroyArrM) {
        [arrM addObject:model];
    }
    if (arrM.count>0) {
        self.dataSearchArr=arrM;
        [self.tableViewSearch reloadData];
    }
}
- (void)showAllSelect{
    NSMutableArray *arrM=[NSMutableArray array];
    for (SearchCellModel *model in self.AllCategroyArrM) {
        if (model.select) {
            [arrM addObject:model];
        }
    }
    if (arrM.count>0) {
        self.dataSearchArr=arrM;
        [self.tableViewSearch reloadData];
    }
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView isEqual:self.tableViewSearch]){
        return self.dataSearchArr.count;
    }
    [self checkShowSelect];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewSearch]) {
        SearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
        SearchCellModel *model=self.dataSearchArr[indexPath.section];
        UIColor *sjColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.2];
        [cell cornerRadiusWithFloat:10 borderColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.6] borderWidth:2];
        cell.backgroundColor=sjColor;
        cell.tag=indexPath.section;
        [cell refreshUI:model];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewSearch]) {
        SearchCellModel *model=self.dataSearchArr[indexPath.section];
        if (model.imageWidth==0) {
            return 300.0f;
        }
        CGFloat percer=model.imageHeigh/model.imageWidth;
        CGFloat height=(self.view.width-16)*percer;
        if(height<80)
            return 80;
        if(height>350)
            return 350;
        return height;
    }
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewSearch]) {
        SearchTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [self singleTap:indexPath.section];
        [[cell getMyIconImageView] addShakerWithDuration:0.5];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewSearch]) {
        return [NSString stringWithFormat:@"第%ld个",section+1];
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

/**可以编辑*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}

/**编辑风格*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

/**设置编辑的控件  删除,置顶,收藏*/
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableViewSearch]) {
        //设置删除按钮
        UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self deleteDataWithNSIndexPath:indexPath];
            [self checkBackUp];
        }];
        return @[deleteRowAction];
    }
    return nil;
}

- (void)deleteDataWithNSIndexPath:(NSIndexPath *)index{
    ZHAlertAction *zh=[ZHAlertAction new];
    [zh alertWithTitle:@"温馨提示" withMsg:@"是否要删除这条数据" addToViewController:self withCancleBlock:nil withOkBlock:^{
        
        SearchCellModel *model=self.dataSearchArr[index.section];
        [[ZHFMDBHelp defaultZHFMDBHelp]deleteDataWithTitle:model.MyID];
        
        [ZHFileManager removeItemAtPath:model.iconImage];
        [ZHFileManager removeItemAtPath:model.storyboard];
        
        [self.dataSearchArr removeObjectAtIndex:index.section];
        if ([self.AllCategroyArrM containsObject:model]) {
            [self.AllCategroyArrM removeObject:model];
        }
        [self.tableViewSearch deleteSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } ActionSheet:NO];
}
- (NSString *)getCellTextFromStroyBoardFile:(NSString *)filePath{
    
    NSString *textNew=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return  [self subTableViewString:textNew];
}
- (NSString *)getCollectionViewCellTextFromStroyBoardFile:(NSString *)filePath{
    
    NSString *textNew=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return  [self subCollectionViewString:textNew];
}

- (NSString *)subTableViewString:(NSString *)text{
    for (NSString *str in [ZHHelp getMidStringBetweenLeftString:@"<prototypes>" RightString:@"</prototypes>" withText:text]) {
        if ([str rangeOfString:@"<tableViewCell"].location!=NSNotFound) {
            return str;
        }
    }
    return @"";
}
- (NSString *)subCollectionViewString:(NSString *)text{
    for (NSString *str in [ZHHelp getMidStringBetweenLeftString:@"<cells>" RightString:@"</cells>" withText:text]) {
        if ([str rangeOfString:@"<collectionViewCell"].location!=NSNotFound) {
            return str;
        }
    }
    return @"";
}
- (CGFloat)getCellHeight:(NSString *)CellText{
    NSArray *arr=[CellText componentsSeparatedByString:@"\n"];
    NSString *tempStr=@"";
    for (NSString *str in arr) {
        tempStr=[ZHHelp removeSpacePrefix:str];
        if ([tempStr hasPrefix:@"<rect key=\"frame\""]) {
            if ([tempStr rangeOfString:@"height=\""].location!=NSNotFound) {
                NSString *heightStr=[tempStr substringFromIndex:[tempStr rangeOfString:@"height=\""].location+8];
                heightStr=[heightStr substringToIndex:[heightStr rangeOfString:@"\""].location];
                return [heightStr floatValue];
            }
        }
    }
    return 0;
}
- (CGFloat)getCellWidth:(NSString *)CellText{
    NSArray *arr=[CellText componentsSeparatedByString:@"\n"];
    NSString *tempStr=@"";
    for (NSString *str in arr) {
        tempStr=[ZHHelp removeSpacePrefix:str];
        if ([tempStr hasPrefix:@"<rect key=\"frame\""]) {
            if ([tempStr rangeOfString:@"width=\""].location!=NSNotFound) {
                NSString *widthStr=[tempStr substringFromIndex:[tempStr rangeOfString:@"width=\""].location+7];
                widthStr=[widthStr substringToIndex:[widthStr rangeOfString:@"\""].location];
                return [widthStr floatValue];
            }
        }
    }
    return 0;
}
@end