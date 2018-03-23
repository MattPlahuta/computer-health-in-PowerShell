Function Get-PCHealth

{

    PARAM ($computer)

 

    $namespace = "root\CIMV2"

 

    $host.ui.RawUI.ForegroundColor = "Blue"

    write-output "++++++++++++++++++++++++++++++++++++++++++"

    write-output "+  Hardware Information for Workstation  + "

    Write-output "++++++++++++++++++++++++++++++++++++++++++"

    write-host

 

    $host.ui.RawUI.ForegroundColor = "DarkGreen"

    write-output "Computer Information"

    $host.ui.RawUI.ForegroundColor = "White"

 

 

    $computersystem = Get-WmiObject -Class Win32_ComputerSystem -computername $computer -namespace $namespace

    $BIOS = Get-WmiObject -Class Win32_BIOS -computername $computer -namespace $namespace

    $Network = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $Computer -Filter "IpEnabled = TRUE"

    $timezone = Get-WmiObject -class Win32_TimeZone -computername $computer -namespace $namespace

    $Bios = Get-WmiObject -class Win32_BIOS -computername $computer -namespace $namespace

    $upt = Get-WMIObject -Class Win32_OperatingSystem -computername $computer -namespace $namespace

    $printer = Get-WMIObject -Class Win32_Printer -computername $Computer -namespace $namespace

 

    $lastboottime = $upt.ConvertToDateTime($upt.LastBootUpTime)

    $sysuptime = (Get-Date) - $lastboottime

    $uptime = "UPTIME: $($sysuptime.days) Days, $($sysuptime.hours) Hours, $($sysuptime.minutes) Minutes, $($sysuptime.seconds) Seconds"

    write-host $uptime

 

    $Properties = @{

            TimeZone = $timezone.caption

            ComputerName = $computer

            Domain = $ComputerSystem.Domain

            OperatingSystem = $upt.caption

            Manufacturer = $ComputerSystem.Manufacturer

           Model = $computersystem.Model

            SerialNumber = $Bios.SerialNumber

            IP = $Network.IpAddress[0]

            MAC = $Network.MacAddress

        }

   

    New-Object -TypeName PSobject -Property $Properties

   

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

    write-output "Printer Info: "

    $host.ui.RawUI.ForegroundColor = "White"

   

    $printerList = @{

            Server = $printer.pscomputername

            Name = $printer.name

            Driver = $printer.drivername

            SpoolerEnabled = $printer.SpoolEnabled

            IP = $printer.portname

        }

   

    New-Object -TypeName PSobject -Property $printerList

 

    $host.ui.RawUI.ForegroundColor = "DarkGreen"

    write-output "Fan Info: "

    $host.ui.RawUI.ForegroundColor = "White"

    Get-WmiObject -class Win32_Fan -computername $computer -namespace $namespace |

        Sort-Object -Property Name |

        Select-Object Name, Status |

        Format-Table -AutoSize

 

    $host.ui.RawUI.ForegroundColor = "DarkGreen"

    write-output "Main Board: "

    $host.ui.RawUI.ForegroundColor = "White"

    Get-WmiObject -class Win32_BaseBoard -computername $computer -namespace $namespace |

        Sort-Object -Property Name |

        Select-Object SerialNumber, Status |

        Format-Table -AutoSize

 

}

$Computer = Read-Host "Enter Machine Name: "

Get-PCHealth $computer

 

$exit = Read-Host "Press Enter To Exit!"

 