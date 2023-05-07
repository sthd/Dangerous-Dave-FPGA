# Dangerous Dave FPGA
The nostalgic 2D video game programmed on a DE-10 Standard. 





## 1. Overview


<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameScreenshotA.jpg"  width="384" height="250">
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/gameScreenshotB.jpg"  width="342" height="280">



## 2. Architecture
### 2.1 I/O Interfaces
<p align="center"><img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/IO.png"  width="340" height="165"></p>

| Unit| Description 
|:-------------------------|:--------------:|
| `Keys + Switches`     | User Input to control the game | 
| `DE-10 Standard FPGA` | Receives user's input, manages game's events and delivers output to the visual and audial units | 
| `VGA`                 | Manages VGA events and delivers visual output to an external screen using the VGA port|
| `7SEG`                | Display game stats on built on the seven-segment display |
| `Audio`               | Manages and delivers the game's audio output to an external speaker using the AUX port |


### 2.2 Block Diagram
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/BlockDiagram.png"  width="500" height="400">

### 2.3 Drawing Module
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/DrawingMatrices.png"  width="303" height="115">

## 4. Schematic and RTL
### 4.1 Top Hierarchy
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/TopHierarchy.png"  width="1132" height="635">

### 4.2 

## 5. Waveforms and Signals
### 5.1 Drawing Module waveform
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/matricesWaveforms.png"  width="1007" height="364">

### 5.2 State machine waveform
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/stateMachineWaveforms.png"  width="992" height="364">

### 5.2 SignalTap debugging
#### SignalTap waveforms used to find a bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFound.png"  width="991" height="127">

#### SignalTap waveform showing desired behavior succeeding to fix the bug
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/SignalTapBugFixed.png"  width="991" height="127">

## 3. FPGA Implementation Results
<img src="https://github.com/sthd/Dangerous-Dave-FPGA/blob/main/b/FlowSummary.png"  width="500" height="400">
