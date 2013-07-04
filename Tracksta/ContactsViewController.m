//
//  ContactsViewController.m
//  Tracksta
//
//  Created by RAGHAV  on 04/07/13.
//  Copyright (c) 2013 RAGHAV . All rights reserved.
//

#import "ContactsViewController.h"
#import "Person.h"
#import "AccountViewController.h"
#import <AddressBook/AddressBook.h>

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [[NSMutableArray alloc] init];
    [self getPersonOutOfAddressBook];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Person *person = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = person.fullName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [self.tableData objectAtIndex:indexPath.row];
    
    AccountViewController *accountViewController = [[AccountViewController alloc] initWithPerson:person];
    [self.navigationController pushViewController:contactViewController animated:YES];
}


- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {
        NSLog(@"Succesful.");
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //3
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            Person *person = [[Person alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //4
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            //email
            //5
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            //6
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                
                else if (j==1)
                    person.workEmail = email;
            }
            
            //7
            [self.tableData addObject:person];
        }
        
        //8
        CFRelease(addressBook);
    }
    else
    {
        //9
        NSLog(@"Error reading Address Book");
    }
}

@end
