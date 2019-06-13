# version-number-manager
This project replaces version numbers in given files.

## Installation

```
gem install bundler
bundle install
```

## Usage
Create a CSV file, which has two columns: relative file path and version number occurrence count.
This configuration file will describe the files in which we want version numbers updated.

Occurrence count ensures, that the manager changes only the predefined count of version in a file. 
In case there are other dependencies with the same version number, exception is thrown.

Version manager is launched by executing main.rb with arguments:

* CSV_PATH - path to CSV configuration file
* OLD_VERSION - currently existing version in a given project. 
* NEW_VERSION - updated version number.
* BASE_PROJECT_PATH(Optional) - full path to directory, containing all the project modules. If undefined, parent directory of this project is used.

```
ruby main.rb CSV_PATH, OLD_VERSION, NEW_VERSION, BASE_PROJECT_PATH?
ruby main.rb Documents/file.csv 2.2.2 2.2.3 /home/User/
```
## License
[MIT](https://choosealicense.com/licenses/mit/)