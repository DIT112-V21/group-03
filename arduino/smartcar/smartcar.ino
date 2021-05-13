#include <Smartcar.h>

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
const long distanceToTravel = 40;
const char noop = 'x';

ArduinoRuntime arduinoRuntime;
BrushedMotor leftMotor(arduinoRuntime, smartcarlib::pins::v2::leftMotorPins);
BrushedMotor rightMotor(arduinoRuntime, smartcarlib::pins::v2::rightMotorPins);
DifferentialControl control(leftMotor, rightMotor);
SR04 sensor(arduinoRuntime, triggerPin, echoPin);
SR04 front(arduinoRuntime, triggerPin, echoPin, maxDistance);

const auto pulsesPerMeter = 600;

DirectionlessOdometer leftOdometer(
    arduinoRuntime,
    smartcarlib::pins::v2::leftOdometerPin,
    []() { leftOdometer.update(); },
    pulsesPerMeter);
DirectionlessOdometer rightOdometer(
    arduinoRuntime,
    smartcarlib::pins::v2::rightOdometerPin,
    []() { rightOdometer.update(); },
    pulsesPerMeter);

const int GYROSCOPE_OFFSET = 37;
GY50 gyro(arduinoRuntime, GYROSCOPE_OFFSET);

std::vector<char> frameBuffer;

SmartCar car(arduinoRuntime, control, gyro, leftOdometer, rightOdometer);
char carOp = noop;

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
                carOp = noop;
                car.setSpeed(message.toInt());
            }
            else if (topic == "/smartcar/group3/control/steering")
            {
                carOp = noop;
                car.setAngle(message.toInt());
            }
            else if (topic == "/smartcar/group3/control/automove")
            {
                carOp = message.charAt(0);
            }
            else
            {
                Serial.println(topic + " " + message);
            }
        });
    }
}

void handleCarOp()
{
    switch (carOp)
    {
    case 'b':
        beeDance();
        break;
    case 'c':
        moveCircle();
        break;
    case 'z':
        snake();
        break;
    case 's':
        car.setSpeed(0);
        break;
    case 'f':
        backAndForth();
        break;
    default:
        break;
    }
}

void loop()
{
    handleInput();
    avoidObstacles();
    handleCarOp();

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
            moveCircle();
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

int circleState = 0;
bool circleBusy = false;
int circleStartTime = 0;
int circleStepTime = 3000;
int degreesToTurnCircle = 45;

void moveCircle()
{
    if (!circleBusy)
    {
        circleStartTime = millis();
        circleState = 0;
        circleBusy = true;
    }

    circleState = nextDelayedRotateState(circleStartTime, 0, circleState, 0, degreesToTurnCircle, 50, &rotate);
    circleState = nextDelayedRotateState(circleStartTime, circleStepTime * 3, circleState, 1, 0, 0, &rotate);

    if (circleState == 2)
    {
        car.setSpeed(0);
        circleBusy = false;
        circleState = 0;
        carOp = noop;
        mqtt.publish("/smartcar/group3/control/automove/complete", "circle");
    }
}

int beeState = 0;
bool beeBusy = false;
int beeStartTime = 0;
int beeStepTime = 3000;
int degreesToTurnBee = 45;

void beeDance()
{
    if (!beeBusy)
    {
        beeStartTime = millis();
        beeState = 0;
        beeBusy = true;
    }

    beeState = nextDelayedRotateState(beeStartTime, 0, beeState, 0, degreesToTurnBee, 50, &rotate);
    beeState = nextDelayedRotateState(beeStartTime, beeStepTime * 3, beeState, 1, -degreesToTurnBee, 50, &rotate);
    beeState = nextDelayedRotateState(beeStartTime, beeStepTime * 5, beeState, 2, 0, 0, &rotate);

    if (beeState == 3)
    {
        car.setSpeed(0);
        beeBusy = false;
        beeState = 0;
        carOp = noop;
        mqtt.publish("/smartcar/group3/control/automove/complete", "beeDancing");
    }
}

int snakeState = 0;
bool snakeBusy = false;
int snakeStartTime = 0;
int snakeStepTime = 3000;
int degreesToTurn = 45;
void snake()
{
    if (!snakeBusy)
    {
        snakeStartTime = millis();
        snakeState = 0;
        snakeBusy = true;
    }
    snakeState = nextDelayedGoState(snakeStartTime, 0, snakeState, 0, 50, &go);
    snakeState = nextDelayedRotateState(snakeStartTime, snakeStepTime / 2, snakeState, 1, degreesToTurn, 50, &rotate);
    snakeState = nextDelayedRotateState(snakeStartTime, snakeStepTime * 1, snakeState, 2, -degreesToTurn, 50, &rotate);
    snakeState = nextDelayedRotateState(snakeStartTime, snakeStepTime * 2, snakeState, 3, degreesToTurn, 50, &rotate);
    snakeState = nextDelayedRotateState(snakeStartTime, snakeStepTime * 3, snakeState, 4, -degreesToTurn, 50, &rotate);
    snakeState = nextDelayedRotateState(snakeStartTime, snakeStepTime * 4, snakeState, 5, degreesToTurn, 50, &rotate);

    if (snakeState == 6)
    {
        car.setSpeed(0);
        snakeBusy = false;
        snakeState = 0;
        carOp = noop;
        mqtt.publish("/smartcar/group3/control/automove/complete", "snake");
    }
}

void rotate(int degrees, int fSpeed)
{
    car.setSpeed(fSpeed);
    car.setAngle(degrees);
}

void go(int fSpeed)
{
    car.setAngle(0);
    car.setSpeed(fSpeed);
}

int backAndForthState = 0;
bool backAndForthBusy = false;
int backAndForthStartTime = 0;
int backAndForthStepTime = 3000;
void backAndForth()
{
    if (!backAndForthBusy)
    {
        backAndForthStartTime = millis();
        backAndForthState = 0;
        backAndForthBusy = true;
    }
    backAndForthState = nextDelayedGoState(backAndForthStartTime, 0, backAndForthState, 0, 50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime, backAndForthState, 1, -50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime * 2, backAndForthState, 2, 50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime * 3, backAndForthState, 3, -50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime * 4, backAndForthState, 4, 50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime * 5, backAndForthState, 5, -50, &go);
    backAndForthState = nextDelayedGoState(backAndForthStartTime, backAndForthStepTime * 6, backAndForthState, 6, 50, &go);
    if (backAndForthState == 7)
    {
        car.setSpeed(0);
        backAndForthState = 0;
        backAndForthBusy = false;
        carOp = noop;
        mqtt.publish("/smartcar/group3/control/automove/complete", "forthBack");
    }
}

int nextDelayedGoState(int startTime, int delay, int currentState, int targetState, int speed, void (*callback)(int))
{
    if (millis() - startTime >= delay && currentState == targetState)
    {
        callback(speed);
        return currentState + 1;
    }
    return currentState;
}

int nextDelayedRotateState(int startTime, int delay, int currentState, int targetState, int angle, int speed, void (*callback)(int, int))
{
    if (millis() - startTime >= delay && currentState == targetState)
    {
        callback(angle, speed);
        return currentState + 1;
    }
    return currentState;
}