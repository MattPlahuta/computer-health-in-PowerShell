$Computer = Read-Host "Enter Machine Name: "

$namespace = "root\CIMV2"

 

$host.ui.RawUI.ForegroundColor = "Blue"

write-output "++++++++++++++++++++++++++++++++++++++++++"

write-output "+  Hardware Information for Workstation  + "

Write-output "++++++++++++++++++++++++++++++++++++++++++"

write-host

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "Computer Information"

$host.ui.RawUI.ForegroundColor = "White"

 

$wmi = Get-WmiObject -Class Win32_ComputerSystem -computername $computer -namespace $namespace

$model = $wmi.Model

$domain = $wmi.Domain

write-host "Model: " $model

write-host "Domain: " $domain

 

$colItems = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $Computer -Filter "IpEnabled = TRUE"

ForEach ($objItem in $colItems) {

write-host $objItem.Description

write-host "MAC Address: " $objItem.MacAddress

write-host "IP Address: " $objItem.IpAddress

}

 

$wmi = Get-WmiObject -class Win32_TimeZone -computername $computer -namespace $namespace

$timezone = $wmi.Caption

write-host "Time Zone: " $timezone

 

$wmi = Get-WMIObject -Class Win32_OperatingSystem -computername $computer -namespace $namespace

$lastboottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)

$sysuptime = (Get-Date) - $lastboottime

$uptime = "UPTIME: $($sysuptime.days) Days, $($sysuptime.hours) Hours, $($sysuptime.minutes) Minutes, $($sysuptime.seconds) Seconds"

write-host $uptime

write-host

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "Drive Size:"

$host.ui.RawUI.ForegroundColor = "White"

Get-WmiObject -Class Win32_LogicalDisk -computername $computer -namespace $namespace |

    Where-Object {$_.DriveType -ne 5} |

    Sort-Object -Property Name |

    Select-Object Name, VolumeName, Status, FileSystem, Description, VolumeDirty, `

        @{"Label"="DiskSize(GB)";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `

        @{"Label"="FreeSpace(GB)";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}}, `

        @{"Label"="%Free";"Expression"={"{0:N}" -f ($_.FreeSpace/$_.Size*100) -as [float]}} |

    Format-Table -AutoSize

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "Drive Status"

$host.ui.RawUI.ForegroundColor = "White"

Get-WmiObject -Class Win32_DiskDrive -computername $computer -namespace $namespace |

    Sort-Object -Property Name |

    Select-Object Caption, Name, InterfaceType, Status |

    Format-Table -AutoSize

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "USB Info:"

$host.ui.RawUI.ForegroundColor = "White"

Get-WmiObject -class Win32_UsbHub -computername $computer -namespace $namespace |

    Sort-Object -Property Name |

    Select-Object Name, Status |

    Format-Table -AutoSize

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "Fan Info:"

$host.ui.RawUI.ForegroundColor = "White"

Get-WmiObject -class Win32_Fan -computername $computer -namespace $namespace |

    Sort-Object -Property Name |

    Select-Object Name, Status |

    Format-Table -AutoSize

 

$host.ui.RawUI.ForegroundColor = "DarkGreen"

write-output "Main Board:"

$host.ui.RawUI.ForegroundColor = "White"

Get-WmiObject -class Win32_BaseBoard -computername $computer -namespace $namespace |

    Sort-Object -Property Name |

    Select-Object SerialNumber, Status |

    Format-Table -AutoSize

 

$exit = Read-Host "Press Enter To Exit!"