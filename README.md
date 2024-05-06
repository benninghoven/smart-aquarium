# Smart Aquarium Monitoring System

This project is a Smart Aquarium Monitoring System designed to provide real-time monitoring of crucial parameters for freshwater fish tanks. The system incorporates three sensors to measure pH, parts per million (ppm), and temperature. Additionally, it includes a mobile application developed using Flutter framework, enabling users to remotely monitor and manage their aquarium conditions conveniently.

## Features

- **Real-time Monitoring**: Get instant updates on pH levels, ppm, and temperature of your aquarium water.
- **Alert System**: Receive notifications when any parameter exceeds preset thresholds, ensuring the well-being of your fish.
- **Historical Data**: View historical data trends to analyze changes in water conditions over time.
- **User-friendly Interface**: The mobile app offers an intuitive interface for easy navigation and control.
- **Customization**: Set personalized preferences and thresholds to tailor the monitoring system to your specific needs.

## Installation

### Requirements

- Raspberry Pi 4
- Arduino Uno or compatible microcontroller
- pH sensor module
- PPM sensor module
- Temperature sensor module
- Smartphone with Flutter support

## Usage

1. Open the mobile app on your smartphone.
2. Sign in or create a new account.
3. Once connected, you will see real-time data from the sensors displayed on the app's dashboard.
4. Set up threshold values for pH, ppm, and temperature to receive alerts when any parameter goes out of range.
5. Monitor historical data trends and adjust settings as needed to maintain optimal conditions for your freshwater fish.

### Running the project:

- cd  into the downloaded github directory foler
- cd into the /src/ file
- open a second terminal in the same folder directory
- in the first terminal, write ``` docker compose up ```
- wait until the docker command has finished running
- in the second terminal write ``` flutter run ```
