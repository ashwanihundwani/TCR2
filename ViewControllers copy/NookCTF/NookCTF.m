 
#import "NookCTF.h"

@interface NookCTF ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *controller;

@end

@implementation NookCTF

- (void)viewDidLoad
{
    [super viewDidLoad];
     //NSURL *url = [NSURL URLWithString:fullURL];
 //   NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NookCTF" ofType:@"html" inDirectory:@"www"]];
 //   NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NookCTF" ofType:@"html" inDirectory:@"Resources"]];
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"NookCTFNew.html"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    self.title=@"Learning Nook";

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
    
  //  self.navigationController.navigationBarHidden = YES;

    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.viewWeb.delegate=self;
    [self writeVisitedPage];
}





- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}




-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
 
    
    if ([request.URL.scheme isEqualToString:@"apple"])
    {
    
    
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"CognitiveBehaviorTherapyForTinnitus" withExtension:@"pdf"];
    
    self.controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    
    [self.controller setDelegate:self];
    [self.controller presentPreviewAnimated:YES];
    
    return NO;
}
    else
    {
        return YES;}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *str = @"Changing Thoughts & Feelings";
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
