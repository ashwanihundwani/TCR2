//
//  TabBarController.m
//  TinnitusCoach
//
//  Created by Creospan on 4/13/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (id)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabBarController"];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Navigation";
        
        NSString *str = @"Home";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Navigated from Nav Bar",str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
            HomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];

        
        }
    
    
    
    if (tabBarController.selectedIndex == 1) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Navigation";
        
        NSString *str = @"Sampler";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Navigated from Nav Bar",str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
               
    }

    
    if (tabBarController.selectedIndex == 2) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Navigation";
        
        NSString *str = @"Plan";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Navigated from Nav Bar",str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
    }

    
    if (tabBarController.selectedIndex == 3) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Navigation";
        
        NSString *str = @"Learn";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Navigated from Nav Bar",str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }

    
    if (tabBarController.selectedIndex == 4) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:@"TinnitusCoachUsageData.csv"];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        NSString *dateString = [dateFormatter stringFromDate: date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        NSString *type = @"Navigation";
        
        NSString *str = @"Support";
        NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,@"Navigated from Nav Bar",str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:documentTXTPath])
        {
            [finalStr writeToFile:documentTXTPath atomically:YES];
        }
        else
        {
            NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
            [myHandle seekToEndOfFile];
            [myHandle writeData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        
    }

    
    
        
    }
    
    
    
    
    
    


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
