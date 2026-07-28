# IPC-100 Rev A Requirements

Status: Initial baseline draft

## Power

- Accept 9–21 V DC input.
- Be designed for DeWalt 20V MAX battery packs.
- Be compatible with automotive electrical environments, subject to a defined transient and protection profile.

## Processor

- Use an ESP32-WROOM-32E module.

## Communications

- Support Wi-Fi.
- Support Bluetooth.
- Support ESP-NOW.

## Display

- Support a 2.42-inch SSD1309 OLED display.

## Sensors

- Include a BME280 environmental sensor.
- Include battery-voltage monitoring.

## Outputs

- Provide one thrower relay output.
- Provide two motor interfaces.
- Provide one RGB status LED.
- Provide one buzzer output.

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

