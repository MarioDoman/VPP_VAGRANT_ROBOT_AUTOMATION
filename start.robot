*** Settings ***
Library    Process    
Library    OperatingSystem
Library    String


*** Test Cases *** 
Start Vagrant VM and check reply from from 172.168.1.6
    ${result} =  Run Process    vagrant    up  shell=True  stdout=vm_start_log.txt
    Should Contain  ${result.stdout}    64 bytes from


Read Text File to find IP from DHCP
    ${File}=    Get File  vm_start_log.txt
    @{list}=    Split to lines  ${File}    
    ${DHCP_IP}=  Set Variable  ${list[-1][25:37]}
    Set Global Variable      ${DHCP_IP} 

Ping test from host to bridged adapter
    ${result} =     Run Process    ping ${DHCP_IP}  shell=True  stdout=stdout.txt
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    Reply from  ${DHCP_IP}

IPERF test from host to bridged adapter
    ${result} =    Run Process    /iperf/iperf.exe -c ${DHCP_IP}  shell=True  stdout=iperf_stdout.txt
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    connected with

Stop Vagrant VM and check shutdown message
    ${result} =  Run Process    vagrant    halt  shell=True  stdout=vm_shutdown_log.txt
    Should Contain  ${result.stdout}    Attempting graceful shutdown of VM