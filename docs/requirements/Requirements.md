# IPC-100 Rev A Requirements

Status: Initial baseline draft

## Power

- Accept 9–21 V DC input.
- Define an electrical input compatible with product-level systems based on DeWalt 20V MAX batteries.
- Be compatible with automotive electrical environments, subject to a defined transient and protection profile.
- Define only the allowable controller input; battery mounting and product-level power distribution are outside IPC-100 scope.

## Processor

- Use an ESP32-WROOM-32E module.

## Communications

- Support Wi-Fi.
- Support Bluetooth.
- Support ESP-NOW.

## Display

- Provide an interface for a 2.42-inch SSD1309 OLED display.

## Sensors

- Provide a BME280 environmental-sensor interface.
- Include battery-voltage monitoring.

## Outputs

- Provide one isolated dry-contact relay output.
- Provide two low-current interfaces for external motor drivers.
- Provide one RGB status output.
- Provide one buzzer output.

Motor drivers, motors, and other high-current loads shall remain external to the IPC-100 PCB.

## Inputs

- Provide four limit-switch inputs.
- Provide a rotary encoder input.
- Provide a rotary-encoder push-button input.
- Provide a dedicated ARM button input.
- Provide a dedicated FIRE button input.
- Provide a dedicated STOP button input.

## Expansion

- Provide an I²C expansion interface.
- Provide spare GPIO.
- Preserve a path for future CAN support.
- Preserve a path for future RS485 support.

## Requirements development notes

Electrical limits, environmental ratings, ingress protection, EMC targets, safety states, timing, diagnostics, connector durability, and verification criteria remain to be defined before the Rev A design freeze.

Product motion logic, actuator selection, battery mounting, product wiring, product enclosure requirements, and product assembly are outside the scope of this specification.
