function Create_VSwitch {

    $myconfig = Get-Content -Raw -Path "cloner.json" | ConvertFrom-Json
    Connect-VIServer -server $myconfig.vcenter_server

    $switchname = Read-Host -Prompt "What would you like to call your Virtual switch"
    $esx_host = Get-VMHost -name $myconfig.esxi_server
    $vswitch = New-VirtualSwitch -VMHost $esx_host -name $switchname
    New-VirtualPortGroup -VirtualSwitch $vswitch -name $switchname
    
}

function setNetwork {
    param ([string] $vmname, [int] $numInterface, [string] $preferredNetwork)
    
    $vm = get-vm -name $vmname

    $interfaces = $vm | Get-NetworkAdapter

    $interfaces[$numInterface] | Set-NetworkAdapter -NetworkName $preferredNetwork
}

function getIP {
    param ($vmName)
    $vm = get-vm -name $vmname
    foreach ($item in $vm) {

        Write-host $item.Guest.IPAddress[0] hostname=$item
    }

}


Create_VSwitch