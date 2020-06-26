# These should be edited to reflect your actual SSID and password

# use 2.4GHz band / not 5GHzrepl
SSID = 'raspi-webgui'
PASSWORD = 'ChangeMe'

if SSID == '':
    print('Please edit config.py and set the SSID and password')
    raise ValueError('SSID not set')
