# Smart Pet Buddy

## Product description 

### What you are going to make? 

Our product is a Smart Pet Buddy app based on a smart car platform that provides pet owners with a solution for improving their pet care routine through manually controlled and automated play sessions. By combining the different opportunities to control the car, you can create a fun and engaging way to keep your pet active on a daily basis. 

The app offers two different modes. In the manually controlled mode, you could play with your pet while you are relaxing after another hard day at work as the app allows you to control the car’s movement patterns remotely in real-time. You can adapt the way the car moves by controlling its velocity, steer it in different directions and reverse it.

In the automated mode, Smart Pet Buddy will play with your pet while you are busy with your Zoom meetings, by starting pre-made movement patterns on you command. You choose the automated play sessions from a play list.

### Why will you make it? 

We are making this product because we want to improve the quality of lives for both pets and owners. This product is recommended to use for cats and small dogs indoors.

Daily exercise and mental stimulation is extremely important for the overall health and well-being of pets. Experts recommend that your cat should be getting exercise every day for at least two sessions of playtime a day of around 15-20 minutes each. 
The recommended amount of daily exercise for most dogs is 30 minutes to 2 hours, but depends on the breed.

However, owners often have a lack time to give proper care to their pets and keep them active indoors. 

### What problem does it solve? 

Smart Pet Buddy offers a solution for pet owners who want to increase the physical and mental activity of their pets indoors. The lack of physical and mental activity may cause the pet to otherwise become depressed, obese and ill. 

## Technical information

### How you are going to make it? What kind of technology you are going to use?

We are going to develop Flutter based application with a simple UI that will allow us to control the car and avoiding obstacles. 
We will store all information in Google firebase from Flutter (user credentials, pattern sequences, etc).
For implementing video streaming we will need to use one additional server. 
One of the team members kindly proposed to use his own Arduino compatible camera.
For the Arduino car, we are going to create an Arduino sketch that holds all car's functions we require.
Communication between car and application will go through a MQTT server.

## [User Manual](https://github.com/DIT112-V21/group-03/wiki/User-manual)


