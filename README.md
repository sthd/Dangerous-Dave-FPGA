# Dangerous Dave programmed on an FPGA
<p>
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayA.png"  width="40%" height="40%">
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayB.png"  width="40%" height="40%">
</p>
<p>
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayC.png"  width="40%" height="40%">
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameplayD.png"  width="40%" height="40%">
</p>

A remake for the nostalgic 2D video game programmed on a DE-10 Standard. 
Dangerous Dave is a Freeware Platform single-player 2D game developed by John Romero and published by SoftDisk.

- [Overview](#1-overview)
- [Architecture](#2-architecture)
- [Schematic](#3-schematic-and-rtl)


## 1. Overview
This version of Dangerous Dave was designed to play on a programmed Terasic DE-10 Standard Development Kit





## 2. Architecture

### 2.1 Block Diagram
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/BlockDiagram.png"  width="60%" height="60%">

### 2.2 I/O Interfaces
<p align="center"><img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/IO.png"  width="40%" height="40%"></p>

| Unit| Description 
|:-------------------------|:--------------:|
| `Keys + Switches`     | User Input to control the game | 
| `DE-10 Standard FPGA` | Receives user's input, manages game's events and delivers output to the visual and audial units | 
| `VGA`                 | Manages VGA events and delivers visual output to an external screen using the VGA port|
| `7SEG`                | Display game stats on built on the seven-segment display |
| `Audio`               | Manages and delivers the game's audio output to an external speaker using the AUX port |


### 2.3 Drawing to screen module
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/DrawingMatrices.png"  width="303" height="115">

| Drawing to screen steps |
|----------------------|
| Reset the matrices that hold all the objects and their positions in screen | 
| On receiving _level_, _pixelX_, _pixelY_ from the VGA controller the module check if there's a drawing request for a new bitmap | 
| The Bitmap looks for the current value to draw on the screen and sends it as _RGB[7..0]_ together with a _drawingRequest_ |
| On receiving _collision_ between the player and an object, the module can erase the object from the matrix |



## 3. Schematic and RTL
### 3.1 Top Hierarchy
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/TopHierarchy.png"  width="1132" height="635">

### 3.2 

## 4. Waveforms and Signals
### 4.1 Drawing Module waveform
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/matricesWaveforms.png"  width="1007" height="364">

### 4.2 State machine waveform
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/stateMachineWaveforms.png"  width="992" height="364">

### 4.3 Signal Tap Logic Analyser
The Signal Tap logic analyser captures real-time signals in an FPGA and allows one to probe and debug the behaviour of specifyed internal signals. Signal Tap was used in this project to debug the logic and test the behaviour of signals during normal device operation.
#### SignalTap waveforms used to find a bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFound.png"  width="991" height="127">

#### SignalTap waveform showing desired behavior succeeding to fix the bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFixed.png"  width="991" height="127">

## 4. FPGA Implementation Results
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/FlowSummary.png"  width="500" height="400">

## 5. Programming the game
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/FlowSummary.png"  width="500" height="400">






## 🎯 Objectives
- [x] **🏃 Player Movement _using_ [keys and switches](https://github.com/sthd/Dangerous-Dave-FPGA/edit/main/README.md ""#1-overview):**
  - [x] Horizontal Movement
  - [x] Vertical Movement (Jumping).

- [x] **Player Lives:**
  - [x] 3 strikes _using_ [State Machine](https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/stateMachineWaveforms.png)
  - [x] Strike if player did not progress to the next level before timer countdown
  - [x] 
- [x] **📣 Audio _using [MSS DEMO](https://github.com/sthd/Dangerous-Dave-FPGA/edit/main/README.md "#1-overview")_ written by Alex Grinshpun and David bar-On:**
    - [x] Background Music (BGM) with volume, pitch, and **looping** features _using [Audio Source Play](https://docs.unity3d.com/ScriptReference/AudioSource.Play.html)_.
        - [x] Sound (https://docs.unity3d.com/ScriptReference/AudioSource.PlayOneShot.html)_.
        - [x] Distance-Relative Audio _using 3D Sound Settings of [Audio Source Component](https://docs.unity3d.com/Manual/class-AudioSource.html)_.

