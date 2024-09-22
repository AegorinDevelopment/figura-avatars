# Model Parts
> A small guide on how to create and use model parts

If you follow these instructions, your model part can be easily copied 
and pasted into any avatar to use. It will also work with the full 
`AvatarRPBase` by pasting the model into the `parts` folder.

## Creation
Follow these steps to create your first own model part

### Create the model
1. Create a new model name in lowercase (`snake_case`)
2. Create a new folder/bone named with the
    [ParentType](https://wiki.figuramc.org/enums/ModelPartParentTypes) 
    the part should be animated with
    - `Head, Body, LeftArm, RightArm, LeftLeg, RightLeg for now...`
    - Make sure it is written correct! (Case sensitive)
3. Create your whole custom part inside a folder/bone named like 
    the part it reassembles

Your folder/bone structure should look a bit like this:
```yml
- [Body]
  - [custom_wings]
    - [wing_right]
      - cube
    - [wing_left]
      - cube
    - cube
    - cube
```

> **Hint** - Make sure your pivot points are at the correct positions
  or your part may rotate weirdly when moving.