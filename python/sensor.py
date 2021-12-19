#!/usr/bin/python
# -*- coding:utf-8 -*-

class PAJ7620U2(object):
    # i2c address
    PAJ7620U2_I2C_ADDRESS = 0x73
    # Register Bank select
    PAJ_BANK_SELECT = 0xEF  # Bank0== 0x00,Bank1== 0x01
    # Register Bank 0
    # I2C suspend command (Write = 0x01 to enter suspend state). I2C wake-up command is slave ID wake-up. Refer to topic “I2C Bus Timing Characteristics and Protocol”
    PAJ_SUSPEND = 0x03
    PAJ_INT_FLAG1_MASK = 0x41  # Gesture detection interrupt flag mask
    PAJ_INT_FLAG2_MASK = 0x42  # Gesture/PS detection interrupt flag mask
    PAJ_INT_FLAG1 = 0x43  # Gesture detection interrupt flag
    PAJ_INT_FLAG2 = 0x44  # Gesture/PS detection interrupt flag
    # State indicator for gesture detection (Only functional at gesture detection mode)
    PAJ_STATE = 0x45
    # PS hysteresis high threshold (Only functional at proximity detection mode)
    PAJ_PS_HIGH_THRESHOLD = 0x69
    # PS hysteresis low threshold (Only functional at proximity detection mode)
    PAJ_PS_LOW_THRESHOLD = 0x6A
    # PS approach state,  Approach = 1 , (8 bits PS data >= PS high threshold),  Not Approach = 0 , (8 bits PS data <= PS low threshold)(Only functional at proximity detection mode)
    PAJ_PS_APPROACH_STATE = 0x6B
    # PS 8 bit data(Only functional at gesture detection mode)
    PAJ_PS_DATA = 0x6C
    PAJ_OBJ_BRIGHTNESS = 0xB0  # Object Brightness (Max. 255)
    PAJ_OBJ_SIZE_L = 0xB1  # Object Size(Low 8 bit)
    PAJ_OBJ_SIZE_H = 0xB2  # Object Size(High 8 bit)
    # Register Bank 1
    # PS gain setting (Only functional at proximity detection mode)
    PAJ_PS_GAIN = 0x44
    # IDLE S1 Step, for setting the S1, Response Factor(Low 8 bit)
    PAJ_IDLE_S1_STEP_L = 0x67
    # IDLE S1 Step, for setting the S1, Response Factor(High 8 bit)
    PAJ_IDLE_S1_STEP_H = 0x68
    # IDLE S2 Step, for setting the S2, Response Factor(Low 8 bit)
    PAJ_IDLE_S2_STEP_L = 0x69
    # IDLE S2 Step, for setting the S2, Response Factor(High 8 bit)
    PAJ_IDLE_S2_STEP_H = 0x6A
    # OPtoS1 Step, for setting the OPtoS1 time of operation state to standby 1 state(Low 8 bit)
    PAJ_OPTOS1_TIME_L = 0x6B
    # OPtoS1 Step, for setting the OPtoS1 time of operation state to standby 1 stateHigh 8 bit)
    PAJ_OPTOS2_TIME_H = 0x6C
    # S1toS2 Step, for setting the S1toS2 time of standby 1 state to standby 2 state(Low 8 bit)
    PAJ_S1TOS2_TIME_L = 0x6D
    # S1toS2 Step, for setting the S1toS2 time of standby 1 state to standby 2 stateHigh 8 bit)
    PAJ_S1TOS2_TIME_H = 0x6E
    PAJ_EN = 0x72  # Enable/Disable PAJ7620U2
    # Gesture detection interrupt flag
    PAJ_UP = 0x01
    PAJ_DOWN = 0x02
    PAJ_LEFT = 0x04
    PAJ_RIGHT = 0x08
    PAJ_FORWARD = 0x10
    PAJ_BACKWARD = 0x20
    PAJ_CLOCKWISE = 0x40
    PAJ_COUNT_CLOCKWISE = 0x80
    PAJ_WAVE = 0x100
    # Power up initialize array
    Init_Register_Array = (
        (0xEF, 0x00),
        (0x37, 0x07),
        (0x38, 0x17),
        (0x39, 0x06),
        (0x41, 0x00),
        (0x42, 0x00),
        (0x46, 0x2D),
        (0x47, 0x0F),
        (0x48, 0x3C),
        (0x49, 0x00),
        (0x4A, 0x1E),
        (0x4C, 0x20),
        (0x51, 0x10),
        (0x5E, 0x10),
        (0x60, 0x27),
        (0x80, 0x42),
        (0x81, 0x44),
        (0x82, 0x04),
        (0x8B, 0x01),
        (0x90, 0x06),
        (0x95, 0x0A),
        (0x96, 0x0C),
        (0x97, 0x05),
        (0x9A, 0x14),
        (0x9C, 0x3F),
        (0xA5, 0x19),
        (0xCC, 0x19),
        (0xCD, 0x0B),
        (0xCE, 0x13),
        (0xCF, 0x64),
        (0xD0, 0x21),
        (0xEF, 0x01),
        (0x02, 0x0F),
        (0x03, 0x10),
        (0x04, 0x02),
        (0x25, 0x01),
        (0x27, 0x39),
        (0x28, 0x7F),
        (0x29, 0x08),
        (0x3E, 0xFF),
        (0x5E, 0x3D),
        (0x65, 0x96),
        (0x67, 0x97),
        (0x69, 0xCD),
        (0x6A, 0x01),
        (0x6D, 0x2C),
        (0x6E, 0x01),
        (0x72, 0x01),
        (0x73, 0x35),
        (0x74, 0x00),
        (0x77, 0x01),
    )
    # Approaches register initialization array
    Init_PS_Array = (
        (0xEF, 0x00),
        (0x41, 0x00),
        (0x42, 0x00),
        (0x48, 0x3C),
        (0x49, 0x00),
        (0x51, 0x13),
        (0x83, 0x20),
        (0x84, 0x20),
        (0x85, 0x00),
        (0x86, 0x10),
        (0x87, 0x00),
        (0x88, 0x05),
        (0x89, 0x18),
        (0x8A, 0x10),
        (0x9f, 0xf8),
        (0x69, 0x96),
        (0x6A, 0x02),
        (0xEF, 0x01),
        (0x01, 0x1E),
        (0x02, 0x0F),
        (0x03, 0x10),
        (0x04, 0x02),
        (0x41, 0x50),
        (0x43, 0x34),
        (0x65, 0xCE),
        (0x66, 0x0B),
        (0x67, 0xCE),
        (0x68, 0x0B),
        (0x69, 0xE9),
        (0x6A, 0x05),
        (0x6B, 0x50),
        (0x6C, 0xC3),
        (0x6D, 0x50),
        (0x6E, 0xC3),
        (0x74, 0x05),
    )
    # Gesture register initializes array
    Init_Gesture_Array = (
        (0xEF, 0x00),
        (0x41, 0x00),
        (0x42, 0x00),
        (0xEF, 0x00),
        (0x48, 0x3C),
        (0x49, 0x00),
        (0x51, 0x10),
        (0x83, 0x20),
        (0x9F, 0xF9),
        (0xEF, 0x01),
        (0x01, 0x1E),
        (0x02, 0x0F),
        (0x03, 0x10),
        (0x04, 0x02),
        (0x41, 0x40),
        (0x43, 0x30),
        (0x65, 0x96),
        (0x66, 0x00),
        (0x67, 0x97),
        (0x68, 0x01),
        (0x69, 0xCD),
        (0x6A, 0x01),
        (0x6B, 0xB0),
        (0x6C, 0x04),
        (0x6D, 0x2C),
        (0x6E, 0x01),
        (0x74, 0x00),
        (0xEF, 0x00),
        (0x41, 0xFF),
        (0x42, 0x01),
    )

    def __init__(self, database, address=PAJ7620U2_I2C_ADDRESS):
        from smbus import SMBus
        from time import sleep

        self._address = address
        self._bus = SMBus(1)
        sleep(0.5)

        self.__database = database
        self.__gestures = None
        self.__color = False
        self.__light = 100

        if self._read_byte(0x00) == 0x20:
            print("\nGesture Sensor OK\n")
            for num in range(len(self.Init_Register_Array)):
                self._write_byte(
                    self.Init_Register_Array[num][0], self.Init_Register_Array[num][1])
        else:
            print("\nGesture Sensor Error\n")
        self._write_byte(self.PAJ_BANK_SELECT, 0)
        for num in range(len(self.Init_Gesture_Array)):
            self._write_byte(
                self.Init_Gesture_Array[num][0], self.Init_Gesture_Array[num][1])

    def _read_byte(self, cmd):
        return self._bus.read_byte_data(self._address, cmd)

    def _read_u16(self, cmd):
        LSB = self._bus.read_byte_data(self._address, cmd)
        MSB = self._bus.read_byte_data(self._address, cmd+1)
        return (MSB << 8) + LSB

    def _write_byte(self, cmd, val):
        self._bus.write_byte_data(self._address, cmd, val)

    def change_color(self, bulb, color):
        self.__color += color
        if self.__color < 1:
            self.__color = 3
        elif self.__color > 3:
            self.__color = 1
        if self.__color == 1:
            bulb.set_rgb(255, 0, 0)
        elif self.__color == 2:
            bulb.set_rgb(0, 255, 0)
        elif self.__color == 3:
            bulb.set_rgb(0, 0, 255)

    def change_light(self, bulb, light):
        self.__light += light
        if self.__light < 0:
            self.__light = 0
        elif self.__light > 100:
            self.__light = 100
        bulb.set_brightness(self.__light)

    def do_action(self, name):
        from yeelight import Bulb
        from lamp import all as allLamps
        from gesture import all as allGestures

        if self.__gestures:
            for lamp in allLamps(self.__database):
                bulb = Bulb(lamp.ip)

                gesture = [g for g in self.__gestures if g.name == name]

                if gesture:
                    action = gesture[0].action

                    if action == 'turn_on':
                        print(name + "\t->\tTurn On\r\n")
                        bulb.turn_on()
                    elif action == 'turn_off':
                        print(name + "\t->\tTurn Off\r\n")
                        bulb.turn_off()
                    elif action == 'increase_light':
                        print(name + "\t->\tIncrease Light\r\n")
                        self.change_light(bulb, 25)
                    elif action == 'decrease_light':
                        print(name + "\t->\tDecrease Light\r\n")
                        self.change_light(bulb, -25)
                    elif action == 'next_color':
                        print(name + "\t->\tNextColor\r\n")
                        self.change_color(bulb, 1)
                    elif action == 'previous_color':
                        print(name + "\t->\tPrevious Color\r\n")
                        self.change_color(bulb, -1)
                    elif action == 'disco_flow':
                        from yeelight.transitions import disco
                        from yeelight import Flow

                        print(name + "\t->\tDisco Flow\r\n")
                        if self.__color == False:
                            bulb.start_flow(Flow(count=0, transitions=disco()))
                        else:
                            bulb.stop_flow()
                        self.__color = not self.__color
        else:
            self.__gestures = allGestures(self.__database)
            print("\nLoading gestures for the first time...\n")
            self.do_action(name)

    def check_gesture(self):
        Gesture_Data = self._read_u16(self.PAJ_INT_FLAG1)
        if Gesture_Data == self.PAJ_UP:
            self.do_action('Up')
        elif Gesture_Data == self.PAJ_DOWN:
            self.do_action('Down')
        elif Gesture_Data == self.PAJ_LEFT:
            self.do_action('Left')
        elif Gesture_Data == self.PAJ_RIGHT:
            self.do_action('Right')
        elif Gesture_Data == self.PAJ_CLOCKWISE:
            self.do_action('Clockwise')
        elif Gesture_Data == self.PAJ_COUNT_CLOCKWISE:
            self.do_action('AntiClockwise')
        elif Gesture_Data == self.PAJ_WAVE:
            self.do_action('Wave')
        return Gesture_Data
