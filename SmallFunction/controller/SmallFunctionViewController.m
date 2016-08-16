#import "SmallFunctionViewController.h"

#import "SmallFunctionTableViewCell.h"

#import "ZHRemoveTheComments.h"

#import "ZHStatisticalCodeRows.h"

@interface SmallFunctionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end


@implementation SmallFunctionViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
        
        NSArray *arr=@[@"去除代码注释",@"修改类文件名",@"查看工程或文件总代码行数"];
        
        for (NSInteger i=0; i<arr.count; i++) {
            @autoreleasepool {
                SmallFunctionCellModel *SmallFunctionModel=[SmallFunctionCellModel new];
                SmallFunctionModel.title=arr[i];
                [_dataArr addObject:SmallFunctionModel];
            }
        }
	}
	return _dataArr;
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
	self.tableView.delegate=self;
    
	self.tableView.dataSource=self;
    
    self.tableView.tableFooterView=[UIView new];
    
	self.edgesForExtendedLayout=UIRectEdgeNone;
    
    //设置NavagationBar (Left和Right) Title
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(leftBarClick)];
    self.title=@"小功能";
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
	return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
	return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	id modelObjct=self.dataArr[indexPath.row];
    
	if ([modelObjct isKindOfClass:[SmallFunctionCellModel class]]){
        
		SmallFunctionTableViewCell *smallFunctionCell=[tableView dequeueReusableCellWithIdentifier:@"SmallFunctionTableViewCell"];
        
		SmallFunctionCellModel *model=modelObjct;
        
		[smallFunctionCell refreshUI:model];
        
		return smallFunctionCell;
        
	}
    
	//随便给一个cell
    
	UITableViewCell *cell=[UITableViewCell new];
    
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    
    [ZHFileManager createFileAtPath:macDesktopPath];
    
    SmallFunctionCellModel *model=self.dataArr[indexPath.row];
    
    NSString *Msg;
    
    if (indexPath.row==0) {//去除注释
        Msg=@"请把要去除注释的 \"文件或文件夹路径\" 填写在桌面的\"代码助手.m\"中";
        [self removeTheCommentWithTitle:model.title withMsg:Msg];
    }
    
    if (indexPath.row==1) {//修改类文件名
        Msg=@"请把要修改类文件名的 \"文件或文件夹\" 路径填写在桌面的\"代码助手.m\"中";
        [self modifyTheFileNameWithTitle:model.title withMsg:Msg];
    }
    
    if (indexPath.row==2) {//查看工程或文件总代码行数
        Msg=@"请把要查看工程或文件总代码行数的 \"文件或文件夹\" 路径填写在桌面的\"代码助手.m\"中";
        [self totalNumberOfLinesOfCodeWithTitle:model.title withMsg:Msg];
    }
}

- (NSString *)getPath{
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    NSString *text=[NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
    return text;
}

- (void)removeTheCommentAction:(NSString *)path RemoveTheCommentsType:(ZHRemoveTheCommentsType)removeTheCommentsType{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (path.length<=0) {
        hud.labelText = @"路径为空!";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        return;
    }
    hud.labelText = [NSString stringWithFormat:@"正在备份(%@)...",[ZHFileManager fileSizeString:path]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //备份工程
        //有后缀的文件名
        NSString *tempFileName=[ZHFileManager getFileNameFromFilePath:path];
        
        //无后缀的文件名
        NSString *fileName=[ZHFileManager getFileNameNoPathComponentFromFilePath:path];
        
        //获取无文件名的路径
        NSString *newFilePath=[path stringByReplacingOccurrencesOfString:tempFileName withString:@""];
        //拿到新的有后缀的文件名
        tempFileName=[tempFileName stringByReplacingOccurrencesOfString:fileName withString:[NSString stringWithFormat:@"%@备份",fileName]];
        
        newFilePath = [newFilePath stringByAppendingPathComponent:tempFileName];
        
        if([ZHFileManager fileExistsAtPath:newFilePath]){
            [ZHFileManager removeItemAtPath:newFilePath];
        }
        
        BOOL result=[ZHFileManager copyItemAtPath:path toPath:newFilePath];
        
        if (result) {
            hud.labelText = @"备份成功,正在处理注释...";
        }else{
            hud.labelText = @"备份失败!请先关闭工程(XCode)";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            return ;
        }
        
        // 处理耗时操作的代码块...
        NSString *resultString=[ZHRemoveTheComments BeginWithFilePath:[self getPath] type:removeTheCommentsType];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.labelText=resultString;
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        });
    });
}
/**去除注释*/
- (void)removeTheCommentWithTitle:(NSString *)title withMsg:(NSString *)msg{
    [ZHAlertAction alertWithTitle:title withMsg:msg addToViewController:self ActionSheet:NO otherButtonBlocks:@[^{
        [self removeTheCommentAction:[self getPath] RemoveTheCommentsType:ZHRemoveTheCommentsTypeEnglishComments];
    },^{
        [self removeTheCommentAction:[self getPath] RemoveTheCommentsType:ZHRemoveTheCommentsTypeAllComments];
    },^{
        [self removeTheCommentAction:[self getPath] RemoveTheCommentsType:ZHRemoveTheCommentsTypeDoubleSlashComments];
    },^{
        [self removeTheCommentAction:[self getPath] RemoveTheCommentsType:ZHRemoveTheCommentsTypeFuncInstructionsComments];
    },^{
        [self removeTheCommentAction:[self getPath] RemoveTheCommentsType:ZHRemoveTheCommentsTypeFileInstructionsComments];
    }] otherButtonTitles:@[@"只留中文注释",@"删除全部注释",@"删除//注释",@"删除/**/或/***/注释",@"删除文件说明注释"]];
}

/**修改类文件名*/
- (void)modifyTheFileNameWithTitle:(NSString *)title withMsg:(NSString *)msg{
    [ZHAlertAction alertWithTitle:@"正在努力" withMsg:nil addToViewController:self withCancleBlock:nil withOkBlock:^{
        
    } cancelButtonTitle:@"取消" OkButtonTitle:@"谢谢使用" ActionSheet:NO];
//    [ZHAlertAction alertWithTitle:title withMsg:msg addToViewController:self withCancleBlock:nil withOkBlock:^{
//        
//    } cancelButtonTitle:@"取消" OkButtonTitle:@"已填写好,生成代码" ActionSheet:NO];
}

- (void)statisticalNumberOfLinesOfCode{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    NSString *path=[self getPath];
    if (path.length<=0) {
        hud.labelText = @"路径为空!";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        return;
    }
    hud.labelText = @"正在统计!";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *resultString=[ZHStatisticalCodeRows Begin:path];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.labelText=resultString;
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        });
    });
}
/**查看工程或文件总代码行数*/
- (void)totalNumberOfLinesOfCodeWithTitle:(NSString *)title withMsg:(NSString *)msg{
    [ZHAlertAction alertWithTitle:title withMsg:msg addToViewController:self withCancleBlock:nil withOkBlock:^{
        [self statisticalNumberOfLinesOfCode];
    } cancelButtonTitle:@"取消" OkButtonTitle:@"已填写完路径,查看工程总代码行数" ActionSheet:NO];
}

@end