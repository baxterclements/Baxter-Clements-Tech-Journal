Write-Host "Cloner Start"
$myconfig = Get-Content -Raw -Path "cloner.json" | ConvertFrom-Json
Connect-VIServer -server $myconfig.vcenter_server

$vms = Get-VM | select Name | Out-String
Write-Host " "
Write-Host "VM Names"
foreach ($item in $vms) {
    $item = $item.substring(7)
    Write-Host "$item"
}

$u_select = read-host -prompt "What VM would you like to clone"

$basevm = Get-VM -name "$u_select"
Write-Host "you  selected $u_select"
Write-Host " "

$clone_type = Read-Host -Prompt "[F]ull clone of Base, [L]inked Clone [R]egular clone of current VM state"
$clone_type = $clone_type.ToLower()
if ($clone_type -eq "f") {

    $snapshot = Get-Snapshot -vm $basevm -Name "Base"

    $vmhost = Get-VMHost -Name $myconfig.esxi_server
    
    $dstore = Get-Datastore -name $myconfig.preferred_datastore

    $link = ".linked"
    $name = Read-Host -Prompt "What would you like to call your vm"
    $linkname = $name+$link

    $newvm = New-Vm -name "$linkname" -vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore

    $newvm = new-vm -name $name -vm $linkname -VMHost $vmhost -Datastore $dstore

    remove-vm -VM $linkname -Confirm -DeletePermanently

    $newnet = $myconfig.preferred_network

    get-vm $name | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnet -Confirm:$false

} elseif ($clone_type -eq "r") {
    
    $vmhost = Get-VMHost -Name $myconfig.esxi_server
    
    $dstore = Get-Datastore -name $myconfig.preferred_datastore

    $name = Read-Host -Prompt "What would you like to call your vm"

    $newvm = new-vm -name $name -vm $basevm -VMHost $vmhost -Datastore $dstore

    $newnet = $myconfig.preferred_network

    get-vm $name | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnet -Confirm:$false

} elseif ($clone_type -eq "l") {

    $snapshot = Get-Snapshot -vm $basevm -Name "Base"
    
    $vmhost = Get-VMHost -Name $myconfig.esxi_server
    
    $dstore = Get-Datastore -name $myconfig.preferred_datastore

    
    $name = Read-Host -Prompt "What would you like to call your vm"

    $newvm = New-Vm -name "$name" -vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore

    $newnet = $myconfig.preferred_network

    get-vm $name | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnet -Confirm:$false

} else {
    Write-Host "error"
    exit
}
