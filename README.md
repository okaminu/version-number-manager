# version-number-manager
This project replaces version numbers in given files.

## Installation

## Usage
Create a CSV file, which has two columns: relative file path and version number occurances count.

Occurances count ensures, that the manager changes only the predefined count of version in a file. In case there are other dependencies with the same version number, exception is thrown.

Version manager is launched by executing main.rb with parameters:

* CSV_PATH - path to CSV file
* OLD_VERSION - currently existing version in a given project. 
* NEW_VERSION - updated version number.
* BASE_PROJECT_PATH(Optional) - full path to the location containing all the project modules. If undefined, parent directory of this project is used.


```
ruby main.rb CSV_PATH, OLD_VERSION, NEW_VERSION, BASE_PROJECT_PATH?
ruby main.rb /home/User/Documents/file.csv 2.2.2 2.2.3
```
## License
[MIT](https://choosealicense.com/licenses/mit/)