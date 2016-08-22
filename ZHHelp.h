//
//  ZHHelp.h
//  StoryBoard助手
//
//  Created by mac on 16/4/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHHelp : NSObject
+ (void)AlertMsg:(NSString *)msg;
+ (NSString *)getHomeDirector;
+(UIViewController *)getViewControllerForView:(UIView *)target;
+ (void)creatDirectorIfNotExsit:(NSString *)DirectorPath;
+ (BOOL)validateNumber:(NSString*)number;
+ (void)saveFileToApp:(NSString *)fileName withRealFilePath:(NSString *)realFilePath;
+ (NSString *)getFilePathFromApp:(NSString *)fileName;
+ (void)deleteFileFromApp:(NSString *)fileName;
/**获取一个独一无二的文件名*/
+ (NSString *)getOlnyOneFilePathToAppWithPathExtension:(NSString *)pathExtension;
+ (NSString *)getCurFilePathFromApp:(NSString *)filePath;
+ (NSString *)getTableView;
+ (NSString *)getCollectionView;

+ (NSInteger)countString:(NSString *)target InString:(NSString *)text;
+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString withText:(NSString *)text;
+ (NSString *)getTableCellsInsertCells:(NSArray *)textCell;
+ (NSString *)getCollectionCellsInsertCells:(NSArray *)textCell;
+ (NSString *)removeSpacePrefix:(NSString *)text;
+ (NSString *)removeSpaceSuffix:(NSString *)text;

//如果主目录不存在,就创建主目录
+ (void)creatMainPath;
@end