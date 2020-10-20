function Create_VSwitch {

    $myconfig = Get-Content -Raw -Path "cloner.json" | ConvertFrom-Json
    Connect-VIServer -server $myconfig.vcenter_server

    $switchname = Read-Host -Prompt "What would you like to call your Virtual switch"
    $esx_host = Get-VMHost -name $myconfig.esxi_server
    $vswitch = New-VirtualSwitch -VMHost $esx_host -name $switchname
    New-VirtualPortGroup -VirtualSwitch $vswitch -name $switchname
    
}

Create_VSwitch 