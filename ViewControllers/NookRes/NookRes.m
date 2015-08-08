 
#import "NookRes.h"

@interface NookRes ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
{NSArray *skillListArray;}
@property (nonatomic, strong) UIDocumentInteractionController *controller;


@end

@implementation NookRes

- (void)viewDidLoad
{
    [super viewDidLoad];
     //NSURL *url = [NSURL URLWithString:fullURL];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NookRes" ofType:@"html" inDirectory:@"www"]];
  //  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2views" ofType:@"png" inDirectory:@"www"]];

    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:@"NookResNew.html"  ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];

    
   //  NSString *fullURL = @"http://google.com";
 //   NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    
 //   NSString *path = [[NSBundle mainBundle] bundlePath];
  //  NSURL *baseURL = [NSURL fileURLWithPath:path];
    //[webView loadHTMLString:htmlString baseURL:baseURL];
    
       self.title=@"Learning Nook";
  //  self.navigationController.navigationBarHidden = YES;

    
// NSURL *url = [NSURL URLWithString:@"http://google.com"];

    
  //      NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  //   [_viewWeb loadRequest:requestObj];
    
    
 //
    
    //[self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
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
    
    
    
    
    
  //  URLArray = [NSArray arrayWithObjects:@{@"link":@"web1://", @"url":@"http://www.ata.org"}, @{@"link":@"web2://", @"url":@"http://www.tinnitus.org.uk"}, @{@"link":@"web3://", @"url":@"http://http://www.nidcd.nih.gov/health/hearing/pages/tinnitus.aspx"}, @{@"link":@"web4://", @"url":@"http://www.pandora.com"}, @{@"link":@"web5://", @"url":@"http://www.spotify.com"}, @{@"link":@"web6://", @"url":@"http://www.iheartradio.org"},@{@"link":@"web7://", @"url":@"http://www.youtube.com"},  @{@"link":@"web8://", @"url":@"http://www.ted.com"},@{@"link":@"web9://", @"url":@"http://www.npr.org"}, @{@"link":@"web10://", @"url":@"http://www.radiolovers.com"}, @{@"link":@"web11://" , @"url":@"http://www.radiodramarevival.com"},  @{@"link":@"web12://", @"url":@"http://www.loyalbooks.com"}, @{@"link":@"web13://", @"url":@"http://www.librivox.org"}, @{@"link":@"web14://", @"url":@"http://www.ambient-mixer.com"}, @{@"link":@"web15://", @"url":@"http://www.calm.com"}, @{@"link":@"web16://", @"url":@"http://www.psychologytoday.com"}, @{@"link":@"web17://", @"url":@"http://www.apa.org"},nil];
    
    
    
//    NSString *tLink = request.URL;
//NSString *tUrl = [skillListArray valueForKey:tLink];
    
    
    NSLog(@"%@",request.URL.scheme);
    
  //  NSLog(@"%@",tUrl);

    
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
