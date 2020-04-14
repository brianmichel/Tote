# Tote 💼

__Tote__ is a simple photo transfer application made for use with the Ricoh GR III camera.

## Icons

| Light App Icon | Dark App Icon |
| ---- | ---- |
| ![](media/RoundedIcon.png) | ![](media/RoundedIcon-Dark.png) |
| ![](media/product/main.mov) | ![](media/RoundedIcon-Dark.png) |


All of the icons that are in the app are currently located in the `ToteIcons.sketch` so you can find them in there.

## Running the fake server

When building this app, since it connects to a physical camera, it can be painful to actually switch wireless networks and connect to the camera to do some debugging.

We've created a simple fake JSON server that passes back mock responses that were captured from a real camera.

__Starting the server__
1. `cd fake-server`
2. `json-server db.json --middlewares externalFile.js --routes routes.json`

## API Information

Much of what I know about the API is documented on the wiki. This will be the place to go dig into more info about those responses, or what is available to use from the application. There are many more API endpoints, but I've documented the ones that Tote is using.

## What does this thing look like?

Here are a couple of gifs that show what the general application looks like. Note that it works in light and dark mode so if you want to imagine light mode just invert everything in your brain.

| Main Application | Settings |
| ---- | ---- |
| ![](media/product/main.gif) | ![](media/product/settings.gif) | 