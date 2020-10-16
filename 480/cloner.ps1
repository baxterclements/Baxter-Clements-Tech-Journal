Write-Host "Cloner Start"
$server = read-host -prompt "What is the Vcenter hostname"
Connect-VIServer -server $server
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
    $select = vmhost | select name | Out-String
    Write-Host " "
    Write-Host "VM Hosts"
    foreach ($item in $select) {
        $item = $item.substring(11)
        Write-Host "[0]$item"
    }
    
    $select = Read-Host -Prompt "Where do you want to run this"
    if ($select -eq "0") {
        $vmhost = Get-VMHost -Name super3.cyber.local
    } else {
        Write-Host "ERROR"
        exit
    }
    
    $select = datastore | select name | Out-String
    Write-Host " "
    Write-Host "Datastores"
    $select
    
    $select = Read-Host -Prompt "What datastore do you want to use"
    if ($select -eq "datastore1-super3") {
        $dstore = Get-Datastore -name datastore1-super3
    } elseif ($select -eq "datastore2-super3") {
        $dstore = Get-Datastore -name datastore2-super3
    } else {
        Write-Host "ERROR"
        exit
    }

    $link = ".linked"
    $name = Read-Host -Prompt "What would you like to call your vm"
    $linkname = $name+$link

    $newvm = New-Vm -name "$linkname" -vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore

    $newvm = new-vm -name $name -vm $linkname -VMHost $vmhost -Datastore $dstore

    remove-vm -VM $linkname -Confirm -DeletePermanently

} elseif ($clone_type -eq "r") {
    
    $select = vmhost | select name | Out-String
    Write-Host " "
    Write-Host "VM Hosts"
    foreach ($item in $select) {
        $item = $item.substring(11)
        Write-Host "[0]$item"
    }
    
    $select = Read-Host -Prompt "Where do you want to run this"
    if ($select -eq "0") {
        $vmhost = Get-VMHost -Name super3.cyber.local
    } else {
        Write-Host "ERROR"
        exit
    }
    
    $select = datastore | select name | Out-String
    Write-Host " "
    Write-Host "Datastores"
    $select
    
    $select = Read-Host -Prompt "What datastore do you want to use"
    if ($select -eq "datastore1-super3") {
        $dstore = Get-Datastore -name datastore1-super3
    } elseif ($select -eq "datastore2-super3") {
        $dstore = Get-Datastore -name datastore2-super3
    } else {
        Write-Host "ERROR"
        exit
    }
    $name = Read-Host -Prompt "What would you like to call your vm"

    $newvm = new-vm -name $name -vm $basevm -VMHost $vmhost -Datastore $dstore

} elseif ($clone_type -eq "l") {

    $snapshot = Get-Snapshot -vm $basevm -Name "Base"
    $select = vmhost | select name | Out-String
    Write-Host " "
    Write-Host "VM Hosts"
    foreach ($item in $select) {
        $item = $item.substring(11)
        Write-Host "[0]$item"
    }
    
    $select = Read-Host -Prompt "Where do you want to run this"
    if ($select -eq "0") {
        $vmhost = Get-VMHost -Name super3.cyber.local
    } else {
        Write-Host "ERROR"
        exit
    }
    
    $select = datastore | select name | Out-String
    Write-Host " "
    Write-Host "Datastores"
    $select
    
    $select = Read-Host -Prompt "What datastore do you want to use"
    if ($select -eq "datastore1-super3") {
        $dstore = Get-Datastore -name datastore1-super3
    } elseif ($select -eq "datastore2-super3") {
        $dstore = Get-Datastore -name datastore2-super3
    } else {
        Write-Host "ERROR"
        exit
    }

    $link = ".linked"
    $name = Read-Host -Prompt "What would you like to call your vm"
    $linkname = $name+$link

    $newvm = New-Vm -name "$linkname" -vm $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore
} else {
    Write-Host "error"
    exit
}
