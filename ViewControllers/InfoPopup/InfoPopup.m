 
#import "InfoPopup.h"

@interface InfoPopup ()

@end

@implementation InfoPopup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *beasMonoPath  =[[NSBundle mainBundle]pathForResource:[PersistenceStorage getObjectForKey:@"infopopupfile"] ofType:nil];
    NSURL *url = [NSURL URLWithString:beasMonoPath];
    self.title=@"Information";
 
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    
}


- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
