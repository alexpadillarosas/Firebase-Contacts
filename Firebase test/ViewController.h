//
//  ViewController.h
//  Firebase test
//
//  Created by alex on 19/5/21.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;

@interface ViewController : UIViewController

//A FIRDatabaseReference represents a particular location in your Firebase Database and can be used for reading or writing data to that Firebase Database location.
@property (strong, nonatomic) FIRDatabaseReference *ref;


@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;






@end

