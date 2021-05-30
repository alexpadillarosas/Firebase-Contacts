//
//  ViewController.m
//  Firebase test
//
//  Created by alex on 19/5/21.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
    
}

- (IBAction)saveContact:(id)sender {
    
    @try {
        
        NSString* cId = [[self idTextField] text];
        NSString* cName = [[self nameTextField] text];
        NSString* cEmail = [[self emailTextField] text];
        NSString* cPhone = [[self phoneTextField] text];
        NSString* cPosition = [[self positionTextField] text];
         
        [[[self.ref child:@"contacts"] child:cId]
        setValue:@{
            @"name": cName,
            @"email": cEmail,
            @"phone": cPhone,
            @"position": cPosition
        }];
        [self showUIAlertWithMessage:@"Contact Saved" andTitle:@"Save"];
    } @catch (NSException *exception) {
        [self showUIAlertWithMessage:@"The contact was not saved" andTitle:@"Save"];
    } @finally {
        
    }

    [self clearContact];
}

- (IBAction)clearScreen:(id)sender {

    [self clearContact];
}

-(void) clearContact{
    [[self idTextField] setText:nil];
    [[self emailTextField] setText:nil];
    [[self nameTextField] setText:nil];
    [[self phoneTextField] setText:nil];
    [[self positionTextField] setText:nil];
    
    [[self idTextField] becomeFirstResponder];
    
}
    
- (IBAction)searchContactg:(id)sender {
    //get the ID typed by the user, we are going to search the info related to that ID
    NSString* contactId = [[self idTextField] text];
    
    [[[_ref child:@"contacts"] child:contactId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
      // Get user value
//      User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        NSString *name = snapshot.value[@"name"];
        NSString *email = snapshot.value[@"email"];
        NSString *phone = snapshot.value[@"phone"];
        NSString *position = snapshot.value[@"position"];
        
        [[self emailTextField] setText:email];
        [[self nameTextField] setText:name];
        [[self phoneTextField] setText:phone];
        [[self positionTextField] setText:position];
      // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
      NSLog(@"%@", error.localizedDescription);
    }];
    
}


- (IBAction)deleteContact:(id)sender {
    @try {
        
        NSString* cId = [[self idTextField] text];
        
        if([cId length] == 0){
            [self showUIAlertWithMessage:@"You must provide the contact ID" andTitle:@"Contact Delete Failed"];
        }
        
//        [[[self.ref child:@"contacts"] child:cId] removeValue];
        //get a reference to the document in the db by using the contact ID
        FIRDatabaseReference* childReference = [[self.ref child:@"contacts"] child:cId];
        //remove that reference.
        [childReference removeValue];
         
        [self showUIAlertWithMessage:@"Contact Deleted" andTitle:@"Delete"];
    } @catch (NSException *exception) {
        [self showUIAlertWithMessage:@"The contact was not deleted" andTitle:@"Delete"];
    } @finally {
        
    }

    [self clearContact];
}


-(void) showUIAlertWithMessage:(NSString*) message andTitle:(NSString*)title{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"You have saved the planet");
        }];
        [alert addAction:okAction];
    
        [self presentViewController:alert animated:YES completion:^{
            NSLog(@"%@", message);
        }];
}

@end
