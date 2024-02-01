Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to create a new user
function Create-User {
    # Code for creating a new user in Office 365 goes here
    $username = $textboxUsernameCreate.Text
    # Implement your logic for creating a user
    Write-Host "Creating user: $username"
}

# Function to delete a user
function Delete-User {
    # Code for deleting a user in Office 365 goes here
    $username = $textboxUsernameDelete.Text
    # Implement your logic for deleting a user
    Write-Host "Deleting user: $username"
}

# Function to switch to Create User screen
function Show-CreateUserScreen {
    $formMain.Visible = $false
    $formCreateUser.Visible = $true
}

# Function to switch to Delete User screen
function Show-DeleteUserScreen {
    $formMain.Visible = $false
    $formDeleteUser.Visible = $true
}

# Create main form
$formMain = New-Object System.Windows.Forms.Form
$formMain.Text = "Main Screen"
$formMain.Size = New-Object System.Drawing.Size(400, 150)
$formMain.StartPosition = "CenterScreen"

# Create create user button on main screen
$buttonCreateUserMain = New-Object System.Windows.Forms.Button
$buttonCreateUserMain.Location = New-Object System.Drawing.Point(50, 50)
$buttonCreateUserMain.Size = New-Object System.Drawing.Size(150, 40)
$buttonCreateUserMain.Text = "Create User"
$buttonCreateUserMain.Add_Click({ Show-CreateUserScreen })

# Create delete user button on main screen
$buttonDeleteUserMain = New-Object System.Windows.Forms.Button
$buttonDeleteUserMain.Location = New-Object System.Drawing.Point(200, 50)
$buttonDeleteUserMain.Size = New-Object System.Drawing.Size(150, 40)
$buttonDeleteUserMain.Text = "Delete User"
$buttonDeleteUserMain.Add_Click({ Show-DeleteUserScreen })

# Add controls to main form
$formMain.Controls.Add($buttonCreateUserMain)
$formMain.Controls.Add($buttonDeleteUserMain)

# Create Create User form
$formCreateUser = New-Object System.Windows.Forms.Form
$formCreateUser.Text = "Create User"
$formCreateUser.Size = New-Object System.Drawing.Size(400, 150)
$formCreateUser.StartPosition = "CenterScreen"
$formCreateUser.Visible = $false

# Create delete user form
$formDeleteUser = New-Object System.Windows.Forms.Form
$formDeleteUser.Text = "Delete User"
$formDeleteUser.Size = New-Object System.Drawing.Size(400, 150)
$formDeleteUser.StartPosition = "CenterScreen"
$formDeleteUser.Visible = $false

# Create username label for create user form
$labelUsernameCreate = New-Object System.Windows.Forms.Label
$labelUsernameCreate.Text = "Username:"
$labelUsernameCreate.Location = New-Object System.Drawing.Point(10, 20)
$labelUsernameCreate.Size = New-Object System.Drawing.Size(100, 20)

# Create username textbox for create user form
$textboxUsernameCreate = New-Object System.Windows.Forms.TextBox
$textboxUsernameCreate.Location = New-Object System.Drawing.Point(120, 20)
$textboxUsernameCreate.Size = New-Object System.Drawing.Size(200, 20)

# Create create user button for create user form
$buttonCreateUser = New-Object System.Windows.Forms.Button
$buttonCreateUser.Location = New-Object System.Drawing.Point(120, 50)
$buttonCreateUser.Size = New-Object System.Drawing.Size(100, 23)
$buttonCreateUser.Text = "Create User"
$buttonCreateUser.Add_Click({ Create-User })

# Create username label for delete user form
$labelUsernameDelete = New-Object System.Windows.Forms.Label
$labelUsernameDelete.Text = "Username:"
$labelUsernameDelete.Location = New-Object System.Drawing.Point(10, 20)
$labelUsernameDelete.Size = New-Object System.Drawing.Size(100, 20)

# Create username textbox for delete user form
$textboxUsernameDelete = New-Object System.Windows.Forms.TextBox
$textboxUsernameDelete.Location = New-Object System.Drawing.Point(120, 20)
$textboxUsernameDelete.Size = New-Object System.Drawing.Size(200, 20)

# Create delete user button for delete user form
$buttonDeleteUser = New-Object System.Windows.Forms.Button
$buttonDeleteUser.Location = New-Object System.Drawing.Point(120, 50)
$buttonDeleteUser.Size = New-Object System.Drawing.Size(100, 23)
$buttonDeleteUser.Text = "Delete User"
$buttonDeleteUser.Add_Click({ Delete-User })

# Add controls to create user form
$formCreateUser.Controls.Add($labelUsernameCreate)
$formCreateUser.Controls.Add($textboxUsernameCreate)
$formCreateUser.Controls.Add($buttonCreateUser)

# Add controls to delete user form
$formDeleteUser.Controls.Add($labelUsernameDelete)
$formDeleteUser.Controls.Add($textboxUsernameDelete)
$formDeleteUser.Controls.Add($buttonDeleteUser)

# Show main form
$formMain.ShowDialog() | Out-Null
