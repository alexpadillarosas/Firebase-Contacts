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
    
    //get a reference to our firebase database, then we can manipulate the data
    self.ref = [[FIRDatabase database] reference];

}

- (IBAction)saveContact:(id)sender {
    
    @try {
        
        NSString* cId = [[self idTextField] text];
        NSString* cName = [[self nameTextField] text];
        NSString* cEmail = [[self emailTextField] text];
        NSString* cPhone = [[self phoneTextField] text];
        NSString* cPosition = [[self positionTextField] text];
        
        //in our database(represented by ref) we find a reference to the "contacts" collection, then in the collection we find a child
        //once we get the reference to the collection, we will find a reference to a specific child of the "contacts" collection, this child will be identified by the contact id, as we will insert new data, that reference won't exist, so if we set values to the child element, those will be stored as a child (element) of the "contacts" collection
        /*
         remember this is how our collection looks like:
         {
           "contacts": {
               "1" : {
                 "email" : "gary@blueradix.com",
                 "name" : "Gary Edwards",
                 "phone" : "0487656567",
                 "position" : "Web Developer"
               },
               "2" : {
                 "email" : "rebecca@blueradix.com",
                 "name" : "Rebecca Edwards",
                 "phone" : "0989878789",
                 "position" : "HR"
               }
           }
         }
         
         where 1 and 2 are childs of the contacts' collection
         
         */
        
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
    
- (IBAction)searchContact:(id)sender {
    //get the ID typed by the user, we are going to search the info related to that ID
    NSString* contactId = [[self idTextField] text];
    // in this case we are going to read data once.
    // we won't be listening for any changes that happens in the database, until we read the data again.
    [[[_ref child:@"contacts"] child:contactId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
      // Get user contact values
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
        }else{
        
            //[[self.ref child:@"contacts"] child:cId] removeValue];
            //get a reference to the document in the db by using the contact ID
            FIRDatabaseReference* childReference = [[self.ref child:@"contacts"] child:cId];
            //remove that reference.
            [childReference removeValue];
             
            [self showUIAlertWithMessage:@"Contact Deleted" andTitle:@"Delete"];
        }
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
