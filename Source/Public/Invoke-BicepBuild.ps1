<#
.SYNOPSIS
    Compiles bicep files to JSON ARM Templates
.DESCRIPTION
    Invoke-BicepBuild is equivalent to bicep build but with the possibility to compile all .bicep files in a directory.
.PARAMETER Path
    Specfies the path to the directory or file that should be compiled
.PARAMETER ExcludeFile
    Specifies a .bicep file to exclude from compilation
.PARAMETER GenerateParameterFile
    The -GenerateParameterFile switch generates a ARM Template paramter file for the compiled template
.EXAMPLE
    Invoke-BicepBuild vnet.bicep
    Compile single bicep file in working directory
.EXAMPLE
    Invoke-BicepBuild 'c:\bicep\modules\vnet.bicep'
    Compile single bicep file in different directory
.EXAMPLE
    Invoke-BicepBuild
    Compile all .bicep files in working directory
.EXAMPLE
    Invoke-BicepBuild -Path 'c:\bicep\modules\'
    Compile all .bicep files in different directory
.EXAMPLE
    Invoke-BicepBuild -ExcludeFile vnet.bicep
    Compile all .bicep files in the working directory except vnet.bicep
.EXAMPLE
    Invoke-BicepBuild -Path 'c:\bicep\modules\' -ExcludeFile vnet.bicep
    Compile all .bicep files in different directory except vnet.bicep
.EXAMPLE
    Invoke-BicepBuild -GenerateParameterFile
    Compile all .bicep files in the working directory and generates a parameter files
.NOTES
    Go to module repository https://github.com/StefanIvemo/BicepPowerShell for detailed info, reporting issues and to submit contributions.
#>
function Invoke-BicepBuild {
    [cmdletbinding()]
    param(
        [string]$Path = $pwd.path,
        [ValidateScript( {
                if ($_ -like '*.bicep') {
                    $true
                }
                else {
                    throw "Only .bicep files are allowed as input to -ExcludeFile."
                }
            })]
        [string]$ExcludeFile,
        [switch]$GenerateParameterFile       
    )
    
    if (TestBicep) {
        $files = Get-Childitem -Path $Path *.bicep -File
        if ($files) {
            foreach ($file in $files) {
                if ($file.Name -ne $ExcludeFile) {
                    bicep build $file
                    if ($GenerateParameterFile.IsPresent) {
                        GenerateParameterFile -File $file
                    }                
                }
            }   
        }
        else {
            Write-Host "No bicep files located in path $Path"
        } 
    }
    else {
        Write-Error "Cannot find the Bicep CLI. Install Bicep CLI using Install-BicepCLI."
    }
}