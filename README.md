# Overview

Wayne HS 10411 Rufus 

[Google Doc Notes](https://docs.google.com/document/d/1e-II6_diUCd73_c5pIJWgDAT_IvrZXD0227dueINiO4/edit) <-- Log what you do here


# 2026CompetitiveConcept

This repository contains the code used for the WestCoast Products 2026 [Competitive Concept](https://wcproducts.com/pages/wcp-competitive-concepts).

The project is based on one of CTRE's [Phoenix 6 example projects](https://github.com/CrossTheRoadElec/Phoenix6-Examples/tree/main/java/SwerveWithChoreo). It uses WPILib [command-based programming](https://docs.wpilib.org/en/stable/docs/software/commandbased/what-is-command-based.html) to manage robot subsystems and actions, a [Limelight](https://limelightvision.io/) for vision, and [Choreo](https://choreo.autos/) for autonomous path following.

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

---

## Field Setup & Match Calibration

Complete these steps **at every new event** (and after any camera or robot mechanical changes) before going on the field.

### 1. Upload the AprilTag Field Map to the Limelight

> Do this once per event — not before every match.

1. Connect a laptop to the robot's network (robot on, roboRIO booted).
2. Open the Limelight web UI: **http://limelight.local:5801** (or **http://10.104.11.11:5801** if mDNS isn't working).
3. Go to **Settings → AprilTag Field Map**.
4. Upload the correct JSON from the [`limelight-config/`](limelight-config/) folder:
   - **Most events (district, regional):** `2026-rebuilt-welded.json`
   - **If the event specifies AndyMark field parts:** `2026-rebuilt-andymark.json`
5. Confirm the active pipeline is set to **AprilTag** mode.

### 2. Verify Camera Pose (Robot-to-Camera Transform)

The Limelight needs to know where it is mounted on the robot to produce accurate field-relative pose estimates.

1. In the Limelight web UI, go to **Settings → Robot Offset** (or the 3D tab depending on firmware version).
2. Enter the camera's position and angle relative to the center of the robot:
   - **Forward (X):** distance the camera is in front of robot center (meters, positive = forward)
   - **Side (Y):** distance left/right of robot center (meters, positive = left)
   - **Up (Z):** height above the floor (meters)
   - **Roll / Pitch / Yaw:** camera tilt angles (degrees)
3. Measure these from the robot physically if they haven't been set — they must match the actual mount.

### 3. Re-Zero Field-Centric Orientation Before Each Match

At the start of every match (robot placed on the field):

1. Point the **front of the robot** toward the driver station wall (or align as required by your starting position).
2. Press **Back** on the Xbox controller to re-zero field-centric orientation to the robot's current heading.

> The robot uses field-centric driving relative to this zero, so this must match how the robot is physically placed.

### 4. Verify Vision Is Working (Pre-Match Check)

1. Open **Shuffleboard** or **AdvantageScope** while connected to the robot.
2. Confirm the **"Estimated Robot Pose"** value under `SmartDashboard/limelight` is updating and makes sense given the robot's position on the field.
3. If the pose is wildly wrong or not updating:
   - Check that the Limelight has a tag in view (run a test with tags visible).
   - Re-confirm the field map was uploaded and the correct pipeline is active.
   - Check that the camera pose offset is configured correctly.

### 5. Shooter Tuning (If Needed)

- The target shooter RPM for manual shots (Right Bumper) is set via **Shuffleboard** — look for the `Target RPM` slider under the Shooter subsystem widget.
- Default is **5000 RPM**. Adjust based on shot distance for the event venue.
- Feed threshold is fixed at **3500 RPM** — the floor and feeder will not run until the shooter crosses this.

---

## Power-Up Initialization

When the robot is powered on and robot code starts, several automatic initialization steps occur before the robot is ready to operate. Understanding this sequence helps diagnose issues and know what to expect when enabling the robot.

> **If you change any of this behavior in code, update this section.**
> Links back here are in the relevant source files:
> - `RobotContainer.java` — `configureBindings()` (homing trigger)
> - `Intake.java` — `homingCommand()`
> - `Hanger.java` — `homingCommand()`

### 1. On Code Start (Robot Constructor)

These happen immediately when the robot code launches, before any mode is active:

| What | Detail |
|---|---|
| AdvantageKit logging | Starts writing `.wpilog` to `/home/lvuser/logs/` and publishing live via NT4 |
| Brownout protection | RoboRIO brownout threshold set to **6.1 V** |
| Subsystems initialized | All subsystems (Swerve, Intake, Floor, Feeder, Shooter, Hood, Hanger, Limelight) are instantiated and their motors configured |
| Vision update begins | Limelight default command starts running immediately, even while disabled (`ignoringDisable = true`) |
| Shooter default command | Shooter default is `stop()` — motors hold at zero until commanded |

### 2. On First Enable (Teleop or Autonomous — not Test Mode)

When the robot transitions into **teleop or autonomous** for the first time after power-up, two homing sequences run automatically and in parallel. They are suppressed in **test mode**.

#### Intake Pivot Homing

The intake pivot motor has no absolute encoder, so its zero position must be found by driving it to a physical hard stop.

1. Pivot motor drives **outward at 10% output** (toward the hard stop).
2. Code waits until **supply current exceeds 6 A** — this indicates the pivot has stalled against the hard stop.
3. Encoder is **zeroed** at the hard stop position (`HOMED` = 110°).
4. Pivot immediately moves to **`STOWED` position (100°)**.

> This command uses `kCancelIncoming` — it cannot be interrupted once started. A subsequent position command will be queued until homing finishes.

#### Hanger Homing

The hanger motor also uses a hard-stop current-sensing approach.

1. Hanger motor drives **inward (retract) at −5% output**.
2. Code waits until **supply current exceeds 0.4 A** — indicating the hanger has bottomed out.
3. Encoder is **zeroed** at the retracted position (`HOMED` = 0 inches extension).
4. Hanger immediately extends to the **`EXTEND_HOPPER` position (2 inches)** — clear of the robot chassis.

> This command uses `kCancelSelf` — any position command issued during homing will cancel the homing sequence.

### 3. Field-Centric Drive Zero

The swerve drive uses field-centric control relative to a stored heading. This heading is **not automatically reset on power-up** — it must be manually re-zeroed by the driver before each match using the **Back button** on the Xbox controller (see [Re-Zero Field-Centric Orientation](#3-re-zero-field-centric-orientation-before-each-match)).

> `seedFieldCentric()` is suppressed in test mode to avoid affecting other test sequences.
