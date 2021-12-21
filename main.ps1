
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Import-Module .\API-Call.ps1
Import-Module .\classMovie.ps1
Import-Module .\movieDisplay.ps1

Function SearchMovies(){

    
    [CmdletBinding(DefaultParameterSetName="Default")]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName="Default")]
        [string]$Year = "2021",

        [Parameter(Mandatory = $false, ParameterSetName="Default")]
        [int]$results = "10"

    )


    $Call = New-Object APIcall
    $allResults = @()
    $index = 1

    Set-Content .\movies.json ""
    
    Write-Host "*****   SEARCHING MOVIES FROM $year   *****"
    while($allResults.Count -lt $results){
        $allresults += $Call.SearchYear("$Year",$index)
        $index++
    }
    Write-Host "*****   HERE ARE SOME MOVIES FROM $year   *****"
    #Seteamos los url a mano
    foreach ($item in $allResults) {
        $url=[APIcall]::SearchURL($item.id)
        $item.urlToWatch = $url
    }

    
    $form = New-Object MoviesForm
    $form.AddMovie($allResults)
    $form.Show()
}