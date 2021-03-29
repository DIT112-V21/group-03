# Smart Pet Buddy

## Product description 

### What you are going to make? 

Our product is a Smart Pet Buddy app based on a smart car platform that provides pet owners with the solution for improving their pet care routine through manual and automatic play sessions. Smart Pet Buddy will play with your pet while you are busy with your Zoom meetings via prescheduled movement patterns that will acivate your pet. 
You could also use it in manual mode while you are relaxing after another hard day at work by remotely controlling the movement patterns.

### Why will you make it? 

We are making this product because we want to improve the quality of lives for both pets and owners. This product is recommended to use for cats and small dogs indoors.

Experts recommend that your cat should be getting exercise every day for at least two sessions of playtime a day of around 15-20 minutes each. 
The recommended amount of daily exercise for most dogs is 30 minutes to 2 hours, depends on the breed.
It is extremely important for their health and well-being.
Owners often have a lack time to give proper care to their pets and keep them active indoors. 

### What problem does it solve? 

Our product solves the problem when people want to increase the physical activity of their pets indoors because if your pet doesn't get enough exercise it risks to become depressed, obese and ill.

## Technical information

### How you are going to make it? What kind of technology you are going to use?

We are going to develop Flutter based application with a simple UI that will allow us to control the car, avoiding obstacles. 
We will store all information in Google firebase from Flutter (user credentials, pattern sequences, etc).
For implementing video streaming we will need to use one additional server. 
One of us kindly proposed to use his own Arduino compatible camera.
For the Arduino car, we are going to create an Arduino sketch that holds all car's functions we require.
Communication between car and application will go through a MQTT server.




