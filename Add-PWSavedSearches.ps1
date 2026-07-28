<#
.SYNOPSIS
    Automates the creation of standard ISO 19650-compliant saved searches in Bentley ProjectWise.
.DESCRIPTION
    Connects to a ProjectWise datasource and provisions a comprehensive set of 
    structured saved searches (WIP, Check, Shared, Published, etc.) mapped to 
    specific workflows and document states for templates or projects.
.PARAMETER TargetName
    The exact name of the target Project Template or Project Description in ProjectWise.
.PARAMETER IsProject
    Switch to indicate if applying to an active project rather than a template path.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetName,

    [Parameter(Mandatory = $false)]
    [switch]$IsProject
)

# Determine owner path based on target type
if ($IsProject) {
    $ownerPath = "$TargetName\"
    $searchFolder = "$TargetName"
} else {
    $ownerPath = "System Administrator Folderistrator Folder\Project Templates\$TargetName\"
    $searchFolder = "System Administrator Folder\Project Templates\$TargetName"
}

try {
    Write-Host "Initiating ProjectWise login..." -ForegroundColor Cyan
    new-pwlogin -usegui

    Write-Host "Provisioning saved searches for: $TargetName..." -ForegroundColor Cyan

    # Define State and Workflow mapping batches
    $searchConfigs = @(
        @{ Name = "1. Work In Progress"; State = "Work in Progress" },
        @{ Name = "1. Work In Progress\1. Drawings - Work In Progress"; State = "Work in Progress"; Workflow = "Workflow -Drawings" },
        @{ Name = "1. Work In Progress\2. Models - Work In Progress"; State = "Work in Progress"; Workflow = "Workflow -Models" },
        @{ Name = "1. Work In Progress\3. Documents - Work In Progress"; State = "Work in Progress"; Workflow = "Workflow -Documents" },
        
        @{ Name = "2. Content Check"; State = "Content Check" },
        @{ Name = "2. Content Check\1. Drawings - Content Check"; State = "Content Check"; Workflow = "Workflow -Drawings" },
        @{ Name = "2. Content Check\2. Models - Content Check"; State = "Content Check"; Workflow = "Workflow -Models" },
        @{ Name = "2. Content Check\3. Documents - Content Check"; State = "Content Check"; Workflow = "Workflow -Documents" },
        
        @{ Name = "3. Technical Check"; State = "Technical Check" },
        @{ Name = "3. Technical Check\1. Drawings - Technical Check"; State = "Technical Check"; Workflow = "Workflow -Drawings" },
        @{ Name = "3. Technical Check\2. Models - Technical Check"; State = "Technical Check"; Workflow = "Workflow -Models" },
        @{ Name = "3. Technical Check\3. Documents - Technical Check"; State = "Technical Check"; Workflow = "Workflow -Documents" },
        
        @{ Name = "4. Reference Shared"; State = "Reference Shared" },
        @{ Name = "4. Reference Shared\1. Drawings - Reference Shared"; State = "Reference Shared"; Workflow = "Workflow -Drawings" },
        @{ Name = "4. Reference Shared\2. Models - Reference Shared"; State = "Reference Shared"; Workflow = "Workflow -Models" },
        @{ Name = "4. Reference Shared\3. Documents - Reference Shared"; State = "Reference Shared"; Workflow = "Workflow -Documents" },
        
        @{ Name = "5. Shared"; State = "Shared" ,
        @{ Name = "5. Shared\1. Drawings - Shared"; State = "Shared"; Workflow = "Workflow -Drawings" },
        @{ Name = "5. Shared\2. Models - Shared"; State = "Shared"; Workflow = "Workflow -Models" },
        @{ Name = "5. Shared\3. Documents - Shared"; State = "Shared"; Workflow = "Workflow -Documents" },
        
        @{ Name = "6. Coordination Check"; State = "Coordination Check" },
        @{ Name = "6. Coordination Check\1. Drawings - Coordination Check"; State = "Coordination Check"; Workflow = "Workflow -Drawings" },
        @{ Name = "6. Coordination Check\2. Models - Coordination Check"; State = "Coordination Check"; Workflow = "Workflow -Models" },
        @{ Name = "6. Coordination Check\3. Documents - Coordination Check"; State = "Coordination Check"; Workflow = "Workflow -Documents" },
        
        @{ Name = "7. Approve"; State = "Approve" },
        @{ Name = "7. Approve\1. Drawings - Approve"; State = "Approve"; Workflow = "Workflow -Drawings" },
        @{ Name = "7. Approve\2. Models - Approve"; State = "Approve"; Workflow = "Workflow -Models" },
        @{ Name = "7. Approve\3. Documents - Approve"; State = "Approve"; Workflow = "Workflow -Documents" },
        
        @{ Name = "8. Authorisation"; State = "Authorisation" },
        @{ Name = "8. Authorisation\1. Drawings - Authorisation"; State = "Authorisation"; Workflow = "CDEDrawings" },
        @{ Name = "8. Authorisation\2. Models - Authorisation"; State = "Authorisation"; Workflow = "Workflow -Models" },
        @{ Name = "8. Authorisation\3. Documents - Authorisation"; State = "Authorisation"; Workflow = "Workflow -Documents" },
        
        @{ Name = "9. Reference Published"; State = "Reference Published" },
        @{ Name = "9. Reference Published\1. Drawings - Reference Published"; State = "Reference Published"; Workflow = "Workflow -Drawings" },
        @{ Name = "9. Reference Published\2. Models - Reference Published"; State = "Reference Published"; Workflow = "Workflow -Models" },
        @{ Name = "9. Reference Published\3. Documents - Reference Published"; State = "Reference Published"; Workflow = "Workflow -Documents" },
        
        @{ Name = "10. Published"; State = "Published" },
        @{ Name = "10. Published\1. Drawings - Published"; State = "Published"; Workflow = "Workflow -Drawings" },
        @{ Name = "10. Published\2. Models - Published"; State = "Published"; Workflow = "Workflow -Models" },
        @{ Name = "10. Published\3. Documents - Published"; State = "Published"; Workflow = "Workflow -Documents" }
    ]

    foreach ($cfg in $searchConfigs) {
        $params = @{
            OwnerProject  = $ownerPath
            SearchName    = $cfg.Name
            SearchFolder  = $searchFolder
            SearchSubFolders = $true
            States        = $cfg.State
            Verbose       = $true
        }
        if ($cfg.Workflow) {
            $params['Workflow'] = $cfg.Workflow
        }

        Add-PWSavedSearch @params
    }

    Write-Host "Successfully provisioned all saved searches!" -ForegroundColor Green
}
catch {
    Write-Error "An error occurred during search provisioning: $_"
}
finally {
    Undo-PWLogin
}
