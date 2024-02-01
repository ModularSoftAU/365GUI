    #region Functions

    function Update-ErrorLog {
        param(
            [System.Management.Automation.ErrorRecord]$ErrorRecord,
            [string]$Message,
            [switch]$Promote
        )

        if ( $Message -ne '' ) {[void][System.Windows.Forms.MessageBox]::Show("$($Message)`r`n`r`nCheck '$($BaseDir)\exceptions.txt' for details.",'Exception Occurred')}

        $date = Get-Date -Format 'yyyyMMdd HH:mm:ss'
        $ErrorRecord | Out-File "$($BaseDir)\tmpError.txt"

        Add-Content -Path "$($BaseDir)\exceptions.txt" -Value "$($date): $($(Get-Content "$($BaseDir)\tmpError.txt") -replace "\s+"," ")"

        Remove-Item -Path "$($BaseDir)\tmpError.txt"

        if ( $Promote ) {throw $ErrorRecord}
    }

    function ConvertFrom-WinFormsXML {
        param(
            [Parameter(Mandatory=$true)]$Xml,
            [string]$Reference,
            $ParentControl,
            [switch]$Suppress
        )

        try {
            if ( $Xml.GetType().Name -eq 'String' ) {$Xml = ([xml]$Xml).ChildNodes}

            if ( $Xml.ToString() -ne 'SplitterPanel' ) {$newControl = New-Object System.Windows.Forms.$($Xml.ToString())}

            if ( $ParentControl ) {
                if ( $Xml.ToString() -match "^ToolStrip" ) {
                    if ( $ParentControl.GetType().Name -match "^ToolStrip" ) {[void]$ParentControl.DropDownItems.Add($newControl)} else {[void]$ParentControl.Items.Add($newControl)}
                } elseif ( $Xml.ToString() -eq 'ContextMenuStrip' ) {$ParentControl.ContextMenuStrip = $newControl}
                elseif ( $Xml.ToString() -eq 'SplitterPanel' ) {$newControl = $ParentControl.$($Xml.Name.Split('_')[-1])}
                else {$ParentControl.Controls.Add($newControl)}
            }

            $Xml.Attributes | ForEach-Object {
                $attrib = $_
                $attribName = $_.ToString()

                if ( $Script:specialProps.Array -contains $attribName ) {
                    if ( $attribName -eq 'Items' ) {
                        $($_.Value -replace "\|\*BreakPT\*\|","`n").Split("`n") | ForEach-Object{[void]$newControl.Items.Add($_)}
                    } else {
                            # Other than Items only BoldedDate properties on MonthCalendar control
                        $methodName = "Add$($attribName)" -replace "s$"

                        $($_.Value -replace "\|\*BreakPT\*\|","`n").Split("`n") | ForEach-Object{$newControl.$attribName.$methodName($_)}
                    }
                } else {
                    switch ($attribName) {
                        FlatAppearance {
                            $attrib.Value.Split('|') | ForEach-Object {$newControl.FlatAppearance.$($_.Split('=')[0]) = $_.Split('=')[1]}
                        }
                        default {
                            if ( $null -ne $newControl.$attribName ) {
                                if ( $newControl.$attribName.GetType().Name -eq 'Boolean' ) {
                                    if ( $attrib.Value -eq 'True' ) {$value = $true} else {$value = $false}
                                } else {$value = $attrib.Value}
                            } else {$value = $attrib.Value}
                            $newControl.$attribName = $value
                        }
                    }
                }

                if (( $attrib.ToString() -eq 'Name' ) -and ( $Reference -ne '' )) {
                    try {$refHashTable = Get-Variable -Name $Reference -Scope Script -ErrorAction Stop}
                    catch {
                        New-Variable -Name $Reference -Scope Script -Value @{} | Out-Null
                        $refHashTable = Get-Variable -Name $Reference -Scope Script -ErrorAction SilentlyContinue
                    }

                    $refHashTable.Value.Add($attrib.Value,$newControl)
                }
            }

            if ( $Xml.ChildNodes ) {$Xml.ChildNodes | ForEach-Object {ConvertFrom-WinformsXML -Xml $_ -ParentControl $newControl -Reference $Reference -Suppress}}

            if ( $Suppress -eq $false ) {return $newControl}
        } catch {Update-ErrorLog -ErrorRecord $_ -Message "Exception encountered adding $($Xml.ToString()) to $($ParentControl.Name)"}
    }

    #endregion Functions
