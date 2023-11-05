# meiam_wifi_auth
Complete MEIAM captive portal

Use like shown below to authenticate:
```console
captive_portal.bat
```
Or use the command below to authenticate automatically:
```console
captive_portal.bat settings.txt
```
With settings.txt a file in the same folder as captive_portal.bat and with this shape:
```
username=AM_XXX
password=XXXXXXXX
```

To automate the process:

-go to task manager

-create new task and name it

-add an event with the following parameters:
  Log: Microsoft-Windows-NetworkProfile/Operational
  Source: NetworkProfile
  Event ID: 10000

-add an action to execute the batch code with the filename of the settings file as a parameter

-in condition tab uncheck "Start the task only if the computer is on AC power" if checked and check "Start only if the following network connection is available:" with parameter "MEIAM WIFI RESIDENTS"

-save and exit
