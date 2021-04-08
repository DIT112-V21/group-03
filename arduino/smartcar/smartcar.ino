#include <Smartcar.h>

const int fSpeed = 50;    // 50% of the full speed forward
const int bSpeed = -40;   // 40% of the full speed backward
const int lDegrees = -75; // degrees to turn left
const int rDegrees = 75;  // degrees to turn right

ArduinoRuntime arduinoRuntime;
BrushedMotor leftMotor(arduinoRuntime, smartcarlib::pins::v2::leftMotorPins);
BrushedMotor rightMotor(arduinoRuntime, smartcarlib::pins::v2::rightMotorPins);
DifferentialControl control(leftMotor, rightMotor);
SR04 sensor(arduinoRuntime, 6, 7);
SimpleCar car(control);

void setup() {
    Serial.begin(9600);
    Serial.setTimeout(200);
}

void loop() {
    handleInput();
    avoidObstacles();
}
//*Title: smartCar shield manualControl
//* Author: Dimitrios Platis
//* Date: 2021-04-08
//* Availability: https://platisd.github.io/smartcar_shield/manual_control_8ino-example.html

void handleInput()
{ 
    if (Serial.available())
    {
        char input = Serial.read(); // read everything that has been received so far and log down
                                    // the last entry
        switch (input)
        {
        case 'l': // rotate counter-clockwise going forward
            car.setSpeed(fSpeed);
            car.setAngle(lDegrees);
            break;
        case 'r': // turn clock-wise
            car.setSpeed(fSpeed);
            car.setAngle(rDegrees);
            break;
        case 'f': // go ahead
            car.setSpeed(fSpeed);
            car.setAngle(0);
            break;
        case 'b': // go back
            car.setSpeed(bSpeed);
            car.setAngle(0);
            break;
        default: // if you receive something that you don't know, just stop
            car.setSpeed(0);
            car.setAngle(0);
        }
    }
}

void avoidObstacles()
{
    unsigned int distance = sensor.getDistance();
    unsigned int distanceToObstacle = 100;
    unsigned int obstacleRotate = 90;

    if (distance > 0 && distance <= distanceToObstacle)
    {
        car.setSpeed(0);
        car.setAngle(obstacleRotate);
        car.setSpeed(bSpeed);
    }
}
