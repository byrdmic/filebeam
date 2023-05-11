# FileBeam

FileBeam is a command-line tool for exploring and displaying file contents interactively. It allows you to navigate through files in a directory, select multiple files, and display their contents conveniently. The script is designed for Arch Linux systems and works well with Pacman package management.

## Features

- List files in the current directory and its subdirectories up to a specified limit
- Filter files by type
- Interactively select multiple files using 'j' and 'k' keys for navigation and 'space' for selection
- Display the contents of the selected files
- Abort the selection process at any time by pressing 'q'

## Installation

1. Clone this repository to your local machine:

git clone https://github.com/byrdmic/filebeam.git


2. Install the script:

cd filebeam
sudo cp filebeam.sh /usr/local/bin/filebeam
sudo chmod +x /usr/local/bin/filebeam

## Usage

Run the script in your terminal:

filebeam

### Options

- `--files <number>`: Limit the number of files to display (default: 50)
- `--types <type>`: Filter files by type (e.g., --types .txt or --types txt)
- `--list`: Display only the file names without their content

### Interactive Controls

- `j`: Move down in the list
- `k`: Move up in the list
- `space`: Select or deselect a file
- `Enter` or `y`: Confirm the selection and display the contents of the selected files
- `q`: Abort the process

## License

FileBeam is released under the GPL license. See [LICENSE](LICENSE) for more information.

