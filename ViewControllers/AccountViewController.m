//
//  FirstViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright bufbomb.com 2010. All rights reserved.
//

#import "AccountViewController.h"
#import "AuthenticationUtility.h"
#import "StorageManager.h"
#import "UserPreference.h"

@interface AccountViewController()
- (void) generateUsernameTableViewCell:(UITableViewCell *)cell;
- (void) generatePasswordTableViewCell:(UITableViewCell *)cell;
- (void) generateBoardNameSwitchTableViewCell:(UITableViewCell *)cell;
- (void) generateShowPictureSwitchTableViewCell:(UITableViewCell *)cell;
- (void) generateANSIColorSwitchTableViewCell:(UITableViewCell *)cell;

- (void) setUsername:(NSString *)name;
- (void) setPassword:(NSString *)password;
- (void) setBoardNameSwitchToEnglish:(BOOL)isEnglish;
- (void) setShowPictureSwitch:(BOOL)isShown;
- (void) setAnsiColorSwitch:(BOOL)needAnsiColor;

- (void) saveUsernameAndPassword;
- (void) saveBoardNameSwitchValue;
- (void) saveShowPictureSwitchValue;
- (void) saveAnsiColorSwitchValue;

- (void) signin;
@end


@implementation AccountViewController


- (id)init {
    if(self = [super init])
    {
        if(self = [super initWithStyle:UITableViewStyleGrouped])
        self.title = @"我的账户";
        tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"user.png"] tag:4];
        self.tabBarItem = tabBarItem;
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    usernameFld = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 5.0f, 200.0f, 30.0f)];
    usernameFld.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameFld.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameFld.keyboardType = UIKeyboardTypeAlphabet;
    usernameFld.returnKeyType = UIReturnKeyJoin;    
    usernameFld.placeholder = @"填入用户名";
    usernameFld.delegate = self;
    
    passwordFld = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 5.0f, 200.0f, 30.0f)];
    passwordFld.placeholder = @"填入密码";
    passwordFld.secureTextEntry = YES;
    passwordFld.keyboardType = UIKeyboardTypeAlphabet;
    passwordFld.returnKeyType = UIReturnKeyJoin;
    passwordFld.delegate = self;
    
    boardNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 0.0f, 0.0f)];
    [boardNameSwitch addTarget:self action:@selector(saveBoardNameSwitchValue) forControlEvents:UIControlEventValueChanged];
    
	showPictureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 0.0f, 0.0f)];
	[showPictureSwitch addTarget:self action:@selector(saveShowPictureSwitchValue) forControlEvents:UIControlEventValueChanged];
	
	ansiColorSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 0.0f, 0.0f)];
	[ansiColorSwitch addTarget:self action:@selector(saveAnsiColorSwitchValue) forControlEvents:UIControlEventValueChanged];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kUserStatusUpdate object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSArray * nameAndPassword = [[StorageManager sharedInstance] getUserNameAndPassword];
    NSString * name = [nameAndPassword objectAtIndex:0];
    NSString * password = [nameAndPassword objectAtIndex:1];
    
    [self setUsername:name];
    [self setPassword:password];
    [self setBoardNameSwitchToEnglish:[UserPreference isEnglishName]];
	[self setShowPictureSwitch:[UserPreference isShownPicture]];
	[self setAnsiColorSwitch:[UserPreference needAnsiColor]];
    [self refresh];
}

#pragma mark -
#pragma mark Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"账户";
        case 1:
            return @"设置";
        default:
            NSAssert(NO, @"Never happen");
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == [tableView numberOfSections] - 1) 
    {
        NSString * versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSAssert(versionString, @"The version string must exist.");
        return [NSString stringWithFormat:@"版本 %@", versionString];
    }
    return nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
        default:
            NSAssert(NO, @"Never happen");
            return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString * CellIdentifier;
    UITableViewCell * cell;
    int sectionIndex = [indexPath section];
    int rowIndex = [indexPath row];
    if (sectionIndex == 0) 
    {
        if (rowIndex == 0) 
        {
            CellIdentifier = @"UsernameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [self generateUsernameTableViewCell:cell];
            }
        }
        else if (rowIndex == 1)
        {
            CellIdentifier = @"PasswordCell"; 
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [self generatePasswordTableViewCell:cell];
            }
        }else if (rowIndex == 2)
        {
            CellIdentifier = @"StatusCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            switch ([AuthenticationUtility sharedInstance].status) 
            {
                case NotSignedIn:
                    cell.textLabel.text = @"未登录";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case SigningIn:
                    cell.textLabel.text = @"正在登录";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case SignedIn:
                    cell.textLabel.text = @"登出";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                case SignInFailed:
                    cell.textLabel.text = @"登录失败";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    NSAssert(NO, @"Can't happen");
                    break;
            }
        }
        else 
        {
            NSAssert(NO, @"Can't happen");
        }
    }
    else if (sectionIndex == 1)
    {
        if (rowIndex == 0) 
        {
            CellIdentifier = @"BoardNameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [self generateBoardNameSwitchTableViewCell:cell];
            }
        }
		else if (rowIndex == 1)
		{
			CellIdentifier = @"ShowPicCell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [self generateShowPictureSwitchTableViewCell:cell];
			}
		}
		else if (rowIndex == 2)
		{
			CellIdentifier = @"ANSIColor";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [self generateANSIColorSwitchTableViewCell:cell];
			}
		}
        else 
        {
            assert(NO);
        }
    }
    else
    {
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"abc";
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section == 0 && row == 2 && [AuthenticationUtility sharedInstance].status == SignedIn) 
    {
        [[AuthenticationUtility sharedInstance] signoutUntilDone:YES];
    }
    
    
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    if (textField == usernameFld || textField == passwordFld) 
    {
        [self signin];
    }
    
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == usernameFld || textField == passwordFld) 
    {
        [self saveUsernameAndPassword];
    }
}



- (void) generateUsernameTableViewCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"user.gif"]];
    [cell.contentView addSubview:usernameFld];
}

- (void) generatePasswordTableViewCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"password.gif"]];
    [cell.contentView addSubview:passwordFld];
}

- (void) generateBoardNameSwitchTableViewCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"显示英文版名";
    [cell.contentView addSubview:boardNameSwitch];
}

- (void) generateShowPictureSwitchTableViewCell:(UITableViewCell *)cell
{
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = @"显示图片";
	[cell.contentView addSubview:showPictureSwitch];
}

- (void) generateANSIColorSwitchTableViewCell:(UITableViewCell *)cell
{
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = @"显示ANSI颜色";
	[cell.contentView addSubview:ansiColorSwitch];
}

- (NSString *) getUsername
{
    return [usernameFld text];
}

- (NSString *) getPassword
{
    return [passwordFld text];
}
- (void) setUsername:(NSString *)name
{
    usernameFld.text = name;
}

- (void) setPassword:(NSString *)password
{
    passwordFld.text = password;
}

- (void) setBoardNameSwitchToEnglish:(BOOL)isEnglish
{
    boardNameSwitch.on = isEnglish;
}

- (void) setShowPictureSwitch:(BOOL)isShown
{
	showPictureSwitch.on = isShown;
}
	 
- (void) setAnsiColorSwitch:(BOOL)needAnsiColor
{
	ansiColorSwitch.on = needAnsiColor;
}

- (void) saveUsernameAndPassword
{
    [[StorageManager sharedInstance] saveUserName:usernameFld.text Password:passwordFld.text];
}

- (void) saveBoardNameSwitchValue
{
    BOOL switchValue = boardNameSwitch.on;
    [UserPreference setEnglishName:switchValue];
}

- (void) saveShowPictureSwitchValue
{
	BOOL switchValue = showPictureSwitch.on;
	[UserPreference setShowPicture:switchValue];
}

- (void) saveAnsiColorSwitchValue
{
	BOOL switchValue = ansiColorSwitch.on;
	[UserPreference setAnsiColor:switchValue];
}

- (void) refresh
{
    [self.tableView reloadData];
}

- (void) signin
{
    [[AuthenticationUtility sharedInstance] signin];
    [self refresh];        
}


     

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserStatusUpdate object:nil];
    [usernameFld release];
    [passwordFld release];
    [boardNameSwitch release];
    [super viewDidUnload];
}


- (void)dealloc {
    [tabBarItem release];
    [super dealloc];
}

@end
