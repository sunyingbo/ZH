//
//  ZHHelp.m
//  StoryBoard助手
//
//  Created by mac on 16/4/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZHHelp.h"

@implementation ZHHelp
+ (void)AlertMsg:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
+ (NSString *)getHomeDirector{
    if ([NSHomeDirectory() rangeOfString:@"Library/Developer"].location!=NSNotFound) {
        NSString *path=[NSHomeDirectory() substringToIndex:[NSHomeDirectory() rangeOfString:@"Library/Developer"].location];
        return [path substringToIndex:path.length-1];
    }else{
        return @"";
    }
}
+ (UIViewController *)getViewControllerForView:(UIView *)target{
    
    for (UIView *view = target.superview; view; view = view.superview) {
        
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    
    return nil;
}
+ (void)creatDirectorIfNotExsit:(NSString *)DirectorPath{
    BOOL yes;
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath isDirectory:&yes]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:DirectorPath withIntermediateDirectories:yes attributes:nil error:nil];
    }
}
+ (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
+ (void)saveFileToApp:(NSString *)fileName withRealFilePath:(NSString *)realFilePath{
    [self creatMainPath];
    NSString *filepath=[self FilePath];
    filepath=[filepath stringByAppendingPathComponent:fileName];
    if ([ZHFileManager fileExistsAtPath:filepath]==NO) {
        if ([ZHFileManager fileExistsAtPath:realFilePath]) {
            [ZHFileManager copyItemAtPath:realFilePath toPath:filepath];
        }
    }
}
+ (void)deleteFileFromApp:(NSString *)fileName{
    if ([self getFilePathFromApp:fileName].length>0) {
        [ZHFileManager removeItemAtPath:fileName];
    }
}
+ (NSString *)getFilePathFromApp:(NSString *)fileName{
    if (fileName.length>0) {
        [self creatMainPath];
        NSString *filePath=[self FilePath];
        filePath=[filePath stringByAppendingPathComponent:fileName];
        if ([ZHFileManager fileExistsAtPath:filePath]) {
            return filePath;
        }
    }
    return @"";
}
+ (NSString *)getCurFilePathFromApp:(NSString *)filePath{
    [self creatMainPath];
    NSString *filePathTemp=[self FilePath];
    filePathTemp=[filePathTemp stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:filePath]];
    return filePathTemp;
}
/**获取一个独一无二的文件名*/
+ (NSString *)getOlnyOneFilePathToAppWithPathExtension:(NSString *)pathExtension{
    NSString *fileName=[self getStringWithCount:20];
    fileName=[fileName stringByAppendingString:[NSString stringWithFormat:@".%@",pathExtension]];
    while ([self getFilePathFromApp:fileName].length>0) {
        fileName=[self getStringWithCount:20];
        fileName=[fileName stringByAppendingString:[NSString stringWithFormat:@".%@",pathExtension]];
    }
    [self creatMainPath];
    NSString *filePath=[self FilePath];
    return [filePath stringByAppendingPathComponent:fileName];
}
+ (NSString *)getStringWithCount:(NSInteger)count{
    NSMutableString *strM=[NSMutableString string];
    while (count>0) {
        unichar ch;
        NSInteger sj=arc4random()%3;
        if (sj==0) {
            ch=arc4random()%10+'0';
        }else if (sj==1){
            ch=arc4random()%26+'A';
        }else if (sj==2){
            ch=arc4random()%26+'a';
        }
        [strM appendFormat:@"%C",ch];
        count--;
    }
    return strM;
}
+ (NSString *)FilePath{
    NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@"file"];
    return saveSslectImagePath;
}
//如果主目录不存在,就创建主目录
+ (void)creatMainPath{
    BOOL temp;
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self FilePath] isDirectory:&temp])
        [[NSFileManager defaultManager] createDirectoryAtPath:[self FilePath]withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString *)getTableView{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10117\" systemVersion=\"15F34\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
    <dependencies>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"ln6-he-TvZ\">\n\
    <objects>\n\
    <viewController storyboardIdentifier=\"LLLViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"LLLViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"Fs0-p9-OwV\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"JON-mD-ZcH\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"1m3-F1-jrf\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <subviews>\n\
    <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"124\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"AUd-uD-BAZ\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
    </tableView>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
    <constraints>\n\
    <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"leading\" secondItem=\"1m3-F1-jrf\" secondAttribute=\"leading\" id=\"IFI-ix-5mE\"/>\n\
    <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"top\" secondItem=\"Fs0-p9-OwV\" secondAttribute=\"bottom\" id=\"ZBG-g6-JnN\"/>\n\
    <constraint firstItem=\"JON-mD-ZcH\" firstAttribute=\"top\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"bottom\" id=\"gtw-gO-Drr\"/>\n\
    <constraint firstAttribute=\"trailing\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"trailing\" id=\"rHu-tH-pGX\"/>\n\
    </constraints>\n\
    </view>\n\
    <connections>\n\
    <outlet property=\"tableView\" destination=\"AUd-uD-BAZ\" id=\"rF3-tR-YSg\"/>\n\
    </connections>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"J53-ai-Zgt\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    <point key=\"canvasLocation\" x=\"413\" y=\"554\"/>\n\
    </scene>\n\
    </scenes>\n\
    </document>\n";
}
+ (NSString *)getCollectionView{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10117\" systemVersion=\"15F34\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
    <dependencies>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController storyboardIdentifier=\"IIIViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"mVP-Cm-krS\" customClass=\"IIIViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"7cz-NE-Ze6\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"4Vf-XF-v7h\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"D83-1j-lmx\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <subviews>\n\
    <collectionView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"scaleToFill\" dataMode=\"prototypes\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"hB6-Qs-mJM\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
    <collectionViewFlowLayout key=\"collectionViewLayout\" minimumLineSpacing=\"10\" minimumInteritemSpacing=\"10\" id=\"I30-Un-Hin\">\n\
    <size key=\"itemSize\" width=\"179\" height=\"225\"/>\n\
    <size key=\"headerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <size key=\"footerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <inset key=\"sectionInset\" minX=\"0.0\" minY=\"0.0\" maxX=\"0.0\" maxY=\"0.0\"/>\n\
    </collectionViewFlowLayout>\n\
    <cells/>\n\
    </collectionView>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    <constraints>\n\
    <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"leading\" secondItem=\"D83-1j-lmx\" secondAttribute=\"leading\" id=\"2yv-3E-Rez\"/>\n\
    <constraint firstAttribute=\"trailing\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"trailing\" id=\"96b-4d-LF1\"/>\n\
    <constraint firstItem=\"4Vf-XF-v7h\" firstAttribute=\"top\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"bottom\" id=\"I41-ln-kzl\"/>\n\
    <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"top\" secondItem=\"7cz-NE-Ze6\" secondAttribute=\"bottom\" id=\"wPv-0k-7E7\"/>\n\
    </constraints>\n\
    </view>\n\
    <connections>\n\
    <outlet property=\"collectionView\" destination=\"hB6-Qs-mJM\" id=\"lGb-dL-7ux\"/>\n\
    </connections>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dZO-Le-KF4\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    <point key=\"canvasLocation\" x=\"416\" y=\"662\"/>\n\
    </scene>\n\
    </scenes>\n\
    </document>\n";
}

+ (NSInteger)countString:(NSString *)target InString:(NSString *)text{
    NSInteger count=0;
    NSInteger index=[text rangeOfString:target].location;
    if (index!=NSNotFound) {
        count++;
        index++;
        index=[text rangeOfString:target options:NSCaseInsensitiveSearch range:NSMakeRange(index, text.length-index)].location;
        while (index!=NSNotFound) {
            count++;
            index++;
            index=[text rangeOfString:target options:NSCaseInsensitiveSearch range:NSMakeRange(index, text.length-index)].location;
        }
        return count;
    }else
        return 0;
}
+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString withText:(NSString *)text{
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSInteger indexStart=[text rangeOfString:leftString].location;
    NSInteger indexEnd=[text rangeOfString:rightString].location;
    
    while (indexStart!=NSNotFound&&indexEnd!=NSNotFound&&indexStart<indexEnd) {
        [arrM addObject:[text substringWithRange:NSMakeRange(indexStart+leftString.length, indexEnd-indexStart-leftString.length)]];
        indexStart=indexEnd+1;
        
        indexStart=[text rangeOfString:leftString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        if (indexStart!=NSNotFound) {
            indexEnd=[text rangeOfString:rightString options:NSCaseInsensitiveSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        }else break;
    }
    return arrM;
}
+ (NSString *)getTableCellsInsertCells:(NSArray *)textCell{
    NSString *start=@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"9532\" systemVersion=\"14F1605\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" initialViewController=\"BYZ-38-t0r\">\n\
    <dependencies>\n\
    <deployment identifier=\"iOS\"/>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"9530\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController storyboardIdentifier=\"ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"BYZ-38-t0r\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"y3c-jy-aDJ\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"wfy-db-euE\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"8bC-Xf-vdC\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <subviews>\n\
    <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"$$###$$\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"TFz-jU-82c\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
    <prototypes>\n";
    NSString *end=@"\
    </prototypes>\n\
    </tableView>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    <constraints>\n\
    <constraint firstItem=\"TFz-jU-82c\" firstAttribute=\"leading\" secondItem=\"8bC-Xf-vdC\" secondAttribute=\"leading\" id=\"QWC-pT-e1M\"/>\n\
    <constraint firstAttribute=\"trailing\" secondItem=\"TFz-jU-82c\" secondAttribute=\"trailing\" id=\"Ujh-v8-omB\"/>\n\
    <constraint firstItem=\"wfy-db-euE\" firstAttribute=\"top\" secondItem=\"TFz-jU-82c\" secondAttribute=\"bottom\" id=\"luh-Xs-Rle\"/>\n\
    <constraint firstItem=\"TFz-jU-82c\" firstAttribute=\"top\" secondItem=\"y3c-jy-aDJ\" secondAttribute=\"bottom\" id=\"zy3-8A-ofA\"/>\n\
    </constraints>\n\
    </view>\n\
    <connections>\n\
    <outlet property=\"tableView\" destination=\"TFz-jU-82c\" id=\"2aw-ko-uSA\"/>\n\
    </connections>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dkx-z0-nzr\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    <point key=\"canvasLocation\" x=\"244\" y=\"341\"/>\n\
    </scene>\n\
    </scenes>\n\
    </document>";
    NSMutableString *strM=[NSMutableString string];
    [strM appendString:start];
    for (NSString *str in textCell) {
        [strM appendString:str];
    }
    [strM appendString:end];
    return strM;
}
+ (NSString *)getCollectionCellsInsertCells:(NSArray *)textCell{
    NSString *start=@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10117\" systemVersion=\"15F34\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
    <dependencies>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController storyboardIdentifier=\"IIIViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"mVP-Cm-krS\" customClass=\"IIIViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"7cz-NE-Ze6\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"4Vf-XF-v7h\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"D83-1j-lmx\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <subviews>\n\
    <collectionView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"scaleToFill\" dataMode=\"prototypes\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"hB6-Qs-mJM\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
    <collectionViewFlowLayout key=\"collectionViewLayout\" minimumLineSpacing=\"10\" minimumInteritemSpacing=\"10\" id=\"I30-Un-Hin\">\n\
    <size key=\"itemSize\" width=\"$$$###$$$\" height=\"###$$$###\"/>\n\
    <size key=\"headerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <size key=\"footerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <inset key=\"sectionInset\" minX=\"0.0\" minY=\"0.0\" maxX=\"0.0\" maxY=\"0.0\"/>\n\
    </collectionViewFlowLayout>\n\
    <cells>\n";
    NSString *end=@"</cells>\n\
    </collectionView>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    <constraints>\n\
    <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"leading\" secondItem=\"D83-1j-lmx\" secondAttribute=\"leading\" id=\"2yv-3E-Rez\"/>\n\
    <constraint firstAttribute=\"trailing\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"trailing\" id=\"96b-4d-LF1\"/>\n\
    <constraint firstItem=\"4Vf-XF-v7h\" firstAttribute=\"top\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"bottom\" id=\"I41-ln-kzl\"/>\n\
    <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"top\" secondItem=\"7cz-NE-Ze6\" secondAttribute=\"bottom\" id=\"wPv-0k-7E7\"/>\n\
    </constraints>\n\
    </view>\n\
    <connections>\n\
    <outlet property=\"collectionView\" destination=\"hB6-Qs-mJM\" id=\"lGb-dL-7ux\"/>\n\
    </connections>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dZO-Le-KF4\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    <point key=\"canvasLocation\" x=\"415\" y=\"483\"/>\n\
    </scene>\n\
    </scenes>\n\
    </document>";
    NSMutableString *strM=[NSMutableString string];
    [strM appendString:start];
    for (NSString *str in textCell) {
        [strM appendString:str];
    }
    [strM appendString:end];
    return strM;
}
+ (NSString *)removeSpacePrefix:(NSString *)text{
    if ([text hasPrefix:@" "]) {
        text=[text substringFromIndex:1];
        return [self removeSpacePrefix:text];
    }
    else if([text hasPrefix:@"\t"]){
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpacePrefix:text];
    }else
        return text;
}
+ (NSString *)removeSpaceSuffix:(NSString *)text{
    if ([text hasSuffix:@" "]) {
        text=[text substringToIndex:text.length-1];
        return [self removeSpaceSuffix:text];
    }
    else if([text hasSuffix:@"\t"]){
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpaceSuffix:text];
    }else
        return text;
}
@end
