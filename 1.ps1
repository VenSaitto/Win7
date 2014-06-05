$computers = get-Content P:\computer-list.txt
$Global:HostInfo = @()
Function CheckON
   {
    $OS = Get-WmiObject Win32_OperatingSystem -computer $computer -ea stop
    $OSName = $OS.Caption
    $MotherBoard=gwmi win32_BaseBoard -computer $computer 
    $MotherBoardModel=$MotherBoard.product
    $MotherBoardFirm=$MotherBoard.Manufacturer
    $ProcessorStats = Get-WmiObject win32_processor -computer $computer 
    $ComputerCpu = $ProcessorStats.LoadPercentage 
    $Processor=$ProcessorStats.Name
    $User=Get-WMIObject -Class Win32_ComputerSystem -computer $computer 
    $LoginUser=$User.UserName
    $OperatingSystem = Get-WmiObject win32_OperatingSystem -computer $computer 
    $FreeMemory = $OperatingSystem.FreePhysicalMemory
    $TotalMemory ="{0:N3}" -f ($OperatingSystem.TotalVisibleMemorySize /1000/1000)
    $LastBootUpTime=[Management.ManagementDateTimeConverter]::ToDateTime($operatingSystem.LastBootUpTime)
   

    $objHostInfo = New-Object System.Object
    $objHostInfo | Add-Member -MemberType NoteProperty -Name Name -Value $computer
    $objHostInfo | Add-Member -MemberType NoteProperty -Name OS -Value $OSName
    $objHostInfo | Add-Member -MemberType NoteProperty -Name MotherBoard -Value $MotherBoardFirm
    $objHostInfo | Add-Member -MemberType NoteProperty -Name MotherBoardID -Value $MotherBoardModel
    $objHostInfo | Add-Member -MemberType NoteProperty -Name RAM -Value $TotalMemory
    $objHostInfo | Add-Member -MemberType NoteProperty -Name BootTime -Value $LastBootUpTime
    $objHostInfo | Add-Member -MemberType NoteProperty -Name CPU -Value $Processor
    $objHostInfo | Add-Member -MemberType NoteProperty -Name User -Value $LoginUser
    #write-host " "
    #$objhostinfo|format-table -wrap
    #Проверка NetFraem4(Занимает продолж. время)#gwmi -computer $computer -query "select * from win32_product where Caption Like '%.NET Framework 4%'"|select Name
    #write-host "____________________________________________________________" 
    $Global:HostInfo += $objHostInfo
    $objHostInfo
    $Global:Path="C:\PC\"
    $Global:Path=$Global:Path+$computer+".txt"
    $objHostInfo| Out-File -FilePath $Global:Path
   }

foreach ($computer in $computers)
    {
       trap 
      {
        write-host "____________________________________________________________"
         write-host "Ошибка подключения к" -fore red "$computer" 
        write-host "____________________________________________________________"
        continue
      }    
       CheckON
    }     
$Global:HostInfo| Out-File -FilePath c:\output.txt
$Global:HostInfo
powershell