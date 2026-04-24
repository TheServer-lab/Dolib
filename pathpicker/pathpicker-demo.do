# pathpicker-demo.do
# Demonstrates every function in pathpicker.do.
# Usage: python doscript.py pathpicker-demo.do

include "pathpicker.do"

say "============================================"
say "        pathpicker.do  —  Demo Script"
say "============================================"
say ""


# ── 1. pick_path ─────────────────────────────────────────────────────────────
say "[ 1 ] pick_path — no validation, any text accepted"
picked_path = pick_path("Enter any path (it won't be checked):")
say 'You entered: {picked_path}'
say ""


# ── 2. pick_path_validated ───────────────────────────────────────────────────
say "[ 2 ] pick_path_validated — must exist on disk"
picked_path = pick_path_validated("Enter a path that exists on your machine:")
say 'Confirmed existing path: {picked_path}'
say ""


# ── 3. pick_existing_file ────────────────────────────────────────────────────
say "[ 3 ] pick_existing_file — file must exist"
picked_path = pick_existing_file("Enter the full path to any file on your machine:")
say 'File selected: {picked_path}'
say ""


# ── 4. pick_existing_folder ──────────────────────────────────────────────────
say "[ 4 ] pick_existing_folder — folder must exist"
picked_path = pick_existing_folder("Enter the full path to any folder:")
say 'Folder selected: {picked_path}'
say ""


# ── 5. pick_from_list ────────────────────────────────────────────────────────
say "[ 5 ] pick_from_list — numbered menu"
picked_path = pick_from_list("Where should we put the output files?", "C:/Output,D:/Exports,C:/Users/dasso/Desktop")
say 'You chose option {picked_index}: {picked_path}'
say ""


# ── 6. pick_install_dir ──────────────────────────────────────────────────────
say "[ 6 ] pick_install_dir — installer-style picker with default"
picked_path = pick_install_dir("DemoApp")
say 'Install directory confirmed: {picked_path}'
say ""


# ── 7. confirm_path ──────────────────────────────────────────────────────────
say "[ 7 ] confirm_path — display and ask user to confirm"
confirm_path(picked_path)
if path_confirmed == "y"
    say 'Great — using: {picked_path}'
else
    say "Alright, path rejected."
end_if
say ""


say "============================================"
say "         Demo complete!"
say "============================================"
pause
