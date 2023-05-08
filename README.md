# Dangerous Dave programmed on an FPGA
<p>
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayA.png"  width="40%" height="40%">
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayB.png"  width="40%" height="40%">
</p>

A remake for the nostalgic 2D video game programmed on a DE-10 Standard. 
Dangerous Dave is a Freeware Platform single-player 2D game developed by John Romero and published by SoftDisk.

- [Overview](#1-overview)
- [Architecture](#2-architecture)
- [Debug Tools](#3-debug-tools)
- [Summary](#4-fpga-implementation-summary)


## 1. Overview
This version of Dangerous Dave was designed to play on a programmed Terasic DE-10 Standard Development Kit


## 2. Architecture

### 2.1 Complete Block Diagram
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/BlockDiagram.png"  width="60%" height="60%">

### 2.2 Top Hierarchy
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/TopHierarchy.png"  width="80%" height="80%">

### 2.3 I/O Interfaces
<p align="center"><img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/IO.png"  width="40%" height="40%"></p>

| Unit| Description 
|:-------------------------|:--------------:|
| `Keys + Switches`     | User Input to control the game | 
| `DE-10 Standard FPGA` | Receives user's input, manages game's events and delivers output to the visual and audial units | 
| `VGA`                 | Manages VGA events and delivers visual output to an external screen using the VGA port|
| `7SEG`                | Display game stats on built on the seven-segment display |
| `Audio`               | Manages and delivers the game's audio output to an external speaker using the AUX port |


### 2.4 Drawing to screen module
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/DrawingMatrices.png"  width="60%" height="60%">

| Drawing to screen steps |
|----------------------|
| Reset the matrices that hold all the objects and their positions in screen | 
| On receiving _level_, _pixelX_, _pixelY_ from the VGA controller the module check if there's a drawing request for a new bitmap | 
| The Bitmap looks for the current value to draw on the screen and sends it as _RGB[7..0]_ together with a _drawingRequest_ |
| On receiving _collision_ between the player and an object, the module can erase the object from the matrix |

<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/matricesWaveforms.png"  width="60%" height="60%">


### 2.5 Fintie-State Machine
The player gets a strike when hitting a bomb and not playing in *GodMode*. The game ends after loosing three lives or if the time is up. 
The player then has an option to restart the game and start from the beginning.

<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/mealyFSM.png"  width="60%" height="60%">

State machine wavform

<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/stateMachineWaveforms.png"  width="60%" height="60%">

## 3. Debug Tools
### 3.1 Signal Tap Logic Analyser
The Signal Tap logic analyser captures real-time signals in an FPGA and allows one to probe and debug the behaviour of specifyed internal signals. Signal Tap was used in this project to debug the logic and test the behaviour of signals during normal device operation.

The following is an example of authentic debug using Signal Tap:
Although I reset the values for score and life stats, the values were matching during low resetN but soon changed to unexpected values.
Using Signal Tap to detect the signals I figured that the bug was in the values associated with resetN while rising edge to high.
The issue was fixed by distinting default values to the unexpected values acquired during low resetN.

#### Signal Tap waveforms used to find a bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFound.png"  width="60%" height="60%">


#### Signal Tap waveform showing desired behavior succeeding to fix the bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFixed.png"  width="60%" height="60%">

### 3.2 In-System Modification of Memory
The In-System Memory Content Editor (ISMCE) allows to view and update memories and constants in the FPGA during normal runtime using the JTAG interface. 
This powerful tool can be used to debug and test the design and bypass functional issues while forcing the desired data.
By testing changes to memory contents in the FPGA while the design is running, you can identify, test, and resolve issues.

I used this memory modification in order to test functionality of drawing and collision between player and objects at the very early stages when the player's movements were only partly implemented.
I hope to add an example soon.



## 4. FPGA Implementation Summary
Logic Utilization of 6%
Total block memory bits < 1%
Compilation time of 3:37 (goal was to be under 10:00 minutes)

<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/FlowSummary.png"  width="50%" height="50%">
