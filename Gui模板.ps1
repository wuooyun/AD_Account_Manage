##A GUI Test
#auth wuooyun
#date 2021.3.29
#version 0.1

# Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Drawing form and controls
$Form_HelloWorld = New-Object System.Windows.Forms.Form
    $Form_HelloWorld.Text = "Hello World"
    $Form_HelloWorld.Size = New-Object System.Drawing.Size(272,160)
    $Form_HelloWorld.FormBorderStyle = "FixedDialog"
    $Form_HelloWorld.TopMost = $true
    $Form_HelloWorld.MaximizeBox = $false
    $Form_HelloWorld.MinimizeBox = $false
    $Form_HelloWorld.ControlBox = $true
    $Form_HelloWorld.StartPosition = "CenterScreen"
    $Form_HelloWorld.Font = "Segoe UI"

# adding a label to my form
$label_HelloWorld = New-Object System.Windows.Forms.Label
    $label_HelloWorld.Location = New-Object System.Drawing.Size(8,8)
    $label_HelloWorld.Size = New-Object System.Drawing.Size(240,32)
    $label_HelloWorld.TextAlign = "MiddleCenter"
    $label_HelloWorld.Text = "Hello World"
    $Form_HelloWorld.Controls.Add($label_HelloWorld)

# add a button
$button_ClickMe = New-Object System.Windows.Forms.Button
    $button_ClickMe.Location = New-Object System.Drawing.Size(8,80)
    $button_ClickMe.Size = New-Object System.Drawing.Size(240,32)
    $button_ClickMe.TextAlign = "MiddleCenter"
    $button_ClickMe.Text = "Click Me!"
    $button_ClickMe.Add_Click({
        $button_ClickMe.Text = "You did click me!"
        Start-Process calc.exe
    })
    $Form_HelloWorld.Controls.Add($button_ClickMe)


# show form
$Form_HelloWorld.Add_Shown({$Form_HelloWorld.Activate()})
[void] $Form_HelloWorld.ShowDialog()