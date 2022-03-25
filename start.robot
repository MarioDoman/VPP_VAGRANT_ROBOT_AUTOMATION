*** Settings ***
Library    Process     

*** Test Cases *** 
Vagrant up
    ${result} =     Run Process     vagrant    up
    Log    ${result.stdout}

# Ping test
#     ${result}=    Run    Process    ping 127.0.0.1 -c 15   shell=True  stdout=/home/user/stdout.txt
    # Log all output:  ${result.stdout}
    # Should Contain  ${result.stdout}    64 bytes from 127.0.0.1*