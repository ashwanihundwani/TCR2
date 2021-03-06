 
#import "NookFAQ.h"

@interface NookFAQ ()

@end

@implementation NookFAQ

- (void)viewDidLoad
{
    [super viewDidLoad];
     //NSURL *url = [NSURL URLWithString:fullURL];
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"NookFAQ.html"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    self.title=@"Learning Nook";

    //  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2views" ofType:@"png" inDirectory:@"www"]];

    
   //  NSString *fullURL = @"http://google.com";
 //   NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    
 //   NSString *path = [[NSBundle mainBundle] bundlePath];
  //  NSURL *baseURL = [NSURL fileURLWithPath:path];
    //[webView loadHTMLString:htmlString baseURL:baseURL];
    
    
    
    
// NSURL *url = [NSURL URLWithString:@"http://google.com"];

    
  //      NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  //   [_viewWeb loadRequest:requestObj];
    
    
 //
    
    //[self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{    [self writeVisitedPage];
}


-(void)writeVisitedPage{
    //  NSURL *path = [self getUrlOfFiles:@"TinnitusCoachUsageData.csv"];
    
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
    NSString *type = @"Accessed Chapter";
    
    NSString *str = @"Frequently Asked Questions";
    NSString   *finalStr = [NSString stringWithFormat:@"\r%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",dateString,timeString,type,nil,str,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil];
    
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
