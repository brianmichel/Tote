# ![](images/RoundedIcon-small.png =80x80) Tote

__Tote__ is a simple photo transfer application made for use with the Ricoh GR III camera.

## Icons

All of the icons that are in the app are currently located in the `ToteIcons.sketch` so you can find them in there.

## Running the fake server

When building this app, since it connects to a physical camera, it can be painful to actually switch wireless networks and connect to the camera to do some debugging.

We've created a simple fake JSON server that passes back mock responses that were captured from a real camera.

__Starting the server__
1. `cd fake-server`
2. `json-server db.json --routes routes.json`
