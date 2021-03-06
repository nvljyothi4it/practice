### the following script is going to do a wide variety of maintainance activities
##Written By: N V Chalam




write-host "The following action items can be performed by using the script"
write-host "================================================================"
write-host "1. Logfiles Cleanup `n2. Server Restart `n3. Url monitoring `n4. Server Reachability `n5. SSL Expiry check `n6. Services Checkup `n copy files "
write-host "================================================================"
write-host "Please select a value to perform an action `n"
$actionitem = read-host 
switch ($actionitem)
{
 1 
   { 
     write-host "---------------------------------------------------------"
     write-host "Performing Logfiles cleanup action "
     write-host "---------------------------------------------------------"
     write-host "Specify the target directory `n"
     $TargetDir=Read-host
     write-host "Target directory is $TargetDir"
     gci $TargetDir -recurse -include *.log |where-object {$_.lastwritetime -le (Get-Date).adddays(-30)}|Remove-item
     write-host "Log files cleanup completed successfully"  
       
     }
 
 2 {
      write-host "---------------------------------------------------------"
      write-host "Performing Server Restart "
      write-host "---------------------------------------------------------"
      $Servers=get-content D:/scripts/servers.txt
      foreach($i in $Servers)
       {
        write-host "Restarting $i"
        ## Restart-Computer $i
        write-host "Restarted $i successfully"
        
        }
     
     
     }

 3 {
      write-host "---------------------------------------------------------"
      write-host "Performing Url monitoring action "
      write-host "---------------------------------------------------------"
      $URLList=get-content D:/scripts/urls.txt
      foreach($i in $URLList)
      { write-host "verifying the URL $i"
        ## if((invoke-webrequest -Url $i).StatusCode -eq 200)
        write-host "$i is reachable"
      }
    }
 
 4 {
 
      write-host "---------------------------------------------------------"
      write-host "Performing Server Reachability action "
      write-host "---------------------------------------------------------"
      $Servers=get-content D:/scripts/servers.txt
      foreach($i in $Servers)
      {
       if(test-connection -computername $i -Quiet -Count 1)
         { write-host "$i is alive"
         }
       else
        {  write-host "$i not reachable"
         }
      }
      
      
     }
 
 5 {
      write-host "---------------------------------------------------------"
      write-host "SSL expiry check "
      write-host "---------------------------------------------------------"
      ## gci cert:/LocalMachine -recurse |where-object{$_.NotAfter -le (get-date).adddays(90)}
      write-host "SSL expiry check done successfully"
       }
 
 6 {
     write-host "---------------------------------------------------------"
     write-host "Performing services checkup action"
     write-host "---------------------------------------------------------"
     $services = get-content D:/scripts/services.txt
 
      foreach ($i in $services)
      {
       if ((get-service $i).status -eq "running")
       { write-host "The status of $i is Running"
        }
       
       else
       { write-host "starting the service $i"
          start-service $i
          if ($? -eq "true")
           { write-host " $i service started successfully "
            }
          else
           { write-host "  Unable to start $i service. Please check manually"
            }  
        } 
       }
   }
 }
 
 7 {
      write-host "---------------------------------------------------------"
      write-host "Copying Files to multiple servers "
      write-host "---------------------------------------------------------"
      
      $computers = gc "C:\scripts\computers.txt"
      $source = "c:\files"
      $dest = "e$"
      foreach ($computer in $computers) 
      {
        if (test-Connection -Cn $computer -quiet) 
           {
          Copy-Item $source -Destination \\$computer\$dest -Recurse
           } 
        else
           {
         "$computer is not online"
            }
          }

     }
 


























