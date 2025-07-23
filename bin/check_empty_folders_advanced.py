#!/usr/bin/env python3
"""
Advanced script to check for empty leaf folders in a directory structure.
A leaf folder is a folder that contains no subdirectories (only files or nothing).

Features:
- Command line arguments for customization
- Detailed reporting with file counts
- Export results to CSV/JSON
- Filtering options
- Summary statistics
"""

import os
import sys
import json
import csv
import argparse
from pathlib import Path
from typing import List, Tuple, Dict, Any
from datetime import datetime


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


def get_folder_stats(path: Path) -> Dict[str, Any]:
    """
    Get detailed statistics for a folder.

    Args:
        path: Path object representing the folder

    Returns:
        Dictionary with folder statistics
    """
    stats = {
        'path': str(path),
        'relative_path': str(path.relative_to(Path.cwd())),
        'is_empty': True,
        'file_count': 0,
        'total_size': 0,
        'file_types': {},
        'last_modified': None
    }

    try:
        files = [item for item in path.iterdir() if item.is_file()]
        stats['file_count'] = len(files)
        stats['is_empty'] = len(files) == 0

        # Calculate total size and file types
        for file in files:
            try:
                file_size = file.stat().st_size
                stats['total_size'] += file_size

                # Count file types
                file_ext = file.suffix.lower()
                if file_ext:
                    stats['file_types'][file_ext] = stats['file_types'].get(file_ext, 0) + 1
                else:
                    stats['file_types']['no_extension'] = stats['file_types'].get('no_extension', 0) + 1

            except (OSError, PermissionError):
                continue

        # Get last modified time
        try:
            stats['last_modified'] = datetime.fromtimestamp(path.stat().st_mtime).isoformat()
        except (OSError, PermissionError):
            pass

    except (OSError, PermissionError):
        pass

    return stats


def find_empty_leaf_folders(root_path: Path, verbose: bool = False) -> List[Dict[str, Any]]:
    """
    Recursively find all leaf folders and get their statistics.

    Args:
        root_path: Path object representing the root directory to search
        verbose: Whether to print verbose output

    Returns:
        List of dictionaries containing folder statistics
    """
    leaf_folders = []

    def traverse_directory(current_path: Path):
        """Recursive helper function to traverse directories."""
        try:
            # Skip if not a directory
            if not current_path.is_dir():
                return

            # Check if this is a leaf folder
            if is_leaf_folder(current_path):
                if verbose:
                    print(f"Found leaf folder: {current_path}")

                # Get detailed statistics
                stats = get_folder_stats(current_path)
                leaf_folders.append(stats)
            else:
                # Not a leaf folder, continue traversing subdirectories
                try:
                    for item in current_path.iterdir():
                        if item.is_dir():
                            traverse_directory(item)
                except PermissionError:
                    if verbose:
                        print(f"Permission denied accessing subdirectories in: {current_path}")
                except Exception as e:
                    if verbose:
                        print(f"Error accessing subdirectories in {current_path}: {e}")

        except Exception as e:
            if verbose:
                print(f"Error processing {current_path}: {e}")

    traverse_directory(root_path)
    return leaf_folders


def export_to_csv(folders: List[Dict[str, Any]], output_file: str):
    """Export folder statistics to CSV file."""
    if not folders:
        print("No data to export.")
        return

    try:
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            # Get all possible fieldnames
            fieldnames = set()
            for folder in folders:
                fieldnames.update(folder.keys())

            fieldnames = sorted(list(fieldnames))

            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()

            for folder in folders:
                # Convert file_types dict to string for CSV
                row = folder.copy()
                if 'file_types' in row:
                    row['file_types'] = json.dumps(row['file_types'])
                writer.writerow(row)

        print(f"Results exported to: {output_file}")
    except Exception as e:
        print(f"Error exporting to CSV: {e}")


def export_to_json(folders: List[Dict[str, Any]], output_file: str):
    """Export folder statistics to JSON file."""
    if not folders:
        print("No data to export.")
        return

    try:
        with open(output_file, 'w', encoding='utf-8') as jsonfile:
            json.dump(folders, jsonfile, indent=2, ensure_ascii=False)

        print(f"Results exported to: {output_file}")
    except Exception as e:
        print(f"Error exporting to JSON: {e}")


def print_summary(folders: List[Dict[str, Any]], show_details: bool = True):
    """Print a detailed summary of the findings."""
    if not folders:
        print("No leaf folders found.")
        return

    # Separate empty and non-empty folders
    empty_folders = [f for f in folders if f['is_empty']]
    non_empty_folders = [f for f in folders if not f['is_empty']]

    # Calculate statistics
    total_size = sum(f['total_size'] for f in non_empty_folders)
    total_files = sum(f['file_count'] for f in non_empty_folders)

    # File type analysis
    all_file_types = {}
    for folder in non_empty_folders:
        for ext, count in folder['file_types'].items():
            all_file_types[ext] = all_file_types.get(ext, 0) + count

    print(f"\n📊 SUMMARY REPORT")
    print("=" * 60)
    print(f"Total leaf folders found: {len(folders)}")
    print(f"  - Empty leaf folders: {len(empty_folders)}")
    print(f"  - Non-empty leaf folders: {len(non_empty_folders)}")
    print(f"  - Total files: {total_files}")
    print(f"  - Total size: {total_size:,} bytes ({total_size / (1024*1024):.2f} MB)")

    if all_file_types:
        print(f"\n📁 File types found:")
        for ext, count in sorted(all_file_types.items(), key=lambda x: x[1], reverse=True):
            print(f"  - {ext}: {count} files")

    if empty_folders and show_details:
        print(f"\n⚠️  Empty leaf folders ({len(empty_folders)}):")
        print("-" * 50)
        for folder in sorted(empty_folders, key=lambda x: x['relative_path']):
            print(f"  {folder['relative_path']}")

    if non_empty_folders and show_details:
        print(f"\n✅ Non-empty leaf folders ({len(non_empty_folders)}):")
        print("-" * 50)
        for folder in sorted(non_empty_folders, key=lambda x: x['relative_path']):
            size_mb = folder['total_size'] / (1024*1024)
            print(f"  {folder['relative_path']} ({folder['file_count']} files, {size_mb:.2f} MB)")

    # Recommendations
    print("\n" + "=" * 60)
    if empty_folders:
        print(f"⚠️  Found {len(empty_folders)} empty leaf folders that may need attention.")
        print("   Consider:")
        print("   - Removing empty folders if they're not needed")
        print("   - Adding placeholder files (like .gitkeep) if folders should remain")
        print("   - Investigating why these folders are empty")
        return 1
    else:
        print("✅ No empty leaf folders found.")
        return 0


def main():
    """Main function with command line argument parsing."""
    parser = argparse.ArgumentParser(
        description="Check for empty leaf folders in a directory structure",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python check_empty_folders_advanced.py
  python check_empty_folders_advanced.py --verbose
  python check_empty_folders_advanced.py --export-csv results.csv
  python check_empty_folders_advanced.py --export-json results.json
  python check_empty_folders_advanced.py --min-size 1024
        """
    )

    parser.add_argument(
        '--path', '-p',
        type=str,
        default='.',
        help='Root directory to scan (default: current directory)'
    )

    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose output'
    )

    parser.add_argument(
        '--export-csv',
        type=str,
        help='Export results to CSV file'
    )

    parser.add_argument(
        '--export-json',
        type=str,
        help='Export results to JSON file'
    )

    parser.add_argument(
        '--min-size',
        type=int,
        help='Only show folders with at least this many bytes'
    )

    parser.add_argument(
        '--min-files',
        type=int,
        help='Only show folders with at least this many files'
    )

    parser.add_argument(
        '--quiet',
        action='store_true',
        help='Suppress detailed output, only show summary'
    )

    args = parser.parse_args()

    # Validate root path
    root_path = Path(args.path).resolve()
    if not root_path.exists():
        print(f"Error: Path '{args.path}' does not exist.")
        return 1

    if not root_path.is_dir():
        print(f"Error: Path '{args.path}' is not a directory.")
        return 1

    print(f"🔍 Checking for empty leaf folders in: {root_path}")
    if args.verbose:
        print("Verbose mode enabled")

    # Find all leaf folders
    leaf_folders = find_empty_leaf_folders(root_path, verbose=args.verbose)

    # Apply filters
    if args.min_size is not None:
        leaf_folders = [f for f in leaf_folders if f['total_size'] >= args.min_size]

    if args.min_files is not None:
        leaf_folders = [f for f in leaf_folders if f['file_count'] >= args.min_files]

    # Export results
    if args.export_csv:
        export_to_csv(leaf_folders, args.export_csv)

    if args.export_json:
        export_to_json(leaf_folders, args.export_json)

    # Print results
    show_details = not args.quiet
    exit_code = print_summary(leaf_folders, show_details=show_details)

    return exit_code


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