# AvatarRPBase ReadMe
> By `Valaron/Anfauglir/Jakob` and `CuddleCat_`

> Using code from `GrandpaScout` and `Slymeball`

If you like what i do, consider contributing to the project, sharing it to others 
or even spending a coffee on [ko-fi](https://ko-fi.com/valaron)

https://github.com/AegorinDevelopment/figura-avatars

## Features
- Change your characters height with a simple command
- Switch between emote poses with the press of a button
- See a formatted version of what you are typing
- Allow other players to see when you are typing
- Add your own custom parts

Every script in `scripts` has a small section at the top that allows to configure 
some basic values for your avatar. Have a look at it if you want to customize 
your avatar even more.

> **Warning** - Be careful when changing these values and read the instructions 
or you might break the avatar.

### Character Height
Use the command `.height <number>` to resize your avatar. Use your characters 
height in centimeter.

> **Hint** - Heights are capped at (min) 80 and (max) 300cm

### Emote Poses
Use your numpad (0-9) to toggle between different emote poses. Pressing one 
number twice toggles the emotes off.

> **Hint** - Hold down `Ctrl` to get even more poses.

### Chat Preview
When typing a preview of your message is shown between the chat and the input. 
This uses common roleplay formattings (`* [ ( > etc.`) to colorcode text.

### Show Typing
Others are able to see when you are typing in your nameplate and on the TAB view. 

### Custom Parts
Its possible to add your own custom parts to add ears, bags, weapons and more. 
When following the correct format, they are properly resized and animated as well. 

Just copy your custom parts inside the `parts` folder and reload your avatar.

> [How to create custom parts](https://github.com/AegorinDevelopment/figura-avatars/blob/master/ModelParts.md)


## Known Issues
- Camera height does not match player height
    > Changing this is a bit tricky and will probably be fixed in a future update

- Nameplate position is off when sitting/laying
    > This is caused by the resize and will be fixed in a future update

- Chat preview looks weird
    > The preview was shrunken by 20% to fit between chat and input