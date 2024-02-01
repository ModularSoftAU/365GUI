<#
    .NOTES
    ===========================================================================
        FileName:  365WelcomeLogin.ps1
        Author:  Ben
        Created On:  2024/02/02
        Last Updated:  2024/02/02
        Organization:
        Version:      v0.1
    ===========================================================================

    .DESCRIPTION

    .DEPENDENCIES
#>

# ScriptBlock to Execute in STA Runspace
$sbGUI = {
    param($BaseDir)

    #region Environment Setup

    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing


    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Environment Setup."}

    #endregion Environment Setup

    #region Dot Sourcing of files

    $dotSourceDir = $BaseDir

    . "$($dotSourceDir)\Functions.ps1"

    #endregion Dot Sourcing of files

    #region Form Initialization

    try {
        ConvertFrom-WinFormsXML -Reference refs -Suppress -Xml @"
  <Form Name="MainForm" FormBorderStyle="FixedSingle" Icon="(Icon)" Size="504, 340" Text="365GUI">
    <Button Name="btn_login" Location="164, 189" Size="158, 48" Text="Login into Office 365" />
    <PictureBox Name="pbx_365GUILogo" Image="System.Drawing.Bitmap" Location="111, 112" Size="271, 61" />
    <Label Name="lbl_365GUICopyright" Location="2, 271" Size="454, 29" Text="Copyright 2024 Modular Software&#xD;&#xA;365GUI - A PowerShell-powered Office 365 GUI for streamlined administration." />
  </Form>
"@
    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered during Form Initialization."}

    #endregion Form Initialization

    #region Other Actions Before ShowDialog

    try {
        Remove-Variable -Name eventSB
    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered before ShowDialog."}

    #endregion Other Actions Before ShowDialog

        # Show the form
    try {[void]$Script:refs['MainForm'].ShowDialog()} catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered unexpectedly at ShowDialog."}

    <#
    #region Actions After Form Closed

    try {

    } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered after Form close."}

    #endregion Actions After Form Closed
    #>
}

#region Start Point of Execution

    # Initialize STA Runspace
$rsGUI = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$rsGUI.ApartmentState = 'STA'
$rsGUI.ThreadOptions = 'ReuseThread'
$rsGUI.Open()

    # Create the PSCommand, Load into Runspace, and BeginInvoke
$cmdGUI = [Management.Automation.PowerShell]::Create().AddScript($sbGUI).AddParameter('BaseDir',$PSScriptRoot)
$cmdGUI.RunSpace = $rsGUI
$handleGUI = $cmdGUI.BeginInvoke()

    # Hide Console Window
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

    #Loop Until GUI Closure
while ( $handleGUI.IsCompleted -eq $false ) {Start-Sleep -Seconds 5}

    # Dispose of GUI Runspace/Command
$cmdGUI.EndInvoke($handleGUI)
$cmdGUI.Dispose()
$rsGUI.Dispose()

Exit

#endregion Start Point of Execution
