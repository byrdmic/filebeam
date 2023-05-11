#!/bin/bash

# Default number of files and file type filter
num_files=50
file_type_filter=""
list_only=false

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --files)
      num_files="$2"
      shift
      shift
      ;;
    --types)
      file_type="$2"
      file_type_filter=".${file_type#.}" # Remove leading period if present and add it back
      shift
      shift
      ;;
    --list)
      list_only=true
      shift
      ;;
    *)
      echo "Unknown option: $key"
      exit 1
      ;;
  esac
done

# Confirm working directory
cwd=$(pwd)
echo "Current working directory: $cwd"
echo "Do you want to continue? (Y/N, default: Y)"
read -r user_input

# Find and process files
if [[ -z $file_type_filter ]]; then
  find_cmd='find "$cwd" -type d \( -name ".git" -o -name "undo" \) -prune -o -type f -print0 | head -z -n "$num_files"'
else
  find_cmd='find "$cwd" -type d \( -name ".git" -o -name "undo" \) -prune -o -type f -iname "*$file_type_filter" -print0 | head -z -n "$num_files"'
fi

if $list_only; then
  files=$(eval "$find_cmd" | xargs -0 -I {} sh -c 'basename="{}"; echo "$(basename "$basename")"')
  selected_files=()
  IFS=$'\n' files_arr=($files)
  selected_arr=($(for file in "${files_arr[@]}"; do echo 0; done))
  current_index=0
  while true; do
    clear
    for i in "${!files_arr[@]}"; do
      prefix=""
      if [[ ${selected_arr[i]} -eq 1 ]]; then
        prefix="$(tput setaf 2)◆$(tput sgr0) "
      fi
      if [[ $current_index -eq $i ]]; then
        echo "> $prefix${files_arr[i]}"
      else
        echo "  $prefix${files_arr[i]}"
      fi
    done
    echo
    echo "Press 'space' to select/deselect, 'Enter' or 'y' to confirm, or 'q' to abort."

    read -rsn1 input
    case $input in
      ' ')
        selected_arr[current_index]=$((1 - selected_arr[current_index]))
        ;;
      ''|'y') # Enter key or 'y'
        for i in "${!files_arr[@]}"; do
          if [[ ${selected_arr[i]} -eq 1 ]]; then
            selected_files+=("${files_arr[i]}")
          fi
        done
        break
        ;;
      'q')
        selected_files=()
        break
        ;;
      'j') # Move down
        current_index=$((current_index + 1))
        if [[ $current_index -ge ${#files_arr[@]} ]]; then
          current_index=$((${#files_arr[@]} - 1))
        fi
        ;;
      'k') # Move up
        current_index=$((current_index - 1))
        if [[ $current_index -lt 0 ]]; then
          current_index=0
        fi
        ;;
    esac
  done

  if [[ ${#selected_files[@]} -gt 0 ]]; then
    for file in "${selected_files[@]}"; do
      echo "// $file"
      cat -v "$(find "$cwd" -name "$file" | head -n 1)"
      echo
    done
  else
    echo "No files selected."
  fi
else
  eval "$find_cmd" | xargs -0 -I {} sh -c 'basename="{}"; echo "// $(basename "$basename")"; cat -v "{}"'
fi

