param($eventGridEvent, $TriggerMetadata)
# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | Out-String | Write-Host
Write-Host "## eventGridEvent.json ##"
$eventGridEvent | convertto-json | Write-Host
# Get Resource Id
$resourceId=$eventGridEvent.data.resourceUri
# Get caller
$createBy=$eventGridEvent.data.claims.name
If ($createBy) {
} else {
    $createBy = $eventGridEvent.data.claims.appid
}
$tags = @{"ITGSO_CREATED_BY"="$createBy";}
try {
    Update-AzTag -ResourceId $resourceId -Tag $tags -operation Merge -ErrorAction Stop
}
catch {
    $err = $_.Exception.message
    Write-Host "Error Occured : $err"
    exit
}
