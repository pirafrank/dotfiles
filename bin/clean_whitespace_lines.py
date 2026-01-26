#!/usr/bin/env python3
"""
Clean Whitespace Lines Script

Recursively processes files in a directory, replacing lines that contain only
whitespace (spaces/tabs) with completely empty lines. Respects .gitignore
patterns and excludes .git directories.

Usage:
    python clean_whitespace_lines.py [directory] [--ext ext1 ext2 ...]

Example:
    python clean_whitespace_lines.py /path/to/project
    python clean_whitespace_lines.py . --extensions .py .js .cpp
"""

import os
import sys
import argparse
from pathlib import Path
from typing import List, Set
import re


class GitignoreParser:
    """Parse and match .gitignore patterns."""

    def __init__(self, gitignore_path: Path):
        self.patterns = []
        self.base_path = gitignore_path.parent

        if gitignore_path.exists():
            with open(gitignore_path, 'r', encoding='utf-8', errors='ignore') as f:
                for line in f:
                    line = line.strip()
                    # Skip empty lines and comments
                    if not line or line.startswith('#'):
                        continue
                    self.patterns.append(line)

    def matches(self, path: Path) -> bool:
        """Check if a path matches any gitignore pattern."""
        try:
            rel_path = path.relative_to(self.base_path)
        except ValueError:
            return False

        rel_path_str = str(rel_path)

        for pattern in self.patterns:
            # Handle negation patterns
            if pattern.startswith('!'):
                continue

            # Remove leading slash
            if pattern.startswith('/'):
                pattern = pattern[1:]

            # Directory pattern
            if pattern.endswith('/'):
                pattern = pattern[:-1]
                if rel_path_str.startswith(pattern + '/') or rel_path_str == pattern:
                    return True

            # Simple glob matching
            elif self._simple_match(rel_path_str, pattern):
                return True

            # Check if any parent directory matches
            for parent in rel_path.parents:
                if self._simple_match(str(parent.name), pattern):
                    return True

        return False

    def _simple_match(self, path: str, pattern: str) -> bool:
        """Simple pattern matching supporting * and **."""
        # Convert gitignore pattern to regex
        pattern = pattern.replace('.', r'\.')
        pattern = pattern.replace('**/', '.*')
        pattern = pattern.replace('**', '.*')
        pattern = pattern.replace('*', '[^/]*')
        pattern = pattern.replace('?', '.')

        return re.match(f'^{pattern}$', path) is not None


def find_gitignore_files(root_dir: Path) -> List[GitignoreParser]:
    """Find all .gitignore files in the directory tree."""
    parsers = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Skip .git directories
        if '.git' in dirnames:
            dirnames.remove('.git')

        if '.gitignore' in filenames:
            gitignore_path = Path(dirpath) / '.gitignore'
            parsers.append(GitignoreParser(gitignore_path))

    return parsers


def should_process_file(file_path: Path, gitignore_parsers: List[GitignoreParser]) -> bool:
    """Check if a file should be processed based on gitignore rules."""
    # Check against all gitignore parsers
    for parser in gitignore_parsers:
        if parser.matches(file_path):
            return False
    return True


def clean_whitespace_lines(file_path: Path) -> int:
    """
    Replace lines containing only whitespace with empty lines.
    Returns the number of lines cleaned.
    """
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
    except (UnicodeDecodeError, PermissionError) as e:
        print(f"Skipping {file_path}: {e}")
        return 0

    cleaned_lines = []
    changes_count = 0

    for line in lines:
        # Check if line contains only whitespace (spaces, tabs, etc.)
        if line.strip() == '' and line != '\n' and line != '':
            cleaned_lines.append('\n')
            changes_count += 1
        else:
            cleaned_lines.append(line)

    # Only write if changes were made
    if changes_count > 0:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(cleaned_lines)
        except PermissionError as e:
            print(f"Permission denied: {file_path}")
            return 0

    return changes_count


def process_directory(root_dir: Path, extensions: Set[str], verbose: bool = True):
    """Process all files in directory tree."""
    root_dir = root_dir.resolve()

    # Find all gitignore files
    print(f"Scanning for .gitignore files in {root_dir}...")
    gitignore_parsers = find_gitignore_files(root_dir)
    print(f"Found {len(gitignore_parsers)} .gitignore file(s)")

    files_processed = 0
    files_modified = 0
    total_lines_cleaned = 0

    print(f"\nProcessing files with extensions: {', '.join(extensions)}")
    print(f"Starting from: {root_dir}\n")

    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Skip .git directories
        if '.git' in dirnames:
            dirnames.remove('.git')

        current_path = Path(dirpath)

        # Check if current directory should be ignored
        skip_dir = False
        for parser in gitignore_parsers:
            if parser.matches(current_path):
                skip_dir = True
                break

        if skip_dir:
            dirnames.clear()  # Don't recurse into ignored directories
            continue

        for filename in filenames:
            file_path = current_path / filename

            # Check file extension
            if file_path.suffix not in extensions:
                continue

            # Check if file should be ignored
            if not should_process_file(file_path, gitignore_parsers):
                if verbose:
                    print(f"Ignoring (gitignore): {file_path}")
                continue

            files_processed += 1
            lines_cleaned = clean_whitespace_lines(file_path)

            if lines_cleaned > 0:
                files_modified += 1
                total_lines_cleaned += lines_cleaned
                print(f"✓ {file_path}: cleaned {lines_cleaned} line(s)")
            elif verbose:
                print(f"  {file_path}: no changes needed")

    # Print summary
    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Files processed: {files_processed}")
    print(f"  Files modified: {files_modified}")
    print(f"  Total lines cleaned: {total_lines_cleaned}")
    print(f"{'='*60}")


def main():
    parser = argparse.ArgumentParser(
        description='Replace whitespace-only lines with empty lines in code files.'
    )
    parser.add_argument(
        'directory',
        nargs='?',
        default='.',
        help='Directory to process (default: current directory)'
    )
    parser.add_argument(
        '--ext',
        nargs='+',
        default=['.py', '.js', '.java', '.c', '.cpp', '.h', '.hpp', '.cs', '.go',
                 '.rs', '.rb', '.php', '.ts', '.tsx', '.jsx', '.sh', '.bash', 'fish'],
        help='File extensions to process (default: common code file extensions)'
    )
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Show all files being processed, not just modified ones'
    )

    args = parser.parse_args()

    target_dir = Path(args.directory)

    if not target_dir.exists():
        print(f"Error: Directory '{target_dir}' does not exist")
        sys.exit(1)

    if not target_dir.is_dir():
        print(f"Error: '{target_dir}' is not a directory")
        sys.exit(1)

    # Ensure extensions start with a dot
    extensions = set()
    for ext in args.ext:
        if not ext.startswith('.'):
            ext = '.' + ext
        extensions.add(ext)

    try:
        process_directory(target_dir, extensions, args.verbose)
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user")
        sys.exit(1)


if __name__ == '__main__':
    main()
