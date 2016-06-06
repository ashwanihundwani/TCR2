 
#import "NookRes.h"

@interface NookRes ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{NSArray *skillListArray;}
@property (nonatomic, strong) UIDocumentInteractionController *controller;


@end

@implementation NookRes

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"NookResNew.html"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
       self.title=@"Learning Nook";
}



-(void)viewWillAppear:(BOOL)animated
{
    self.viewWeb.delegate=self;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.scheme isEqualToString:@"web1"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ata.org"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web2"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tinnitus.org.uk"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web3"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nidcd.nih.gov/health/hearing/pages/tinnitus.aspx"]];
    }

    if ([request.URL.scheme isEqualToString:@"web4"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pandora.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web5"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.spotify.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web6"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.iheart.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web7"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com"]];
    }
    
    
    if ([request.URL.scheme isEqualToString:@"web8"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ted.com"]];
    }
    
    
    if ([request.URL.scheme isEqualToString:@"web9"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.npr.org"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web10"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.radiolovers.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web11"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.radiodramarevival.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web12"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.loyalbooks.com"]];
    }
    
    
    if ([request.URL.scheme isEqualToString:@"web13"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.librivox.org"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web14"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ambient-mixer.com"]];
    }
    
    
    if ([request.URL.scheme isEqualToString:@"web15"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.calm.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web16"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.psychologytoday.com"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"web17"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apa.org"]];
    }
    
    if ([request.URL.scheme isEqualToString:@"pdf1"])
    {
        
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"PlainLanguageSummaryTinnitus" withExtension:@"pdf"];
        
        self.controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        [self.controller setDelegate:self];
        [self.controller presentPreviewAnimated:YES];
    }
    if ([request.URL.scheme isEqualToString:@"pdf2"])
    {
        
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"YourGuideToHealthySleep" withExtension:@"pdf"];
        
        self.controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        [self.controller setDelegate:self];
        [self.controller presentPreviewAnimated:YES];
    }
    
    return YES;
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

-(void)viewDidAppear:(BOOL)animated
{    [self writeVisitedPage];
}


-(void)writeVisitedPage{
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
    
    NSString *str = @"Resources";
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
