
#################################################################################  
##  
## Workstation Check
## Created by Matt Plahuta 
## 
################################################################################  
 
# $ServerListFile = "C:\Users\matt\ServerList.txt"   
# $ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue  
$Result = @()  
$computername = "localhost"
# ForEach($computername in $ServerList)  
# { 
 

$BIOS = Get-WmiObject -Class Win32_BIOS -computername $computername
$OS = Get-WMIObject -Class Win32_OperatingSystem -computername $computername
$Network = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $computername
$main = Get-WmiObject -class Win32_BaseBoard -computername $computername
$Drive = Get-WmiObject -Class Win32_DiskDrive -computername $computername
$Net = Get-WmiObject -class Win32_NetworkAdapter -computername $computername
$Fan = Get-WmiObject -class Win32_Fan -computername $computername
$logdisk = Get-WmiObject -class Win32_LogicalDisk -computername $computername

$result += [PSCustomObject] @{  
        ServerName = "$computername" 
        OpSystem = "$($OS.caption)%" 
        SerialNumber = "$($BIOS.SerialNumber)%"
        IP = "$($Network.IpAddress)%"
        main = "$($Main.Status)%" 
        drive = "$($Drive.Status)%"
        net = "$($Net.AdapterType)%"
        fan = "$($Fan.Status)%"
        logdisk = "$($logdisk.Caption)%"
    } 
 
    $Outputreport = "<HTML><TITLE> Workstation Information </TITLE> 
                     <BODY background-color:peachpuff> 
                     <font color =""#99000"" face=""Microsoft Tai le""> 
                     <H2> Workstation Information </H2></font> 
                     <Table border=1 cellpadding=1 cellspacing=0> 
                     <TR bgcolor=gray align=center> 
                       <TD><B>Server Name</B></TD> 
                       <TD><B>Operating System</B></TD>
                       <TD><B>Serial Number</B></TD> 
                       <TD><B>IP Address version 4</B></TD>
                       <TD><B>MAC Address</B></TD>
                       <TD><B>Main Board Status</B></TD>
                       <TD><B>Harddrive Status</B></TD>
                       <TD><B>Network Interface Card</B></TD>
                       <TD><B>Fan Status</B></TD><TR>" 
                      
        Foreach($Entry in $Result){      
          {
          $Outputreport += "<TR>"  
          }
          $Outputreport += "<TD>$($Entry.Servername)</TD>
          <TD align=center>$($OS.Caption)</TD>
          <TD align=center>$($BIOS.SerialNumber)</TD>
          <TD align=center>$($Network.IpAddress)</TD>
          <TD align=center>$($Network.MacAddress)</TD>
          <TD align=center>$($Main.Status)</TD>
          <TD align=center>$($Drive.Status)</TD>
          <TD align=center>$($Net.AdapterType)</TD>
          <TD align=center>$($Fan.Status)</TD><TR>"  
          }
      # $Outputreport += "<TR><TR><TR><H2> Hardware Information </H2></font> 
      #         <Table border=1 cellpadding=0 cellspacing=0> 
      #         <TR bgcolor=gray align=center> "  
        
     $Outputreport += "</Table></BODY></HTML>"  
          
  
$Outputreport | out-file C:\Scripts\Test.htm  
Invoke-Expression C:\Scripts\Test.htm 



# ##Send email functionality from below line, use it if you want    
# $smtpServer = "yoursmtpserver.com" 
# $smtpFrom = "fromemailaddress@test.com" 
# $smtpTo = "receipentaddress@test.com" 
# $messageSubject = "Servers Health report" 
# $message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto 
# $message.Subject = $messageSubject 
# $message.IsBodyHTML = $true 
# $message.Body = "<head><pre>$style</pre></head>" 
# $message.Body += Get-Content C:\scripts\test.htm 
# $smtp = New-Object Net.Mail.SmtpClient($smtpServer) 
# $smtp.Send($message)