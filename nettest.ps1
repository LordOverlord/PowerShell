netsh interface set interface "Wi-Fi" disable
timeout 5 > null
netsh interface set interface "Wi-Fi" enable