#!/usr/bin/env python3
"""
Script to check for empty leaf folders in a directory structure.
A leaf folder is a folder that contains no subdirectories (only files or nothing).
"""

import sys
from pathlib import Path
from typing import List, Tuple


def is_leaf_folder(path: Path) -> bool:
    """
    Check if a directory is a leaf folder (contains no subdirectories).

    Args:
        path: Path object representing the directory to check

    Returns:
        bool: True if it's a leaf folder, False otherwise
    """
    try:
        # Get all items in the directory
        items = list(path.iterdir())

        # Check if any item is a directory
        for item in items:
            if item.is_dir():
                return False

        # If we get here, no subdirectories were found
        return True
    except PermissionError:
        print(f"Permission denied accessing: {path}")
        return False
    except Exception as e:
        print(f"Error accessing {path}: {e}")
        return False


def find_empty_leaf_folders(root_path: Path) -> List[Tuple[Path, bool]]:
    """
    Recursively find all leaf folders and check if they're empty.

    Args:
        root_path: Path object representing the root directory to search

    Returns:
        List of tuples containing (path, is_empty) for each leaf folder
    """
    empty_leaf_folders = []

    def traverse_directory(current_path: Path):
        """Recursive helper function to traverse directories."""
        try:
            # Skip if not a directory
            if not current_path.is_dir():
                return

            # Check if this is a leaf folder
            if is_leaf_folder(current_path):
                # Count files in the leaf folder
                try:
                    files = [item for item in current_path.iterdir() if item.is_file()]
                    is_empty = len(files) == 0
                    empty_leaf_folders.append((current_path, is_empty))
                except PermissionError:
                    print(f"Permission denied counting files in: {current_path}")
                except Exception as e:
                    print(f"Error counting files in {current_path}: {e}")
            else:
                # Not a leaf folder, continue traversing subdirectories
                try:
                    for item in current_path.iterdir():
                        if item.is_dir():
                            traverse_directory(item)
                except PermissionError:
                    print(f"Permission denied accessing subdirectories in: {current_path}")
                except Exception as e:
                    print(f"Error accessing subdirectories in {current_path}: {e}")

        except Exception as e:
            print(f"Error processing {current_path}: {e}")

    traverse_directory(root_path)
    return empty_leaf_folders


def main():
    """Main function to run the empty folder check."""
    # Get the root path from the command line (first argument)
    # or use the current working directory if no argument is provided
    root_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()

    print(f"\nChecking for empty leaf folders in: {root_path}")
    print("=" * 60)

    # Find all leaf folders
    leaf_folders = find_empty_leaf_folders(root_path)

    if not leaf_folders:
        print("No leaf folders found.")
        return

    # Separate empty and non-empty leaf folders
    empty_folders = [path for path, is_empty in leaf_folders if is_empty]
    non_empty_folders = [path for path, is_empty in leaf_folders if not is_empty]

    # Print results
    print(f"\nFound {len(leaf_folders)} leaf folders total:")
    print(f"  - Empty leaf folders: {len(empty_folders)}")
    print(f"  - Non-empty leaf folders: {len(non_empty_folders)}")

    if empty_folders:
        print(f"\nEmpty leaf folders ({len(empty_folders)}):")
        print("-" * 40)
        for folder in sorted(empty_folders):
            # Show relative path from current directory
            relative_path = folder.relative_to(root_path)
            print(f"  {relative_path}")

    if non_empty_folders:
        print(f"\nNon-empty leaf folders ({len(non_empty_folders)}):")
        print("-" * 40)
        for folder in sorted(non_empty_folders):
            # Show relative path from current directory
            relative_path = folder.relative_to(root_path)
            try:
                file_count = len([item for item in folder.iterdir() if item.is_file()])
                print(f"  {relative_path} ({file_count} files)")
            except Exception as e:
                print(f"  {relative_path} (error counting files: {e})")

    # Summary
    print("\n" + "=" * 60)
    if empty_folders:
        print(f"⚠️  Found {len(empty_folders)} empty leaf folders that may need attention.")
        return 1  # Exit with error code if empty folders found
    else:
        print("✅ No empty leaf folders found.")
        return 0


if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)