# Placing Virtual Objects in Augmented Reality

Follow best practices for visual feedback, gesture interactions, and realistic rendering in AR experiences.

## Overview

Augmented reality (AR) offers new ways for users to interact with real and virtual 3D content in your app. However, many fundamental principles of human interface design are still valid. Convincing AR illusions also require careful attention to 3D asset design and rendering. By following this article's guidelines for AR human interface principles and experimenting with this sample code, you can create immersive, intuitive AR experiences.

## Getting Started

ARKit and this sample app require iOS 11 and a device with an A9 (or later) processor. (ARKit is not available in iOS Simulator.)

## Provide Clear Feedback

**Help users recognize when your app is ready for real-world interactions.**
Tracking the real-world environment involves complex algorithms whose timeliness and accuracy are affected by real-world conditions.

The [`FocusSquare`](x-source-tag://FocusSquare) class draws a square outline in the AR view, giving the user hints about the status of ARKit world tracking. The square changes size to reflect estimated scene depth, and switches between open and closed states with a prominent animation to indicate whether ARKit has detected a plane suitable for placing an object.

Use the [`session(_:cameraDidChangeTrackingState:)`](https://developer.apple.com/documentation/arkit/arsessionobserver/2887450-session) delegate method to detect changes in tracking quality, and present feedback to the user when low-quality conditions are correctable (for example, by telling the user to move to an environment with better lighting).

Use specific terms a user is likely to recognize. For example, if you give textual feedback for plane detection, a user not familiar with technical definitions might mistake the word "plane" as referring to aircraft.

Fall back gracefully if tracking fails, and allow the user to reset tracking if their experience isn't working as expected. In this sample's `ViewController` class, see the [`session(_:cameraDidChangeTrackingState:)`](https://developer.apple.com/documentation/arkit/arsessionobserver/2887450-session) for a way to temporarily use lower-fidelity tracking, and the [`restartExperience`](x-source-tag://restartExperience) button and method for resetting tracking.

**Help users understand the relationship of your app's virtual content to the real world.** Use visual cues in your UI that react to changes in camera position relative to virtual content.

In this sample, the focus square disappears after the user places an object in the scene, and reappears when the user points the camera away from the object.

## Enable Direct Manipulation

**Provide common gestures, familiar to users of other iOS apps, for interacting with real-world objects.** See the [`Gesture`](x-source-tag://Gesture) class for implementations of the gestures available in this sample app, such as one-finger dragging to move a virtual object and two-finger rotation to spin the object.

Map touch gestures into a restricted space so the user can more easily control results. Touch gestures are inherently two-dimensional, but an AR experience involves the three dimensions of the real world. For example:

- Limit object dragging to the two-dimensional plane the object rests on. (Especially if a plane represents the ground or floor, it often makes sense to ignore the plane's extent while dragging.)

- Limit object rotation to a single axis at a time. (In this sample, each object rests on a plane, so the object can rotate around a vertical axis.)

- Don't allow the user to resize virtual objects, or offer this ability only sparingly. A virtual object inhabits the real world more convincingly when it has an intuitive intrinsic size. Additionally, a user may become confused as to whether they're resizing an object or changing its depth relative to the camera. (If you do provide object resizing, use pinch gestures.)

While the user is dragging a virtual object, smooth the changes in its position so that it doesn't appear to jump while moving. See the `updateVirtualObjectPosition` method for an example of smoothing based on perceived distance from the camera.

Set thresholds for gestures so that the user doesn't trigger a gesture accidentally, but moderate your thresholds so that gestures aren't too hard to discover or intentionally trigger. See the [`TwoFingerGesture`](x-source-tag://TwoFingerGesture) class for examples of using thresholds to dynamically choose gesture effects.

Provide an area that's large enough for the user to tap (or begin to drag) a virtual object and still see the object while moving it. For examples, see how the [`TwoFingerGesture`](x-source-tag://TwoFingerGesture) class calculates its  `firstTouchWasOnObject` property.

**Design interactions for situations where AR illusions can be most convincing.** For example, place virtual content near the centers of detected planes, where it's safer to assume that the detected plane is a good match to the real-world surface. It may be tempting to design experiences that use the full surface of a tabletop, where virtual scene elements can react to or fall off the table's edges. However, world tracking and plane detection may not precisely estimate the edges of the table.


## Keep the User in Control

**Strive for a balance between accurately placing virtual content and respecting the user's input.** For example, consider a situation where the user attempts to place content that should appear on top of a flat surface.

- Try to place content by using the [`hitTest(_:types:)`](https://developer.apple.com/documentation/arkit/arframe/2875718-hittest) method to search for an intersection with a plane anchor. If you don't find a plane anchor, there might still be a plane at the target location that has not yet been identified by plane detection.
- Lacking a plane anchor, you can hit-test against scene features to get a rough estimate for where to place content initially, and refine that estimate over time as ARKit detects planes.
- When plane detection provides a better estimate for where to place content, use animation to subtly move that content to its new position. Having user-placed content suddenly jump to a new position can break the AR illusion and confuse the user.
- Filter out hit test results that are too close or too far away. In most scenarios, there's a reasonable limit to how far away virtual content can be placed. To prevent users from accidentally placing virtual content too far away, you can use the `distance` property of `ARHitTestResult` to filter out hit tests that exeed the limit.

**Avoid interrupting the AR experience.** If the user transitions to another full-screen UI in your app, the AR view might not be in an expected state when they return.

To keep the user in the AR experience while adjusting settings or making a modal selection, use the popover presentation (even on iPhone) for auxiliary view controllers. In this sample, the `SettingsViewController` and `VirtualObjectSelectionViewController` classes use popover presentation.


