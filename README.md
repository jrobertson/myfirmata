# Introducing the MyFirmata gem

    require 'myfirmata'
    require 'myfirmata-plugin-button'

    mf = MyFirmata.new device_name: 'jessie', sps_address: '192.168.4.135',\
      plugins: {Button: {pin: 2} }
    mf.start

The MyFirmata gem facilitates publishing and subscribing message to or from the SimplePubSub broker given the events triggered from the Arduino or instructions to be actioned by the Arduino.

In the above example the MyFirmata plugin listens for button presses (on digital pin 2) and then publishes them to the SPS broker at 192.168.4.135 on port 59000.

Output:
Observed the following when the button was pressed 5 times:

<pre>
MyFirmata/jessie: button pressed
MyFirmata/jessie: button pressed
MyFirmata/jessie: button pressed
MyFirmata/jessie: button pressed
MyFirmata/jessie: button pressed
</pre>


Note: The button press event is ignored if the button is pressed less than a second ago since the last button press.

## Resources

* Pressing a button http://www.jamesrobertson.eu/arduino/2015/jun/08/pressing-a-button.html
* Communicating with the Arduino using the arduino_firmata gem http://www.jamesrobertson.eu/snippets/2014/apr/18/communicating-with-the-arduino-using-the-arduino_fi.html
* shokai/arduino_firmata: Arduino Firmata protocol implementation on Ruby https://github.com/shokai/arduino_firmata
* myfirmata https://rubygems.org/gems/myfirmata

firmata arduino button plugin myfirmata
