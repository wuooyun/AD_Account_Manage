# Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
[System.Windows.Forms.Application]::EnableVisualStyles()


# Start Creating Functions
Function GetADuserLoginTime{

    # Reset the columns and content of listview_Processes before adding data to it.
    $listview_GetADuserLoginTime.Items.Clear()
    $listview_GetADuserLoginTime.Columns.Clear()
    
    # Get a list and create an array of all running processes
    $logonDate = $DatePicker.value
    $logonDate | Out-Host
    $Users = Get-ADUser  -Filter {(lastLogonDate -le $logonDate) -and ( Enabled -eq $true )}  -Properties lastLogonDate,lastLogon | select Name,LastLogonDate,Enabled,lastLogon | select -First 50
    
    # Compile a list of the properties stored for the first indexed process "0"
    $UserProperties = $Users[0].psObject.Properties

    # Create a column in the listView for each property
    $UserProperties | ForEach-Object {
        $listview_GetADuserLoginTime.Columns.Add("$($_.Name)") | Out-Null
    }

    # Looping through each object in the array, and add a row for each
    ForEach ($User in $Users){
        
        if($User.name -in "Administrator","Guest","krbtgt","admin003") {continue;}
        # Create a listViewItem, and assign it it's first value
        $UserListViewItem = New-Object System.Windows.Forms.ListViewItem($User.Name)

        # For each properties, except for 'Id' that we've already used to create the ListViewItem,
        # find the column name, and extract the data for that property on the current object/process 
        $User.psObject.Properties | Where {$_.Name -ne "Name"} | ForEach-Object {
            $ColumnName = $_.Name
            $UserListViewItem.SubItems.Add("$($User.$ColumnName)") | Out-Null
        }

        # Add the created listViewItem to the ListView control
        # (not adding 'Out-Null' at the end of the line will result in numbers outputred to the console)
        $listview_GetADuserLoginTime.Items.Add($UserListViewItem) | Out-Null

    }

    # Resize all columns of the listView to fit their contents
    $listview_GetADuserLoginTime.AutoResizeColumns("HeaderSize")

}

Function DisableADUser{

    # Since we allowed 'MultiSelect = $true' on the listView control,
    # Compile a list in an array of selected items
    $SelectedUsers = @($listview_GetADuserLoginTime.SelectedIndices)

    # Find which column index has an the name 'Id' on it, for the listView control
    # We chose 'Id' because it is required by 'Stop-Process' to properly identify the process to kill.
    $NameColumnIndex = ($listview_GetADuserLoginTime.Columns | Where {$_.Text -eq "Name"}).Index
    
    # For each object/item in the array of selected item, find which SubItem/cell of the row...
    $SelectedUsers | ForEach-Object {
    
        # ...contains the Id of the process that is currently being "foreach'd",
        $UserName = ($listview_GetADuserLoginTime.Items[$_].SubItems[$NameColumnIndex]).Text
        
        # ...and stop it.
        Disable-ADAccount $UserName -WhatIf

        # The WhatIf switch was used to simulate the action. Remove it to use cmdlet as per normal.

    }

    # Refresh your user list, once you are done stopping them
    GetADuserLoginTime
    
}


# Drawing form and controls
$Form_HelloWorld = New-Object System.Windows.Forms.Form
    $Form_HelloWorld.Text = "域用户管理"
    $Form_HelloWorld.Size = New-Object System.Drawing.Size(832,528)
    $Form_HelloWorld.FormBorderStyle = "FixedDialog"
    $Form_HelloWorld.TopMost  = $true
    $Form_HelloWorld.MaximizeBox  = $true
    $Form_HelloWorld.MinimizeBox  = $true
    $Form_HelloWorld.ControlBox = $true
    $Form_HelloWorld.StartPosition = “CenterScreen”
    $Form_HelloWorld.Font = "Segoe UI"


# Adding a label control to Form
$label_HelloWorld = New-Object System.Windows.Forms.Label
    $label_HelloWorld.Location = New-Object System.Drawing.Size(8,8)
    $label_HelloWorld.Size = New-Object System.Drawing.Size(240,32)
    $label_HelloWorld.TextAlign = "MiddleLeft"
    $label_HelloWorld.Text = “域账号信息：”
        $Form_HelloWorld.Controls.Add($label_HelloWorld)


# Adding a listView control to Form, which will hold all process information
$Global:listview_GetADuserLoginTime = New-Object System.Windows.Forms.ListView
    $listview_GetADuserLoginTime.Location = New-Object System.Drawing.Size(8,40)
    $listview_GetADuserLoginTime.Size = New-Object System.Drawing.Size(800,402)
    $listview_GetADuserLoginTime.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor 
    [System.Windows.Forms.AnchorStyles]::Top -bor
    [System.Windows.Forms.AnchorStyles]::Left
    $listview_GetADuserLoginTime.View = "Details"
    $listview_GetADuserLoginTime.FullRowSelect = $true
    $listview_GetADuserLoginTime.MultiSelect = $true
    $listview_GetADuserLoginTime.Sorting = "None"
    $listview_GetADuserLoginTime.AllowColumnReorder = $true
    $listview_GetADuserLoginTime.GridLines = $true
    #$listview_GetADuserLoginTimes.Add_ColumnClick({SortListView $_.Column})
        $Form_HelloWorld.Controls.Add($listview_GetADuserLoginTime)

            
$label_Date = New-Object System.Windows.Forms.Label
    $label_Date.Location = New-Object System.Drawing.Size(280,460)
    $label_Date.Size = New-Object System.Drawing.Size(60,32)
    $label_Date.TextAlign = "MiddleLeft"
    $label_Date.Text = “选择时间:”
        $Form_HelloWorld.Controls.Add($label_Date)

#Adding time selecter
 $DatePicker = New-Object System.Windows.Forms.DateTimePicker
    $DatePicker.Location = New-Object System.Drawing.Size(350,460)
    $DatePicker.Format = [windows.forms.datetimepickerFormat]::custom
    $DatePicker.CustomFormat = “yyyy-MM-dd”
    $Form_HelloWorld.Controls.Add($DatePicker)
    
#Adding a textBox
'''
$TexBox_Date = New-Object System.Windows.Forms.TextBox
    $TexBox_Date.Location = New-Object System.Drawing.Size(350,460)
    $TexBox_Date.Size = New-Object System.Drawing.Size(180,32)
        $Form_HelloWorld.Controls.Add($TexBox_Date)
'''
# Adding a button control to Form
$button_GetADuserLoginTime = New-Object System.Windows.Forms.Button
    $button_GetADuserLoginTime.Location = New-Object System.Drawing.Size(8,450)
    $button_GetADuserLoginTime.Size = New-Object System.Drawing.Size(240,32)
    $button_GetADuserLoginTime.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Left
    $button_GetADuserLoginTime.TextAlign = "MiddleCenter"
    $button_GetADuserLoginTime.Text = "获取域用户信息"
    $button_GetADuserLoginTime.Add_Click({
           GetADuserLoginTime
    })
        $Form_HelloWorld.Controls.Add($button_GetADuserLoginTime)


# Adding another button control to Form
$button_DisableADuser = New-Object System.Windows.Forms.Button
    $button_DisableADuser.Location = New-Object System.Drawing.Size(568,450)
    $button_DisableADuser.Size = New-Object System.Drawing.Size(240,32)
    $button_DisableADuser.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Right
    $button_DisableADuser.TextAlign = "MiddleCenter"
    $button_DisableADuser.Text = "禁用域用户"
    $button_DisableADuser.Add_Click(
        {
            DisableADUser
        }
    )
        $Form_HelloWorld.Controls.Add($button_DisableADuser)



# Show form with all of its controls
#$Form_HelloWorld.Add_Shown({$Form_HelloWorld.Activate();GetProcesses})
[Void] $Form_HelloWorld.ShowDialog()
