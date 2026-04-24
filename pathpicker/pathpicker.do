# pathpicker.do
# A reusable library for interactive path selection and validation.
# Use with: include "pathpicker.do"
#
# ─── FUNCTIONS PROVIDED ───────────────────────────────────────────────────────
#
#   pick_path(prompt)
#     Asks the user to type a path. Returns it raw (no validation).
#     Result stored in: picked_path
#
#   pick_path_validated(prompt)
#     Asks for a path and loops until the user gives one that actually exists.
#     Result stored in: picked_path
#
#   pick_install_dir(app_name)
#     Installer-style picker. Shows a default (C:\<AppName>), lets the user
#     accept or override. Creates the folder when confirmed.
#     Result stored in: picked_path
#
#   pick_existing_file(prompt)
#     Asks for a file path and loops until the file exists.
#     Result stored in: picked_path
#
#   pick_existing_folder(prompt)
#     Asks for a folder path and loops until the folder exists.
#     Result stored in: picked_path
#
#   pick_from_list(label, choices)
#     Numbered menu. Pass a comma-separated list of options.
#     Result stored in: picked_path   (the chosen option text)
#     Result index stored in: picked_index  (1-based)
#
#   confirm_path(path)
#     Displays a path and asks "Is this correct? (y/n)".
#     Result stored in: path_confirmed   ("y" or "n")
#
# ─────────────────────────────────────────────────────────────────────────────

global_variable = picked_path, picked_index, path_confirmed
global_variable = _pp_input, _pp_default, _pp_label, _pp_choices, _pp_choice_list, _pp_choice_count, _pp_i, _pp_item, _pp_valid


# ─── pick_path ────────────────────────────────────────────────────────────────
# Prompt the user for any path. No existence check.
# Usage: picked_path = pick_path("Where should we put the files?")

function pick_path prompt
    local_variable = _result
    say ""
    say '  {prompt}'
    ask _result "  > "
    return _result
end_function


# ─── pick_path_validated ──────────────────────────────────────────────────────
# Prompt for a path that must already exist (file OR folder).
# Loops until a valid path is entered.
# Usage: picked_path = pick_path_validated("Select an existing path:")

function pick_path_validated prompt
    local_variable = _result, _ok
    _ok = false

    loop forever
        say ""
        say '  {prompt}'
        ask _result "  > "

        if exists(_result)
            _ok = true
        end_if

        if _ok == true
            break
        end_if

        warn '  Path not found: {_result}'
        say "  Please enter a valid path and try again."
    end_loop

    return _result
end_function


# ─── pick_install_dir ─────────────────────────────────────────────────────────
# Show a default install location, allow the user to accept or change it.
# Creates the directory once confirmed.
# Usage: picked_path = pick_install_dir("MyApp")

function pick_install_dir app_name
    local_variable = _default, _choice, _custom, _final, _done
    _default = 'C:/{app_name}'
    _done = false

    loop forever
        say ""
        say '  Install location for {app_name}:'
        say '    [1] Use default  →  {_default}'
        say "    [2] Choose a custom path"
        ask _choice "  Select (1 or 2): "

        if _choice == "1"
            _final = _default
            _done = true
        end_if

        if _choice == "2"
            say ""
            say "  Enter the full path where you want to install:"
            ask _custom "  > "
            _final = _custom
            _done = true
        end_if

        if _done == false
            warn "  Please enter 1 or 2."
        end_if

        if _done == true
            break
        end_if
    end_loop

    say ""
    say '  Install path: {_final}'
    ask _choice "  Confirm? (y/n): "

    if _choice == "y"
        make folder _final
        say '  Folder ready: {_final}'
    else
        say "  Cancelled. Re-running picker..."
        _final = pick_install_dir(app_name)
    end_if

    return _final
end_function


# ─── pick_existing_file ───────────────────────────────────────────────────────
# Loops until the user enters a path to a file that exists.
# Usage: picked_path = pick_existing_file("Select the config file:")

function pick_existing_file prompt
    local_variable = _result, _ok
    _ok = false

    loop forever
        say ""
        say '  {prompt}'
        ask _result "  > "

        if exists(_result)
            _ok = true
        end_if

        if _ok == true
            break
        end_if

        warn '  File not found: {_result}'
        say "  Please enter a valid file path."
    end_loop

    return _result
end_function


# ─── pick_existing_folder ─────────────────────────────────────────────────────
# Loops until the user enters a path to a folder that exists.
# Usage: picked_path = pick_existing_folder("Select a folder:")

function pick_existing_folder prompt
    local_variable = _result, _ok
    _ok = false

    loop forever
        say ""
        say '  {prompt}'
        ask _result "  > "

        if exists(_result)
            _ok = true
        end_if

        if _ok == true
            break
        end_if

        warn '  Folder not found: {_result}'
        say "  Please enter a valid folder path."
    end_loop

    return _result
end_function


# ─── pick_from_list ───────────────────────────────────────────────────────────
# Show a numbered menu built from a comma-separated string of choices.
# Returns the chosen option text; also sets picked_index (1-based).
# Usage:
#   picked_path = pick_from_list("Where to install?", "C:/MyApp,D:/Programs,Custom")

function pick_from_list label choices
    local_variable = _list, _count, _i, _item, _choice, _chosen, _valid
    _list = split(choices, ",")
    _count = list_length(_list)
    _valid = false

    loop forever
        say ""
        say '  {label}'
        _i = 0
        loop forever
            if _i >= _count
                break
            end_if
            _item = list_get(_list, _i)
            _i = _i + 1
            say '    [{_i}] {_item}'
        end_loop

        say ""
        ask _choice "  Enter number (1-{_count}): "

        _i = 0
        loop forever
            if _i >= _count
                break
            end_if
            _i = _i + 1
            if _choice == _i
                _chosen = list_get(_list, _i - 1)
                picked_index = _i
                _valid = true
                break
            end_if
        end_loop

        if _valid == true
            break
        end_if

        warn '  Invalid choice. Please enter a number between 1 and {_count}.'
    end_loop

    return _chosen
end_function


# ─── confirm_path ─────────────────────────────────────────────────────────────
# Display a path and ask the user to confirm it.
# Sets path_confirmed to "y" or "n".
# Usage:
#   confirm_path(some_path)
#   if path_confirmed == "y"  ...  end_if

function confirm_path path
    local_variable = _ans
    say ""
    say '  Selected path: {path}'
    ask _ans "  Is this correct? (y/n): "
    path_confirmed = _ans
end_function
