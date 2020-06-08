# Docker image to run the automatic grader for Java Assesment 02 (pattern 2)

## Requirements

- Docker (tested with 19.03.5 on linux)
- docker-compose (tested with 1.25.4 on linux)
- Port 8888 is available in your environment (for JupyterLab)

## Usage

1. Put trainees' workspaces (.java files) in the directory workspaces
2. Make sure that there are three directories namely workspaces, work, and results in the directory that contains the readme.md
3. Double-click run.bat and find a URL http://127.0.0.1:8888/?token=...
...
4. Find main.ipynb in the file browser in the left sidebar and open it
4. (Optional) Disable autosave via "Settings"  in the menu bar
5. Run all cells
6. Open results/result.csv

## Shut down

Click "Shut Down" in the "File" menu.

## Structure of the workspaces
Make sure that the structure of "workspaces" looks as:
```
workspaces
├── Trainee01
│   └── src
│       ├── form
│       │   ├── Employee.java
│       │   ├── Engineer.java
│       │   └── Sales.java
│       ├── main
│       │   └── Application.java
│       └── utility
│           └── StandardInputReader.java
├── Trainee02
│   └── src
│       ├── form
│       │   ├── Employee.java
│       │   ├── Engineer.java
│       │   └── Sales.java
│       ├── main
│       │   └── Application.java
│       └── utility
│           └── StandardInputReader.java
...
