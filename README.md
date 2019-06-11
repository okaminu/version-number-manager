# version-number-manager
This project replaces version numbers in given files.

## Installation

## Usage
Create a CSV file, which has two columns: file path and version number occurances count.

Occurances count ensures, that the manager changes only the predefined count of version in a file. In case there are other dependencies with the same version number, exception is thrown.

```
ruby main.rb CSV_PATH, OLD_VERSION, NEW_VERSION
```
## License
[MIT](https://choosealicense.com/licenses/mit/)