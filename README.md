# Overview

Wayne HS 10411 Rufus 

[Google Doc Notes](https://docs.google.com/document/d/1e-II6_diUCd73_c5pIJWgDAT_IvrZXD0227dueINiO4/edit) <-- Log what you do here


# 2026CompetitiveConcept

This repository contains the code used for the WestCoast Products 2026 [Competitive Concept](https://wcproducts.com/pages/wcp-competitive-concepts).

The project is based on one of CTRE's [Phoenix 6 example projects](https://github.com/CrossTheRoadElec/Phoenix6-Examples/tree/main/java/SwerveWithChoreo). It uses WPILib [command-based programming](https://docs.wpilib.org/en/stable/docs/software/commandbased/what-is-command-based.html) to manage robot subsystems and actions, a [Limelight](https://limelightvision.io/) for vision, and [Choreo](https://choreo.autos/) for autonomous path following.

## Driver Controls

The active controller type is selected by the `useJoystick` boolean in `RobotContainer.java`:
- `false` (default) — Xbox controller on port 0
- `true` — Flight stick (joystick) on port 0

---

## Driver Controls (Flight Stick — port 0)

> Set `useJoystick = true` in `RobotContainer.java` to use this mode.

### Driving
| Input | Action |
|---|---|
| Axis 0 (X) | Translate left/right (field-centric) |
| Axis 1 (Y) | Translate forward/back (field-centric) |
| Axis 3 (Twist) | Rotate |
| Button 1 | Lock heading toward opponent alliance wall (180°) |
| Button 2 | Lock heading right (90° clockwise) |
| Button 3 | Lock heading left (90° counter-clockwise) |
| Button 4 | Lock heading toward own alliance wall (0°) |
| Button 8 | Re-zero field-centric orientation to current robot heading |

### Shooting
| Input | Action |
|---|---|
| Button 17 | Auto-aim at hub using Limelight, spin up shooter, feed when aimed and ready |
| Button 18 | Spin up shooter to dashboard RPM (default 5000), feed once above 3500 RPM |

> **Button 17 vs Button 18:** Button 17 requires a valid Limelight target lock before feeding. Button 18 shoots without vision — use this when the Limelight has no target or for close shots.

### Intake
| Input | Action |
|---|---|
| Button 16 | Deploy intake pivot and run rollers (hold to intake) |
| Button 5 | Stow intake pivot |

### Climbing
| Input | Action |
|---|---|
| D-Pad Up | Raise hanger to pre-hang position |
| D-Pad Down | Pull hanger down to fully climbed position |

### Troubleshooting
| Input | Action |
|---|---|
| D-Pad Left | Reverse floor and shooter to clear a jam (hold) |

---

## Driver Controls (Xbox Controller — port 0)

### Driving
| Input | Action |
|---|---|
| Left Stick | Translate (field-centric) |
| Right Stick X | Rotate |
| A | Lock heading toward opponent alliance wall (180°) |
| B | Lock heading right (90° clockwise) |
| X | Lock heading left (90° counter-clockwise) |
| Y | Lock heading toward own alliance wall (0°) |
| Back | Re-zero field-centric orientation to current robot heading |

### Shooting
| Input | Action |
|---|---|
| Right Trigger | Auto-aim at hub using Limelight, spin up shooter, feed when aimed and ready |
| Right Bumper | Spin up shooter to dashboard RPM (default 5000), feed once above 3500 RPM |

> **Right Trigger vs Right Bumper:** Right trigger requires a valid Limelight target lock before feeding. Right bumper shoots without vision — use this when the Limelight has no target or for close shots.

### Intake
| Input | Action |
|---|---|
| Left Trigger | Deploy intake pivot and run rollers (hold to intake) |
| Left Bumper | Stow intake pivot |

### Climbing
| Input | Action |
|---|---|
| D-Pad Up | Raise hanger to pre-hang position |
| D-Pad Down | Pull hanger down to fully climbed position |

### Troubleshooting
| Input | Action |
|---|---|
| D-Pad Left | Reverse floor and shooter to clear a jam (hold) |
