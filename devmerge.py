import evdev
from evdev import UInput, AbsInfo, ecodes as e   
from selectors import DefaultSelector, EVENT_READ

input_names = ["adc-joystick", "adc-keys", "gpio-keys-control"]

def mainloop():

    # Capabilities, required to describe the virtual device
    caps = {}
    # Using selector API to read from multiple evdev devices
    selector = DefaultSelector()

    # Find path to evdev devices listed by name
    for path in evdev.list_devices():
        dev = evdev.InputDevice(path) 
        if dev.name not in input_names:
            continue
        # Grabbing gives us exclusive access to this device
        dev.grab()
        # Update capabilities
        for k, v in dev.capabilities().items():
            if k == e.EV_ABS:
                # uinput doesn't allow max lower than min so fix it
                v = fix_absinfo(v)
            if k == e.EV_SYN:
                # EV_SYN is not allowed
                continue
            caps[k] = caps.get(k, []) + v
        selector.register(dev, EVENT_READ)

    # Create virtual uinput device
    vdev = UInput(caps, "virt-joypad", version=0x1)
    
    # Forward all events forever 
    while True:
        for key, _ in selector.select():
            dev = key.fileobj
            for event in dev.read():
                # Invert these axes to make it work correctly...
                if event.code == e.ABS_X or event.code == e.ABS_Y:
                    event.value = invert_absval(event.value)
                vdev.write(event.type, event.code, event.value)
                vdev.syn()    

def fix_absinfo(val):
    """
    In the dts for adc-joystick sometimes min is greater than max. 
    This is valid according to adc-joystick schema but uinput doesn't like it.
    """
    return [ (t, AbsInfo(info[0], 15, 1023, info[3], info[4], info[5])) 
        for t, info in val ]

def invert_absval(val):
    return 1008 - (val - 15) + 15

if __name__ == '__main__':
    mainloop()
