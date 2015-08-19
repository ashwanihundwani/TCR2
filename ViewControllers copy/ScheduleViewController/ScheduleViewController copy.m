//
//  ScheduleViewController.m
//  TinnitusCoach
//
//  Created by Swipe Video Labs Pvt Ltd on 30/03/15.
//  Copyright (c) 2015 Swipe Video Labs Pvt Ltd. All rights reserved.
//
#import "MBProgressHUD.h"

#import "ScheduleViewController.h"
#import <EventKitUI/EventKitUI.h>

 
    
@interface ScheduleViewController ()
{NSArray *remindersArray;
}





@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSDate  *endDate;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
          self.title = @"Add Event";
    // Do any additional setup after loading the view.
    [self setUpView];
}

-(void)setUpView{
    [self.datePicker setHidden:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.activityName.text = self.name;
}





- (IBAction)DeleteReminder:(id)sender {
    
    
    
    
    NSString *query = [NSString stringWithFormat: @"select * from MyReminders where ActName = '%@'", [PersistenceStorage getObjectForKey:@"activityName"] ];
    
   
    
    NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@'",[PersistenceStorage getObjectForKey:@"activityName"]];
    
  //  NSString *queryDelete = [NSString stringWithFormat:@"delete from MyReminders where ActivityName = %ld", [PersistenceStorage getObjectForKey:@"activityName"] ];

    
    
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];
    remindersArray = [[NSArray alloc] initWithArray:[self.manager loadDataFromDB:query]];
 
    
    if ([remindersArray count]== 1) {
        
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"CalendarEventID"];
         [PersistenceStorage setObject:strAct andKey:@"EventID"];
     
    
    }
    
    
    
    /*
    
    NSString *query = [NSString stringWithFormat: @"delete from MyReminders where ActivityName = %ld", [PersistenceStorage getObjectForKey:@"activityName"] ];
 
    
    BOOL isDone = [self.manager executeQuery:queryClear];
    if (isDone == YES)
    {
     
        
        
        
        
        
        //   [[planListArray objectAtIndex:indexPath.row] valueForKey:@"situationName"];
        
        
        
        
    }
    else{
     }

    
    
    if ([remindersArray count]== 1) {
        
        //label.text = @"Reminder set";
        
        NSDictionary *dict = [remindersArray objectAtIndex:0];
        NSString *strAct = [dict valueForKey:@"ScheduledDate"];
        
         

    
    
    
    
    
    
    
    
    
    */
    
    
    
    
    
    
    
                
           [self.manager executeQuery:queryClear];
    


    
//    [self.manager executeQuery:queryClear];
 
    
}












#pragma mark DoneClicked
-(void)doneClicked{

 
    self.manager = [[DBManager alloc]initWithDatabaseFileName:@"GNResoundDB.sqlite"];

 
//[button.controlName isEqualToString:controlName]
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Pleasant Activities"]){
 //else
  //   } */
    
 
    
    
//    [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];

    
    NSString * schDate = self.startDate;
 
    
    
    [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
    
    
    UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
    
    NSString *buttonTitle =repeatLabel.currentTitle;
     
 
        
        NSString *queryClear = [NSString stringWithFormat:@"delete from MyReminders where ActName = '%@'",[PersistenceStorage getObjectForKey:@"activityName"]];
        
        
         NSString *query = [NSString stringWithFormat:@"insert into MyReminders ('ID','ActName','ScheduledDate','CalendarEventID') values(1,'%@','%@','%@' )",[PersistenceStorage getObjectForKey:@"activityName"],[PersistenceStorage getObjectForKey:@"scheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"]];
      
        
        
        
        // Execute the query.
        [self.manager executeQuery:queryClear];
        [self.manager executeQuery:query];
        
        
        
    }
    
      
NSArray *skillListArray = [NSArray arrayWithObjects:@{@"name":@"Using Sound", @"description":@"Listening to sound can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Deep Breathing", @"description":@"This breathing exercise can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Imagery", @"description":@"Imagining a peaceful place can reduce your stress and help you cope with your tinnitus."}, @{@"name":@"Guided Meditation", @"description":@"Try several other guided relaxation exercises."}, @{@"name":@"Pleasant Activities", @"description":@"Make a list of activities that will help you take your mind off of tinnitus."}, @{@"name":@"Changing Thoughts & Feelings", @"description":@"Changing the way you think about tinnitus can improve how you feel."}, @{@"name":@"Tips for Better Sleeping", @"description":@"Following these suggestions can help you sleep better."}, nil];

        
 
    
    
    
       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"] ];
       
       hud.mode = MBProgressHUDModeCustomView;
       
       hud.labelText = @"Scheduled Reminder";
       
       [hud show:YES];
       [hud hide:YES afterDelay:2];
    
    



    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Imagery"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        
        
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Imagery'"];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID') values(1,'%@','%@','%@' )",@"Imagery",[PersistenceStorage getObjectForKey:@"scheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
        
        
    }
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Guided Meditation"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        
        
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Guided Meditation'"];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID') values(1,'%@','%@','%@' )",@"Guided Meditation",[PersistenceStorage getObjectForKey:@"scheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
    
        
        
        
    }
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Tips for Better Sleep"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        
       
        
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Tips for Better Sleep'"];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID') values(1,'%@','%@','%@' )",@"Tips for Better Sleep",[PersistenceStorage getObjectForKey:@"scheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
    }

        
        

    
    
    
    
    
    
    
    if ([[PersistenceStorage getObjectForKey:@"skillName"] isEqualToString:@"Deep Breathing"]){
        
        NSString * schDate = self.startDate;
        
        
        
        [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];
        
        
        UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
        
        NSString *buttonTitle =repeatLabel.currentTitle;
        
        
        
       
            
            
            NSString *queryClear = [NSString stringWithFormat:@"delete from MySkillReminders where SkillName = 'Deep Breathing'"];
            
            
            NSString *query = [NSString stringWithFormat:@"insert into MySkillReminders ('ID','SkillName','ScheduledDate','CalendarEventID') values(1,'%@','%@','%@' )",@"Deep Breathing",[PersistenceStorage getObjectForKey:@"scheduledDate"],[PersistenceStorage getObjectForKey:@"lastEventIdentifer"]];
            
            [self.manager executeQuery:queryClear];
            [self.manager executeQuery:query];
            
            
            
        
        
        
        

    
        
        
    
//[self dismissModalViewControllerAnimated:YES];
     
    
[self.navigationController popViewControllerAnimated:YES];
}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)startButtonTapped:(id)sender {
    [self.datePicker setHidden:NO];
    [self.datePicker addTarget:self
                        action:@selector(setDatePickerTime:)
              forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd,yyy hh:mm:ss"];
    
    NSString *title = [outputFormatter stringFromDate:self.datePicker.date];
     self.startDate = self.datePicker.date;
    
    NSString * schDate = self.startDate;
    
    
    [PersistenceStorage setObject:schDate andKey:@"scheduledDate"];

    
    
    [self.startButton setTitle:title forState:UIControlStateNormal];
    self.endDate = [[NSDate alloc]initWithTimeInterval:3600 sinceDate:self.datePicker.date];
    NSString *endTitle = [outputFormatter stringFromDate:self.endDate ];
    [self.endButton setTitle:endTitle forState:UIControlStateNormal];
}



- (IBAction)repeatButtonTapped:(id)sender {
    NSString *actionSheetTitle = @"Repeat this event in your Calendar?"; //Action Sheet Title
    NSString *other0 = @"None"; //Action Sheet Button Titles
    NSString *other1 = @"Daily";
    NSString *other2 = @"Weekly";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other0, other1, other2, nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //   NSString * theValue = [(UILabel*)[self viewWithTag:t200] text];
    
    
    UIButton *repeatLabel = (UIButton *)[self.view viewWithTag:355];
    if  ([buttonTitle isEqualToString:@"Daily"]) {
        
        
        //
        /*  UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"Daily";
         
         [self.activityNameButton setTitle:[dict valueForKey:@"activityName"] forState:UIControlStateNormal];
         */
        [repeatLabel setTitle:@"Daily" forState:UIControlStateNormal];
        //    [self.repeatLabel setTitle:@"Daily"];
    }
    if ([buttonTitle isEqualToString:@"Weekly"]) {
        /*       UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"Weekly";*/
        
        //      [self.repeatLabel setTitle:@"Weekly"];
        [repeatLabel setTitle:@"Weekly" forState:UIControlStateNormal];
        
        
    }
    
    if ([buttonTitle isEqualToString:@"None"]) {
        /*UILabel *firstLabel = (UILabel *)[self.view viewWithTag:555];
         firstLabel.text = @"None";*/
        [repeatLabel setTitle:@"None" forState:UIControlStateNormal];
        
        //[self.repeatLabel setTitle:@"None"];
        

}

}





-(void)setDatePickerTime:(id)sender
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd,yyy hh:mm:ss"];
    
    NSString *title = [outputFormatter stringFromDate:self.datePicker.date];
    self.startDate = self.datePicker.date;
    
    [self.startButton setTitle:title forState:UIControlStateNormal];
    //end date
    self.endDate = [[NSDate alloc]initWithTimeInterval:3600 sinceDate:self.datePicker.date];
    NSString *endTitle = [outputFormatter stringFromDate:self.endDate ];
    [self.endButton setTitle:endTitle forState:UIControlStateNormal];
}





- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"Ignore"
                                              otherButtonTitles:@"Run"];
        [alert show];
    }
    
    
    NSString *NotificationValue = [notification.userInfo objectForKey:@"name"];        //objectForKey:TheKeyNameYouUsed
    
    
    
    
    
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}





@end