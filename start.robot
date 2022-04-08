*** Settings ***
Library    Process     

*** Test Cases *** 
Start Vagrant VM and check reply from from 172.168.1.6
    ${result} =  Run Process    vagrant    up  shell=True  stdout=vm_start_log.txt
    Should Contain  ${result.stdout}    64 bytes from 172.168.1.6:

Ping test from host to bridged adapter
    ${result} =     Run Process    ping 192.168.1.17  shell=True  stdout=stdout.txt
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    Reply from 192.168.1.17

IPERF test from host to bridged adapter
    ${result} =    Run Process    /iperf/iperf.exe    -c    192.168.1.17  shell=True  stdout=iperf_stdout.txt
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    connected with 192.168.1.17 port 5001

Stop Vagrant VM and check shutdown message
    ${result} =  Run Process    vagrant    halt  shell=True  stdout=vm_shutdown_log.txt
    Should Contain  ${result.stdout}    Attempting graceful shutdown of VM