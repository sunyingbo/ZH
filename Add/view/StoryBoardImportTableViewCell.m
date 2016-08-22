#import "StoryBoardImportTableViewCell.h"
#import "ZHBlockSingleCategroy.h"

@interface StoryBoardImportTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *importStoryBoardButton;
@property (nonatomic,strong)StoryBoardImportCellModel *dataModel;

@end

@implementation StoryBoardImportTableViewCell

- (void)refreshUI:(StoryBoardImportCellModel *)dataModel{
    _dataModel=dataModel;
    if (dataModel.noChange) {
        self.importStoryBoardButton.enabled=NO;
        [self.importStoryBoardButton setTitle:@"不能修改StoryBoard" forState:(UIControlStateNormal)];
    }
}

- (IBAction)importStoryBoard:(id)sender {
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"CodeRobot.storyboard"];
    NSString *Msg=@"";
    if ([self.detailModel.category isEqualToString:@"UITableViewCell"]) {
        [[ZHHelp getTableView]writeToFile:macDesktopPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        Msg=@"文件\"CodeRobot.storyboard\"已生成在桌面上, 请把你的cell复制粘贴到控制器的tableView中";
    }else if ([self.detailModel.category isEqualToString:@"UICollectionViewCell"]) {
        [[ZHHelp getCollectionView]writeToFile:macDesktopPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        Msg=@"文件\"CodeRobot.storyboard\"已生成在桌面上, 请把你的cell复制粘贴到控制器的collectionView中";
    }
    
    [ZHAlertAction alertWithTitle:@"导入Cell" withMsg:Msg addToViewController:[self getViewController] withCancleBlock:^{
        _dataModel.stroyboardPath=@"";
        [self.importStoryBoardButton setTitle:@"还未导入cell,请导入" forState:(UIControlStateNormal)];
    }withOkBlock:^{
        
        if ([ZHFileManager fileExistsAtPath:macDesktopPath]==NO) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction alertWithMsg:@"CodeRobot.storyboard被你删了!" addToViewController:[self getViewController] ActionSheet:NO];
            });
            return ;
        }else{
            NSString *text=[NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
            NSInteger count=0;
            NSInteger prototypesCount=1;;
            if ([self.detailModel.category isEqualToString:@"UITableViewCell"]) {
                count=[ZHHelp countString:@"<tableViewCell " InString:text];
            }else if ([self.detailModel.category isEqualToString:@"UICollectionViewCell"]) {
                count=[ZHHelp countString:@"<collectionViewCell " InString:text];
                prototypesCount=[ZHHelp countString:@"<prototypes>" InString:text];
            }
            if (count==0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZHAlertAction alertWithMsg:@"可能你没有(保存)ctrl+s,CodeRobot.storyboard里面cell为空!" addToViewController:[self getViewController] ActionSheet:NO];
                });
                return ;
            }
            if (count>1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZHAlertAction alertWithMsg:[NSString stringWithFormat:@"CodeRobot.storyboard里面有%ld个cell,只限一个!",count] addToViewController:[self getViewController] ActionSheet:NO];
                });
                return ;
            }
            if (prototypesCount==0) {
                if ([self.detailModel.category isEqualToString:@"UITableViewCell"]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ZHAlertAction alertWithMsg:[NSString stringWithFormat:@"哥,你把cell没放到TableView里面,而是放到了View里面,不信你打开CodeRobot.storyboard看看"] addToViewController:[self getViewController] ActionSheet:NO];
                    });
                    return ;
                }
            }
            
            _dataModel.stroyboardPath=macDesktopPath;
            [self.importStoryBoardButton setTitle:@"导入cell成功,点击可重改" forState:(UIControlStateNormal)];
        }
    } cancelButtonTitle:@"取消" OkButtonTitle:@"已复制,导入Cell" ActionSheet:NO];
}

- (void)awakeFromNib {
    [self.importStoryBoardButton cornerRadiusWithFloat:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end