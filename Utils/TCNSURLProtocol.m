//
//  TCNSURLProtocol.m
//  TinnitusCoach
//
//  Created by Creospan on 9/8/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import "TCNSURLProtocol.h"

@implementation TCNSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSLog(@"URL is:%@  and scheme is:%@", theRequest.URL, theRequest.URL.scheme);
    if ([theRequest.URL.scheme caseInsensitiveCompare:@"tcappweb"] == NSOrderedSame) {
        return YES;
    }
    else if([theRequest.URL.scheme caseInsensitiveCompare:@"tcappweb1"] == NSOrderedSame){
        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)theRequest
{
    return theRequest;
}

- (void)startLoading
{
    NSLog(@"got load uRL request :%@ ", self.request.URL);
    NSString* urlString = [self.request.URL absoluteString];
    NSArray* temp = [urlString componentsSeparatedByString:@"://"];
    if (temp.count > 1) {
        
        NSString *protocol = [temp objectAtIndex:0];
        NSString* activity, *itemName, *skillName;
        
        if([protocol isEqualToString:@"tcappweb1"]){
            NSString* paramString = [temp objectAtIndex:1];
            NSArray* params = [paramString componentsSeparatedByString:@"/"];
            for (int i=0; i < params.count; ++i) {
                switch (i) {
                    case 0:
                        activity = [[[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"%20" withString:@" "] stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
                        break;
                    case 1:
                        skillName = [[[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"%20" withString:@" "] stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
                        break;
                    case 2:
                        itemName = [[[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"%20" withString:@" "] stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
                        break;
                        
                    default:
                        break;
                }
            }

        }
        else{
            NSString* paramString = [temp objectAtIndex:1];
            NSArray* params = [paramString componentsSeparatedByString:@"/"];
            for (int i=0; i < params.count; ++i) {
                switch (i) {
                    case 0:
                        activity = [[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
                        break;
                    case 1:
                        itemName = [[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
                        break;
                    case 2:
                        skillName = [[params objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
                        break;
                        
                    default:
                        break;
                }
            }

        }
        
        [self logDatawithActivity:activity andItem:itemName skill:skillName];
    }
    
}

- (void)stopLoading
{
    NSLog(@"loading stopped");
}

-(void)logDatawithActivity:(NSString*)activity andItem:(NSString*)item skill:(NSString *)skill{
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
    NSString *type = @"Learning Nook";
    
    NSString *str = activity;
    
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,item,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
    if(skill){
        
        finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,str,skill,item,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    }
    
    
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

@end

