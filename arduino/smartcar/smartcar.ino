#include <vector>

#include <MQTT.h>
#include <WiFi.h>
#ifdef __SMCE__
#include <OV767X.h>
#endif

#include <Smartcar.h>

#ifndef __SMCE__
WiFiClient net;
#endif
MQTTClient mqtt;

const int fSpeed = 50;    // 50% of the full speed forward
const int bSpeed = -40;   // 40% of the full speed backward
const int lDegrees = -75; // degrees to turn left
const int rDegrees = 75;  // degrees to turn right
const auto oneSecond = 1000UL;
const auto triggerPin = 6;
const auto echoPin = 7;
const auto maxDistance = 400;

ArduinoRuntime arduinoRuntime;
BrushedMotor leftMotor(arduinoRuntime, smartcarlib::pins::v2::leftMotorPins);
BrushedMotor rightMotor(arduinoRuntime, smartcarlib::pins::v2::rightMotorPins);
DifferentialControl control(leftMotor, rightMotor);
SR04 sensor(arduinoRuntime, triggerPin, echoPin);
SR04 front(arduinoRuntime, triggerPin, echoPin, maxDistance);

const int GYROSCOPE_OFFSET = 37;
GY50 gyro(arduinoRuntime, GYROSCOPE_OFFSET);

std::vector<char> frameBuffer;

SimpleCar car(control);

void setup()
{
    Serial.begin(9600);
    Serial.setTimeout(200);

#ifdef __SMCE__
    Camera.begin(QVGA, RGB888, 15);
    frameBuffer.resize(Camera.width() * Camera.height() * Camera.bytesPerPixel());
    //  mqtt.begin("127.0.0.1", 1883, WiFi);
    mqtt.begin("aerostun.dev", 1883, WiFi);

    // mqtt.begin(WiFi); // Will connect to localhost
#else
    mqtt.begin(net);
#endif
    if (mqtt.connect("arduino", "public", "public"))
    {
        mqtt.subscribe("/smartcar/group3/control/#", 1);
        mqtt.onMessage([](String topic, String message) {
            if (topic == "/smartcar/group3/control/throttle")
            {
                car.setSpeed(message.toInt());
            }
            else if (topic == "/smartcar/group3/control/steering")
            {
                car.setAngle(message.toInt());
            }
            else if (topic == "/smartcar/group3/control/automove")
            {
                switch (message.charAt(0))
                {
                case 'b':
                    beeDance();
                    break;
                case 'c':
                    moveCircle(60, 60, true);
                    break;
                case 'z':
                    snake();
                    break;
                case 's':
                    car.setSpeed(0);
                    break;
                default:
                    break;
                }
            }
            else
            {
                Serial.println(topic + " " + message);
            }
        });
    }
}

void loop()
{
    handleInput();
    avoidObstacles();

    if (mqtt.connected())
    {
        mqtt.loop();
        const auto currentTime = millis();
#ifdef __SMCE__
        static auto previousFrame = 0UL;
        if (currentTime - previousFrame >= 65)
        {
            previousFrame = currentTime;
            Camera.readFrame(frameBuffer.data());
            mqtt.publish("/smartcar/group3/camera", frameBuffer.data(), frameBuffer.size(),
                         false, 0);
        }
#endif
        static auto previousTransmission = 0UL;
        if (currentTime - previousTransmission >= oneSecond)
        {
            previousTransmission = currentTime;
            const auto distance = String(front.getDistance());
            mqtt.publish("/smartcar/group3/ultrasound/front", distance);
        }
    }
#ifdef __SMCE__
    // Avoid over-using the CPU if we are running in the emulator
    delay(35);
#endif
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
        case 'c': // cicrle
            moveCircle(50, 50, true);
            break;
        case 's':
            snake();
            break;
        case 'd':
            beeDance();
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

void moveCircle(int speed, int angle, bool direction)
{

    gyro.update();
    const int startingHeading = gyro.getHeading();
    int currentHeading = -1;

    if (!direction)
    {
        angle = -angle;
    }
    car.setAngle(angle);
    car.setSpeed(speed);
    while(millis() < 0 + 1000){
        do
        {

            gyro.update();
            currentHeading = gyro.getHeading();

        } while (currentHeading != startingHeading);

        car.setSpeed(0);
        mqtt.publish("/smartcar/group3/control/automove/complete", "circle");
        return;
    }
}

void beeDance()
{
    moveCircle(50, 100, true);
    moveCircle(50, 100, false);
    while(millis() < 0 + 1000){
        mqtt.publish("/smartcar/group3/control/automove/complete", "beeDancing");
    }
}

void snake()
// TODO: use while(millis() < 0 + 1000) instead of delay
{

    int angle = 100;
    int counter = 0;
    car.setSpeed(100);

    while (counter < 8)
    {

        car.setAngle(angle);
        delay(1000);
        car.setAngle(0);
        delay(1000);
        counter++;
        angle = -angle;
    }

    car.setSpeed(0);
}

