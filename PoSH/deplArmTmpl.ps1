[CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$location,
    [Parameter(Mandatory=$true)]
    [string]$rgName,
    [Parameter(Mandatory=$true)]
    [string]$resDeplName,
    [Parameter(Mandatory=$true)]
    [string]$tmplPath,
    [Parameter(Mandatory=$true)]
    [string]$tmplFile,
    [Parameter(Mandatory=$true)]
    [string]$tmpl,
    [Parameter(Mandatory=$true)]
    [string]$paramPath,
    [Parameter(Mandatory=$true)]
    [string]$paramFile,
    [Parameter(Mandatory=$true)]
    [string]$params
    )
    
New-AzResourceGroup `
    -Name $rgName `
    -Location $location `
    -Verbose -Force

New-AzResourceGroupDeployment `
    -Name $resDeplName `
    -ResourceGroupName $rgName `
    -TemplateFile $tmpl `
    -TemplateParameterFile $params

# Submit template as a job via PowerShell:
$job = New-AzResourceGroupDeployment `
    -Name $resDeplName `
    -ResourceGroupName $rgName `
    -TemplateFile $templ `
    -TemplateParameterFile $params -AsJob

# Check status of the job
$job.StatusMessage
