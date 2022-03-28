*** Settings ***
Library    Process     

*** Test Cases *** 
Ping test
    ${result} =     Run Process    ping 172.168.1.6  shell=True  stdout=stdout.txt
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    Reply from