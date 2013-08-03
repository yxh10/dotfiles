#### Top level API

Name               | Args                                | Return value
-------------------|-------------------------------------|--------------------
bind               | key, mods                           | nil, callback, ...
listen             | event_name                          | 0, callback, ...
relaunch_config    |                                     | nil
clipboard_contents |                                     | string
focused_window     |                                     | id
visible_windows    |                                     | array of ids
all_windows        |                                     | array of ids
main_screen        |                                     | id
all_screens        |                                     | array of ids
running_apps       |                                     | array of ids
alert              | msg, duration_sec                   | nil
log                | msg                                 | nil
choose_from        | list, title, lines_tall, chars_wide | 0, idx

#### Window

#### App

#### Screen
